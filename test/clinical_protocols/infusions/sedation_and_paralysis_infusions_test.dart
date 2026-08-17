// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

// Inherited-baseline regression tests, not source-derived clinical vectors.
// The discrepancies asserted here remain pending current formulary review.

import 'package:flutter_test/flutter_test.dart';
import 'package:neomate2/calculations/patient_context.dart';
import 'package:neomate2/calculations/protocol_calculation.dart';
import 'package:neomate2/clinical_policy/neonatal_weight_policy.dart';
import 'package:neomate2/clinical_protocols/infusions/morphine_infusion.dart';
import 'package:neomate2/clinical_protocols/infusions/vecuronium_infusion.dart';

void main() {
  final weight = (PatientWeight.validate(
    grams: 3000,
    policy: neonatalWeightPolicy,
  ) as ValidWeight)
      .weight;
  final patient =
      PatientContext(weight: weight, weightOrigin: WeightOrigin.measured);

  ProtocolCalculationResult<InfusionPreparation> run(
    WeightBasedInfusionProtocol protocol, {
    VascularAccess access = VascularAccess.central,
  }) =>
      protocol.calculate(
        patient: patient,
        route: AdministrationRoute.intravenous,
        access: access,
      );

  test('records the contradictory inherited morphine ranges explicitly', () {
    expect(morphineApprovedDose.minimum, 5);
    expect(morphineApprovedDose.maximum, 60);
    expect(morphineUsualDose.minimum, 5);
    expect(morphineUsualDose.maximum, 20);
    expect(morphineApprovedConcentration.maximum, 30000);
  });

  test('prepares morphine using an hourly dose basis', () {
    final result = run(morphineInfusion(dosePerKilogramPerHour: 5))
        as ProtocolCalculationSuccess<InfusionPreparation>;

    // 5 mcg/kg/hour x 3 kg / 0.1 mL/hour = 150 mcg/mL.
    expect(result.value.concentrationPerMillilitre, 150);
    expect(result.value.amountInSyringe, 7500);
    expect(result.value.amountUnit, DoseUnit.micrograms);
  });

  test('enforces the inherited morphine dose ceiling', () {
    final zero = run(morphineInfusion(dosePerKilogramPerHour: 0))
        as ProtocolCalculationFailure<InfusionPreparation>;
    final result = run(morphineInfusion(dosePerKilogramPerHour: 61))
        as ProtocolCalculationFailure<InfusionPreparation>;

    expect(zero.issue, ProtocolCalculationIssue.doseBelowApprovedRange);
    expect(result.issue, ProtocolCalculationIssue.doseAboveApprovedRange);
  });

  test('uses the stricter stated vecuronium concentration ceiling', () {
    expect(vecuroniumApprovedDose.minimum, 50);
    expect(vecuroniumApprovedDose.maximum, 200);
    expect(vecuroniumApprovedConcentration.maximum, 2000);

    final accepted = run(vecuroniumInfusion(dosePerKilogramPerHour: 100))
        as ProtocolCalculationSuccess<InfusionPreparation>;
    expect(accepted.value.concentrationPerMillilitre, 300);

    final refused = run(
      vecuroniumInfusion(
        dosePerKilogramPerHour: 200,
        rateMillilitresPerHour: 0.1,
      ),
    ) as ProtocolCalculationFailure<InfusionPreparation>;
    expect(
      refused.issue,
      ProtocolCalculationIssue.concentrationAboveApprovedRange,
    );
  });

  test('conservatively refuses peripheral access for both protocols', () {
    for (final protocol in [
      morphineInfusion(dosePerKilogramPerHour: 5),
      vecuroniumInfusion(dosePerKilogramPerHour: 100),
    ]) {
      final result = run(protocol, access: VascularAccess.peripheral)
          as ProtocolCalculationFailure<InfusionPreparation>;
      expect(result.issue, ProtocolCalculationIssue.accessNotApproved);
    }
  });
}
