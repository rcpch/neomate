// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';

import '../features/home/home_screen.dart';

class NeomateApp extends StatelessWidget {
  const NeomateApp({super.key, this.showStartupWarning = false});

  final bool showStartupWarning;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Neomate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff176c55),
          brightness: Brightness.light,
        ),
        fontFamily: 'Lato',
        useMaterial3: true,
      ),
      builder: (context, child) => Banner(
        message: 'ALPHA',
        location: BannerLocation.topEnd,
        color: const Color(0xffa6382a),
        textStyle: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.8,
        ),
        child: child ?? const SizedBox.shrink(),
      ),
      home: showStartupWarning
          ? const _EvaluationStartupWarning(child: HomeScreen())
          : const HomeScreen(),
    );
  }
}

class _EvaluationStartupWarning extends StatefulWidget {
  const _EvaluationStartupWarning({required this.child});

  final Widget child;

  @override
  State<_EvaluationStartupWarning> createState() =>
      _EvaluationStartupWarningState();
}

class _EvaluationStartupWarningState extends State<_EvaluationStartupWarning> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (context) => AlertDialog(
          icon: const Icon(Icons.science_outlined),
          title: const Text('Evaluation and clinical review version'),
          content: const Text(
            'This app is not ready for clinical use. It is provided for evaluation and clinical review only. Do not use its content or calculations for patient care.',
          ),
          actions: [
            FilledButton(
              key: const Key('dismiss-evaluation-warning'),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Continue evaluation'),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
