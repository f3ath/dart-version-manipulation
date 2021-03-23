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

/// Bumps the pre-release version
class BumpPreRelease implements VersionMutation {
  const BumpPreRelease();

  @override
  Version call(Version version) => version.nextPreRelease;
}

/// A wrapper that keeps the original build
class KeepBuild implements VersionMutation {
  const KeepBuild(this.wrapped);

  final VersionMutation wrapped;

  @override
  Version call(Version version) =>
      wrapped.call(version.change(build: [])).change(build: version.build);
}
