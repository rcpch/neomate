# Clinical Sign-Off Register

This is the definitive list of source files that require clinical sign-off before Neomate 2 can be released for clinical use. Nothing on this list is signed off yet.

Each file is written to be reviewable on its own: one formula or one clinical decision per file, with the derivation and every constant explained in comments. A reviewer should be able to read a single file end to end without reading the rest of the codebase.

The list is kept honest by `test/architecture/clinical_sign_off_register_test.dart`, which fails if a file requiring sign-off is missing from this register, or if this register names a file that no longer exists. Adding a new clinical file therefore forces a corresponding entry here.

## How To Review An Entry

1. Read the file. It states its formula, its inputs and their units, and the bounds it enforces.
2. Confirm the formula against a named, dated, authoritative source, and record that source in the file header and in the source registry.
3. Confirm the plausibility bounds are wide enough never to block a real neonatal value, and narrow enough to catch a mistyped one. These bounds are engineering guards against typing errors, not clinical limits.
4. Confirm the file's tests reflect the source, including the boundary and refusal cases.
5. Record the outcome in the file's header block using the fields in [../spec/clinical-source-convention.md](../spec/clinical-source-convention.md), and tick the box below.

A tick here records that the header block has been completed with a named reviewer, an ISO 8601 sign-off, and a review-due date. The header block in the file remains the authoritative record.

## Calculation Modules

- [ ] `lib/calculations/patient_context.dart` - patient weight validation, and the single gram-to-kilogram conversion every other calculation depends on.
- [ ] `lib/calculations/protocol_calculation.dart` - the protocol engine: enforcement of dose range, route, vascular access, infusion rate, preparation volume, and concentration bounds.
- [ ] `lib/calculations/ventilation/mean_airway_pressure.dart` - mean airway pressure from conventional ventilator settings.
- [ ] `lib/calculations/ventilation/oxygenation_index.dart` - oxygenation index, including the kPa to mmHg conversion.
- [ ] `lib/calculations/fluids/daily_fluid_volume.dart` - total daily fluid volume and hourly rate from a prescribed volume per kilogram.
- [ ] `lib/calculations/fluids/glucose_infusion_rate.dart` - glucose infusion rate in mg/kg/min.
- [ ] `lib/calculations/fluids/electrolyte_requirement.dart` - daily electrolyte requirement in mmol/day from a prescribed mmol/kg/day.
- [ ] `lib/calculations/fluids/additive_volume.dart` - compounding step: volume of a stock preparation needed to deliver a required amount.

## Files Exempt From Clinical Sign-Off

These contain only generic value types or technical infrastructure, with no formula, threshold, dose, or clinical statement. The exemption is asserted in the test named above, so removing or weakening it is a visible change.

- `lib/calculations/calculation_outcome.dart` - generic result and error types shared by the calculation modules.

## Not Yet Written

The following require sign-off when implemented, and must be added to this register at that time:

- Electrolyte and compounding calculations.
- Line-length calculations.
- Every clinical content and protocol record admitted to the registry, each of which carries its own source, reviewer, sign-off, and expiry fields.

## Excluded From Review

- `lib/legacy/` is migration evidence only. It is excluded from static analysis, cannot be imported by the application, and must never be signed off. It is retained so that inherited behaviour can be traced during rebuild.
