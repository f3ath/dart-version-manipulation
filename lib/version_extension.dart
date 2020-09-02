import 'package:pub_semver/pub_semver.dart';

extension VersionManipulation on Version {
  /// Changes the given parts, returning a new instance on [Version]
  Version change(
          {int major,
          int minor,
          int patch,
          List<dynamic> build,
          List<dynamic> preRelease}) =>
      Version(major ?? this.major, minor ?? this.minor, patch ?? this.patch,
          build: _join(build ?? this.build),
          pre: _join(preRelease ?? this.preRelease));

  String _join(List elements) =>
      elements?.isEmpty == true ? null : elements.join('.');

  /// Returns a new instance of Version withe the next build:
  /// - empty build will be set to `1`: 1.2.3 -> 1.2.3+1
  /// - non-numeric build gets `.1` appended: 1.2.3+foo42 -> 1.2.3+foo42.1
  /// - in a complex build the first numeric part gets incremented:
  ///   1.2.3+foo.1.2.3.bar -> 1.2.3+foo.2.0.0.bar
  Version get nextBuild {
    var incremented = false;
    final next = build.map((part) {
      if (part is! int) return part;
      if (incremented) return 0;
      incremented = true;
      return part + 1;
    }).toList();
    if (!incremented) next.add(1);
    return change(build: next);
  }
}
