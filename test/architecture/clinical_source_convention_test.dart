// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

// Makes spec/clinical-source-convention.md executable.
//
// The convention requires every active clinical Dart file to carry a
// structured provenance and sign-off comment block. A document alone cannot
// stop a new calculation being added without one, so this test walks the
// calculation modules and checks the block is present and internally
// consistent.
//
// The most important rule enforced here is the last one: a file may not claim
// clinical approval unless it also names a source, a reviewer, and a review-due
// date. That prevents a partially-filled header from reading as a sign-off.

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Directories whose Dart files are treated as clinical source files.
const _clinicalSourceDirectories = <String>[
  'lib/calculations',
  'lib/clinical_policy'
];

/// Files exempt from the convention, each with the reason it qualifies under
/// the "generic technical infrastructure or non-clinical value types" rule.
/// Adding an entry here is a deliberate, reviewable act.
const _exemptFiles = <String, String>{
  'lib/calculations/calculation_outcome.dart':
      'Generic result and error value types. Contains no formula, threshold, '
          'dose, or clinical statement.',
};

/// The fields the convention requires, in the order it specifies them.
const _requiredFields = <String>[
  'Clinical source IDs',
  'Clinical content IDs',
  'Clinical reviewer',
  'Clinical sign-off',
  'Review due',
  'Safety hazards',
];

/// `approved`, `rejected`, or `superseded` followed by an ISO 8601 date, or the
/// literal `none` while a file is awaiting review.
final _signOffPattern =
    RegExp(r'^(none|(approved|rejected|superseded) \d{4}-\d{2}-\d{2})$');

final _reviewDuePattern = RegExp(r'^(none|\d{4}-\d{2}-\d{2})$');

void main() {
  final clinicalFiles = _clinicalSourceDirectories
      .expand(
        (directory) => Directory(directory)
            .listSync(recursive: true)
            .whereType<File>()
            .where((file) => file.path.endsWith('.dart')),
      )
      .toList()
    ..sort((a, b) => a.path.compareTo(b.path));

  test('clinical source directories are not empty', () {
    // Guards against the whole suite silently passing if the directories are
    // renamed or moved.
    expect(clinicalFiles, isNotEmpty);
  });

  test('every exemption refers to a file that exists', () {
    for (final path in _exemptFiles.keys) {
      expect(File(path).existsSync(), isTrue,
          reason: 'Stale exemption for missing file $path');
    }
  });

  for (final file in clinicalFiles) {
    final path = file.path;
    if (_exemptFiles.containsKey(path)) {
      continue;
    }

    group(path, () {
      final fields = _parseFields(file.readAsStringSync());

      test('carries every required clinical provenance field', () {
        for (final field in _requiredFields) {
          expect(fields.containsKey(field), isTrue,
              reason: '$path is missing the "$field" comment field. See '
                  'spec/clinical-source-convention.md.');
        }
      });

      test('states its clinical approval status in a recognised form', () {
        expect(
            _signOffPattern.hasMatch(fields['Clinical sign-off'] ?? ''), isTrue,
            reason: 'Clinical sign-off must be "none" or one of approved / '
                'rejected / superseded with an ISO 8601 date.');
        expect(_reviewDuePattern.hasMatch(fields['Review due'] ?? ''), isTrue,
            reason: 'Review due must be "none" or an ISO 8601 date.');
      });

      test('does not claim approval without source, reviewer, and review date',
          () {
        final signOff = fields['Clinical sign-off'] ?? '';
        if (!signOff.startsWith('approved')) {
          return;
        }

        expect(fields['Clinical source IDs'], isNot('none assigned'),
            reason: 'An approved clinical file must cite its source IDs.');
        expect(fields['Clinical reviewer'], isNot('none'),
            reason: 'An approved clinical file must name its reviewer.');
        expect(fields['Review due'], isNot('none'),
            reason: 'An approved clinical file must carry a review-due date.');
      });
    });
  }
}

/// Extracts `// Field: value` pairs from the comment block at the top of a
/// source file. Reading stops at the first non-comment line so that a field
/// name appearing later in the body cannot be mistaken for a header field.
Map<String, String> _parseFields(String contents) {
  final fields = <String, String>{};
  for (final rawLine in contents.split('\n')) {
    final line = rawLine.trim();
    if (line.isEmpty) {
      continue;
    }
    if (!line.startsWith('//')) {
      break;
    }
    final withoutSlashes = line.substring(2).trim();
    final separator = withoutSlashes.indexOf(':');
    if (separator <= 0) {
      continue;
    }
    final name = withoutSlashes.substring(0, separator).trim();
    if (_requiredFields.contains(name)) {
      fields[name] = withoutSlashes.substring(separator + 1).trim();
    }
  }
  return fields;
}
