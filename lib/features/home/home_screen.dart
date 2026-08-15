// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';

import '../calculators/calculators_screen.dart';
import '../references/references_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _destinations = [
    _Destination(
      title: 'Calculators',
      description:
          'Weight-based calculations and approved protocol preparations',
      icon: Icons.calculate_outlined,
      available: true,
    ),
    _Destination(
      title: 'Clinical guidance',
      description: 'Versioned neonatal guidance for acute care',
      icon: Icons.menu_book_outlined,
    ),
    _Destination(
      title: 'Checklists',
      description: 'Reviewed cognitive aids for neonatal workflows',
      icon: Icons.checklist_outlined,
    ),
    _Destination(
      title: 'References',
      description: 'Sources, review dates, and clinical sign-off records',
      icon: Icons.source_outlined,
      available: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f7f5),
      body: CustomScrollView(
        slivers: [
          const _Header(),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
            sliver: SliverToBoxAdapter(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 960),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _SafetyNotice(),
                      const SizedBox(height: 28),
                      Text(
                        'Clinical workspace',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: const Color(0xff153e33),
                                  fontWeight: FontWeight.w700,
                                ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Features become available only after their clinical sources, controls, and tests are approved.',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: const Color(0xff456158),
                            ),
                      ),
                      const SizedBox(height: 18),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final columns = constraints.maxWidth >= 720 ? 2 : 1;
                          final width = columns == 1
                              ? constraints.maxWidth
                              : (constraints.maxWidth - 16) / 2;
                          return Wrap(
                            spacing: 16,
                            runSpacing: 16,
                            children: [
                              for (final destination in _destinations)
                                SizedBox(
                                  width: width,
                                  child: _DestinationPanel(
                                    key: Key(
                                      'destination-${destination.title.toLowerCase().replaceAll(' ', '-')}',
                                    ),
                                    destination: destination,
                                    onTap: destination.available
                                        ? () => _openDestination(
                                              context,
                                              destination.title,
                                            )
                                        : null,
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 28),
                      const _OfflineStatus(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openDestination(BuildContext context, String title) {
    final screen = switch (title) {
      'Calculators' => const CalculatorsScreen(),
      'References' => const ReferencesScreen(),
      _ => null,
    };
    if (screen == null) return;
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => screen),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 168,
      backgroundColor: const Color(0xff125743),
      foregroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        expandedTitleScale: 1,
        titlePadding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
        title: Semantics(
          header: true,
          child: const Text(
            'Neomate',
            style: TextStyle(
                color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800),
          ),
        ),
        background: const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff0e4738), Color(0xff1f765d)],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 64, 20, 20),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Offline neonatal calculations and guidance',
                style: TextStyle(color: Color(0xffd7ede5), fontSize: 16),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SafetyNotice extends StatelessWidget {
  const _SafetyNotice();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: 'Development safety notice',
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xfffff0c7),
          border: Border.all(color: const Color(0xffd79818), width: 1.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExcludeSemantics(
              child: Icon(Icons.health_and_safety_outlined,
                  color: Color(0xff775000)),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Native rebuild in progress',
                    style: TextStyle(
                      color: Color(0xff4f3500),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'This build is not approved for clinical use. Alpha demonstrations are available for evaluation; reviewed clinical features remain unavailable.',
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

class _DestinationPanel extends StatelessWidget {
  const _DestinationPanel({super.key, required this.destination, this.onTap});

  final _Destination destination;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      button: destination.available,
      label: destination.available
          ? '${destination.title}, internal alpha available'
          : '${destination.title}, unavailable pending clinical review',
      child: Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xffcbd8d3)),
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Container(
            constraints: const BoxConstraints(minHeight: 150),
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ExcludeSemantics(
                      child: Icon(destination.icon,
                          color: const Color(0xff176c55), size: 28),
                    ),
                    const Spacer(),
                    _ReviewStatus(available: destination.available),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  destination.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: const Color(0xff153e33),
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  destination.description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color(0xff50665f),
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ReviewStatus extends StatelessWidget {
  const _ReviewStatus({required this.available});

  final bool available;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: available ? const Color(0xffe8f3ef) : const Color(0xffedf1ef),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        available ? 'Alpha demo' : 'In review',
        style: TextStyle(
          color: available ? const Color(0xff125743) : const Color(0xff50665f),
          fontSize: 12,
          fontWeight: FontWeight.w700,
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
            child: Icon(Icons.offline_bolt_outlined, color: Color(0xff176c55))),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            'Offline by design · no analytics · no patient data storage',
            style: TextStyle(
                color: Color(0xff34554b), fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

class _Destination {
  const _Destination(
      {required this.title,
      required this.description,
      required this.icon,
      this.available = false});

  final String title;
  final String description;
  final IconData icon;
  final bool available;
}
