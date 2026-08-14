// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

// Tests for the runtime gate that decides whether clinical material may be
// shown. Every branch is covered, because the failure mode of this file is
// presenting unapproved or out-of-date clinical guidance as if it were
// current.
//
// All records here are synthetic. No real clinical content is used.

import 'package:flutter_test/flutter_test.dart';
import 'package:neomate2/clinical_content/clinical_artifact.dart';
import 'package:neomate2/clinical_content/clinical_availability.dart';
import 'package:neomate2/clinical_content/content_document.dart';
import 'package:neomate2/clinical_content/provenance.dart';

void main() {
  final today = DateTime.utc(2026, 8, 14);

  const applicability = ClinicalApplicability(
    population: 'Synthetic test population',
    intendedUsers: 'Synthetic test users',
    careSetting: 'Synthetic test setting',
    exclusions: <String>['Synthetic exclusion'],
  );

  ClinicalProtocol protocolWith({
    required List<ClinicalSignOff> signOffs,
    required ReviewWindow reviewWindow,
  }) {
    return ClinicalProtocol(
      id: 'PROTOCOL-SYNTHETIC',
      title: 'Synthetic protocol',
      version: '1.0.0',
      sourceIds: const <String>['SRC-SYNTHETIC'],
      hazardIds: const <String>['HZ-001'],
      applicability: applicability,
      reviewWindow: reviewWindow,
      signOffs: signOffs,
      warnings: const <ClinicalWarning>[],
    );
  }

  ClinicalSignOff signOff(SignOffDecision decision, DateTime signedOn) {
    return ClinicalSignOff(
      reviewer: 'Dr Synthetic Reviewer',
      role: 'Test reviewer',
      decision: decision,
      signedOn: signedOn,
    );
  }

  final currentWindow = ReviewWindow(
    reviewedOn: DateTime.utc(2026, 1, 1),
    reviewDueOn: DateTime.utc(2027, 1, 1),
  );

  group('clinical availability', () {
    test('presents an approved artefact within its review window', () {
      final artifact = protocolWith(
        signOffs: [signOff(SignOffDecision.approved, DateTime.utc(2026, 1, 1))],
        reviewWindow: currentWindow,
      );

      final availability =
          availabilityOf(artifact, date: today) as ClinicallyAvailable;

      // The authorising sign-off is returned so the interface can name the
      // reviewer without searching the record again.
      expect(availability.approval.reviewer, 'Dr Synthetic Reviewer');
    });

    test('refuses an artefact that has never been reviewed', () {
      final artifact = protocolWith(
        signOffs: const <ClinicalSignOff>[],
        reviewWindow: currentWindow,
      );

      final availability =
          availabilityOf(artifact, date: today) as ClinicallyUnavailable;

      expect(availability.reason, UnavailabilityReason.neverReviewed);
    });

    test('refuses a rejected artefact', () {
      final artifact = protocolWith(
        signOffs: [signOff(SignOffDecision.rejected, DateTime.utc(2026, 1, 1))],
        reviewWindow: currentWindow,
      );

      final availability =
          availabilityOf(artifact, date: today) as ClinicallyUnavailable;

      expect(availability.reason, UnavailabilityReason.rejected);
    });

    test('refuses a superseded artefact', () {
      final artifact = protocolWith(
        signOffs: [
          signOff(SignOffDecision.superseded, DateTime.utc(2026, 1, 1)),
        ],
        reviewWindow: currentWindow,
      );

      final availability =
          availabilityOf(artifact, date: today) as ClinicallyUnavailable;

      expect(availability.reason, UnavailabilityReason.superseded);
    });

    test('refuses an approved artefact whose review has expired', () {
      // Approval alone is not enough: guidance goes out of date.
      final artifact = protocolWith(
        signOffs: [signOff(SignOffDecision.approved, DateTime.utc(2024, 1, 1))],
        reviewWindow: ReviewWindow(
          reviewedOn: DateTime.utc(2024, 1, 1),
          reviewDueOn: DateTime.utc(2025, 1, 1),
        ),
      );

      final availability =
          availabilityOf(artifact, date: today) as ClinicallyUnavailable;

      expect(availability.reason, UnavailabilityReason.reviewExpired);
    });

    test('remains available on the review-due date itself', () {
      // The boundary is inclusive: review is due that day, not overdue.
      final artifact = protocolWith(
        signOffs: [signOff(SignOffDecision.approved, DateTime.utc(2026, 1, 1))],
        reviewWindow: ReviewWindow(
          reviewedOn: DateTime.utc(2026, 1, 1),
          reviewDueOn: today,
        ),
      );

      expect(availabilityOf(artifact, date: today), isA<ClinicallyAvailable>());
    });

    test('becomes unavailable the day after the review-due date', () {
      final artifact = protocolWith(
        signOffs: [signOff(SignOffDecision.approved, DateTime.utc(2026, 1, 1))],
        reviewWindow: ReviewWindow(
          reviewedOn: DateTime.utc(2026, 1, 1),
          reviewDueOn: today,
        ),
      );

      final availability = availabilityOf(
        artifact,
        date: today.add(const Duration(days: 1)),
      ) as ClinicallyUnavailable;

      expect(availability.reason, UnavailabilityReason.reviewExpired);
    });

    test('the most recent decision governs, whatever the list order', () {
      // An older approval must not override a later rejection.
      final artifact = protocolWith(
        signOffs: [
          signOff(SignOffDecision.rejected, DateTime.utc(2026, 6, 1)),
          signOff(SignOffDecision.approved, DateTime.utc(2026, 1, 1)),
        ],
        reviewWindow: currentWindow,
      );

      final availability =
          availabilityOf(artifact, date: today) as ClinicallyUnavailable;

      expect(availability.reason, UnavailabilityReason.rejected);
    });

    test('a later approval supersedes an earlier rejection', () {
      final artifact = protocolWith(
        signOffs: [
          signOff(SignOffDecision.rejected, DateTime.utc(2026, 1, 1)),
          signOff(SignOffDecision.approved, DateTime.utc(2026, 6, 1)),
        ],
        reviewWindow: currentWindow,
      );

      expect(availabilityOf(artifact, date: today), isA<ClinicallyAvailable>());
    });

    test('applies the same rules to content as to protocols', () {
      // The gate works on the ClinicalArtifact interface, so both record types
      // are governed identically.
      final content = ClinicalContent(
        id: 'CONTENT-SYNTHETIC',
        title: 'Synthetic content',
        version: '1.0.0',
        sourceIds: const <String>['SRC-SYNTHETIC'],
        hazardIds: const <String>['HZ-002'],
        applicability: applicability,
        reviewWindow: ReviewWindow(
          reviewedOn: DateTime.utc(2024, 1, 1),
          reviewDueOn: DateTime.utc(2025, 1, 1),
        ),
        signOffs: [signOff(SignOffDecision.approved, DateTime.utc(2024, 1, 1))],
        summary: 'Synthetic summary',
        document:
            const ClinicalContentDocument(blocks: <ClinicalContentBlock>[]),
      );

      final availability =
          availabilityOf(content, date: today) as ClinicallyUnavailable;

      expect(availability.reason, UnavailabilityReason.reviewExpired);
    });
  });
}
