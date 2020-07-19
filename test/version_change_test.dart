import 'package:pub_semver/pub_semver.dart';
import 'package:test/test.dart';
import 'package:version_manipulation/mutations.dart';
import 'package:version_manipulation/version_extension.dart';

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
  group('Mutations', () {
    test('BumpBreaking', () {
      expect(BumpBreaking()(Version.parse('0.2.3+foo')).toString(), '0.3.0');
    });
    test('BumpMajor', () {
      expect(BumpMajor()(Version.parse('0.2.3+foo')).toString(), '1.0.0');
    });
    test('BumpMinor', () {
      expect(BumpMinor()(Version.parse('0.2.3+foo')).toString(), '0.3.0');
    });
    test('BumpPatch', () {
      expect(BumpPatch()(Version.parse('0.2.3+foo')).toString(), '0.2.4');
    });
    test('BumpBuild', () {
      expect(BumpBuild()(Version.parse('0.2.3+foo')).toString(), '0.2.3+foo.1');
    });
    test('KeepBuild', () {
      expect(KeepBuild(BumpBreaking())(Version.parse('0.2.3+foo')).toString(),
          '0.3.0+foo');
    });
  });
}
