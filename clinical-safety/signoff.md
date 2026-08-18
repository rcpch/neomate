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

- [ ] `lib/calculations/result_rounding.dart` - rounding and display of calculated numbers, including the refusal to display a non-zero amount that rounds to zero.
- [ ] `lib/calculations/patient_context.dart` - patient weight validation, and the single gram-to-kilogram conversion every other calculation depends on.
- [ ] `lib/calculations/protocol_calculation.dart` - the protocol engine: finite positive inputs, valid infusion denominators, and non-blocking dose, concentration, route, and vascular-access review advisories.
- [ ] `lib/calculations/ventilation/mean_airway_pressure.dart` - mean airway pressure from conventional ventilator settings.
- [ ] `lib/calculations/ventilation/oxygenation_index.dart` - oxygenation index, including the kPa to mmHg conversion.
- [ ] `lib/calculations/fluids/daily_fluid_volume.dart` - total daily fluid volume and hourly rate from a prescribed volume per kilogram.
- [ ] `lib/calculations/fluids/glucose_infusion_rate.dart` - glucose infusion rate in mg/kg/min.
- [ ] `lib/calculations/fluids/electrolyte_requirement.dart` - daily electrolyte requirement in mmol/day from a prescribed mmol/kg/day.
- [ ] `lib/calculations/fluids/additive_volume.dart` - compounding step: volume of a stock preparation needed to deliver a required amount.
- [ ] `lib/calculations/airway/endotracheal_tube_size.dart` - inherited ETT internal-diameter bands by weight.
- [ ] `lib/calculations/airway/endotracheal_tube_lip_length.dart` - inherited ETT oral lip-length bands. **Carries an unresolved discrepancy below 500 g between the HTML and Dart predecessors.**
- [ ] `lib/calculations/lines/umbilical_venous_catheter.dart` - inherited UVC insertion-length formula and catheter-size threshold.
- [ ] `lib/calculations/lines/umbilical_arterial_catheter.dart` - inherited UAC insertion-length formula and catheter-size threshold.

## Drug Protocols

Carried forward from the shipped Neomate product (SRC-006), which has been in live clinical use internationally, with concentration advice the inherited code attributes to BNFc 2015 (SRC-008) and Medusa 2015 (SRC-009). The reviewer's task is to confirm each figure against the current edition, not to derive it afresh. All are restricted to central or umbilical venous access.

- [ ] `lib/clinical_protocols/boluses/bolus_catalogue.dart` - named weight-based intubation, circulation, sedation, neurological and emergency bolus values; retired resuscitation bicarbonate and empirical D10 are excluded.

- [ ] `lib/clinical_protocols/infusions/dopamine_infusion.dart` - 5-20 micrograms/kg/min; maximum 1.6 mg/mL.
- [ ] `lib/clinical_protocols/infusions/dobutamine_infusion.dart` - 2-20 micrograms/kg/min; maximum 10 mg/mL.
- [ ] `lib/clinical_protocols/infusions/adrenaline_infusion.dart` - 50-500 nanograms/kg/min; maximum 0.24 mg/mL.
- [ ] `lib/clinical_protocols/infusions/noradrenaline_infusion.dart` - 50-500 nanograms/kg/min; maximum 40 micrograms/mL.
- [ ] `lib/clinical_protocols/infusions/dinoprostone_infusion.dart` - configured 1-20 nanograms/kg/min against a 5-10 usual range; maximum 1 microgram/mL. **Carries an unresolved discrepancy between the configured and displayed dose ranges, for the reviewer to settle.**
- [ ] `lib/clinical_protocols/infusions/morphine_infusion.dart` - configured 5-60 micrograms/kg/hour against a 5-20 displayed range and narrative ceiling of 40; zero remains invalid, and the concentration field is equivalent to 30 mg/mL. **Carries unresolved dose-range and concentration-limit discrepancies.**
- [ ] `lib/clinical_protocols/infusions/vecuronium_infusion.dart` - 50-200 micrograms/kg/hour; human-readable 2 mg/mL ceiling enforced. **Carries an unresolved disagreement between inherited numeric and human-readable concentration fields.**
- [ ] `lib/clinical_protocols/infusions/clonazepam_infusion.dart` - 10-40 micrograms/kg/hour; maximum 12 micrograms/mL. **The inherited default preparation exceeds its own ceiling at common neonatal weights, and the Ionic display was commented out.**
- [ ] `lib/clinical_protocols/infusions/midazolam_infusion.dart` - 30-300 micrograms/kg/hour; maximum 1 mg/mL. **Carries unresolved 10-60, 30-60, and 30-300 dose-range discrepancies.**

## Clinical Policy Values

These files hold the numeric limits and presentation decisions that the calculation modules are validated against. They are separated from the formulas so that a value can be changed and re-reviewed without touching arithmetic that has already been signed off.

- [ ] `lib/clinical_policy/neonatal_weight_policy.dart` - the permitted weight range, currently 200-6000 g harvested from the inherited implementation and attributed to SRC-006 as an inherited baseline.
- [ ] `lib/clinical_policy/display_precision.dart` - decimal places used when displaying fluid volumes and rates, currently 1 d.p. on the grounds that no syringe dispenses more accurately than 0.1 mL.
- [ ] `lib/clinical_policy/retired_bolus_policy.dart` - retirement of inherited resuscitation bicarbonate and empirical 2.5 mL/kg D10 outputs against RCUK 2025, with supporting neonatal evidence.

## Clinical Content

- [ ] `lib/clinical_content/checklists/checklist_catalogue.dart` - nine structured neonatal checklists exposed for clinical review; all statements, thresholds and actions require current-source review.

## Files Exempt From Clinical Sign-Off

These contain only generic value types or technical infrastructure, with no formula, threshold, dose, or clinical statement. The exemption is asserted in the test named above, so removing or weakening it is a visible change.

- `lib/calculations/calculation_outcome.dart` - generic result and error types shared by the calculation modules.
- `lib/clinical_content/checklists/checklist.dart` - generic immutable checklist value types containing no clinical statements.

## Not Yet Written

The following require sign-off when implemented, and must be added to this register at that time:

- Drug bolus protocols.
- Every clinical content and protocol record admitted to the registry, each of which carries its own source, reviewer, sign-off, and expiry fields.

## Excluded From Review

- `lib/legacy/` is migration evidence only. It is excluded from static analysis, cannot be imported by the application, and must never be signed off. It is retained so that inherited behaviour can be traced during rebuild.
