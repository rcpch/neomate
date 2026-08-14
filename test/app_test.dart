// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter_test/flutter_test.dart';
import 'package:neomate2/app/neomate_app.dart';

void main() {
  testWidgets('shows the native rebuild status', (tester) async {
    await tester.pumpWidget(const NeomateApp());

    expect(find.text('Neomate'), findsOneWidget);
    expect(find.text('Native rebuild in progress'), findsOneWidget);
    expect(
        find.textContaining('not approved for clinical use'), findsOneWidget);
  });
}
