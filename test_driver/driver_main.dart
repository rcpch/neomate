// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/widgets.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:neomate2/app/neomate_app.dart';

/// Development-only entrypoint for Flutter MCP and Flutter Driver interaction.
///
/// Production builds continue to use `lib/main.dart`, which never enables the
/// driver extension.
void main() {
  enableFlutterDriverExtension();
  runApp(const NeomateApp());
}
