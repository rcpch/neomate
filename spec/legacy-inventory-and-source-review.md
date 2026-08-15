# Legacy Inventory And Source Review

## Status And Method

This is a read-only inventory of the three locally available Neomate implementations, completed on 14 August 2026. It is a planning and safety artefact, not clinical approval. A source being current means its publisher page was found and checked; it does not approve any legacy implementation, dose, threshold, or workflow. Each clinical item still requires an item-level review by the designated clinical content lead, a source version, local-policy assessment, and independently reviewed test vectors before release.

The repositories reviewed were:

| Repository | Technology | Role in this review |
| --- | --- | --- |
| `../neomateapp` | Ionic/Cordova, JavaScript | Original, broadest feature set including growth clinic and legacy telemetry. |
| `../neomate-2025` | Flutter/Dart | Most developed Flutter successor, with a small inherited unit-test suite. |
| `.` | Flutter/Dart | Controlled rebuild target, largely a copy of the 2025 clinical logic with new safety/QMS baseline. Root-level legacy development logs and code archive snapshots were deliberately deleted on 14 August 2026 because Git history is the authoritative change record. |

The inherited Dart files are retained under `lib/legacy/` as read-only migration evidence. They are excluded from shipped imports and static analysis. Native replacements must not import them.

## Product Baseline

Neomate 2 is proposed as an offline-capable clinical calculator and guidance-reference application for appropriately trained neonatal healthcare professionals. It must not diagnose, prescribe, replace clinical judgement, replace local policy, replace independent calculation checks, store an electronic patient record, or process patient data unless separately specified and approved.

The proposed platform scope is Android, iOS, macOS, Windows, Linux, and web. Offline operation means the app must provide all approved clinical content and calculation functions without a network connection. A network connection may only be used for non-clinical update, source, support, or optional feedback functions that are separately specified, privacy assessed, and unavailable by default in clinical use.

## Functional Inventory

| Capability | Ionic legacy | Flutter 2025 / Neomate 2 | Rebuild disposition |
| --- | --- | --- | --- |
| Weight entry and gestational estimate | Yes | Yes | Retain only after source review; define one inclusive boundary policy. |
| Intubation ETT size and lip-length aid | Yes | Yes | Retain as an aid, requiring a placement-confirmation warning and source review. |
| Drug bolus doses | Yes | Yes | Review every medicine against current BNFC and local formulary before inclusion. |
| UVC/UAC formulae and infusion guidance | Yes | Yes | Review against current BAPM central-venous-access guidance and local policy. |
| Preconfigured vasoactive, sedative, neurological and emergency infusions | Yes | Yes | Rebuild only as named, source-traceable protocols with enforced range controls. |
| Daily fluid, glucose, electrolyte and compounding calculator | Yes | Yes | Retain as a separate calculation family after a clinical specification and source-derived vectors. |
| Ventilator cycle/MAP aid | Yes | Yes | Retain if clinically approved; fix inaccurate presentation and add domain validation. |
| Oxygenation index | Yes | Yes | Retain only with approved source, unit-aware validation, and referral workflow. |
| Generic infusion calculator | Yes | Yes | Do not carry into a clinical release unless an explicit safety case and hard controls are approved. |
| Cooling/HIE eligibility and aEEG/CFM reference | Yes | Yes | Replace legacy content with current BAPM framework and designated local network policy. |
| Acute-care checklists | Yes | Yes | Retain only as independently reviewed, versioned content. |
| Extreme-preterm guidance | Yes | Yes | Replace 2008/2019 material with BAPM 2026 framework. |
| Neonatal infection reference | Legacy only / added 2025 | Flutter 2025 / Neomate 2 | Use NICE NG195, updated May 2026, if this feature is retained. |
| Corrected age, EDD, BMI, growth z-score/centile and charts | Yes | No | Product decision required: either reinstate as a separately governed feature or formally retire. Do not silently lose it. |
| Surveys, analytics and feedback transmission | Yes | No | Exclude from the clinical product baseline. Any future collection requires privacy, security, and explicit consent controls. |

## Required Feature Boundaries

### Clinical Content

- Every rendered clinical statement, dose, threshold, checklist item, image, and link must have a stable content ID, source ID, source edition/version, source URL, clinical reviewer, review date, expiry/review date, and local-policy status.
- Each source-code file containing clinical content or calculation logic must link to its sources and clinical sign-off in top-of-file comments. The repository-level content/protocol record remains the authoritative index and must include the corresponding source version and review dates.
- Content that is not current, has no current source, or is only an inherited implementation must not be included in a clinical build.
- External links must not be used as the only delivery mechanism for clinical content because the proposed product must work offline.

