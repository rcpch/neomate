# Clinical Source Register

Stable IDs for the sources cited in file headers under the [clinical source convention](clinical-source-convention.md). A source appearing here has been **proposed**, not approved: approval is recorded per file in [../clinical-safety/signoff.md](../clinical-safety/signoff.md) by a named clinical reviewer.

Candidates below were selected for current UK practice, preferring national bodies (NICE, BAPM, RCUK, RCPCH, NHS England) over textbooks and over non-UK guidance.

## Status Meanings

- **Proposed** - identified as the likely governing source; URL and edition checked; not yet clinically approved for this use.
- **Candidate** - plausible governing source, but the specific edition or its applicability to our use has not been confirmed.
- **Inherited baseline** - carried forward from the shipped Neomate product, which has been in live clinical use internationally. Treated as a reasonably assured starting point rather than as unevidenced, but still requiring verification against a current source before sign-off.
- **Provenance only** - not an authoritative clinical source. Records where an inherited value came from, so it is never mistaken for evidence.

## Register

| ID | Source | Publisher | Edition / date | Status | Governs |
| --- | --- | --- | --- | --- | --- |
| SRC-001 | Identification and Management of Neonatal Hypoglycaemia in the Full Term Infant - Framework for Practice | BAPM | 2017, page reviewed 2023 | Proposed | Glucose infusion rate formula and the normal neonatal GIR range |
| SRC-002 | Neonatal parenteral nutrition (NG154) | NICE | Published February 2020 | Proposed | Daily fluid volumes and electrolyte requirements in mmol/kg/day |
| SRC-003 | Newborn Resuscitation and Support of Transition of Infants at Birth Guidelines | Resuscitation Council UK | 2025 | Proposed | Newborn resuscitation content. Note: bicarbonate is no longer recommended |
| SRC-004 | Neonatal infection: antibiotics for prevention and treatment (NG195) | NICE | Updated May 2026 | Proposed | Neonatal infection content |
| SRC-005 | Therapeutic hypothermia for neonatal encephalopathy - Framework for Practice | BAPM | 2025 update | Proposed | Cooling and HIE content |
| SRC-006 | Inherited Neomate implementation | Neomate team, repository held by RCPCH | Legacy, undated | Inherited baseline | Default values, algorithms, and logic carried forward from the shipped product |
| SRC-008 | BNF for Children | NICE / BMJ / RPS | Cited by the inherited product as the 2015 edition; current edition not yet checked | Candidate | Drug doses and concentration limits |
| SRC-009 | Injectable Medicines Guide (Medusa) | SPS / NHS | Cited by the inherited product as 2015; current edition not yet checked | Candidate | Infusion concentration limits and preparation advice |
| SRC-007 | Neonatal respiratory ECMO service specification | NHS England | Not confirmed | Candidate | Oxygenation index escalation thresholds, if such thresholds are ever presented |

## Notes On Specific Sources

**SRC-001** states the glucose infusion rate as `GIR (mg/kg/min) = (fluid rate mL/hour x % dextrose) / (weight kg x 6)`. This matches `lib/calculations/fluids/glucose_infusion_rate.dart` exactly, including the constant 6. The framework addresses term infants in the first 48-72 hours; applicability to preterm infants and to later postnatal age needs a reviewer's decision.

**SRC-002** gives starting and maintenance ranges in mmol/kg/day and mL/kg/day. These are the numbers the reviewed policy records should carry. NG154 covers parenteral nutrition specifically, so its ranges may not be the right bounds for all fluid prescribing; a reviewer must confirm the scope.

**SRC-006** is deliberately not an authoritative source. Values harvested from the inherited implementation, such as the 200-6000 g weight range, are attributed to it so that the absence of clinical evidence behind them stays visible until a reviewer either confirms the value against a real source or replaces it.

**Mean airway pressure and oxygenation index** have no single UK guideline defining them; they are standard physiological definitions. The inherited implementation used the algebraically identical MAP form `((Ti x PIP) + (Te x PEEP)) / (Ti + Te)` and converted PaO2 from kPa using a factor of 7.5. A reviewer should confirm an acceptable citation, such as a current neonatal ventilation reference text, and confirm the conversion factor to use.
