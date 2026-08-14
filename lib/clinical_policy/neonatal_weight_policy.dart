// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

// Clinical source IDs: SRC-006
// Clinical content IDs: POLICY-NEONATAL-WEIGHT
// Clinical reviewer: none
// Clinical sign-off: none
// Review due: none
// Safety hazards: HZ-001, HZ-003
//
// ---------------------------------------------------------------------------
// STATUS: NOT APPROVED FOR CLINICAL USE. Source is provenance only, no
// clinical reviewer, no sign-off. See spec/clinical-source-convention.md.
// ---------------------------------------------------------------------------
// Policy      : Permitted patient weight range for weight-based calculations.
// Value       : 200 g to 6000 g inclusive.
//
// Reviewer notes:
//   * This range is harvested from the inherited Neomate implementation
//     (lib/legacy/neomate.dart, minWeightGrams 200 / maxWeightGrams 6000) and
//     is attributed to SRC-006, which is provenance only and carries no
//     clinical authority. It is recorded here so the value is visible and
//     reviewable rather than invisible in a text field.
//   * The range is clinically plausible on its face: 200 g spans the smallest
//     periviable infants, and 6000 g covers a large infant needing
//     resuscitation at birth. A reviewer is being asked to confirm that, and
//     to decide whether either bound should move.
//   * The bounds are deliberately wide. Their purpose is to catch a typing
//     error such as a weight entered in kilograms, or a missing digit, not to
//     define which babies the product is for. Intended population is stated in
//     the intended-purpose record, not here.
//   * Bounds are inclusive: a weight of exactly 200 g or 6000 g is accepted.
// ---------------------------------------------------------------------------

import '../calculations/patient_context.dart';

/// The weight range Neomate 2 accepts for weight-based calculations.
///
/// Passed explicitly to [PatientWeight.validate] rather than being read as a
/// global, so that a calculation always shows which policy it validated
/// against.
const WeightPolicy neonatalWeightPolicy = WeightPolicy(
  minimumGrams: 200,
  maximumGrams: 6000,
  sourceId: 'SRC-006',
);