### Calculations

- Calculation logic must be pure, deterministic, unit-explicit, and separated from Flutter widgets and persistence.
- A calculation must validate every input in the same domain in which the formula operates. Invalid, non-finite, zero denominator, and out-of-range inputs must return a controlled non-result, never `NaN`, infinity, a stale result, or an apparent clinical answer.
- A result must include value, unit, source ID, calculation version, warnings, and applicability limits.
- Each calculation requires source-derived vector tests, boundary tests, invalid-input tests, and independent clinical review before clinical release.

### Medicines And Infusions

- Named medicine protocols require medicine, indication, route, units, concentration, diluent, preparation volume, rate, minimum and maximum dose, minimum and maximum concentration, route/line constraints, warnings, source ID, and local-formulary approval.
- Configured bounds are safety controls, not display text. The calculation engine must enforce them and prevent a result outside approved bounds.
- Generic free-text infusion calculation is excluded from the first clinical release unless the Clinical Safety Officer approves an explicit hazard-control design.

### Checklists And References

- A checklist is a versioned clinical content object, not unstructured HTML.
- A checklist must show its title, applicable setting, content version, reviewer, source, and review date.
- Checklists must not embed local phone numbers, referral thresholds, or service instructions without a network/deployment-specific content profile and its own review process.

### Growth

- Growth-chart functionality is out of scope for native Neomate 2 development. A future Rust implementation of RCPCH digital growth charts may be integrated through Flutter FFI after its own data, clinical, security, and interface review. Do not copy embedded LMS data from the Ionic app.
- Growth functionality must identify sex, measure type, chronological and corrected age rules, gestation, units, dataset version, and applicability limits. It needs conformance vectors from the approved data provider.

## Algorithm And Guidance Register

