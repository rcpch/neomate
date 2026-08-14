// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter_test/flutter_test.dart';
import 'package:neomate2/clinical_content/clinical_artifact.dart';
import 'package:neomate2/clinical_content/clinical_registry.dart';
import 'package:neomate2/clinical_content/content_document.dart';
import 'package:neomate2/clinical_content/provenance.dart';

void main() {
  final reviewDate = DateTime.utc(2026, 8, 14);
  final reviewDueDate = DateTime.utc(2027, 8, 14);

  ClinicalSource validSource({String id = 'SRC-001'}) => ClinicalSource(
        id: id,
        title: 'Example clinical guidance',
        publisher: 'Example publisher',
        version: '2026',
        url: Uri.parse('https://example.org/guidance'),
        publishedOn: DateTime.utc(2026),
        accessedOn: reviewDate,
      );

  ClinicalContent validContent({
    String id = 'CONTENT-001',
    List<String> sourceIds = const ['SRC-001'],
    List<String> hazardIds = const ['HZ-001'],
    List<ClinicalSignOff>? signOffs,
    ReviewWindow? reviewWindow,
  }) =>
      ClinicalContent(
        id: id,
        title: 'Example content',
        version: '1.0.0',
        sourceIds: sourceIds,
        hazardIds: hazardIds,
        applicability: const ClinicalApplicability(
          population: 'Example population',
          intendedUsers: 'Example clinicians',
          careSetting: 'Example care setting',
          exclusions: [],
        ),
        reviewWindow: reviewWindow ??
            ReviewWindow(reviewedOn: reviewDate, reviewDueOn: reviewDueDate),
        signOffs: signOffs ??
            [
              ClinicalSignOff(
                reviewer: 'Dr Example Reviewer',
                role: 'Clinical reviewer',
                decision: SignOffDecision.approved,
                signedOn: reviewDate,
              ),
            ],
        summary: 'Synthetic test content only.',
        document: const ClinicalContentDocument(blocks: []),
      );

  test('accepts a complete current registry', () {
    final registry =
        ClinicalRegistry(sources: [validSource()], artifacts: [validContent()]);

    expect(registry.validate(onDate: reviewDate), isEmpty);
  });

  test('rejects duplicate source and artifact identifiers', () {
    final registry = ClinicalRegistry(
      sources: [validSource(), validSource()],
      artifacts: [validContent(), validContent()],
    );

    final issues = registry.validate(onDate: reviewDate);

    expect(
      issues.where((issue) => issue.code == RegistryIssueCode.duplicateId),
      hasLength(2),
    );
  });

  test('rejects an unregistered source and missing hazard', () {
    final registry = ClinicalRegistry(
      sources: [validSource()],
      artifacts: [
        validContent(sourceIds: const ['SRC-MISSING'], hazardIds: const [])
      ],
    );

    final issueCodes =
        registry.validate(onDate: reviewDate).map((issue) => issue.code);

    expect(issueCodes, contains(RegistryIssueCode.missingSource));
    expect(issueCodes, contains(RegistryIssueCode.missingHazard));
  });

  test('rejects missing or non-approved clinical sign-off', () {
    final missing = ClinicalRegistry(
      sources: [validSource()],
      artifacts: [validContent(signOffs: const [])],
    );
    final rejected = ClinicalRegistry(
      sources: [validSource()],
      artifacts: [
        validContent(
          signOffs: [
            ClinicalSignOff(
              reviewer: 'Dr Example Reviewer',
              role: 'Clinical reviewer',
              decision: SignOffDecision.rejected,
              signedOn: reviewDate,
            ),
          ],
        ),
      ],
    );

    expect(
      missing.validate(onDate: reviewDate).map((issue) => issue.code),
      contains(RegistryIssueCode.missingSignOff),
    );
    expect(
      rejected.validate(onDate: reviewDate).map((issue) => issue.code),
      contains(RegistryIssueCode.missingApproval),
    );
  });

  test('rejects expired and inverted review windows', () {
    final expired = ClinicalRegistry(
      sources: [validSource()],
      artifacts: [validContent()],
    );
    final inverted = ClinicalRegistry(
      sources: [validSource()],
      artifacts: [
        validContent(
          reviewWindow: ReviewWindow(
            reviewedOn: DateTime.utc(2027),
            reviewDueOn: DateTime.utc(2026),
          ),
        ),
      ],
    );

    expect(
      expired
          .validate(onDate: DateTime.utc(2027, 8, 15))
          .map((issue) => issue.code),
      contains(RegistryIssueCode.expiredReview),
    );
    expect(
      inverted.validate(onDate: reviewDate).map((issue) => issue.code),
      contains(RegistryIssueCode.invalidReviewWindow),
    );
  });

  test('rejects non-HTTPS source URLs and blank required fields', () {
    final invalidSource = ClinicalSource(
      id: 'SRC-001',
      title: '',
      publisher: 'Example publisher',
      version: '2026',
      url: Uri.parse('http://example.org/guidance'),
      publishedOn: DateTime.utc(2026),
      accessedOn: reviewDate,
    );
    final registry = ClinicalRegistry(
      sources: [invalidSource],
      artifacts: [validContent()],
    );

    final issueCodes =
        registry.validate(onDate: reviewDate).map((issue) => issue.code);

    expect(issueCodes, contains(RegistryIssueCode.invalidSourceUrl));
    expect(issueCodes, contains(RegistryIssueCode.emptyRequiredField));
  });
}
