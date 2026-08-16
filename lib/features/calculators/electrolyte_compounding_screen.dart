// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../calculations/calculation_outcome.dart';
import '../../calculations/fluids/additive_volume.dart';
import '../../calculations/fluids/electrolyte_requirement.dart';
import '../../calculations/patient_context.dart';
import '../../calculations/protocol_calculation.dart';
import '../../clinical_policy/neonatal_weight_policy.dart';
import '../shared/alpha_notice.dart';

class ElectrolyteCompoundingScreen extends StatefulWidget {
  const ElectrolyteCompoundingScreen({
    super.key,
    this.initialWeightGrams = 3000,
    this.initialWeightOrigin = WeightOrigin.measured,
  });

  final double initialWeightGrams;
  final WeightOrigin initialWeightOrigin;

  @override
  State<ElectrolyteCompoundingScreen> createState() =>
      _ElectrolyteCompoundingScreenState();
}

class _ElectrolyteCompoundingScreenState
    extends State<ElectrolyteCompoundingScreen> {
  late final TextEditingController _weight;
  final _prescribed = TextEditingController(text: '3');
  final _stockConcentration = TextEditingController(text: '1');
  final _maximumVolume = TextEditingController(text: '50');
  Electrolyte _electrolyte = Electrolyte.sodium;

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
    _prescribed.dispose();
    _stockConcentration.dispose();
    _maximumVolume.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final result = _calculate();
    return Scaffold(
      appBar: AppBar(title: const Text('Electrolytes and compounding')),
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
            'Prescription requirement',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: const Color(0xff153e33),
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Enter a prescription already selected from an approved policy. This calculator does not recommend a dose.',
          ),
          const SizedBox(height: 18),
          _ResponsiveFields(
            children: [
              _NumberField(
                key: const Key('compounding-weight-field'),
                controller: _weight,
                label: 'Weight',
                suffix: 'g',
                onChanged: (_) => setState(() {}),
              ),
              DropdownButtonFormField<Electrolyte>(
                initialValue: _electrolyte,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Electrolyte',
                  border: OutlineInputBorder(),
                ),
                items: [
                  for (final electrolyte in Electrolyte.values)
                    DropdownMenuItem(
                      value: electrolyte,
                      child: Text(_electrolyteLabel(electrolyte)),
                    ),
                ],
                onChanged: (value) {
                  if (value != null) setState(() => _electrolyte = value);
                },
              ),
              _NumberField(
                key: const Key('electrolyte-prescription-field'),
                controller: _prescribed,
                label: 'Prescribed amount',
                suffix: 'mmol/kg/day',
                onChanged: (_) => setState(() {}),
              ),
            ],
          ),
          const SizedBox(height: 28),
          Text(
            'Stock preparation',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: const Color(0xff153e33),
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Confirm the stock concentration from the ampoule and pharmacy policy before entering it.',
          ),
          const SizedBox(height: 16),
          _ResponsiveFields(
            children: [
              _NumberField(
                key: const Key('stock-concentration-field'),
                controller: _stockConcentration,
                label: 'Stock concentration',
                suffix: 'mmol/mL',
                onChanged: (_) => setState(() {}),
              ),
              _NumberField(
                controller: _maximumVolume,
                label: 'Maximum permitted volume',
                suffix: 'mL',
                onChanged: (_) => setState(() {}),
              ),
            ],
          ),
          const SizedBox(height: 22),
          if (result.error != null)
            _ErrorPanel(message: result.error!)
          else
            _ResultPanel(
              electrolyte: _electrolyteLabel(_electrolyte),
              millimolesPerDay: result.millimolesPerDay!,
              stockVolumeMillilitres: result.stockVolumeMillilitres!,
            ),
          const SizedBox(height: 18),
          const Text(
            'Independently verify the prescription, stock product, compatibility, final concentration, total fluid volume, and preparation instructions.',
            style: TextStyle(color: Color(0xff50665f)),
          ),
        ],
      ),
    );
  }

  _CompoundingResult _calculate() {
    final weight = double.tryParse(_weight.text);
    final prescribed = double.tryParse(_prescribed.text);
    final stock = double.tryParse(_stockConcentration.text);
    final maximumVolume = double.tryParse(_maximumVolume.text);
    if ([weight, prescribed, stock, maximumVolume]
        .any((value) => value == null)) {
      return const _CompoundingResult(
        error: 'Enter a valid number in every field.',
      );
    }

    final weightResult = PatientWeight.validate(
      grams: weight!,
      policy: neonatalWeightPolicy,
    );
    if (weightResult is! ValidWeight) {
      return const _CompoundingResult(
        error: 'Weight must be between 200 and 6000 g.',
      );
    }
    final patient = PatientContext(
      weight: weightResult.weight,
      weightOrigin: widget.initialWeightOrigin,
    );
    final requirement = calculateElectrolyteRequirement(
      patient: patient,
      electrolyte: _electrolyte,
      prescribedMillimolesPerKilogramPerDay: prescribed!,
      // Broad alpha input guard only, not a prescribing range.
      approvedMillimolesPerKilogramPerDay:
          const ApprovedRange(minimum: 0.1, maximum: 100),
    );
    if (requirement is! CalculationValue<ElectrolyteRequirement>) {
      return const _CompoundingResult(
        error: 'The prescribed amount is not valid.',
      );
    }
    final volume = calculateAdditiveVolumeMillilitres(
      requiredAmount: AdditiveAmount(
        value: requirement.value.millimolesPerDay,
        unit: DoseUnit.millimoles,
      ),
      stock: StockConcentration(
        amountPerMillilitre: stock!,
        unit: DoseUnit.millimoles,
      ),
      maximumVolumeMillilitres: maximumVolume!,
    );
    if (volume is! CalculationValue<double>) {
      return const _CompoundingResult(
        error: 'The stock volume is invalid or exceeds the permitted maximum.',
      );
    }
    return _CompoundingResult(
      millimolesPerDay: requirement.value.millimolesPerDay,
      stockVolumeMillilitres: volume.value,
    );
  }
}

