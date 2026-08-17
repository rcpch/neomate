// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter_test/flutter_test.dart';
import 'package:neomate2/clinical_policy/retired_bolus_policy.dart';

void main() {
  test('retires the two obsolete inherited resuscitation boluses', () {
    expect(retiredBolusAlgorithms, hasLength(2));
    expect(
      retiredBolusAlgorithms.map((entry) => entry.id),
      containsAll({
        'RETIRED-BOLUS-SODIUM-BICARBONATE-RESUSCITATION',
        'RETIRED-BOLUS-EMPIRICAL-DEXTROSE-10',
      }),
    );
  });

  test('every retirement has dated, externally verifiable evidence', () {
    for (final retirement in retiredBolusAlgorithms) {
      expect(retirement.retiredOn, DateTime.utc(2026, 8, 17));
      expect(Uri.parse(retirement.authorityUrl).scheme, 'https');
      expect(retirement.authorityTitle, isNotEmpty);
      expect(retirement.retiredOutput, isNotEmpty);
      expect(retirement.reason, isNotEmpty);
      if (retirement.supportingEvidenceUrl case final evidenceUrl?) {
        expect(Uri.parse(evidenceUrl).scheme, 'https');
        expect(retirement.supportingEvidenceTitle, isNotEmpty);
      }
    }
  });

  test('retirement wording preserves post-resuscitation scope', () {
    final bicarbonate = retiredBolusAlgorithms.first;
    expect(bicarbonate.title, contains('resuscitation'));
    expect(bicarbonate.reason, contains('newborn resuscitation'));
    expect(bicarbonate.reason, isNot(contains('never')));
  });
}
