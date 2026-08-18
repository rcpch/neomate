// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter_test/flutter_test.dart';
import 'package:neomate2/clinical_protocols/boluses/bolus_catalogue.dart';

void main() {
  test('bolus catalogue exposes named records and excludes retired outputs',
      () {
    expect(bolusProtocols, hasLength(15));
    expect(bolusProtocols.map((record) => record.id).toSet(), hasLength(15));
    expect(
        bolusProtocols.every((record) => record.dosePerKilogram > 0), isTrue);
    expect(
        bolusProtocols
            .any((record) => record.name.contains('Sodium bicarbonate')),
        isFalse);
    expect(bolusProtocols.any((record) => record.name.contains('Dextrose')),
        isFalse);
  });

  test('calculates weight-based amounts without a review gate', () {
    final fentanyl =
        bolusProtocols.singleWhere((record) => record.id == 'BOLUS-FENTANYL');
    final adrenaline = bolusProtocols
        .singleWhere((record) => record.id == 'BOLUS-ADRENALINE-RESUSCITATION');

    expect(fentanyl.amountForKilograms(3), 15);
    expect(adrenaline.amountForKilograms(3), closeTo(0.6, 1e-9));
  });
}
