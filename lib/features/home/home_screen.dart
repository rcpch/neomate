// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../calculations/patient_context.dart';
import '../../clinical_policy/neonatal_weight_policy.dart';
import '../calculators/airway_and_lines_screen.dart';
import '../calculators/calculators_screen.dart';
import '../calculators/electrolyte_compounding_screen.dart';
import '../calculators/named_infusions_screen.dart';
import '../calculators/physiology_calculators_screen.dart';
import '../references/references_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _weight = TextEditingController(text: '3000');
  bool _estimatedWeight = false;

  @override
  void dispose() {
    _weight.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final validWeight = _validatedWeight;
    return Scaffold(
      backgroundColor: const Color(0xfff4f7f5),
      body: CustomScrollView(
        slivers: [
          const _Header(),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 36),
            sliver: SliverToBoxAdapter(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 920),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _SafetyNotice(),
                      const SizedBox(height: 18),
                      _WeightContext(
                        controller: _weight,
                        estimated: _estimatedWeight,
                        valid: validWeight != null,
                        onChanged: () => setState(() {}),
                        onEstimatedChanged: (value) {
                          setState(() => _estimatedWeight = value);
                        },
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Clinical tasks',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: const Color(0xff153e33),
                                  fontWeight: FontWeight.w800,
                                ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Select a clinical task. Items without an active workflow are marked as not implemented.',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: const Color(0xff456158),
                            ),
                      ),
                      const SizedBox(height: 14),
                      _ClinicalCategory(
                        title: 'Intubation and airway',
                        icon: Icons.air,
                        available: true,
                        children: [
                          _AvailableAction(
                            key: const Key('task-airway-aids'),
                            title: 'ETT size and lip length',
                            detail:
                                'Weight-based selection and initial-position aids with confirmation warning',
                            onTap: () => _openWithWeight(
                              validWeight,
                              (weight, origin) => AirwayAndLinesScreen(
                                initialWeightGrams: weight,
                                initialWeightOrigin: origin,
                              ),
                            ),
                          ),
                          const _NotImplementedAction(
                            title: 'Premedication boluses',
                            detail:
                                'Not implemented: active bolus protocols and review UI',
                          ),
                        ],
                      ),
                      _ClinicalCategory(
                        title: 'Central lines',
                        icon: Icons.water_drop_outlined,
                        available: true,
                        children: [
                          _AvailableAction(
                            key: const Key('task-central-line-aids'),
                            title: 'UVC and UAC length aids',
                            detail:
                                'Weight-based insertion length and catheter-size aids with tip-confirmation warning',
                            onTap: () => _openWithWeight(
                              validWeight,
                              (weight, origin) => AirwayAndLinesScreen(
                                initialWeightGrams: weight,
                                initialWeightOrigin: origin,
                              ),
                            ),
                          ),
                        ],
                      ),
                      _ClinicalCategory(
                        title: 'Cardiac drugs',
                        icon: Icons.favorite_outline,
                        available: true,
                        initiallyExpanded: true,
                        children: [
                          _AvailableAction(
                            key: const Key('task-cardiac-infusions'),
                            title: 'Cardiac infusions',
                            detail:
                                'Dopamine, dobutamine, adrenaline, noradrenaline, and dinoprostone',
                            onTap: () => _openWithWeight(
                              validWeight,
                              (weight, origin) => NamedInfusionsScreen(
                                initialWeightGrams: weight,
                                initialWeightOrigin: origin,
                              ),
                            ),
                          ),
                          const _NotImplementedAction(
                            title: 'Reviewed fluid and medicine boluses',
                            detail:
                                'Not implemented: active bolus protocols and review UI',
                          ),
                        ],
                      ),
                      _ClinicalCategory(
                        title: 'Sedation and paralysis',
                        icon: Icons.bedtime_outlined,
                        available: true,
                        children: [
                          _AvailableAction(
                            key: const Key('task-sedation-infusions'),
                            title: 'Morphine and vecuronium infusions',
                            detail:
                                'Dose-configured protocols with explicit paralysis warning',
                            onTap: () => _openWithWeight(
                              validWeight,
                              (weight, origin) => NamedInfusionsScreen(
                                initialWeightGrams: weight,
                                initialWeightOrigin: origin,
                                initialInfusion: NamedInfusion.morphine,
                              ),
                            ),
                          ),
                        ],
                      ),
                      _ClinicalCategory(
                        title: 'Neurology',
                        icon: Icons.psychology_outlined,
                        available: true,
                        children: [
                          _AvailableAction(
                            key: const Key('task-neurological-infusions'),
                            title: 'Clonazepam and midazolam infusions',
                            detail:
                                'Dose-configured protocols with unresolved range discrepancies',
                            onTap: () => _openWithWeight(
                              validWeight,
                              (weight, origin) => NamedInfusionsScreen(
                                initialWeightGrams: weight,
                                initialWeightOrigin: origin,
                                initialInfusion: NamedInfusion.clonazepam,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const _ClinicalCategory(
                        title: 'Emergency drugs',
                        icon: Icons.emergency_outlined,
                        children: [
                          _NotImplementedAction(
                            title: 'Newborn resuscitation medicines',
                            detail:
                                'Not implemented: active emergency medicine protocols',
                          ),
                        ],
                      ),
                      const _ClinicalCategory(
                        title: 'Cooling criteria',
                        icon: Icons.ac_unit,
                        children: [
                          _NotImplementedAction(
                            title: 'HIE and therapeutic hypothermia guidance',
                            detail:
                                'Not implemented: guidance review interface',
                          ),
                        ],
                      ),
                      const _ClinicalCategory(
                        title: 'Admission to unit',
                        icon: Icons.login_outlined,
                        children: [
                          _NotImplementedAction(
                            title: 'Admission checklist and medicines',
                            detail: 'Not implemented: admission workflow',
                          ),
                        ],
                      ),
                      _ClinicalCategory(
                        title: 'Intravenous fluids',
                        icon: Icons.local_drink_outlined,
                        available: true,
                        children: [
                          _AvailableAction(
                            title: 'Daily fluids and glucose infusion rate',
                            detail:
                                'Daily/hourly volume and single-infusion GIR',
                            onTap: () => _openWithWeight(
                              validWeight,
                              (weight, origin) => PhysiologyCalculatorsScreen(
                                initialWeightGrams: weight,
                                initialWeightOrigin: origin,
                              ),
                            ),
                          ),
                          _AvailableAction(
                            key: const Key('task-electrolyte-compounding'),
                            title: 'Electrolytes and compounding',
                            detail:
                                'Prescribed daily requirement and stock volume',
                            onTap: () => _openWithWeight(
                              validWeight,
                              (weight, origin) => ElectrolyteCompoundingScreen(
                                initialWeightGrams: weight,
                                initialWeightOrigin: origin,
                              ),
                            ),
                          ),
                        ],
                      ),
                      _ClinicalCategory(
                        title: 'Oxygenation index',
                        icon: Icons.monitor_heart_outlined,
                        available: true,
                        children: [
                          _AvailableAction(
                            title: 'Ventilation and oxygenation',
                            detail:
                                'Mean airway pressure and unit-explicit oxygenation index',
                            onTap: () => _openWithWeight(
                              validWeight,
                              (weight, origin) => PhysiologyCalculatorsScreen(
                                initialWeightGrams: weight,
                                initialWeightOrigin: origin,
                              ),
                            ),
                          ),
                        ],
                      ),
                      _ClinicalCategory(
                        title: 'Infusion calculators',
                        icon: Icons.medication_outlined,
                        available: true,
                        children: [
                          _AvailableAction(
                            title: 'Named cardiac protocols',
                            detail:
                                'Only reviewed-by-name protocol structures; no generic calculator',
                            onTap: () => _openWithWeight(
                              validWeight,
                              (weight, origin) => NamedInfusionsScreen(
                                initialWeightGrams: weight,
                                initialWeightOrigin: origin,
                              ),
                            ),
                          ),
                          _AvailableAction(
                            title: 'Sedation and neurological infusions',
                            detail:
                                'Morphine, vecuronium, clonazepam, and midazolam',
                            onTap: () => _openWithWeight(
                              validWeight,
                              (weight, origin) => NamedInfusionsScreen(
                                initialWeightGrams: weight,
                                initialWeightOrigin: origin,
                                initialInfusion: NamedInfusion.morphine,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const _OfflineStatus(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        onDestinationSelected: (index) {
          switch (index) {
            case 1:
              _openWithWeight(
                validWeight,
                (weight, origin) => CalculatorsScreen(
                  initialWeightGrams: weight,
                  initialWeightOrigin: origin,
                ),
              );
            case 2:
              _showNotImplemented('Checklists');
            case 3:
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const ReferencesScreen(),
                ),
              );
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Workspace',
          ),
          NavigationDestination(
            key: Key('destination-calculators'),
            icon: Icon(Icons.calculate_outlined),
            label: 'Calculators',
          ),
          NavigationDestination(
            icon: Icon(Icons.checklist_outlined),
            label: 'Checklists',
          ),
          NavigationDestination(
            key: Key('destination-references'),
            icon: Icon(Icons.source_outlined),
            label: 'References',
          ),
        ],
      ),
    );
  }

  double? get _validatedWeight {
    final grams = double.tryParse(_weight.text);
    if (grams == null) return null;
    final result = PatientWeight.validate(
      grams: grams,
      policy: neonatalWeightPolicy,
    );
    return result is ValidWeight ? result.weight.grams : null;
  }

  void _openWithWeight(
    double? weight,
    Widget Function(double weightGrams, WeightOrigin origin) builder,
  ) {
    if (weight == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter a weight between 200 and 6000 g first.'),
        ),
      );
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => builder(
          weight,
          _estimatedWeight ? WeightOrigin.estimated : WeightOrigin.measured,
        ),
      ),
    );
  }

  void _showNotImplemented(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature are not implemented yet.'),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 150,
      backgroundColor: const Color(0xff202322),
      foregroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        expandedTitleScale: 1,
        titlePadding: const EdgeInsets.fromLTRB(16, 0, 16, 15),
        title: Semantics(
          header: true,
          image: true,
          label: 'Neomate',
          child: ExcludeSemantics(
            child: Image.asset(
              'graphics/neomate-logo.gif',
              width: 205,
              height: 34,
              fit: BoxFit.contain,
              alignment: Alignment.centerLeft,
            ),
          ),
        ),
        background: const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff181b1a), Color(0xff176c55)],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 54, 16, 20),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Offline neonatal calculations and guidance',
                style: TextStyle(color: Color(0xffd7ede5), fontSize: 15),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _WeightContext extends StatelessWidget {
  const _WeightContext({
    required this.controller,
    required this.estimated,
    required this.valid,
    required this.onChanged,
    required this.onEstimatedChanged,
  });

  final TextEditingController controller;
  final bool estimated;
  final bool valid;
  final VoidCallback onChanged;
  final ValueChanged<bool> onEstimatedChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: valid ? const Color(0xff3d9275) : const Color(0xffbd4c36),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 560;
          final input = TextField(
            key: const Key('home-weight-field'),
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
            ],
            decoration: InputDecoration(
              labelText: 'Baby weight',
              suffixText: 'grams',
              helperText: valid ? 'Used for this session only' : '200-6000 g',
              border: const OutlineInputBorder(),
              errorText: valid ? null : 'Enter a valid neonatal weight',
              prefixIcon: const Icon(Icons.monitor_weight_outlined),
            ),
            onChanged: (_) => onChanged(),
          );
          final estimate = Material(
            color: Colors.transparent,
            child: SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: const Text('Estimated weight'),
              subtitle: const Text('Mark derived results as estimated'),
              value: estimated,
              onChanged: onEstimatedChanged,
            ),
          );
          if (compact) {
            return Column(children: [input, estimate]);
          }
          return Row(
            children: [
              Expanded(flex: 3, child: input),
              const SizedBox(width: 18),
              Expanded(flex: 2, child: estimate),
            ],
          );
        },
      ),
    );
  }
}