String _electrolyteLabel(Electrolyte electrolyte) => switch (electrolyte) {
      Electrolyte.sodium => 'Sodium',
      Electrolyte.potassium => 'Potassium',
      Electrolyte.chloride => 'Chloride',
      Electrolyte.calcium => 'Calcium',
      Electrolyte.magnesium => 'Magnesium',
      Electrolyte.phosphate => 'Phosphate',
    };

class _CompoundingResult {
  const _CompoundingResult({
    this.error,
    this.millimolesPerDay,
    this.stockVolumeMillilitres,
  });

  final String? error;
  final double? millimolesPerDay;
  final double? stockVolumeMillilitres;
}

class _ResultPanel extends StatelessWidget {
  const _ResultPanel({
    required this.electrolyte,
    required this.millimolesPerDay,
    required this.stockVolumeMillilitres,
  });

  final String electrolyte;
  final double millimolesPerDay;
  final double stockVolumeMillilitres;

  @override
  Widget build(BuildContext context) {
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
            Text(
              '$electrolyte daily requirement',
              style: const TextStyle(
                color: Color(0xff125743),
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${millimolesPerDay.toStringAsFixed(1)} mmol/day',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: const Color(0xff125743),
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 6),
            Text(
              'Draw up ${stockVolumeMillilitres.toStringAsFixed(1)} mL of the entered stock preparation',
              style: const TextStyle(color: Color(0xff34554b)),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResponsiveFields extends StatelessWidget {
  const _ResponsiveFields({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 700 ? 3 : 1;
        final width = columns == 1
            ? constraints.maxWidth
            : (constraints.maxWidth - (12 * (columns - 1))) / columns;
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final child in children) SizedBox(width: width, child: child),
          ],
        );
      },
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

class _ErrorPanel extends StatelessWidget {
  const _ErrorPanel({required this.message});

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
