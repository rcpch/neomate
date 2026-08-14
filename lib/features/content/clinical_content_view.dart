// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';

import '../../clinical_content/clinical_artifact.dart';
import '../../clinical_content/content_document.dart';

class ClinicalContentView extends StatelessWidget {
  const ClinicalContentView({required this.content, super.key});

  final ClinicalContent content;

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Semantics(
            header: true,
            child: Text(content.title,
                style: Theme.of(context).textTheme.headlineMedium),
          ),
          const SizedBox(height: 8),
          Text(content.summary, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 8),
          Text(
            'Version ${content.version} · Reviewed ${_date(content.reviewWindow.reviewedOn)} · Review due ${_date(content.reviewWindow.reviewDueOn)}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 24),
          for (final block in content.document.blocks)
            _ContentBlockView(block: block),
        ],
      ),
    );
  }

  static String _date(DateTime value) {
    final month = value.month.toString().padLeft(2, '0');
    final day = value.day.toString().padLeft(2, '0');
    return '${value.year}-$month-$day';
  }
}

class _ContentBlockView extends StatelessWidget {
  const _ContentBlockView({required this.block});

  final ClinicalContentBlock block;

  @override
  Widget build(BuildContext context) {
    return switch (block) {
      ClinicalHeading(:final text, :final level) => Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 8),
          child: Semantics(
            header: true,
            child: Text(
              text,
              style: level == ClinicalHeadingLevel.section
                  ? Theme.of(context).textTheme.titleLarge
                  : Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ),
      ClinicalParagraph(:final text) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(text),
        ),
      ClinicalBulletList(:final items) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final item in items)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ExcludeSemantics(child: Text('• ')),
                      Expanded(child: Text(item)),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ClinicalCallout(:final kind, :final title, :final message) =>
        _ClinicalCalloutView(
          kind: kind,
          title: title,
          message: message,
        ),
    };
  }
}

class _ClinicalCalloutView extends StatelessWidget {
  const _ClinicalCalloutView(
      {required this.kind, required this.title, required this.message});

  final ClinicalCalloutKind kind;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final (icon, background, foreground) = switch (kind) {
      ClinicalCalloutKind.information => (
          Icons.info_outline,
          colors.secondaryContainer,
          colors.onSecondaryContainer
        ),
      ClinicalCalloutKind.caution => (
          Icons.warning_amber,
          colors.tertiaryContainer,
          colors.onTertiaryContainer
        ),
      ClinicalCalloutKind.urgent => (
          Icons.error_outline,
          colors.errorContainer,
          colors.onErrorContainer
        ),
    };

    return Semantics(
      container: true,
      label: '${kind.name} callout',
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: background, borderRadius: BorderRadius.circular(12)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExcludeSemantics(child: Icon(icon, color: foreground)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          color: foreground, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(message, style: TextStyle(color: foreground)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
