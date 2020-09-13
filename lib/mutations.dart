/// Mutations which can be applied to the [Version]
library mutations;

import 'package:pub_semver/pub_semver.dart';
import 'package:version_manipulation/version_extension.dart';

/// A mutation which can be applied to the [Version]
abstract class VersionMutation {
  Version call(Version version);
}

/// Bumps the breaking version
class BumpBreaking implements VersionMutation {
  const BumpBreaking();

  @override
  Version call(Version version) => version.nextBreaking;
}

/// Bumps the major version
class BumpMajor implements VersionMutation {
  const BumpMajor();

  @override
  Version call(Version version) => version.nextMajor;
}

/// Bumps the minor version
class BumpMinor implements VersionMutation {
  const BumpMinor();

  @override
  Version call(Version version) => version.nextMinor;
}

/// Bumps the patch version
class BumpPatch implements VersionMutation {
  const BumpPatch();

  @override
  Version call(Version version) => version.nextPatch;
}

/// Bumps the build version
class BumpBuild implements VersionMutation {
  const BumpBuild();

  @override
  Version call(Version version) => version.nextBuild;
}

/// A wrapper that keeps the original build
class KeepBuild implements VersionMutation {
  const KeepBuild(this.wrapped);

  final VersionMutation wrapped;

  @override
  Version call(Version version) {
    final mutated = wrapped.call(version);
    return Version(mutated.major, mutated.minor, mutated.patch,
        pre: _join(mutated.preRelease), build: _join(version.build));
  }
}

/// A wrapper that keeps original pre-release part
class KeepPreRelease implements VersionMutation {
  const KeepPreRelease(this.wrapped);

  final VersionMutation wrapped;

  @override
  Version call(Version version) {
    final versionWithoutPreRelease = Version(
        version.major, version.minor, version.patch,
        build: _join(version.build));
    final mutated = wrapped.call(versionWithoutPreRelease);
    return Version(mutated.major, mutated.minor, mutated.patch,
        pre: _join(version.preRelease), build: _join(mutated.build));
  }
}

/// A chain of mutations applied sequentially
class MutationChain implements VersionMutation {
  MutationChain(Iterable<VersionMutation> mutations) {
    _mutations.addAll(mutations ?? []);
  }

  final _mutations = <VersionMutation>[];

  @override
  Version call(Version version) {
    var v = version;
    _mutations.forEach((m) {
      v = m(v);
    });
    return v;
  }
}

String _join(List elements) => elements.isEmpty ? null : elements.join('.');