| ID | Legacy function/content | Current or latest located authority | Current status as at 14 Aug 2026 | Required action |
| --- | --- | --- | --- | --- |
| SRC-001 | Newborn resuscitation, IV adrenaline, glucose, volume, bicarbonate | [RCUK Newborn Resuscitation and Support of Transition, 2025](https://www.resus.org.uk/professional-library/2025-resuscitation-guidelines/newborn-resuscitation-and-support-transition-infants-birth), published 27 Oct 2025 | Current RCUK guideline located. It states 20 micrograms/kg IV/IO adrenaline = 0.2 mL/kg of 1:10,000, glucose 200 mg/kg = 2 mL/kg D10 only when blood glucose is low, and bicarbonate is no longer recommended in resuscitation. | Retire or redesign inherited bicarbonate-resuscitation output. Recheck emergency glucose and every resuscitation statement against the 2025 guideline and local policy. |
| SRC-002 | Therapeutic hypothermia/HIE eligibility, cooling, CFM | [BAPM Therapeutic Hypothermia for Neonatal Encephalopathy](https://www.bapm.org/resources/237-therapeutic-hypothermia-for-neonatal-encephalopathy), 2020 framework with 20 Mar 2025 update; renewal consultation active in 2026 | Current published BAPM PDF is labelled 2025 after an update concerning infants below 36 weeks. A further renewal is in progress. | Replace TOBY/legacy criteria presentation. Confirm the deployed network protocol and review cadence; do not call an in-app eligibility aid definitive. |
| SRC-003 | Extreme preterm delivery checklist/reference | [BAPM Perinatal Management of Extreme Preterm Birth Before 27 Weeks of Gestation](https://www.bapm.org/resources/perinatal-management-of-extreme-preterm-birth-before-27-weeks-of-gestation), 9 Feb 2026 | 2026 framework supersedes the 2019 framework and makes the legacy infographic unsuitable as a parent leaflet. | Replace all 2008/2019 text and images. Create a reviewed content item rather than embedding an old PDF/image. |
| SRC-004 | Neonatal infection risk factors/indicators and antibiotics | [NICE NG195 Neonatal infection: antibiotics for prevention and treatment](https://www.nice.org.uk/guidance/ng195), last updated 13 May 2026 | Current and explicitly replaces CG149. | Replace every CG149-derived item. Do not encode antimicrobial dose schedules without current local formulary approval. |
| SRC-005 | Growth charting and neonatal weight estimates | [RCPCH UK-WHO NICM growth charts](https://www.rcpch.ac.uk/resources/uk-who-growth-charts-neonatal-infant-close-monitoring-nicm) and [professional guidance](https://www.rcpch.ac.uk/resources/uk-who-growth-charts-guidance-health-professionals) | NICM is for 23 weeks' gestation to 2 years corrected age. RCPCH provides digital charts and measurement/plotting guidance. | Confirm data licensing and whether to use RCPCH Digital Growth Charts rather than local LMS data. Establish the clinical basis of the 23-42 week estimate table separately. |
| SRC-006 | Medicines: fentanyl, morphine, atropine, suxamethonium, poractant alfa, pancuronium, phenobarbital, phenytoin, midazolam, adenosine | [BNFC medicines](https://bnfc.nice.org.uk/drugs/) | BNFC is the located current national medicines source, but public search results are insufficient to validate individual neonatal indication, route, preparation, or local formulary choices. | Create one source record and clinical review per named protocol. Do not infer validity from a legacy link or package search result. |
| SRC-007 | Central lines, UVC/UAC length, line care | [BAPM Use of Central Venous Access Devices in Neonatal Units](https://www.bapm.org/resources/central-venous-access-devices-in-neonates), 7 Jul 2026 | Current BAPM framework located. Legacy formulae derive from older material and are placement aids only. | Review formulae and all line-care content; ensure in-app outputs require appropriate placement confirmation. |
| LEGACY-SRC-008 | Airway/intubation reference | [BAPM Neonatal Airway Safety Standard](https://www.bapm.org/resources/BAPM-Neonatal-Airway-Safety-Standard), 24 Apr 2024; legacy ETT source is Kempley et al. | Current safety standard located. The legacy ETT table still requires direct evidence and local-policy review. | Assign a stable source-register ID during implementation. Do not release ETT size/length outputs until source traceability and placement confirmation controls are approved. |
| LEGACY-SRC-009 | Transport/referral checklist | [London NTS referral guidance](https://london-nts.nhs.uk/making-a-referral/) | Current local service page found. It describes referral process, not a portable national referral threshold algorithm. | Assign a stable source-register ID during implementation. Remove static local referral numbers and threshold rules from the core app. Use deployment-specific, reviewed network profiles. |
| LEGACY-SRC-010 | OI and ECMO referral | [NHS England ECMO service specification](https://www.england.nhs.uk/publication/extra-corporeal-membrane-oxygenation-for-neonates-infants-and-children/), 16 Jul 2026; local PPHN guidance found but not adopted | A current service specification was found; no single national in-app OI threshold algorithm was verified in this review. | Keep the mathematical OI formula separate from clinical interpretation. Obtain designated ECMO/network policy and define action thresholds, population limits, and escalation wording. |
| LEGACY-SRC-011 | Daily fluids, GIR, electrolyte addition, D5/D10/D50 compounding | No single current national source identified in this review | Legacy calculations and warnings conflict or regress across versions. | Treat as a high-risk new specification. Obtain current local neonatal parenteral-fluid protocol and pharmacy approval before implementing. |
| LEGACY-SRC-012 | Ventilator settings, permissive hypercapnia, DOPE, NEC, respiratory distress | No single current national source identified in this review | Legacy checklists combine multiple unversioned local practices. | Decompose into distinct content items and source each to an approved national/network/local protocol. |
| LEGACY-SRC-013 | aEEG/CFM interpretation images and thresholds | Legacy TOBY material; a current local HIE guideline was located but is not a universal authority | Existing assets/content require rights and clinical review. | Do not redistribute or rebuild from legacy images until rights and current clinical review are confirmed. |

## Important Source Changes

- RCUK 2025 replaces 2021 newborn guidance. The legacy emergency bicarbonate advice cannot be carried over as resuscitation guidance because RCUK says bicarbonate is no longer recommended in resuscitation.
- BAPM published the 2026 extreme-preterm framework. The legacy 2008 reference and 2019 infographic are obsolete for this purpose.
- NICE NG195 was updated on 13 May 2026 and supersedes the legacy CG149 infection reference.
- BAPM therapeutic-hypothermia guidance has a 2025 update and is subject to renewal in 2026, so HIE content needs a formally managed review date.
- BAPM published a central-venous-access framework in July 2026, requiring re-review of inherited UVC/UAC material.

## Known Defects And Risks

These findings are observations of inherited code, not clinical determinations. They are linked to `clinical-safety/HAZARD-LOG.md` during remediation.

| ID | Severity | Finding | Evidence |
| --- | --- | --- | --- |
| BUG-001 | Critical | Configured infusion dose and concentration bounds are never enforced by the Flutter `DrugInfusion` calculation. | `lib/neomate.dart:629-680,703-836` |
| BUG-002 | Critical | The generic infusion calculator can calculate an arbitrary medicine/dose without approved dose, concentration, compatibility, route, or rate controls. | `lib/main.dart:1708-1777`; `lib/neomate.dart:829-833` |
| BUG-003 | High | Weight UI accepts 200 g and 6000 g while the model rejects both endpoints; the UI can claim a weight was set when it was invalidated. | `lib/main.dart:357-369,253-265`; `lib/neomate.dart:1408-1419` |
| BUG-004 | High | Potassium warning triggers above 4.5 mmol/kg/day but its own rationale states above 4.8 mmol/kg/day. | `lib/neomate.dart:1657-1661` |
| BUG-005 | High | Legacy and Flutter content contain contradictory infusion ranges and concentrations, including dobutamine, morphine, midazolam, and dinoprostone. | `../neomateapp/www/index.html:83-123`; `../neomateapp/www/js/neomate-full.js:5-140`; `lib/neomate.dart:1092-1313` |
| BUG-006 | High | Current Flutter code visibly renders “Heparin Bicarbonate: Need to confirm.” | `lib/neomate.dart:1054-1059` |
| BUG-007 | High | OI input validation is applied before unit conversion and therefore does not validate the calculated physical-domain values. | `lib/main.dart:1179-1211`; `lib/neomate.dart:1512-1536` |
| BUG-008 | High | Legacy Ionic OI implementation allows missing/zero values to produce `NaN`/infinite results and disagrees with its own OI escalation thresholds. | `../neomateapp/www/js/neomate-full.js:1337-1387`; `../neomateapp/www/index.html:225-281` |
| BUG-009 | High | Current fluid calculator has lost legacy central-line and potassium-concentration warnings without replacement evidence. | `lib/neomate.dart:1595-1626,1657-1661`; `../neomateapp/www/js/neomate-full.js:1624-1686` |
| BUG-010 | Medium | MAP presentation says it calculates respiratory rate while displaying the inverse relation, despite receiving rate as input. | `lib/neomate.dart:1465-1471` |
| BUG-011 | Medium | Estimate flag is mutated without `setState`, so the “estimated” indication is not reliably rendered. | `lib/main.dart:253-265` |
| BUG-012 | High | Ionic growth code uses assignment instead of comparison in centile formatting and overrides the intended chart type to preterm. | `../neomateapp/www/growth/js/growth-compile.js:222-235,744-770` |
| BUG-013 | High | Ionic app stores and transmits survey/feedback data and persistent identifiers via GET query strings to a third party. | `../neomateapp/www/js/neomate-full.js:443-475,1199-1219,1262-1301` |
| BUG-014 | Medium | Ionic app permits broad network and navigation access through Cordova configuration. | `../neomateapp/config.xml:10-11,29-32` |
| BUG-015 | High | Ionic repository includes Firebase configuration/API identifiers requiring restriction and provenance review. | `../neomateapp/google-services.json`; `../neomateapp/GoogleService-Info.plist` |

## Architecture Specification

The rebuilt application must use the following boundary:

```text
lib/
  app/                 Flutter application composition, theme, routing
  features/            Feature-specific presentation and interaction
  clinical-content/    Versioned, typed content records and rendering
  calculations/        Pure calculation engines, units, inputs, results
  protocols/           Named source-traceable medicine and clinical protocols
  shared/              Accessibility, error presentation, common UI
test/
  calculations/        Source-derived vectors and invalid-input cases
  protocols/           Registry and range-control tests
  content/             Content provenance and expiry-policy tests
  features/            Widget, navigation, accessibility tests
```

No Flutter widget may own clinical formulae, thresholds, or protocol data. No clinical content may be supplied as opaque unversioned HTML. The application must have no analytics, identifiers, network calls, or persistent patient data in its default clinical mode.

## Verification Specification

- A protocol registry test must reject any protocol lacking source, version, review date, expiry/review date, reviewer, and applicable population.
- A content registry test must reject any clinical content lacking the equivalent provenance fields.
- Each approved calculation requires literature or policy vectors, exact boundary tests, invalid/non-finite input tests, unit-conversion tests, and a review reference.
- Every protocol must test its enforced minimum/maximum dose, concentration, and line/route constraints.
- Widget tests must cover input validation, warning visibility, result provenance, no-result state, navigation, and accessibility semantics.
- Supported-device smoke tests must run for every released target platform. Web must be tested offline with approved clinical content already available.

## Decisions Required Before Implementation

- Select a content-management approach that remains offline by default and supports signed/versioned updates.
- Define deployment-specific content profiles and owners for local network referral processes.
- Obtain written rights/provenance for inherited code, clinical content, images, font, and growth data.
