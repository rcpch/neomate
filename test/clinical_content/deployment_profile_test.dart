// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter_test/flutter_test.dart';
import 'package:neomate2/clinical_content/clinical_artifact.dart';
import 'package:neomate2/clinical_content/clinical_registry.dart';
import 'package:neomate2/clinical_content/deployment_profile.dart';
import 'package:neomate2/clinical_content/content_document.dart';
import 'package:neomate2/clinical_content/provenance.dart';

void main() {
  final reviewedOn = DateTime.utc(2026, 8, 14);
  final applicability = const ClinicalApplicability(
    population: 'Synthetic population',
    intendedUsers: 'Synthetic users',
    careSetting: 'Synthetic setting',
    exclusions: [],
  );
  final reviewWindow = ReviewWindow(
    reviewedOn: reviewedOn,
    reviewDueOn: DateTime.utc(2027, 8, 14),
  );
  final signOffs = [
    ClinicalSignOff(
      reviewer: 'Dr Example Reviewer',
      role: 'Clinical reviewer',
      decision: SignOffDecision.approved,
      signedOn: reviewedOn,
    ),
  ];
  final clinicalRegistry = ClinicalRegistry(
    sources: [
      ClinicalSource(
        id: 'SRC-001',
        title: 'Synthetic source',
        publisher: 'Synthetic publisher',
        version: '1',
        url: Uri.parse('https://example.org/source'),
        publishedOn: DateTime.utc(2026),
        accessedOn: reviewedOn,
      ),
    ],
    artifacts: [
      ClinicalContent(
        id: 'CONTENT-001',
        title: 'Synthetic content',
        version: '1',
        sourceIds: const ['SRC-001'],
        hazardIds: const ['HZ-001'],
        applicability: applicability,
        reviewWindow: reviewWindow,
        signOffs: signOffs,
        summary: 'Synthetic content for tests.',
        document: const ClinicalContentDocument(blocks: []),
      ),
      ClinicalProtocol(
        id: 'PROTOCOL-001',
        title: 'Synthetic protocol',
        version: '1',
        sourceIds: const ['SRC-001'],
        hazardIds: const ['HZ-001'],
        applicability: applicability,
        reviewWindow: reviewWindow,
        signOffs: signOffs,
        warnings: const [],
      ),
    ],
  );

  test('accepts profiles containing only registered artifact IDs', () {
    final profiles = DeploymentProfileRegistry(
      profiles: const [
        DeploymentProfile(
          id: 'PROFILE-001',
          name: 'Synthetic deployment',
          version: '1',
          contentIds: ['CONTENT-001'],
          protocolIds: ['PROTOCOL-001'],
        ),
      ],
    );

    expect(profiles.validateAgainst(clinicalRegistry), isEmpty);
  });

  test('rejects missing and incorrectly typed artifact references', () {
    final profiles = DeploymentProfileRegistry(
      profiles: const [
        DeploymentProfile(
          id: 'PROFILE-001',
          name: 'Synthetic deployment',
          version: '1',
          contentIds: ['PROTOCOL-001', 'CONTENT-MISSING'],
          protocolIds: ['CONTENT-001', 'PROTOCOL-MISSING'],
        ),
      ],
    );

    final issues = profiles.validateAgainst(clinicalRegistry);

    expect(
      issues.where(
          (issue) => issue.code == DeploymentProfileIssueCode.missingContent),
      hasLength(2),
    );
    expect(
      issues.where(
          (issue) => issue.code == DeploymentProfileIssueCode.missingProtocol),
      hasLength(2),
    );
  });

  test('rejects duplicate IDs and blank profile metadata', () {
    final profiles = DeploymentProfileRegistry(
      profiles: const [
        DeploymentProfile(
          id: '',
          name: '',
          version: '',
          contentIds: [],
          protocolIds: [],
        ),
        DeploymentProfile(
          id: '',
          name: 'Duplicate',
          version: '1',
          contentIds: [],
          protocolIds: [],
        ),
      ],
    );

    final issues = profiles.validateAgainst(clinicalRegistry);

    expect(issues.map((issue) => issue.code),
        contains(DeploymentProfileIssueCode.duplicateId));
    expect(
      issues.where((issue) =>
          issue.code == DeploymentProfileIssueCode.emptyRequiredField),
      hasLength(4),
    );
  });
}
