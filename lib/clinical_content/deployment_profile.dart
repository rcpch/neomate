// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'clinical_artifact.dart';
import 'clinical_registry.dart';

enum DeploymentProfileIssueCode {
  duplicateId,
  emptyRequiredField,
  missingContent,
  missingProtocol,
}

class DeploymentProfileIssue {
  const DeploymentProfileIssue({
    required this.code,
    required this.profileId,
    required this.message,
  });

  final DeploymentProfileIssueCode code;
  final String profileId;
  final String message;
}

class DeploymentProfile {
  const DeploymentProfile({
    required this.id,
    required this.name,
    required this.version,
    required this.contentIds,
    required this.protocolIds,
  });

  final String id;
  final String name;
  final String version;
  final List<String> contentIds;
  final List<String> protocolIds;
}

class DeploymentProfileRegistry {
  DeploymentProfileRegistry({required List<DeploymentProfile> profiles})
      : profiles = List.unmodifiable(profiles);

  final List<DeploymentProfile> profiles;

  List<DeploymentProfileIssue> validateAgainst(
      ClinicalRegistry clinicalRegistry) {
    final issues = <DeploymentProfileIssue>[];
    final profileIds = <String>{};
    final contentIds = clinicalRegistry.artifacts
        .whereType<ClinicalContent>()
        .map((item) => item.id)
        .toSet();
    final protocolIds = clinicalRegistry.artifacts
        .whereType<ClinicalProtocol>()
        .map((item) => item.id)
        .toSet();

    for (final profile in profiles) {
      if (!profileIds.add(profile.id)) {
        issues.add(
          DeploymentProfileIssue(
            code: DeploymentProfileIssueCode.duplicateId,
            profileId: profile.id,
            message: 'Deployment profile ID must be unique.',
          ),
        );
      }
      _requireText(issues, profile.id, profile.id, 'profile ID');
      _requireText(issues, profile.id, profile.name, 'profile name');
      _requireText(issues, profile.id, profile.version, 'profile version');

      for (final contentId in profile.contentIds) {
        if (!contentIds.contains(contentId)) {
          issues.add(
            DeploymentProfileIssue(
              code: DeploymentProfileIssueCode.missingContent,
              profileId: profile.id,
              message: 'Unknown clinical content ID: $contentId.',
            ),
          );
        }
      }
      for (final protocolId in profile.protocolIds) {
        if (!protocolIds.contains(protocolId)) {
          issues.add(
            DeploymentProfileIssue(
              code: DeploymentProfileIssueCode.missingProtocol,
              profileId: profile.id,
              message: 'Unknown clinical protocol ID: $protocolId.',
            ),
          );
        }
      }
    }

    return List.unmodifiable(issues);
  }

  static void _requireText(
    List<DeploymentProfileIssue> issues,
    String profileId,
    String value,
    String field,
  ) {
    if (value.trim().isEmpty) {
      issues.add(
        DeploymentProfileIssue(
          code: DeploymentProfileIssueCode.emptyRequiredField,
          profileId: profileId,
          message: '$field must not be empty.',
        ),
      );
    }
  }
}
