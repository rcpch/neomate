// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../calculations/airway/endotracheal_tube_lip_length.dart';
import '../../calculations/airway/endotracheal_tube_size.dart';
import '../../calculations/lines/umbilical_arterial_catheter.dart';
import '../../calculations/lines/umbilical_venous_catheter.dart';
import '../../calculations/patient_context.dart';
import '../../clinical_policy/neonatal_weight_policy.dart';
import '../shared/alpha_notice.dart';

class AirwayAndLinesScreen extends StatefulWidget {
  const AirwayAndLinesScreen({
    super.key,
    this.initialWeightGrams = 3000,
    this.initialWeightOrigin = WeightOrigin.measured,
  });

  final double initialWeightGrams;
  final WeightOrigin initialWeightOrigin;

  @override
  State<AirwayAndLinesScreen> createState() => _AirwayAndLinesScreenState();
}

class _AirwayAndLinesScreenState extends State<AirwayAndLinesScreen> {
  late final TextEditingController _weight;

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final patient = _patient;
    return Scaffold(
      appBar: AppBar(title: const Text('Airway and umbilical lines')),
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
          TextField(
            key: const Key('airway-lines-weight-field'),
            controller: _weight,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
            ],
            decoration: const InputDecoration(
              labelText: 'Weight',
              suffixText: 'g',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.monitor_weight_outlined),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 22),
          if (patient == null)
            const _ErrorPanel(
              message: 'Weight must be between 200 and 6000 g.',
            )
          else ...[
            _AirwayResults(patient: patient),
            const SizedBox(height: 20),
            _LineResults(patient: patient),
          ],
        ],
      ),
    );
  }

  PatientContext? get _patient {
    final grams = double.tryParse(_weight.text);
    if (grams == null) return null;
    final result = PatientWeight.validate(
      grams: grams,
      policy: neonatalWeightPolicy,
    );
    if (result is! ValidWeight) return null;
    return PatientContext(
      weight: result.weight,
      weightOrigin: widget.initialWeightOrigin,
    );
  }
}

class _AirwayResults extends StatelessWidget {
  const _AirwayResults({required this.patient});

  final PatientContext patient;

  @override
  Widget build(BuildContext context) {
    final size = endotrachealTubeSizeAid(patient: patient);
    final length = endotrachealTubeLipLengthAid(patient: patient);
    final sizeText = size.isRange
        ? '${size.minimumInternalDiameterMillimetres.toStringAsFixed(1)}-${size.maximumInternalDiameterMillimetres.toStringAsFixed(1)}'
        : size.minimumInternalDiameterMillimetres.toStringAsFixed(1);
    final lengthText = switch (length) {
      EndotrachealTubeLipLengthAid(
        isAvailable: false,
      ) =>
        'No inherited value',
      EndotrachealTubeLipLengthAid(
        isBelowNominalValue: true,
        :final centimetres,
      ) =>
        'Below ${centimetres!.toStringAsFixed(1)}',
      EndotrachealTubeLipLengthAid(:final centimetres) =>
        centimetres!.toStringAsFixed(1),
    };

    return _ResultSection(
      title: 'Intubation and airway',
      icon: Icons.air,
      warning:
          'Initial selection and position aids only. Confirm tube size, depth, and final position using approved clinical methods.',
      results: [
        _ResultRow(
          key: const Key('ett-size-result'),
          label: 'ETT internal diameter',
          value: sizeText,
          unit: 'mm',
        ),
        _ResultRow(
          key: const Key('ett-length-result'),
          label: 'Initial oral length at lips',
          value: lengthText,
          unit: length.isAvailable ? 'cm' : '',
        ),
      ],
    );
  }
}

class _LineResults extends StatelessWidget {
  const _LineResults({required this.patient});

  final PatientContext patient;

  @override
  Widget build(BuildContext context) {
    final uvc = umbilicalVenousCatheterAid(patient: patient);
    final uac = umbilicalArterialCatheterAid(patient: patient);
    return _ResultSection(
      title: 'Central lines',
      icon: Icons.water_drop_outlined,
      warning:
          'Lengths exclude the umbilical stump. Add measured stump length and confirm final tip position using the unit’s approved method.',
      results: [
        _ResultRow(
          key: const Key('uvc-result'),
          label: 'UVC',
          value:
              uvc.insertionLengthCentimetresExcludingStump.toStringAsFixed(1),
          unit: 'cm + stump · ${uvc.catheterSizeFrench.toStringAsFixed(1)} F',
        ),
        _ResultRow(
          key: const Key('uac-result'),
          label: 'UAC',
          value:
              uac.insertionLengthCentimetresExcludingStump.toStringAsFixed(1),
          unit: 'cm + stump · ${uac.catheterSizeFrench.toStringAsFixed(1)} F',
        ),
      ],
    );
  }
}

class _ResultSection extends StatelessWidget {
  const _ResultSection({
    required this.title,
    required this.icon,
    required this.warning,
    required this.results,
  });

  final String title;
  final IconData icon;
  final String warning;
  final List<Widget> results;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xffc8d8d2)),
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            color: const Color(0xff176c55),
            child: Row(
              children: [
                Icon(icon, color: Colors.white),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                    softWrap: true,
                  ),
                ),
              ],
            ),
          ),
          ...results,
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xfffff0c7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              warning,
              style: const TextStyle(
                color: Color(0xff5f4200),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({
    super.key,
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
      child: LayoutBuilder(
        builder: (context, constraints) {
          final stack = constraints.maxWidth < 420 ||
              MediaQuery.textScalerOf(context).scale(1) > 1.5;
          final labelWidget = Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w700),
          );
          final valueWidget = Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: const Color(0xff125743),
                        fontWeight: FontWeight.w900,
                      ),
                ),
                if (unit.isNotEmpty)
                  TextSpan(
                    text: '  $unit',
                    style: const TextStyle(color: Color(0xff456158)),
                  ),
              ],
            ),
            textAlign: stack ? TextAlign.start : TextAlign.end,
          );
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 15, 16, 0),
            child: stack
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      labelWidget,
                      const SizedBox(height: 4),
                      valueWidget,
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: labelWidget),
                      const SizedBox(width: 16),
                      Flexible(child: valueWidget),
                    ],
                  ),
          );
        },
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
