// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

// Clinical source IDs: none assigned
// Clinical content IDs: CALC-PROTOCOL-ENGINE
// Clinical reviewer: none
// Clinical sign-off: none
// Review due: none
// Safety hazards: none assigned
//
// ---------------------------------------------------------------------------
// STATUS: NOT APPROVED FOR CLINICAL USE. No source assigned, no clinical
// reviewer, no sign-off. See spec/clinical-source-convention.md.
// ---------------------------------------------------------------------------
// Module  : Shared engine for weight-based bolus doses, infusion preparations,
//           and line-length protocols.
// Purpose : Calculate protocol outputs and report configured dose,
//           concentration, route, and vascular-access constraints as
//           non-blocking advisories for clinical review.
//
// Reviewer notes:
//   * This file holds no doses and no protocol values. Every clinical figure
//     arrives from a protocol record supplied by the caller, so signing this
//     file off means agreeing the constraint logic, not any drug.
//   * Configured ranges and access constraints are review metadata. They do not
//     suppress a finite calculation in the internal development build.
// ---------------------------------------------------------------------------

import 'patient_context.dart';

enum AdministrationRoute {
  intravenous,
  intraosseous,
  intramuscular,
  enteral,
  endotracheal,
}

enum VascularAccess {
  notApplicable,
  peripheral,
  central,
  umbilicalVenous,
  intraosseous
}

enum DoseUnit {
  grams,
  milligrams,
  micrograms,
  nanograms,
  millimoles,
  millilitres
}

enum DoseTimeBasis { minute, hour, day }

enum ProtocolCalculationIssue {
  notFinite,
  invalidDose,
  invalidRate,
  invalidPreparationVolume,
}

enum ProtocolCalculationAdvisory {
  doseBelowConfiguredRange,
  doseAboveConfiguredRange,
  concentrationBelowConfiguredRange,
  concentrationAboveConfiguredRange,
  routeOutsideConfiguredUse,
  accessOutsideConfiguredUse,
  invalidConfiguredRange,
}

sealed class ProtocolCalculationResult<T> {
  const ProtocolCalculationResult();
}

class ProtocolCalculationSuccess<T> extends ProtocolCalculationResult<T> {
  const ProtocolCalculationSuccess(
    this.value, {
    this.advisories = const <ProtocolCalculationAdvisory>[],
  });

  final T value;
  final List<ProtocolCalculationAdvisory> advisories;
}

class ProtocolCalculationFailure<T> extends ProtocolCalculationResult<T> {
  const ProtocolCalculationFailure(this.issue);

  final ProtocolCalculationIssue issue;
}

class ApprovedRange {
  const ApprovedRange({required this.minimum, required this.maximum})
      : assert(maximum >= minimum);

  final double minimum;
  final double maximum;

  bool contains(double value) => value >= minimum && value <= maximum;

  bool get isValid =>
      minimum.isFinite && maximum.isFinite && maximum >= minimum;
}

abstract interface class WeightBasedProtocol<T> {
  String get protocolId;

  ProtocolCalculationResult<T> calculate({
    required PatientContext patient,
    required AdministrationRoute route,
    required VascularAccess access,
  });
}

abstract interface class LineLengthProtocol {
  String get protocolId;

  ProtocolCalculationResult<double> calculateLengthCentimetres(
      {required PatientContext patient});
}

class WeightBasedDose {
  const WeightBasedDose({required this.amount, required this.unit});

  final double amount;
  final DoseUnit unit;
}

class WeightBasedDoseProtocol implements WeightBasedProtocol<WeightBasedDose> {
  const WeightBasedDoseProtocol({
    required this.protocolId,
    required this.dosePerKilogram,
    required this.unit,
    required this.approvedDosePerKilogram,
    required this.approvedRoutes,
    required this.approvedAccess,
  });

  @override
  final String protocolId;
  final double dosePerKilogram;
  final DoseUnit unit;
  final ApprovedRange approvedDosePerKilogram;
  final Set<AdministrationRoute> approvedRoutes;
  final Set<VascularAccess> approvedAccess;

  @override
  ProtocolCalculationResult<WeightBasedDose> calculate({
    required PatientContext patient,
    required AdministrationRoute route,
    required VascularAccess access,
  }) {
    final inputFailure = _validateDose(dosePerKilogram);
    if (inputFailure != null) {
      return ProtocolCalculationFailure(inputFailure);
    }
    final advisories = _configuredAdvisories(
      dosePerKilogram: dosePerKilogram,
      approvedDosePerKilogram: approvedDosePerKilogram,
      route: route,
      approvedRoutes: approvedRoutes,
      access: access,
      approvedAccess: approvedAccess,
    );
    final amount = dosePerKilogram * patient.weight.kilograms;
    if (!amount.isFinite) {
      return const ProtocolCalculationFailure(
          ProtocolCalculationIssue.notFinite);
    }
    return ProtocolCalculationSuccess(
      WeightBasedDose(amount: amount, unit: unit),
      advisories: advisories,
    );
  }
}

class InfusionPreparation {
  const InfusionPreparation({
    required this.amountInSyringe,
    required this.amountUnit,
    required this.preparationVolumeMillilitres,
    required this.rateMillilitresPerHour,
    required this.concentrationPerMillilitre,
  });

  final double amountInSyringe;
  final DoseUnit amountUnit;
  final double preparationVolumeMillilitres;
  final double rateMillilitresPerHour;
  final double concentrationPerMillilitre;
}

