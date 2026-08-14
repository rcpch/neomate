// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

// Clinical source IDs: none assigned
// Clinical content IDs: POLICY-DISPLAY-PRECISION
// Clinical reviewer: none
// Clinical sign-off: none
// Review due: none
// Safety hazards: HZ-001, HZ-004
//
// ---------------------------------------------------------------------------
// STATUS: NOT APPROVED FOR CLINICAL USE. No source assigned, no clinical
// reviewer, no sign-off. See spec/clinical-source-convention.md.
// ---------------------------------------------------------------------------
// Policy      : Number of decimal places used when displaying calculated
//               values.
//
// Reviewer notes:
//   * Fluid volumes and rates are shown to 1 decimal place. The reason is
//     practical rather than mathematical: no syringe can be dispensed more
//     accurately than 0.1 mL, so further digits imply a precision that cannot
//     be delivered and make the number harder to read at speed.
//   * The same 1 decimal place is applied to rates in mL/hour, since infusion
//     pumps are set in those terms.
//   * A reviewer may wish to vary this for a specific view. It is expressed as
//     named constants rather than one global value so that a change can be
//     made for one calculation without silently affecting the others.
//   * Rounding behaviour itself, including the refusal to display a non-zero
//     amount that rounds to zero, lives in
//     lib/calculations/result_rounding.dart.
// ---------------------------------------------------------------------------

/// Decimal places for a volume in millilitres, such as a syringe volume or a
/// daily fluid total.
const int fluidVolumeDecimalPlaces = 1;

/// Decimal places for an infusion rate in millilitres per hour.
const int fluidRateDecimalPlaces = 1;

/// Decimal places for the volume of a stock preparation to draw up when
/// compounding.
const int additiveVolumeDecimalPlaces = 1;
