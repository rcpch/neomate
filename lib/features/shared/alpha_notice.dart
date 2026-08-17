// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';

class AlphaNotice extends StatelessWidget {
  const AlphaNotice({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: 'Clinical approval warning',
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(compact ? 12 : 16),
        decoration: BoxDecoration(
          color: const Color(0xfffff0c7),
          border: Border.all(color: const Color(0xffd79818), width: 1.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ExcludeSemantics(
              child: Icon(
                Icons.science_outlined,
                color: Color(0xff775000),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Not approved for clinical use',
                    style: TextStyle(
                      color: Color(0xff4f3500),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if (!compact) ...[
                    const SizedBox(height: 3),
                    const Text(
                      'Independent clinical review is incomplete. Do not use these outputs for patient care.',
                      style: TextStyle(color: Color(0xff4f3500)),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
