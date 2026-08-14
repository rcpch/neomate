// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

/// Decides whether a clinical artefact may be presented to a user.
///
/// This is the runtime gate that sits between the registry and the interface.
/// The registry checks that a record is *well formed*; this decides whether it
/// is *currently fit to show*. Both are needed: a record can be complete and
/// still be out of review, or superseded, or rejected.
///
/// The default is refusal. An artefact is presented only when it positively
/// satisfies every condition below, so a new field or state that nobody has
/// thought about yet cannot accidentally read as approval.
///
/// This file contains no clinical statement, formula, or threshold, so it does
/// not itself require clinical sign-off. What it decides, however, is safety
/// critical, which is why every branch is tested.
library;

import 'clinical_artifact.dart';
import 'provenance.dart';

/// Why an artefact may not be shown.
enum UnavailabilityReason {
  /// No sign-off has ever been recorded.
  neverReviewed,

  /// The most recent decision was to reject the artefact.
  rejected,

  /// The artefact has been replaced by a newer one.
  superseded,

  /// Sign-off exists but the review-due date has passed. Clinical guidance
  /// goes out of date, so an expired review is treated as no approval at all
  /// rather than as a warning shown alongside the content.
  reviewExpired,
}

/// The outcome of the availability decision.
sealed class ClinicalAvailability {
  const ClinicalAvailability();
}

/// The artefact may be presented.
class ClinicallyAvailable extends ClinicalAvailability {
  const ClinicallyAvailable(this.approval);

  /// The sign-off that authorises presentation, so the interface can name the
  /// reviewer and the date without searching for them again.
  final ClinicalSignOff approval;
}

/// The artefact must not be presented.
class ClinicallyUnavailable extends ClinicalAvailability {
  const ClinicallyUnavailable(this.reason);

  final UnavailabilityReason reason;
}

/// Decides whether [artifact] may be presented on [date].
///
/// [date] is passed in rather than read from the system clock so that the
/// decision is deterministic and testable, and so that a single "now" can be
/// used consistently across a screen.
ClinicalAvailability availabilityOf(
  ClinicalArtifact artifact, {
  required DateTime date,
}) {
  if (artifact.signOffs.isEmpty) {
    return const ClinicallyUnavailable(UnavailabilityReason.neverReviewed);
  }

  // The most recent sign-off governs. Sorting rather than trusting list order
  // means a record whose sign-offs were appended out of order still gives the
  // right answer.
  final latest = artifact.signOffs.reduce(
    (a, b) => b.signedOn.isAfter(a.signedOn) ? b : a,
  );

  switch (latest.decision) {
    case SignOffDecision.rejected:
      return const ClinicallyUnavailable(UnavailabilityReason.rejected);
    case SignOffDecision.superseded:
      return const ClinicallyUnavailable(UnavailabilityReason.superseded);
    case SignOffDecision.approved:
      break;
  }

  if (!artifact.reviewWindow.isCurrentOn(date)) {
    return const ClinicallyUnavailable(UnavailabilityReason.reviewExpired);
  }

  return ClinicallyAvailable(latest);
}
