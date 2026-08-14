// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'clinical_artifact.dart';
import 'provenance.dart';

enum RegistryIssueCode {
  duplicateId,
  emptyRequiredField,
  invalidSourceUrl,
  invalidReviewWindow,
  missingSource,
  missingHazard,
  missingSignOff,
  missingApproval,
  expiredReview,
}

class RegistryIssue {
  const RegistryIssue({
    required this.code,
    required this.recordId,
    required this.message,
  });

  final RegistryIssueCode code;
  final String recordId;
  final String message;
}

class ClinicalRegistry {
  ClinicalRegistry(
      {required List<ClinicalSource> sources,
      required List<ClinicalArtifact> artifacts})
      : sources = List.unmodifiable(sources),
        artifacts = List.unmodifiable(artifacts);

  final List<ClinicalSource> sources;
  final List<ClinicalArtifact> artifacts;

  List<RegistryIssue> validate({required DateTime onDate}) {
    final issues = <RegistryIssue>[];
    final sourceIds = <String>{};
    final artifactIds = <String>{};

    for (final source in sources) {
      _requireText(issues, source.id, source.id, 'source ID');
      _requireText(issues, source.id, source.title, 'source title');
      _requireText(issues, source.id, source.publisher, 'source publisher');
      _requireText(issues, source.id, source.version, 'source version');
      if (!sourceIds.add(source.id)) {
        issues.add(
          RegistryIssue(
            code: RegistryIssueCode.duplicateId,
            recordId: source.id,
            message: 'Source ID must be unique.',
          ),
        );
      }
      if (source.url.scheme != 'https' || source.url.host.isEmpty) {
        issues.add(
          RegistryIssue(
            code: RegistryIssueCode.invalidSourceUrl,
            recordId: source.id,
            message: 'Source URL must be an absolute HTTPS URL.',
          ),
        );
      }
    }

    for (final artifact in artifacts) {
      _requireText(issues, artifact.id, artifact.id, 'artifact ID');
      _requireText(issues, artifact.id, artifact.title, 'artifact title');
      _requireText(issues, artifact.id, artifact.version, 'artifact version');
      _requireText(
          issues, artifact.id, artifact.applicability.population, 'population');
      _requireText(issues, artifact.id, artifact.applicability.intendedUsers,
          'intended users');
      _requireText(issues, artifact.id, artifact.applicability.careSetting,
          'care setting');

      if (!artifactIds.add(artifact.id)) {
        issues.add(
          RegistryIssue(
            code: RegistryIssueCode.duplicateId,
            recordId: artifact.id,
            message: 'Artifact ID must be unique.',
          ),
        );
      }
      if (artifact.reviewWindow.reviewDueOn
          .isBefore(artifact.reviewWindow.reviewedOn)) {
        issues.add(
          RegistryIssue(
            code: RegistryIssueCode.invalidReviewWindow,
            recordId: artifact.id,
            message: 'Review due date must not precede the review date.',
          ),
        );
      } else if (!artifact.reviewWindow.isCurrentOn(onDate)) {
        issues.add(
          RegistryIssue(
            code: RegistryIssueCode.expiredReview,
            recordId: artifact.id,
            message: 'Clinical review has expired.',
          ),
        );
      }
      if (artifact.sourceIds.isEmpty ||
          artifact.sourceIds.any((id) => !sourceIds.contains(id))) {
        issues.add(
          RegistryIssue(
            code: RegistryIssueCode.missingSource,
            recordId: artifact.id,
            message: 'Every artifact must reference registered sources.',
          ),
        );
      }
      if (artifact.hazardIds.isEmpty) {
        issues.add(
          RegistryIssue(
            code: RegistryIssueCode.missingHazard,
            recordId: artifact.id,
            message:
                'Every artifact must reference at least one safety hazard.',
          ),
        );
      }
      if (artifact.signOffs.isEmpty) {
        issues.add(
          RegistryIssue(
            code: RegistryIssueCode.missingSignOff,
            recordId: artifact.id,
            message: 'Every artifact must have a clinical sign-off record.',
          ),
        );
      } else {
        for (final signOff in artifact.signOffs) {
          _requireText(issues, artifact.id, signOff.reviewer, 'reviewer');
          _requireText(issues, artifact.id, signOff.role, 'reviewer role');
        }
        if (!artifact.signOffs
            .any((signOff) => signOff.decision == SignOffDecision.approved)) {
          issues.add(
            RegistryIssue(
              code: RegistryIssueCode.missingApproval,
              recordId: artifact.id,
              message:
                  'Every artifact must have an approved clinical sign-off.',
            ),
          );
        }
      }
    }

    return List.unmodifiable(issues);
  }

  static void _requireText(
    List<RegistryIssue> issues,
    String recordId,
    String value,
    String field,
  ) {
    if (value.trim().isEmpty) {
      issues.add(
        RegistryIssue(
          code: RegistryIssueCode.emptyRequiredField,
          recordId: recordId,
          message: '$field must not be empty.',
        ),
      );
    }
  }
}