class WeightBasedInfusionProtocol
    implements WeightBasedProtocol<InfusionPreparation> {
  const WeightBasedInfusionProtocol({
    required this.protocolId,
    required this.dosePerKilogram,
    required this.doseUnit,
    required this.timeBasis,
    required this.approvedDosePerKilogram,
    required this.approvedConcentrationPerMillilitre,
    required this.preparationVolumeMillilitres,
    required this.rateMillilitresPerHour,
    required this.approvedRoutes,
    required this.approvedAccess,
  });

  @override
  final String protocolId;
  final double dosePerKilogram;
  final DoseUnit doseUnit;
  final DoseTimeBasis timeBasis;
  final ApprovedRange approvedDosePerKilogram;
  final ApprovedRange approvedConcentrationPerMillilitre;
  final double preparationVolumeMillilitres;
  final double rateMillilitresPerHour;
  final Set<AdministrationRoute> approvedRoutes;
  final Set<VascularAccess> approvedAccess;

  @override
  ProtocolCalculationResult<InfusionPreparation> calculate({
    required PatientContext patient,
    required AdministrationRoute route,
    required VascularAccess access,
  }) {
    final inputFailure = _validateDose(dosePerKilogram);
    if (inputFailure != null) {
      return ProtocolCalculationFailure(inputFailure);
    }
    if (!rateMillilitresPerHour.isFinite || rateMillilitresPerHour <= 0) {
      return const ProtocolCalculationFailure(
          ProtocolCalculationIssue.invalidRate);
    }
    if (!preparationVolumeMillilitres.isFinite ||
        preparationVolumeMillilitres <= 0) {
      return const ProtocolCalculationFailure(
        ProtocolCalculationIssue.invalidPreparationVolume,
      );
    }
    final hourlyDosePerKilogram = switch (timeBasis) {
      DoseTimeBasis.minute => dosePerKilogram * 60,
      DoseTimeBasis.hour => dosePerKilogram,
      DoseTimeBasis.day => dosePerKilogram / 24,
    };
    final hourlyAmount = hourlyDosePerKilogram * patient.weight.kilograms;
    final concentrationPerMillilitre = hourlyAmount / rateMillilitresPerHour;
    final amountInSyringe =
        concentrationPerMillilitre * preparationVolumeMillilitres;

    if (![hourlyAmount, concentrationPerMillilitre, amountInSyringe]
        .every((value) => value.isFinite)) {
      return const ProtocolCalculationFailure(
          ProtocolCalculationIssue.notFinite);
    }
    final advisories = _configuredAdvisories(
      dosePerKilogram: dosePerKilogram,
      approvedDosePerKilogram: approvedDosePerKilogram,
      route: route,
      approvedRoutes: approvedRoutes,
      access: access,
      approvedAccess: approvedAccess,
    );
    if (!approvedConcentrationPerMillilitre.isValid) {
      advisories.add(ProtocolCalculationAdvisory.invalidConfiguredRange);
    } else {
      if (concentrationPerMillilitre <
          approvedConcentrationPerMillilitre.minimum) {
        advisories.add(
          ProtocolCalculationAdvisory.concentrationBelowConfiguredRange,
        );
      }
      if (concentrationPerMillilitre >
          approvedConcentrationPerMillilitre.maximum) {
        advisories.add(
          ProtocolCalculationAdvisory.concentrationAboveConfiguredRange,
        );
      }
    }

    return ProtocolCalculationSuccess(
      InfusionPreparation(
        amountInSyringe: amountInSyringe,
        amountUnit: doseUnit,
        preparationVolumeMillilitres: preparationVolumeMillilitres,
        rateMillilitresPerHour: rateMillilitresPerHour,
        concentrationPerMillilitre: concentrationPerMillilitre,
      ),
      advisories: advisories,
    );
  }
}

ProtocolCalculationIssue? _validateDose(double dosePerKilogram) {
  if (!dosePerKilogram.isFinite) return ProtocolCalculationIssue.notFinite;
  if (dosePerKilogram <= 0) return ProtocolCalculationIssue.invalidDose;
  return null;
}

List<ProtocolCalculationAdvisory> _configuredAdvisories({
  required double dosePerKilogram,
  required ApprovedRange approvedDosePerKilogram,
  required AdministrationRoute route,
  required Set<AdministrationRoute> approvedRoutes,
  required VascularAccess access,
  required Set<VascularAccess> approvedAccess,
}) {
  final advisories = <ProtocolCalculationAdvisory>[];
  if (!approvedDosePerKilogram.isValid) {
    advisories.add(ProtocolCalculationAdvisory.invalidConfiguredRange);
  } else {
    if (dosePerKilogram < approvedDosePerKilogram.minimum) {
      advisories.add(ProtocolCalculationAdvisory.doseBelowConfiguredRange);
    }
    if (dosePerKilogram > approvedDosePerKilogram.maximum) {
      advisories.add(ProtocolCalculationAdvisory.doseAboveConfiguredRange);
    }
  }
  if (!approvedRoutes.contains(route)) {
    advisories.add(ProtocolCalculationAdvisory.routeOutsideConfiguredUse);
  }
  if (!approvedAccess.contains(access)) {
    advisories.add(ProtocolCalculationAdvisory.accessOutsideConfiguredUse);
  }
  return advisories;
}
