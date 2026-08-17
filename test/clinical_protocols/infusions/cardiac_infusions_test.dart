// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

// Tests for the inherited cardiac infusion protocols.
//
// These assert the dose and concentration bounds themselves, so that a limit
// carried forward from the shipped product cannot be changed without a test
// failing and forcing a conversation. They are inherited-baseline regression
// tests, not source-derived conformance vectors: the latter arrive with
// clinical review, when the figures are checked against the current BNFc.
//
// Each protocol is also exercised through the calculation engine to confirm
// configured bounds are reported as non-blocking review advisories.

import 'package:flutter_test/flutter_test.dart';
import 'package:neomate2/calculations/patient_context.dart';
import 'package:neomate2/calculations/protocol_calculation.dart';
import 'package:neomate2/clinical_policy/neonatal_weight_policy.dart';
import 'package:neomate2/clinical_protocols/infusions/adrenaline_infusion.dart';
import 'package:neomate2/clinical_protocols/infusions/dinoprostone_infusion.dart';
import 'package:neomate2/clinical_protocols/infusions/dobutamine_infusion.dart';
import 'package:neomate2/clinical_protocols/infusions/dopamine_infusion.dart';
import 'package:neomate2/clinical_protocols/infusions/noradrenaline_infusion.dart';

void main() {
  final weight = (PatientWeight.validate(
    grams: 3000,
    policy: neonatalWeightPolicy,
  ) as ValidWeight)
      .weight;
  final patient =
      PatientContext(weight: weight, weightOrigin: WeightOrigin.measured);

  ProtocolCalculationResult<InfusionPreparation> run(
    WeightBasedInfusionProtocol protocol,
  ) =>
      protocol.calculate(
        patient: patient,
        route: AdministrationRoute.intravenous,
        access: VascularAccess.central,
      );

  group('inherited dose bounds', () {
    test('match the values carried forward from the shipped product', () {
      // Dopamine 5-20 mcg/kg/min.
      expect(dopamineApprovedDose.minimum, 5);
      expect(dopamineApprovedDose.maximum, 20);
      // Dobutamine 2-20 mcg/kg/min.
      expect(dobutamineApprovedDose.minimum, 2);
      expect(dobutamineApprovedDose.maximum, 20);
      // Adrenaline and noradrenaline 50-500 ng/kg/min.
      expect(adrenalineApprovedDose.minimum, 50);
      expect(adrenalineApprovedDose.maximum, 500);
      expect(noradrenalineApprovedDose.minimum, 50);
      expect(noradrenalineApprovedDose.maximum, 500);
      // Dinoprostone 1-20 ng/kg/min enforced, 5-10 described as usual.
      expect(dinoprostoneApprovedDose.minimum, 1);
      expect(dinoprostoneApprovedDose.maximum, 20);
      expect(dinoprostoneUsualDose.minimum, 5);
      expect(dinoprostoneUsualDose.maximum, 10);
    });
  });

  group('inherited concentration limits', () {
    test('convert the syringe limits to a concentration per millilitre', () {
      // Dopamine 80 mg / 50 mL = 1.6 mg/mL = 1600 micrograms/mL.
      expect(dopamineApprovedConcentration.maximum, 1600);
      // Dobutamine 500 mg / 50 mL = 10 mg/mL = 10000 micrograms/mL.
      expect(dobutamineApprovedConcentration.maximum, 10000);
      // Adrenaline 12 mg / 50 mL = 0.24 mg/mL = 240000 nanograms/mL.
      expect(adrenalineApprovedConcentration.maximum, 240000);
      // Noradrenaline 2 mg / 50 mL = 40 micrograms/mL = 40000 nanograms/mL,
      // matching the 40 micrograms/mL limit stated by the inherited product.
      expect(noradrenalineApprovedConcentration.maximum, 40000);
      // Dinoprostone 0.05 mg / 50 mL = 1 microgram/mL = 1000 nanograms/mL.
      expect(dinoprostoneApprovedConcentration.maximum, 1000);
    });
  });

  group('dopamine infusion', () {
    test('prepares an infusion and reports concentration advisory', () {
      // 10 mcg/kg/min x 3 kg = 30 mcg/min = 1800 mcg/hour.
      // At 1 mL/hour that is 1800 mcg/mL, which is above the 1600 mcg/mL
      // limit, so the preparation carries an advisory at this dose.
      final result = run(dopamineInfusion(dosePerKilogramPerMinute: 10))
          as ProtocolCalculationSuccess<InfusionPreparation>;

      expect(
        result.advisories,
        contains(
          ProtocolCalculationAdvisory.concentrationAboveConfiguredRange,
        ),
      );
    });

    test('accepts a preparation within the concentration limit', () {
      // Same dose at 2 mL/hour gives 900 mcg/mL, within the limit.
      final result = run(
        dopamineInfusion(
          dosePerKilogramPerMinute: 10,
          rateMillilitresPerHour: 2,
        ),
      ) as ProtocolCalculationSuccess<InfusionPreparation>;

      expect(result.value.concentrationPerMillilitre, closeTo(900, 1e-6));
      expect(result.value.amountInSyringe, closeTo(45000, 1e-6));
      expect(result.value.amountUnit, DoseUnit.micrograms);
    });

    test('reports a dose below and above the configured range', () {
      final tooLow = run(dopamineInfusion(dosePerKilogramPerMinute: 4))
          as ProtocolCalculationSuccess<InfusionPreparation>;
      final tooHigh = run(dopamineInfusion(dosePerKilogramPerMinute: 25))
          as ProtocolCalculationSuccess<InfusionPreparation>;

      expect(
        tooLow.advisories,
        contains(ProtocolCalculationAdvisory.doseBelowConfiguredRange),
      );
      expect(
        tooHigh.advisories,
        contains(ProtocolCalculationAdvisory.doseAboveConfiguredRange),
      );
    });

    test('reports peripheral access for review without blocking', () {
      final result = dopamineInfusion(dosePerKilogramPerMinute: 10).calculate(
        patient: patient,
        route: AdministrationRoute.intravenous,
        access: VascularAccess.peripheral,
      ) as ProtocolCalculationSuccess<InfusionPreparation>;

      expect(
        result.advisories,
        contains(ProtocolCalculationAdvisory.accessOutsideConfiguredUse),
      );
    });

    test('reports a non-intravenous route without blocking', () {
      final result = dopamineInfusion(dosePerKilogramPerMinute: 10).calculate(
        patient: patient,
        route: AdministrationRoute.enteral,
        access: VascularAccess.central,
      ) as ProtocolCalculationSuccess<InfusionPreparation>;

      expect(
        result.advisories,
        contains(ProtocolCalculationAdvisory.routeOutsideConfiguredUse),
      );
    });
  });

  group('adrenaline infusion', () {
    test('prepares the inherited 0.1 mL/hour preparation', () {
      // 100 ng/kg/min x 3 kg = 300 ng/min = 18000 ng/hour.
      // At 0.1 mL/hour that is 180000 ng/mL, within the 240000 limit.
      final result = run(adrenalineInfusion(dosePerKilogramPerMinute: 100))
          as ProtocolCalculationSuccess<InfusionPreparation>;

      expect(result.value.concentrationPerMillilitre, closeTo(180000, 1e-3));
      expect(result.value.amountUnit, DoseUnit.nanograms);
    });

    test('reports a dose outside the configured range', () {
      final tooHigh = run(adrenalineInfusion(dosePerKilogramPerMinute: 600))
          as ProtocolCalculationSuccess<InfusionPreparation>;

      expect(
        tooHigh.advisories,
        contains(ProtocolCalculationAdvisory.doseAboveConfiguredRange),
      );
    });
  });

  group('every inherited cardiac infusion', () {
    test('accepts a dose at each inclusive bound of its approved range', () {
      // A dose exactly on the minimum or maximum must be permitted, so that
      // the bounds do not silently exclude the doses they name. The rate is
      // raised where needed so the concentration limit is not the thing being
      // tested here.
      final atBounds = <String, List<WeightBasedInfusionProtocol>>{
        'dopamine': [
          dopamineInfusion(
            dosePerKilogramPerMinute: dopamineApprovedDose.minimum,
            rateMillilitresPerHour: 2,
          ),
          dopamineInfusion(
            dosePerKilogramPerMinute: dopamineApprovedDose.maximum,
            rateMillilitresPerHour: 4,
          ),
        ],
        'dobutamine': [
          dobutamineInfusion(
            dosePerKilogramPerMinute: dobutamineApprovedDose.minimum,
            rateMillilitresPerHour: 2,
          ),
          dobutamineInfusion(
            dosePerKilogramPerMinute: dobutamineApprovedDose.maximum,
            rateMillilitresPerHour: 2,
          ),
        ],
        'adrenaline': [
          adrenalineInfusion(
            dosePerKilogramPerMinute: adrenalineApprovedDose.minimum,
          ),
          adrenalineInfusion(
            dosePerKilogramPerMinute: adrenalineApprovedDose.maximum,
            rateMillilitresPerHour: 0.5,
          ),
        ],
        'noradrenaline': [
          noradrenalineInfusion(
            dosePerKilogramPerMinute: noradrenalineApprovedDose.minimum,
            rateMillilitresPerHour: 0.5,
          ),
          noradrenalineInfusion(
            dosePerKilogramPerMinute: noradrenalineApprovedDose.maximum,
            rateMillilitresPerHour: 3,
          ),
        ],
        'dinoprostone': [
          dinoprostoneInfusion(
            dosePerKilogramPerMinute: dinoprostoneApprovedDose.minimum,
          ),
          dinoprostoneInfusion(
            dosePerKilogramPerMinute: dinoprostoneApprovedDose.maximum,
            rateMillilitresPerHour: 4,
          ),
        ],
      };

      atBounds.forEach((name, protocols) {
        for (final protocol in protocols) {
          expect(
            run(protocol),
            isA<ProtocolCalculationSuccess<InfusionPreparation>>(),
            reason: '$name should accept a dose on its inclusive bound',
          );
        }
      });
    });

    test('reports its own configured dose ceiling', () {
      final aboveCeiling = <String, WeightBasedInfusionProtocol>{
        'dopamine': dopamineInfusion(dosePerKilogramPerMinute: 21),
        'dobutamine': dobutamineInfusion(dosePerKilogramPerMinute: 21),
        'adrenaline': adrenalineInfusion(dosePerKilogramPerMinute: 501),
        'noradrenaline': noradrenalineInfusion(dosePerKilogramPerMinute: 501),
        'dinoprostone': dinoprostoneInfusion(dosePerKilogramPerMinute: 21),
      };

      aboveCeiling.forEach((name, protocol) {
        final result =
            run(protocol) as ProtocolCalculationSuccess<InfusionPreparation>;
        expect(
          result.advisories,
          contains(ProtocolCalculationAdvisory.doseAboveConfiguredRange),
          reason: '$name should report a dose above its configured ceiling',
        );
      });
    });

    test('reports access outside central or umbilical venous use', () {
      final protocols = <String, WeightBasedInfusionProtocol>{
        'dopamine': dopamineInfusion(dosePerKilogramPerMinute: 10),
        'dobutamine': dobutamineInfusion(dosePerKilogramPerMinute: 10),
        'adrenaline': adrenalineInfusion(dosePerKilogramPerMinute: 100),
        'noradrenaline': noradrenalineInfusion(dosePerKilogramPerMinute: 100),
        'dinoprostone': dinoprostoneInfusion(dosePerKilogramPerMinute: 5),
      };

      protocols.forEach((name, protocol) {
        for (final access in <VascularAccess>[
          VascularAccess.peripheral,
          VascularAccess.intraosseous,
          VascularAccess.notApplicable,
        ]) {
          final result = protocol.calculate(
            patient: patient,
            route: AdministrationRoute.intravenous,
            access: access,
          ) as ProtocolCalculationSuccess<InfusionPreparation>;
          expect(
            result.advisories,
            contains(ProtocolCalculationAdvisory.accessOutsideConfiguredUse),
            reason: '$name should report $access',
          );
        }
      });
    });
  });
}
