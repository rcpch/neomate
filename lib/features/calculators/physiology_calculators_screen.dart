// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../calculations/calculation_outcome.dart';
import '../../calculations/fluids/daily_fluid_volume.dart';
import '../../calculations/fluids/glucose_infusion_rate.dart';
import '../../calculations/patient_context.dart';
import '../../calculations/protocol_calculation.dart';
import '../../calculations/ventilation/mean_airway_pressure.dart';
import '../../calculations/ventilation/oxygenation_index.dart';
import '../../clinical_policy/neonatal_weight_policy.dart';
import '../shared/alpha_notice.dart';

class PhysiologyCalculatorsScreen extends StatefulWidget {
  const PhysiologyCalculatorsScreen({super.key});

  @override
  State<PhysiologyCalculatorsScreen> createState() =>
      _PhysiologyCalculatorsScreenState();
}

class _PhysiologyCalculatorsScreenState
    extends State<PhysiologyCalculatorsScreen> {
  final _weight = TextEditingController(text: '3000');
  final _pip = TextEditingController(text: '24');
  final _peep = TextEditingController(text: '6');
  final _ti = TextEditingController(text: '0.4');
  final _te = TextEditingController(text: '0.6');
  final _fio2 = TextEditingController(text: '0.60');
  final _paO2 = TextEditingController(text: '6.5');
  final _fluid = TextEditingController(text: '150');
  final _glucose = TextEditingController(text: '10');
  final _rate = TextEditingController(text: '10');
  PartialPressureUnit _paO2Unit = PartialPressureUnit.kilopascals;

  @override
  void dispose() {
    for (final controller in [
      _weight,
      _pip,
      _peep,
      _ti,
      _te,
      _fio2,
      _paO2,
      _fluid,
      _glucose,
      _rate,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final results = _calculate();
    return Scaffold(
      appBar: AppBar(title: const Text('Physiology and fluids')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const AlphaNotice(compact: true),
          const SizedBox(height: 18),
          _Section(
            title: 'Patient',
            children: [
              _NumberField(
                key: const Key('weight-field'),
                controller: _weight,
                label: 'Weight',
                suffix: 'g',
                onChanged: (_) => setState(() {}),
              ),
            ],
          ),
          _Section(
            title: 'Ventilation',
            children: [
              _ResponsiveFields(
                children: [
                  _NumberField(
                    controller: _pip,
                    label: 'PIP',
                    suffix: 'cmH₂O',
                    onChanged: (_) => setState(() {}),
                  ),
                  _NumberField(
                    controller: _peep,
                    label: 'PEEP',
                    suffix: 'cmH₂O',
                    onChanged: (_) => setState(() {}),
                  ),
                  _NumberField(
                    controller: _ti,
                    label: 'Ti',
                    suffix: 's',
                    onChanged: (_) => setState(() {}),
                  ),
                  _NumberField(
                    controller: _te,
                    label: 'Te',
                    suffix: 's',
                    onChanged: (_) => setState(() {}),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _ResponsiveFields(
                children: [
                  _NumberField(
                    controller: _fio2,
                    label: 'FiO₂',
                    suffix: 'fraction',
                    onChanged: (_) => setState(() {}),
                  ),
                  _NumberField(
                    controller: _paO2,
                    label: 'PaO₂',
                    suffix: _paO2Unit == PartialPressureUnit.kilopascals
                        ? 'kPa'
                        : 'mmHg',
                    onChanged: (_) => setState(() {}),
                  ),
                  DropdownButtonFormField<PartialPressureUnit>(
                    initialValue: _paO2Unit,
                    decoration: const InputDecoration(
                      labelText: 'PaO₂ unit',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: PartialPressureUnit.kilopascals,
                        child: Text('kPa'),
                      ),
                      DropdownMenuItem(
                        value: PartialPressureUnit.millimetresOfMercury,
                        child: Text('mmHg'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) setState(() => _paO2Unit = value);
                    },
                  ),
                ],
              ),
            ],
          ),
          _Section(
            title: 'Fluids',
            children: [
              _ResponsiveFields(
                children: [
                  _NumberField(
                    controller: _fluid,
                    label: 'Prescribed daily fluid',
                    suffix: 'mL/kg/day',
                    onChanged: (_) => setState(() {}),
                  ),
                  _NumberField(
                    controller: _glucose,
                    label: 'Glucose concentration',
                    suffix: '%',
                    onChanged: (_) => setState(() {}),
                  ),
                  _NumberField(
                    controller: _rate,
                    label: 'Infusion rate',
                    suffix: 'mL/hour',
                    onChanged: (_) => setState(() {}),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            key: const Key('calculated-results-heading'),
            'Calculated results',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: const Color(0xff153e33),
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 10),
          if (results.error != null)
            _ErrorPanel(message: results.error!)
          else
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _ResultCard(
                  label: 'Mean airway pressure',
                  value: results.map!.toStringAsFixed(1),
                  unit: 'cmH₂O',
                ),
                _ResultCard(
                  label: 'Oxygenation index',
                  value: results.oi!.toStringAsFixed(1),
                  unit: 'dimensionless',
                ),
                _ResultCard(
                  label: 'Daily fluid',
                  value: results.dailyFluid!.toStringAsFixed(1),
                  unit: 'mL/day',
                ),
                _ResultCard(
                  label: 'Hourly fluid',
                  value: results.hourlyFluid!.toStringAsFixed(1),
                  unit: 'mL/hour',
                ),
                _ResultCard(
                  label: 'Glucose infusion rate',
                  value: results.gir!.toStringAsFixed(1),
                  unit: 'mg/kg/min',
                ),
              ],
            ),
          const SizedBox(height: 22),
          const Text(
            'No interpretation or treatment recommendation is provided. Inputs and results are held in memory only.',
            style: TextStyle(color: Color(0xff50665f)),
          ),
        ],
      ),
    );
  }

  _Results _calculate() {
    final values = [
      _weight,
      _pip,
      _peep,
      _ti,
      _te,
      _fio2,
      _paO2,
      _fluid,
      _glucose,
      _rate,
    ].map((controller) => double.tryParse(controller.text)).toList();
    if (values.any((value) => value == null)) {
      return const _Results(error: 'Enter a valid number in every field.');
    }

    final weightResult = PatientWeight.validate(
      grams: values[0]!,
      policy: neonatalWeightPolicy,
    );
    if (weightResult is! ValidWeight) {
      return const _Results(error: 'Weight must be between 200 and 6000 g.');
    }
    final patient = PatientContext(
      weight: weightResult.weight,
      weightOrigin: WeightOrigin.measured,
    );
    final mapResult = calculateMeanAirwayPressure(
      peakInspiratoryPressureCmH2O: values[1]!,
      positiveEndExpiratoryPressureCmH2O: values[2]!,
      inspiratoryTimeSeconds: values[3]!,
      expiratoryTimeSeconds: values[4]!,
    );
    if (mapResult is! CalculationValue<MeanAirwayPressure>) {
      return const _Results(error: 'Ventilator settings are not valid.');
    }
    final oiResult = calculateOxygenationIndex(
      meanAirwayPressure: mapResult.value,
      fractionInspiredOxygen: values[5]!,
      arterialOxygenPartialPressure: ArterialOxygenPartialPressure(
        value: values[6]!,
        unit: _paO2Unit,
      ),
    );
    if (oiResult is! CalculationValue<double>) {
      return const _Results(error: 'FiO₂ or PaO₂ is outside accepted bounds.');
    }
    final fluidResult = calculateDailyFluidVolume(
      patient: patient,
      prescribedMillilitresPerKilogramPerDay: values[7]!,
      // Deliberately broad inherited-alpha guard, not a prescribing range.
      approvedMillilitresPerKilogramPerDay:
          const ApprovedRange(minimum: 1, maximum: 300),
    );
    if (fluidResult is! CalculationValue<DailyFluidVolume>) {
      return const _Results(error: 'Daily fluid entry is not valid.');
    }
    final girResult = calculateGlucoseInfusionRate(
      patient: patient,
      glucosePercentWeightPerVolume: values[8]!,
      rateMillilitresPerHour: values[9]!,
    );
    if (girResult is! CalculationValue<double>) {
      return const _Results(error: 'Glucose concentration or rate is invalid.');
    }
    return _Results(
      map: mapResult.value.centimetresOfWater,
      oi: oiResult.value,
      dailyFluid: fluidResult.value.totalMillilitresPerDay,
      hourlyFluid: fluidResult.value.millilitresPerHour,
      gir: girResult.value,
    );
  }
}

class _Results {
  const _Results({
    this.error,
    this.map,
    this.oi,
    this.dailyFluid,
    this.hourlyFluid,
    this.gir,
  });

  final String? error;
  final double? map;
  final double? oi;
  final double? dailyFluid;
  final double? hourlyFluid;
  final double? gir;
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: const Color(0xff153e33),
                ),
          ),
          const SizedBox(height: 10),
          ...children,
        ],
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
            for (final child in children) SizedBox(width: width, child: child)
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

class _ResultCard extends StatelessWidget {
  const _ResultCard({
    required this.label,
    required this.value,
    required this.unit,
  });

  final String label;
  final String value;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$label, $value $unit',
      child: Container(
        width: 220,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xffe8f3ef),
          border: Border.all(color: const Color(0xffaacbbf)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Color(0xff34554b))),
            const SizedBox(height: 7),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: const Color(0xff125743),
                    fontWeight: FontWeight.w800,
                  ),
            ),
            Text(unit, style: const TextStyle(color: Color(0xff34554b))),
          ],
        ),
      ),
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
