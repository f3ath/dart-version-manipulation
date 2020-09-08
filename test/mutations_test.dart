import 'package:pub_semver/pub_semver.dart';
import 'package:test/test.dart';
import 'package:version_manipulation/mutations.dart';

void main() {
  group('Mutations', () {
    test('BumpBreaking', () {
      check(BumpBreaking(), {'0.2.3-alpha+42': '0.3.0'});
    });
    test('BumpMajor', () {
      check(BumpMajor(), {'0.2.3-alpha+42': '1.0.0'});
    });
    test('BumpMinor', () {
      check(BumpMinor(), {'0.2.3-alpha+42': '0.3.0'});
    });
    test('BumpPatch', () {
      check(BumpPatch(), {'0.2.3-alpha+42': '0.2.3'});
    });
    test('BumpBuild', () {
      check(BumpBuild(), {
        '0.2.3-alpha+42': '0.2.3-alpha+43',
        '0.2.3-alpha+foo': '0.2.3-alpha+foo.1',
        '0.2.3-alpha+foo.42.2': '0.2.3-alpha+foo.43.0',
      });
    });
    test('KeepBuild', () {
      check(KeepBuild(BumpBreaking()), {
        '0.2.3-alpha+foo.1.2.3': '0.3.0+foo.1.2.3',
        '0.2.3': '0.3.0',
      });
      check(KeepBuild(BumpMajor()), {
        '0.2.3-alpha+foo.1.2.3': '1.0.0+foo.1.2.3',
        '0.2.3': '1.0.0',
      });
      check(KeepBuild(BumpMinor()), {
        '0.2.3-alpha+foo.1.2.3': '0.3.0+foo.1.2.3',
        '0.2.3': '0.3.0',
      });
      check(KeepBuild(BumpPatch()), {
        '0.2.3-alpha+foo.1.2.3': '0.2.3+foo.1.2.3',
        '0.2.3': '0.2.4',
      });
      check(KeepBuild(BumpBuild()), {
        '0.2.3-alpha+foo.1.2.3': '0.2.3-alpha+foo.1.2.3',
        '0.2.3': '0.2.3',
      });
    });
    test('KeepPreRelease', () {
      check(KeepPreRelease(BumpBreaking()), {
        '0.2.3-alpha+foo.1.2.3': '0.3.0-alpha',
        '0.2.3': '0.3.0',
      });
      check(KeepPreRelease(BumpMajor()), {
        '0.2.3-alpha+foo.1.2.3': '1.0.0-alpha',
        '0.2.3': '1.0.0',
      });
      check(KeepPreRelease(BumpMinor()), {
        '0.2.3-alpha+foo.1.2.3': '0.3.0-alpha',
        '0.2.3': '0.3.0',
      });
      check(KeepPreRelease(BumpPatch()), {
        '0.2.3-alpha+foo.1.2.3': '0.2.4-alpha',
        '0.2.3': '0.2.4',
      });
      check(KeepPreRelease(BumpBuild()), {
        '0.2.3-alpha+foo.1.2.3': '0.2.3-alpha+foo.2.0.0',
        '0.2.3': '0.2.3+1',
      });
    });
    test('KeepPreRelease and KeepBuild', () {
      check(KeepPreRelease(KeepBuild(BumpBreaking())), {
        '0.2.3-alpha+foo.1.2.3': '0.3.0-alpha+foo.1.2.3',
        '0.2.3': '0.3.0',
      });
      check(KeepPreRelease(KeepBuild(BumpMajor())), {
        '0.2.3-alpha+foo.1.2.3': '1.0.0-alpha+foo.1.2.3',
        '0.2.3': '1.0.0',
      });
      check(KeepPreRelease(KeepBuild(BumpMinor())), {
        '0.2.3-alpha+foo.1.2.3': '0.3.0-alpha+foo.1.2.3',
        '0.2.3': '0.3.0',
      });
      check(KeepPreRelease(KeepBuild(BumpPatch())), {
        '0.2.3-alpha+foo.1.2.3': '0.2.4-alpha+foo.1.2.3',
        '0.2.3': '0.2.4',
      });
      check(KeepPreRelease(KeepBuild(BumpBuild())), {
        '0.2.3-alpha+foo.1.2.3': '0.2.3-alpha+foo.1.2.3',
        '0.2.3': '0.2.3',
      });

      check(KeepBuild(KeepPreRelease(BumpBreaking())), {
        '0.2.3-alpha+foo.1.2.3': '0.3.0-alpha+foo.1.2.3',
        '0.2.3': '0.3.0',
      });
      check(KeepBuild(KeepPreRelease(BumpMajor())), {
        '0.2.3-alpha+foo.1.2.3': '1.0.0-alpha+foo.1.2.3',
        '0.2.3': '1.0.0',
      });
      check(KeepBuild(KeepPreRelease(BumpMinor())), {
        '0.2.3-alpha+foo.1.2.3': '0.3.0-alpha+foo.1.2.3',
        '0.2.3': '0.3.0',
      });
      check(KeepBuild(KeepPreRelease(BumpPatch())), {
        '0.2.3-alpha+foo.1.2.3': '0.2.4-alpha+foo.1.2.3',
        '0.2.3': '0.2.4',
      });
      check(KeepBuild(KeepPreRelease(BumpBuild())), {
        '0.2.3-alpha+foo.1.2.3': '0.2.3-alpha+foo.1.2.3',
        '0.2.3': '0.2.3',
      });
    });
  });
}

void check(VersionMutation mutation, Map<String, String> changes) {
  changes.forEach((from, to) {
    expect(mutation(Version.parse(from)).toString(), to);
  });
}
