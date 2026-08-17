// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

// Inherited-baseline regression tests, not source-derived clinical vectors.

import 'package:flutter_test/flutter_test.dart';
import 'package:neomate2/calculations/patient_context.dart';
import 'package:neomate2/calculations/protocol_calculation.dart';
import 'package:neomate2/clinical_policy/neonatal_weight_policy.dart';
import 'package:neomate2/clinical_protocols/infusions/clonazepam_infusion.dart';
import 'package:neomate2/clinical_protocols/infusions/midazolam_infusion.dart';

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

  test('records inherited neurological dose and concentration bounds', () {
    expect(clonazepamApprovedDose.minimum, 10);
    expect(clonazepamApprovedDose.maximum, 40);
    expect(clonazepamApprovedConcentration.maximum, 12);
    expect(midazolamApprovedDose.minimum, 30);
    expect(midazolamApprovedDose.maximum, 300);
    expect(midazolamDisplayedDose.minimum, 30);
    expect(midazolamDisplayedDose.maximum, 60);
    expect(midazolamApprovedConcentration.maximum, 1000);
  });

  test('clonazepam calculates the contradictory default with an advisory', () {
    // 10 mcg/kg/hour x 3 kg / 1 mL/hour = 30 mcg/mL, above the
    // inherited human-readable ceiling of 12 mcg/mL.
    final result = run(clonazepamInfusion(dosePerKilogramPerHour: 10))
        as ProtocolCalculationSuccess<InfusionPreparation>;

    expect(
      result.advisories,
      contains(
        ProtocolCalculationAdvisory.concentrationAboveConfiguredRange,
      ),
    );
    expect(result.value.amountInSyringe, 1500);
  });

  test('clonazepam accepts a preparation within the concentration ceiling', () {
    final result = run(
      clonazepamInfusion(
        dosePerKilogramPerHour: 10,
        rateMillilitresPerHour: 3,
      ),
    ) as ProtocolCalculationSuccess<InfusionPreparation>;

    expect(result.value.concentrationPerMillilitre, 10);
    expect(result.value.amountInSyringe, 500);
  });

  test('midazolam reports numeric bounds and the 1 mg/mL ceiling', () {
    final accepted = run(midazolamInfusion(dosePerKilogramPerHour: 30))
        as ProtocolCalculationSuccess<InfusionPreparation>;
    expect(accepted.value.concentrationPerMillilitre, 900);

    final aboveDose = run(midazolamInfusion(dosePerKilogramPerHour: 301))
        as ProtocolCalculationSuccess<InfusionPreparation>;
    expect(
      aboveDose.advisories,
      contains(ProtocolCalculationAdvisory.doseAboveConfiguredRange),
    );

    final aboveConcentration = run(
      midazolamInfusion(
        dosePerKilogramPerHour: 30,
        rateMillilitresPerHour: 0.05,
      ),
    ) as ProtocolCalculationSuccess<InfusionPreparation>;
    expect(
      aboveConcentration.advisories,
      contains(
        ProtocolCalculationAdvisory.concentrationAboveConfiguredRange,
      ),
    );
  });

  test('both protocols report peripheral access without blocking', () {
    for (final protocol in [
      clonazepamInfusion(
        dosePerKilogramPerHour: 10,
        rateMillilitresPerHour: 3,
      ),
      midazolamInfusion(dosePerKilogramPerHour: 30),
    ]) {
      final result = run(protocol, access: VascularAccess.peripheral)
          as ProtocolCalculationSuccess<InfusionPreparation>;
      expect(
        result.advisories,
        contains(ProtocolCalculationAdvisory.accessOutsideConfiguredUse),
      );
    }
  });
}
