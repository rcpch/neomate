// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../calculations/patient_context.dart';
import '../../calculations/protocol_calculation.dart';
import '../../clinical_policy/neonatal_weight_policy.dart';
import '../../clinical_protocols/infusions/adrenaline_infusion.dart';
import '../../clinical_protocols/infusions/dinoprostone_infusion.dart';
import '../../clinical_protocols/infusions/dobutamine_infusion.dart';
import '../../clinical_protocols/infusions/dopamine_infusion.dart';
import '../../clinical_protocols/infusions/noradrenaline_infusion.dart';
import '../shared/alpha_notice.dart';

class CardiacInfusionsScreen extends StatefulWidget {
  const CardiacInfusionsScreen({
    super.key,
    this.initialWeightGrams = 3000,
    this.initialWeightOrigin = WeightOrigin.measured,
  });

  final double initialWeightGrams;
  final WeightOrigin initialWeightOrigin;

  @override
  State<CardiacInfusionsScreen> createState() => _CardiacInfusionsScreenState();
}

class _CardiacInfusionsScreenState extends State<CardiacInfusionsScreen> {
  late final TextEditingController _weight;
  final _dose = TextEditingController(text: '10');
  final _volume = TextEditingController(text: '50');
  final _rate = TextEditingController(text: '2');
  _Drug _drug = _Drug.dopamine;
  VascularAccess _access = VascularAccess.central;

  @override
  void initState() {
    super.initState();
    _weight = TextEditingController(
      text: widget.initialWeightGrams.toStringAsFixed(0),
    );
  }

