// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

// Keeps clinical-safety/signoff.md synchronised with the codebase.
//
// A register of files awaiting clinical sign-off is only trustworthy if it
// cannot fall behind the code. This test fails when a file requiring sign-off
// is absent from the register, when the register names a file that no longer
// exists, and when a file is quietly moved from the review list to the exempt
// list without that change being visible in the diff.
//
// It deliberately does not check the tick state: whether a file has been
// signed off is recorded in the file's own header block and verified by
// test/architecture/clinical_source_convention_test.dart.

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

const _registerPath = 'clinical-safety/signoff.md';

/// Directories whose Dart files require clinical sign-off. Kept identical to
/// the scope used by the source-convention test.
const _clinicalSourceDirectories = <String>['lib/calculations'];

/// Files that carry no clinical meaning and so need no sign-off. This list is
/// asserted against the register below, so an exemption cannot be added in
/// code alone.
const _exemptFiles = <String>{
  'lib/calculations/calculation_outcome.dart',
};

/// Matches a markdown checkbox entry naming a Dart file in backticks, for
/// example: "- [ ] `lib/calculations/patient_context.dart` - description".
final _checkboxEntryPattern =
    RegExp(r'^- \[[ xX]\] `([^`]+\.dart)`', multiLine: true);

/// Matches a plain bullet naming a Dart file, used in the exempt section.
final _plainEntryPattern = RegExp(r'^- `([^`]+\.dart)`', multiLine: true);

void main() {
  final register = File(_registerPath);

  test('the clinical sign-off register exists', () {
    expect(register.existsSync(), isTrue,
        reason: '$_registerPath is the definitive list of files awaiting '
            'clinical sign-off and must be present.');
  });

  final contents = register.readAsStringSync();

  final registeredForSignOff = _checkboxEntryPattern
      .allMatches(contents)
      .map((match) => match.group(1)!)
      .toSet();
  final registeredAsExempt =
      _plainEntryPattern.allMatches(contents).map((m) => m.group(1)!).toSet();

  final actualClinicalFiles = _clinicalSourceDirectories
      .expand(
        (directory) => Directory(directory)
            .listSync(recursive: true)
            .whereType<File>()
            .map((file) => file.path)
            .where((path) => path.endsWith('.dart')),
      )
      .toSet();

  final expectedForSignOff =
      actualClinicalFiles.difference(_exemptFiles).toSet();

  test('every file requiring clinical sign-off is listed with a checkbox', () {
    final missing = expectedForSignOff.difference(registeredForSignOff);

    expect(missing, isEmpty,
        reason: 'These files require clinical sign-off but are not listed in '
            '$_registerPath: ${missing.join(', ')}');
  });

  test('the register lists no file that has been removed or renamed', () {
    final stale = registeredForSignOff.difference(actualClinicalFiles);

    expect(stale, isEmpty,
        reason: '$_registerPath lists files that no longer exist: '
            '${stale.join(', ')}');
  });

  test('exemptions in code and in the register agree', () {
    // Catches a file being dropped from review by editing only one of the two
    // places, which is exactly how an unreviewed calculation could slip
    // through.
    expect(registeredAsExempt.intersection(actualClinicalFiles), _exemptFiles,
        reason: 'The exempt list in $_registerPath must match the exempt list '
            'in this test.');
  });

  test('no exempt file is also listed as requiring sign-off', () {
    expect(registeredForSignOff.intersection(_exemptFiles), isEmpty,
        reason: 'A file cannot be both exempt from and awaiting clinical '
            'sign-off.');
  });

  test('legacy migration material is never listed for sign-off', () {
    // lib/legacy/ is inherited evidence. Signing it off would imply the
    // unreviewed legacy behaviour had been approved.
    expect(
      registeredForSignOff.where((path) => path.startsWith('lib/legacy/')),
      isEmpty,
      reason: 'Legacy migration files must not be presented for clinical '
          'sign-off.',
    );
  });
}
