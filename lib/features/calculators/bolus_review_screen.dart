// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../clinical_protocols/boluses/bolus_catalogue.dart';
import '../shared/alpha_notice.dart';

class BolusReviewScreen extends StatefulWidget {
  const BolusReviewScreen({super.key, this.initialWeightGrams = 3000});

  final double initialWeightGrams;

  @override
  State<BolusReviewScreen> createState() => _BolusReviewScreenState();
}

class _BolusReviewScreenState extends State<BolusReviewScreen> {
  late final TextEditingController _weight =
      TextEditingController(text: widget.initialWeightGrams.toStringAsFixed(0));
  BolusCategory? _category;

  @override
  void dispose() {
    _weight.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final grams = double.tryParse(_weight.text);
    final validWeight = grams != null && grams.isFinite && grams > 0;
    final visible = bolusProtocols.where(
        (protocol) => _category == null || protocol.category == _category);
    return Scaffold(
      appBar: AppBar(title: const Text('Medicine boluses')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const AlphaNotice(),
          const SizedBox(height: 16),
          const Text(
              'Named bolus values are available for structured clinical review. Retired resuscitation bicarbonate and empirical D10 outputs are not included.'),
          const SizedBox(height: 16),
          TextField(
            key: const Key('bolus-weight-field'),
            controller: _weight,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
            ],
            decoration: InputDecoration(
                labelText: 'Weight',
                suffixText: 'g',
                border: const OutlineInputBorder(),
                errorText: validWeight ? null : 'Enter a positive weight'),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<BolusCategory?>(
            initialValue: _category,
            decoration: const InputDecoration(
                labelText: 'Category', border: OutlineInputBorder()),
            items: [
              const DropdownMenuItem(
                  value: null, child: Text('All categories')),
              for (final category in BolusCategory.values)
                DropdownMenuItem(value: category, child: Text(category.name)),
            ],
            onChanged: (value) => setState(() => _category = value),
          ),
          const SizedBox(height: 16),
          for (final protocol in visible)
            Card(
              child: ListTile(
                key: Key('bolus-${protocol.id}'),
                title: Text(
                    protocol.qualifier == null
                        ? protocol.name
                        : '${protocol.name} - ${protocol.qualifier}',
                    style: const TextStyle(fontWeight: FontWeight.w700)),
                subtitle: Text(
                    '${protocol.doseLabel} · ${protocol.instructions}${protocol.note == null ? '' : '\n${protocol.note}'}'),
                trailing: validWeight
                    ? Text(
                        '${_format(protocol.amountForKilograms(grams / 1000))}\n${protocol.outputUnit}',
                        textAlign: TextAlign.end,
                        style: const TextStyle(fontWeight: FontWeight.w800))
                    : null,
                isThreeLine: protocol.note != null,
              ),
            ),
        ],
      ),
    );
  }

  String _format(double value) {
    if (value >= 100) return value.toStringAsFixed(0);
    if (value >= 1) return value.toStringAsFixed(1);
    return value.toStringAsFixed(2);
  }
}
