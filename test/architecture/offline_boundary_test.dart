// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  const forbiddenDependencies = [
    'connectivity_plus',
    'dio',
    'firebase_',
    'http',
    'url_launcher',
    'web_socket_channel',
    'webview_flutter',
  ];
  const forbiddenActiveSource = [
    "import 'dart:io'",
    'HttpClient(',
    'RawSocket.',
    'Socket.',
    'WebSocket.',
  ];

  test('runtime dependencies contain no networking packages', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();
    final dependencyStart = pubspec.indexOf('\ndependencies:\n');
    final devDependencyStart = pubspec.indexOf('\ndev_dependencies:\n');
    final dependencyBlock =
        pubspec.substring(dependencyStart, devDependencyStart);

    for (final dependency in forbiddenDependencies) {
      expect(
        dependencyBlock,
        isNot(contains(RegExp('^\\s+$dependency:', multiLine: true))),
        reason: '$dependency would violate the offline runtime boundary.',
      );
    }
  });

  test('active Dart source contains no networking APIs', () {
    final activeFiles = Directory('lib')
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'))
        .where((file) => !file.path.contains('/legacy/'));

    for (final file in activeFiles) {
      final source = file.readAsStringSync();
      for (final forbidden in forbiddenActiveSource) {
        expect(
          source,
          isNot(contains(forbidden)),
          reason:
              '${file.path} uses $forbidden, which violates the offline runtime boundary.',
        );
      }
    }
  });

  test('release platform configuration grants no network entitlement', () {
    final releaseFiles = [
      File('android/app/src/main/AndroidManifest.xml'),
      File('macos/Runner/Release.entitlements'),
      File('ios/Runner/Info.plist'),
    ];

    for (final file in releaseFiles) {
      final configuration = file.readAsStringSync();
      expect(configuration, isNot(contains('android.permission.INTERNET')));
      expect(configuration, isNot(contains('com.apple.security.network')));
      expect(configuration, isNot(contains('NSAppTransportSecurity')));
    }
  });
}
