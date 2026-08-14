// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

enum ClinicalHeadingLevel { section, subsection }

enum ClinicalCalloutKind { information, caution, urgent }

class ClinicalContentDocument {
  const ClinicalContentDocument({required this.blocks});

  final List<ClinicalContentBlock> blocks;
}

sealed class ClinicalContentBlock {
  const ClinicalContentBlock();
}

class ClinicalHeading extends ClinicalContentBlock {
  const ClinicalHeading(
      {required this.text, this.level = ClinicalHeadingLevel.section});

  final String text;
  final ClinicalHeadingLevel level;
}

class ClinicalParagraph extends ClinicalContentBlock {
  const ClinicalParagraph(this.text);

  final String text;
}

class ClinicalBulletList extends ClinicalContentBlock {
  const ClinicalBulletList({required this.items});

  final List<String> items;
}

class ClinicalCallout extends ClinicalContentBlock {
  const ClinicalCallout(
      {required this.kind, required this.title, required this.message});

  final ClinicalCalloutKind kind;
  final String title;
  final String message;
}
