// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';

import '../features/home/home_screen.dart';

class NeomateApp extends StatelessWidget {
  const NeomateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Neomate',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff176c55),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
