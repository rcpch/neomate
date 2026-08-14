// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'provenance.dart';
import 'content_document.dart';

abstract interface class ClinicalArtifact {
  String get id;
  String get title;
  String get version;
  List<String> get sourceIds;
  List<String> get hazardIds;
  ClinicalApplicability get applicability;
  ReviewWindow get reviewWindow;
  List<ClinicalSignOff> get signOffs;
}

class ClinicalContent implements ClinicalArtifact {
  const ClinicalContent({
    required this.id,
    required this.title,
    required this.version,
    required this.sourceIds,
    required this.hazardIds,
    required this.applicability,
    required this.reviewWindow,
    required this.signOffs,
    required this.summary,
    required this.document,
  });

  @override
  final String id;
  @override
  final String title;
  @override
  final String version;
  @override
  final List<String> sourceIds;
  @override
  final List<String> hazardIds;
  @override
  final ClinicalApplicability applicability;
  @override
  final ReviewWindow reviewWindow;
  @override
  final List<ClinicalSignOff> signOffs;
  final String summary;
  final ClinicalContentDocument document;
}

class ClinicalWarning {
  const ClinicalWarning({required this.id, required this.message});

  final String id;
  final String message;
}

class ClinicalProtocol implements ClinicalArtifact {
  const ClinicalProtocol({
    required this.id,
    required this.title,
    required this.version,
    required this.sourceIds,
    required this.hazardIds,
    required this.applicability,
    required this.reviewWindow,
    required this.signOffs,
    required this.warnings,
  });

  @override
  final String id;
  @override
  final String title;
  @override
  final String version;
  @override
  final List<String> sourceIds;
  @override
  final List<String> hazardIds;
  @override
  final ClinicalApplicability applicability;
  @override
  final ReviewWindow reviewWindow;
  @override
  final List<ClinicalSignOff> signOffs;
  final List<ClinicalWarning> warnings;
}