  @override
  void dispose() {
    _weight.dispose();
    _dose.dispose();
    _volume.dispose();
    _rate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final result = _calculate();
    return Scaffold(
      appBar: AppBar(title: const Text('Cardiac infusions')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const AlphaNotice(compact: true),
          if (widget.initialWeightOrigin == WeightOrigin.estimated) ...[
            const SizedBox(height: 10),
            const Text(
              'Estimated weight: all weight-derived outputs carry additional uncertainty.',
              style: TextStyle(
                color: Color(0xff775000),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
          const SizedBox(height: 18),
          Text(
            'Named protocol preparation',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: const Color(0xff153e33),
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Inherited values are shown for author review. Current BNFC and local formulary verification remains outstanding.',
          ),
          const SizedBox(height: 18),
          DropdownButtonFormField<_Drug>(
            key: const Key('drug-selector'),
            initialValue: _drug,
            decoration: const InputDecoration(
              labelText: 'Medicine',
              border: OutlineInputBorder(),
            ),
            items: [
              for (final drug in _Drug.values)
                DropdownMenuItem(value: drug, child: Text(drug.label)),
            ],
            onChanged: (drug) {
              if (drug == null) return;
              setState(() {
                _drug = drug;
                _dose.text = drug.startingDose.toString();
                _rate.text = drug.defaultRate.toString();
              });
            },
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final fieldWidth = constraints.maxWidth >= 720
                  ? (constraints.maxWidth - 24) / 3
                  : constraints.maxWidth;
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  SizedBox(
                    width: fieldWidth,
                    child: _NumberField(
                      key: const Key('infusion-weight-field'),
                      controller: _weight,
                      label: 'Weight',
                      suffix: 'g',
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  SizedBox(
                    width: fieldWidth,
                    child: _NumberField(
                      key: const Key('dose-field'),
                      controller: _dose,
                      label: 'Dose',
                      suffix: _drug.doseSuffix,
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  SizedBox(
                    width: fieldWidth,
                    child: _NumberField(
                      controller: _rate,
                      label: 'Pump rate',
                      suffix: 'mL/hour',
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  SizedBox(
                    width: fieldWidth,
                    child: _NumberField(
                      controller: _volume,
                      label: 'Syringe volume',
                      suffix: 'mL',
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  SizedBox(
                    width: fieldWidth,
                    child: DropdownButtonFormField<VascularAccess>(
                      isExpanded: true,
                      initialValue: _access,
                      decoration: const InputDecoration(
                        labelText: 'Vascular access',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: VascularAccess.central,
                          child: Text('Central line'),
                        ),
                        DropdownMenuItem(
                          value: VascularAccess.umbilicalVenous,
                          child: Text('Umbilical venous catheter'),
                        ),
                        DropdownMenuItem(
                          value: VascularAccess.peripheral,
                          child: Text('Peripheral line'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) setState(() => _access = value);
                      },
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 20),
          _RangePanel(drug: _drug),
          const SizedBox(height: 16),
          if (result.error != null)
            _InfusionError(message: result.error!)
          else
            _PreparationPanel(result: result),
          const SizedBox(height: 18),
          const Text(
            'The amount displayed is the total medicine to add to the selected syringe volume. Independently verify all calculations and compatibility.',
            style: TextStyle(color: Color(0xff50665f)),
          ),
        ],
      ),
    );
  }

  _InfusionResult _calculate() {
    final weightGrams = double.tryParse(_weight.text);
    final dose = double.tryParse(_dose.text);
    final volume = double.tryParse(_volume.text);
    final rate = double.tryParse(_rate.text);
    if ([weightGrams, dose, volume, rate].any((value) => value == null)) {
      return const _InfusionResult(
          error: 'Enter a valid number in every field.');
    }
    final weightResult = PatientWeight.validate(
      grams: weightGrams!,
      policy: neonatalWeightPolicy,
    );
    if (weightResult is! ValidWeight) {
      return const _InfusionResult(
          error: 'Weight must be between 200 and 6000 g.');
    }
    final protocol = _drug.protocol(
      dose: dose!,
      volume: volume!,
      rate: rate!,
    );
    final calculated = protocol.calculate(
      patient: PatientContext(
        weight: weightResult.weight,
        weightOrigin: widget.initialWeightOrigin,
      ),
      route: AdministrationRoute.intravenous,
      access: _access,
    );
    return switch (calculated) {
      ProtocolCalculationSuccess<InfusionPreparation>(:final value) =>
        _InfusionResult(
          amount: value.amountInSyringe,
          concentration: value.concentrationPerMillilitre,
          unit: value.amountUnit,
        ),
      ProtocolCalculationFailure<InfusionPreparation>(:final issue) =>
        _InfusionResult(error: _messageFor(issue)),
    };
  }

  String _messageFor(ProtocolCalculationIssue issue) => switch (issue) {
        ProtocolCalculationIssue.doseBelowApprovedRange =>
          'Dose is below the inherited protocol range.',
        ProtocolCalculationIssue.doseAboveApprovedRange =>
          'Dose is above the inherited protocol range.',
        ProtocolCalculationIssue.concentrationBelowApprovedRange =>
          'Preparation is below the inherited concentration range.',
        ProtocolCalculationIssue.concentrationAboveApprovedRange =>
          'Preparation exceeds the inherited maximum concentration. Increase the pump rate or review the prescribed dose.',
        ProtocolCalculationIssue.accessNotApproved =>
          'This inherited preparation requires central or umbilical venous access.',
        ProtocolCalculationIssue.routeNotApproved =>
          'Only the intravenous route is supported.',
        ProtocolCalculationIssue.invalidRate => 'Pump rate must be above zero.',
        ProtocolCalculationIssue.invalidPreparationVolume =>
          'Syringe volume must be above zero.',
        ProtocolCalculationIssue.notFinite ||
        ProtocolCalculationIssue.invalidApprovedRange =>
          'The preparation could not be calculated.',
      };
}

enum _Drug {
  dopamine(
    label: 'Dopamine',
    doseSuffix: 'micrograms/kg/min',
    startingDose: 10,
    defaultRate: 2,
    minimumDose: 5,
    maximumDose: 20,
    maximumConcentration: '1.6 mg/mL',
  ),
  dobutamine(
    label: 'Dobutamine',
    doseSuffix: 'micrograms/kg/min',
    startingDose: 10,
    defaultRate: 1,
    minimumDose: 2,
    maximumDose: 20,
    maximumConcentration: '10 mg/mL',
  ),
  adrenaline(
    label: 'Adrenaline',
    doseSuffix: 'nanograms/kg/min',
    startingDose: 100,
    defaultRate: 0.1,
    minimumDose: 50,
    maximumDose: 500,
    maximumConcentration: '0.24 mg/mL',
  ),
  noradrenaline(
    label: 'Noradrenaline',
    doseSuffix: 'nanograms/kg/min',
    startingDose: 100,
    defaultRate: 0.5,
    minimumDose: 50,
    maximumDose: 500,
    maximumConcentration: '40 micrograms/mL',
  ),
  dinoprostone(
    label: 'Dinoprostone',
    doseSuffix: 'nanograms/kg/min',
    startingDose: 5,
    defaultRate: 1,
    minimumDose: 1,
    maximumDose: 20,
    maximumConcentration: '1 microgram/mL',
  );

  const _Drug({
    required this.label,
    required this.doseSuffix,
    required this.startingDose,
    required this.defaultRate,
    required this.minimumDose,
    required this.maximumDose,
    required this.maximumConcentration,
  });

  final String label;
  final String doseSuffix;
  final double startingDose;
  final double defaultRate;
  final double minimumDose;
  final double maximumDose;
  final String maximumConcentration;

  WeightBasedInfusionProtocol protocol({
    required double dose,
    required double volume,
    required double rate,
  }) =>
      switch (this) {
        _Drug.dopamine => dopamineInfusion(
            dosePerKilogramPerMinute: dose,
            preparationVolumeMillilitres: volume,
            rateMillilitresPerHour: rate,
          ),
        _Drug.dobutamine => dobutamineInfusion(
            dosePerKilogramPerMinute: dose,
            preparationVolumeMillilitres: volume,
            rateMillilitresPerHour: rate,
          ),
        _Drug.adrenaline => adrenalineInfusion(
            dosePerKilogramPerMinute: dose,
            preparationVolumeMillilitres: volume,
            rateMillilitresPerHour: rate,
          ),
        _Drug.noradrenaline => noradrenalineInfusion(
            dosePerKilogramPerMinute: dose,
            preparationVolumeMillilitres: volume,
            rateMillilitresPerHour: rate,
          ),
        _Drug.dinoprostone => dinoprostoneInfusion(
            dosePerKilogramPerMinute: dose,
            preparationVolumeMillilitres: volume,
            rateMillilitresPerHour: rate,
          ),
      };
}

class _InfusionResult {
  const _InfusionResult({
    this.error,
    this.amount,
    this.concentration,
    this.unit,
  });

  final String? error;
  final double? amount;
  final double? concentration;
  final DoseUnit? unit;
}

class _RangePanel extends StatelessWidget {
  const _RangePanel({required this.drug});

  final _Drug drug;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xfff1f5f3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        'Inherited range: ${drug.minimumDose.toStringAsFixed(drug.minimumDose % 1 == 0 ? 0 : 1)}-${drug.maximumDose.toStringAsFixed(drug.maximumDose % 1 == 0 ? 0 : 1)} ${drug.doseSuffix}  •  Maximum concentration: ${drug.maximumConcentration}',
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _PreparationPanel extends StatelessWidget {
  const _PreparationPanel({required this.result});

  final _InfusionResult result;

  @override
  Widget build(BuildContext context) {
    final unit = switch (result.unit!) {
      DoseUnit.micrograms => 'micrograms',
      DoseUnit.nanograms => 'nanograms',
      DoseUnit.milligrams => 'milligrams',
      DoseUnit.grams => 'grams',
      DoseUnit.millimoles => 'millimoles',
      DoseUnit.millilitres => 'millilitres',
    };
    return Semantics(
      liveRegion: true,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xffe8f3ef),
          border: Border.all(color: const Color(0xff75aa96), width: 1.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Preparation output',
              style: TextStyle(
                color: Color(0xff125743),
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${result.amount!.toStringAsFixed(1)} $unit in syringe',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: const Color(0xff125743),
                    fontWeight: FontWeight.w800,
                  ),
            ),
            Text(
              'Concentration ${result.concentration!.toStringAsFixed(1)} $unit/mL',
              style: const TextStyle(color: Color(0xff34554b)),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfusionError extends StatelessWidget {
  const _InfusionError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xffffe7e1),
          border: Border.all(color: const Color(0xffbd4c36)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(message, style: const TextStyle(color: Color(0xff702719))),
      ),
    );
  }
}

class _NumberField extends StatelessWidget {
  const _NumberField({
    super.key,
    required this.controller,
    required this.label,
    required this.suffix,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String label;
  final String suffix;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
      decoration: InputDecoration(
        labelText: label,
        suffixText: suffix,
        border: const OutlineInputBorder(),
      ),
      onChanged: onChanged,
    );
  }
}
