// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';

import '../../calculations/patient_context.dart';
import '../shared/alpha_notice.dart';
import 'airway_and_lines_screen.dart';
import 'cardiac_infusions_screen.dart';
import 'electrolyte_compounding_screen.dart';
import 'physiology_calculators_screen.dart';

class CalculatorsScreen extends StatelessWidget {
  const CalculatorsScreen({
    super.key,
    this.initialWeightGrams = 3000,
    this.initialWeightOrigin = WeightOrigin.measured,
  });

  final double initialWeightGrams;
  final WeightOrigin initialWeightOrigin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calculators')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const AlphaNotice(),
          const SizedBox(height: 24),
          Text(
            'Native calculation demos',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: const Color(0xff153e33),
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Pure Dart calculation modules presented through Flutter-native controls. Nothing is saved or sent anywhere.',
          ),
          const SizedBox(height: 18),
          _CalculatorTile(
            title: 'Airway and umbilical lines',
            description:
                'Inherited ETT size/lip-length and UVC/UAC insertion aids with confirmation warnings',
            icon: Icons.air,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => AirwayAndLinesScreen(
                  initialWeightGrams: initialWeightGrams,
                  initialWeightOrigin: initialWeightOrigin,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _CalculatorTile(
            title: 'Physiology and fluids',
            description:
                'Weight, mean airway pressure, oxygenation index, daily fluids, and glucose infusion rate',
            icon: Icons.monitor_heart_outlined,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => PhysiologyCalculatorsScreen(
                  initialWeightGrams: initialWeightGrams,
                  initialWeightOrigin: initialWeightOrigin,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _CalculatorTile(
            title: 'Cardiac infusions',
            description:
                'Five named inherited infusion protocols with dose, concentration, route, and line controls',
            icon: Icons.medication_outlined,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => CardiacInfusionsScreen(
                  initialWeightGrams: initialWeightGrams,
                  initialWeightOrigin: initialWeightOrigin,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _CalculatorTile(
            title: 'Electrolytes and compounding',
            description:
                'Convert a prescribed mmol/kg/day requirement into a daily amount and stock volume',
            icon: Icons.science_outlined,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => ElectrolyteCompoundingScreen(
                  initialWeightGrams: initialWeightGrams,
                  initialWeightOrigin: initialWeightOrigin,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CalculatorTile extends StatelessWidget {
  const _CalculatorTile({
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        minTileHeight: 96,
        leading: Icon(icon, color: const Color(0xff176c55), size: 32),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(description),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
        onTap: onTap,
      ),
    );
  }
}
