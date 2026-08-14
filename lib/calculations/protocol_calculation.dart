// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

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
  doseBelowApprovedRange,
  doseAboveApprovedRange,
  concentrationBelowApprovedRange,
  concentrationAboveApprovedRange,
  routeNotApproved,
  accessNotApproved,
  invalidApprovedRange,
  invalidRate,
  invalidPreparationVolume,
}

sealed class ProtocolCalculationResult<T> {
  const ProtocolCalculationResult();
}

class ProtocolCalculationSuccess<T> extends ProtocolCalculationResult<T> {
  const ProtocolCalculationSuccess(this.value);

  final T value;
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
    final commonFailure = _validateCommon(
      dosePerKilogram: dosePerKilogram,
      approvedDosePerKilogram: approvedDosePerKilogram,
      route: route,
      approvedRoutes: approvedRoutes,
      access: access,
      approvedAccess: approvedAccess,
    );
    if (commonFailure != null) {
      return ProtocolCalculationFailure(commonFailure);
    }

    final amount = dosePerKilogram * patient.weight.kilograms;
    if (!amount.isFinite) {
      return const ProtocolCalculationFailure(
          ProtocolCalculationIssue.notFinite);
    }
    return ProtocolCalculationSuccess(
        WeightBasedDose(amount: amount, unit: unit));
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
    final commonFailure = _validateCommon(
      dosePerKilogram: dosePerKilogram,
      approvedDosePerKilogram: approvedDosePerKilogram,
      route: route,
      approvedRoutes: approvedRoutes,
      access: access,
      approvedAccess: approvedAccess,
    );
    if (commonFailure != null) {
      return ProtocolCalculationFailure(commonFailure);
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
    if (!approvedConcentrationPerMillilitre.isValid) {
      return const ProtocolCalculationFailure(
        ProtocolCalculationIssue.invalidApprovedRange,
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
    if (concentrationPerMillilitre <
        approvedConcentrationPerMillilitre.minimum) {
      return const ProtocolCalculationFailure(
        ProtocolCalculationIssue.concentrationBelowApprovedRange,
      );
    }
    if (concentrationPerMillilitre >
        approvedConcentrationPerMillilitre.maximum) {
      return const ProtocolCalculationFailure(
        ProtocolCalculationIssue.concentrationAboveApprovedRange,
      );
    }

    return ProtocolCalculationSuccess(
      InfusionPreparation(
        amountInSyringe: amountInSyringe,
        amountUnit: doseUnit,
        preparationVolumeMillilitres: preparationVolumeMillilitres,
        rateMillilitresPerHour: rateMillilitresPerHour,
        concentrationPerMillilitre: concentrationPerMillilitre,
      ),
    );
  }
}

ProtocolCalculationIssue? _validateCommon({
  required double dosePerKilogram,
  required ApprovedRange approvedDosePerKilogram,
  required AdministrationRoute route,
  required Set<AdministrationRoute> approvedRoutes,
  required VascularAccess access,
  required Set<VascularAccess> approvedAccess,
}) {
  if (!approvedDosePerKilogram.isValid) {
    return ProtocolCalculationIssue.invalidApprovedRange;
  }
  if (!dosePerKilogram.isFinite) {
    return ProtocolCalculationIssue.notFinite;
  }
  if (dosePerKilogram < approvedDosePerKilogram.minimum) {
    return ProtocolCalculationIssue.doseBelowApprovedRange;
  }
  if (dosePerKilogram > approvedDosePerKilogram.maximum) {
    return ProtocolCalculationIssue.doseAboveApprovedRange;
  }
  if (!approvedRoutes.contains(route)) {
    return ProtocolCalculationIssue.routeNotApproved;
  }
  if (!approvedAccess.contains(access)) {
    return ProtocolCalculationIssue.accessNotApproved;
  }
  return null;
}
