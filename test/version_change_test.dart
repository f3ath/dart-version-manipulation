import 'package:pub_semver/pub_semver.dart';
import 'package:test/test.dart';
import 'package:version_manipulation/version_manipulation.dart';

void main() {
  final version = Version.parse('0.1.3+foo.1');
  test('Set build', () {
    expect(version.change(build: ['moo']).toString(), '0.1.3+moo');
  });
  group('Build', () {
    test('bumping empty build sets it to 1', () {
      expect(Version.parse('1.2.3').nextBuild.toString(), '1.2.3+1');
    });

    test('non-numeric build gets ".1" appended to it', () {
      expect(
          Version.parse('1.2.3+foo42').nextBuild.toString(), '1.2.3+foo42.1');
    });

    test('in a complex build the first numeric part gets incremented', () {
      expect(Version.parse('1.2.3+foo.1.2.3.bar').nextBuild.toString(),
          '1.2.3+foo.2.0.0.bar');
    });
  });
}