class _ClinicalCategory extends StatelessWidget {
  const _ClinicalCategory({
    required this.title,
    required this.icon,
    required this.children,
    this.available = false,
    this.initiallyExpanded = false,
  });

  final String title;
  final IconData icon;
  final List<Widget> children;
  final bool available;
  final bool initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        initiallyExpanded: initiallyExpanded,
        leading: Icon(icon, color: Colors.white),
        collapsedIconColor: Colors.white,
        iconColor: Colors.white,
        collapsedBackgroundColor: const Color(0xff176c55),
        backgroundColor: const Color(0xfff8fbfa),
        textColor: const Color(0xff153e33),
        collapsedTextColor: Colors.white,
        shape: const Border(),
        collapsedShape: const Border(),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: available
            ? const Text(
                'Calculations available',
                style: TextStyle(color: Color(0xffd7ede5)),
              )
            : null,
        childrenPadding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
        children: children,
      ),
    );
  }
}

class _AvailableAction extends StatelessWidget {
  const _AvailableAction({
    super.key,
    required this.title,
    required this.detail,
    required this.onTap,
  });

  final String title;
  final String detail;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      leading: const Icon(Icons.play_circle_outline, color: Color(0xff176c55)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      subtitle: Text(detail),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

class _NotImplementedAction extends StatelessWidget {
  const _NotImplementedAction({required this.title, required this.detail});

  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      leading:
          const Icon(Icons.construction_outlined, color: Color(0xff6d7d77)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      subtitle: Text(detail),
    );
  }
}

class _SafetyNotice extends StatelessWidget {
  const _SafetyNotice();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: 'Clinical approval warning',
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xfffff0c7),
          border: Border.all(color: const Color(0xffd79818), width: 1.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExcludeSemantics(
              child: Icon(
                Icons.health_and_safety_outlined,
                color: Color(0xff775000),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Not approved for clinical use',
                    style: TextStyle(
                      color: Color(0xff4f3500),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    'Independent clinical review is incomplete. Do not use these calculations for patient care.',
                    style: TextStyle(color: Color(0xff4f3500)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OfflineStatus extends StatelessWidget {
  const _OfflineStatus();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        ExcludeSemantics(
          child: Icon(Icons.offline_bolt_outlined, color: Color(0xff176c55)),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            'Offline by design · no analytics · no patient data storage',
            style: TextStyle(
              color: Color(0xff34554b),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
