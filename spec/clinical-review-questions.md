# Clinical Review Questions

## Purpose

This is the working question set for neonatal clinicians reviewing Neomate 2. Answers should identify the exact source, edition, page or section, applicable population, local-policy dependency, reviewer, review date, and proposed review-due date. An answer records a clinical decision but does not approve code until the corresponding source file, tests, and sign-off register entry have been reviewed.

Clinicians can answer one section at a time. Questions marked **Implementation blocker** prevent the related feature from moving beyond inherited internal-alpha status.

## Answer Template

For each answer, please record:

| Field | Required information |
| --- | --- |
| Question ID | For example `CRQ-01` |
| Decision | The approved value, wording, scope, retirement, or exclusion |
| Governing source | Full title, publisher, edition/date, URL, and page/section |
| Local policy | Named network/unit policy and version, or confirmation that none is required |
| Applicability | Gestation, weight, postnatal age, indication, route, access, and exclusions |
| Reviewer | Named clinician and role |
| Review date | ISO 8601 date |
| Review due | ISO 8601 date |
| Notes | Uncertainty, dissent, implementation constraints, or further evidence needed |

## Priority Decisions

| ID | Question | Why it matters |
| --- | --- | --- |
| CRQ-01 | **Implementation blocker:** Which current neonatal formulary governs medicine doses, routes, diluents, concentrations, infusion rates, and vascular-access restrictions: a named local/network formulary, current BNFC, Medusa, or a defined combination? Please provide access or exact citations. | No remaining bolus protocol can be activated safely without a governing formulary. |
| CRQ-02 | What neonatal population should the first release cover: gestational-age range, birthweight/current-weight range, postnatal-age range, and clinical settings? | Every calculation and warning needs explicit applicability limits. |
| CRQ-03 | Is `200-6000 g` an acceptable inclusive working weight range? If not, what range and source should replace it, and should any feature have narrower limits? | Weight validation controls every weight-derived output. |
| CRQ-04 | When no measured weight is available, may an estimated weight be used for all current features, only specified emergency features, or none? What warning and confirmation are required? | The alpha currently propagates an estimated-weight uncertainty warning but does not restrict features. |
| CRQ-05 | Which clinical roles may use the product, and which outputs require an independent calculation or second-person check? | This determines intended users, interface warnings, training, and usability testing. |
| CRQ-06 | Which local/network policies may be bundled, and which content must remain deployment-specific rather than part of the core app? | Referral details, medicine preparation, and escalation rules cannot be assumed to be nationally portable. |
| CRQ-07 | Who will act as named reviewer for each clinical family, and who provides independent review where the content author is also a product owner or Clinical Safety Officer? | Clinical release requires named and sufficiently independent review. |

## Airway And Umbilical Lines

| ID | Question | Current inherited position |
| --- | --- | --- |
| CRQ-10 | Are the ETT internal-diameter bands `<1 kg: 2.5 mm`, `1-<2 kg: 3.0 mm`, `2-<3 kg: 3.5 mm`, and `>=3 kg: 3.5-4.0 mm` correct? | `CALC-ENDOTRACHEAL-TUBE-SIZE`; pending current-source review. |
| CRQ-11 | What should the oral ETT lip-length output be below 500 g: `below 5.5 cm`, `5.5 cm`, another value, or no output? | HTML and Dart predecessors disagree. |
| CRQ-12 | Should the ETT lip-length aid return no inherited value above 4.2 kg, or should a reviewed formula/table replace that limit? | The active alpha deliberately shows `No inherited value`. |
| CRQ-13 | Are weight alone and oral placement sufficient inputs for an initial ETT depth aid, or must gestation, nasal/oral route, sex, or another factor be represented? | Current output is explicitly only an initial oral-position aid. |
| CRQ-14 | Are the UVC formula `(1.5 x weight kg) + 5.5 cm + stump` and size threshold `<1.5 kg: 3.5 F; otherwise 5 F` acceptable? | Inherited baseline, pending BAPM/local review. |
| CRQ-15 | Are the UAC formula `(3 x weight kg) + 9 cm + stump` and size threshold `<1.2 kg: 3.5 F; otherwise 5 F` acceptable? | Inherited baseline, pending BAPM/local review. |
| CRQ-16 | What exact confirmation wording and approved tip-position methods must accompany UVC, UAC, and ETT outputs? | Current wording requires confirmation without prescribing a method. |

## Named Infusions

For every retained infusion, please confirm the indication, minimum and maximum dose, usual starting dose, dose unit/time basis, syringe volume, pump-rate assumptions, diluent, minimum and maximum concentration, route, vascular access, compatibility warnings, and whether the protocol should appear at all before local formulary selection.

| ID | Protocol | Specific unresolved question |
| --- | --- | --- |
| CRQ-20 | Dopamine | Confirm `5-20 micrograms/kg/min` and `1.6 mg/mL`; is peripheral administration ever permitted with an explicit policy? |
| CRQ-21 | Dobutamine | Confirm `2-20 micrograms/kg/min` and `10 mg/mL`; is central/UVC-only access appropriate? |
| CRQ-22 | Adrenaline infusion | Confirm `50-500 nanograms/kg/min` and `0.24 mg/mL`, distinct from resuscitation bolus adrenaline. |
| CRQ-23 | Noradrenaline | Confirm `50-500 nanograms/kg/min` and `40 micrograms/mL`; define any fluid-restriction exception. |
| CRQ-24 | Dinoprostone | Resolve whether the approved range is `1-20` or `5-10 nanograms/kg/min`, and confirm the `1 microgram/mL` ceiling. |
| CRQ-25 | Morphine | Resolve numeric `0-60`, displayed `5-20`, and narrative `up to 40 micrograms/kg/hour` ranges. Is the inherited `30 mg/mL` concentration field erroneous, and what should replace it? |
| CRQ-26 | Vecuronium | Resolve numeric `80 micrograms/mL-4 mg/mL` versus stated `40 micrograms/mL-2 mg/mL` concentration limits. Confirm the required analgesia/sedation warning and monitoring prerequisites. |
| CRQ-27 | Clonazepam | Should this infusion be retired? Its Ionic display was commented out and the inherited default exceeds its own `12 micrograms/mL` ceiling at common neonatal weights. |
| CRQ-28 | Midazolam | Resolve inherited dose ranges `10-60`, `30-60`, and `30-300 micrograms/kg/hour`; confirm the `1 mg/mL` ceiling and indication-specific limits. |
| CRQ-29 | All infusions | Should the alpha continue to restrict every preparation to central or umbilical venous access, or should access be decided per medicine and concentration? |
| CRQ-30 | All infusions | Should users enter arbitrary syringe volume and pump rate within hard limits, choose only approved standard preparations, or see fixed local-formulary preparations? |

## Bolus Medicines And Resuscitation

| ID | Question | Current position |
| --- | --- | --- |
| CRQ-40 | **Implementation blocker:** Which inherited boluses should be retained, replaced, or retired: fentanyl, morphine, atropine, suxamethonium, poractant alfa, pancuronium, vecuronium, phenobarbital, phenytoin, midazolam, adrenaline, volume, and adenosine? | None is active; each requires item-level source and formulary review. |
| CRQ-41 | What complete premedication regimen(s) should be represented for elective/semi-elective neonatal intubation, including ordering, timing, contraindications, and rescue planning? | Individual inherited doses must not imply a complete safe regimen. |
| CRQ-42 | Confirm that sodium bicarbonate should remain excluded from newborn resuscitation while allowing separately reviewed post-resuscitation use under local protocol. | Retired against RCUK 2025; rationale and evidence are in the in-app clinical change log. |
| CRQ-43 | Confirm retirement of empirical `2.5 mL/kg` D10. Should a replacement appear only after a low blood-glucose result, using RCUK 2025 `200 mg/kg (2 mL/kg D10)`, and what threshold/local policy applies? | Retired; no replacement calculator is active. |
| CRQ-44 | Should volume replacement show `10 mL/kg` only when blood loss is suspected or the infant is unresponsive to other resuscitative measures, and should blood be distinguished from isotonic crystalloid? | RCUK 2025 conditions the intervention; the inherited app displayed a generic saline bolus. |
| CRQ-45 | Should resuscitation adrenaline support UVC/IO and intratracheal routes as separate protocols, with the RCUK 2025 doses and four-minute interval? | Route-specific doses differ substantially and must not be combined. |

## Fluids, Electrolytes, And Physiology

| ID | Question | Current inherited position |
| --- | --- | --- |
| CRQ-50 | What local neonatal fluid/pharmacy policy should govern daily fluid, GIR, electrolyte, and stock-volume workflows? | Arithmetic is active as an unapproved demonstration; clinical prescribing ranges are not. |
| CRQ-51 | Are the engineering guards `1-300 mL/kg/day` and `0.1-100 mmol/kg/day` acceptable typo barriers, or should different non-prescribing bounds be used? | These guards are deliberately broad and are not treatment recommendations. |
| CRQ-52 | For which glucose concentrations, routes, and populations is the GIR formula applicable, and what warnings or interpretation should be shown? | Current alpha calculates a number without a treatment target. |
| CRQ-53 | Which stock preparations, concentration units, maximum additive concentrations, central-line restrictions, and compatibility warnings may be represented? | Current compounding arithmetic deliberately omits local stock defaults and compatibility advice. |
| CRQ-54 | Confirm the mean-airway-pressure formula, plausible input bounds, and whether the warning about flow-sensor measurement is sufficient. | Formula is isolated but has no approved neonatal source. |
| CRQ-55 | Confirm oxygenation-index PaO2 units, the kPa-to-mmHg conversion factor, plausible bounds, applicable population, and whether any escalation threshold should be shown. | Current alpha calculates OI but deliberately gives no referral interpretation. |
| CRQ-56 | Is one decimal place appropriate for displayed fluid volumes and rates across the full weight range, and which outputs require different precision? | Current default is one decimal place. |

## Guidance, Checklists, And Usability

| ID | Question | Why it matters |
| --- | --- | --- |
| CRQ-60 | Which guidance/checklist family should be reviewed first: newborn resuscitation, HIE/cooling, extreme preterm birth, neonatal infection, respiratory deterioration, NEC, or transport/referral? | No checklist is active until independently sourced and reviewed. |
| CRQ-61 | Which checklist statements are universal, and which require a deployment-specific network profile? | Local phone numbers, referral pathways, and treatment rules must not leak into the core product. |
| CRQ-62 | Which inherited images or diagrams remain clinically useful, and who can confirm clinical accuracy and redistribution rights? | Legacy CFM/extreme-preterm assets are not approved for reuse. |
| CRQ-63 | Are the internal-alpha warnings, estimated-weight warning, placement-confirmation warnings, paralysis warning, and controlled-refusal messages clinically clear and appropriately prominent? | Warning wording and hierarchy are use-error controls. |
| CRQ-64 | Which high-risk tasks should representative clinicians perform in usability testing, and what errors or delays constitute unacceptable performance? | Usability evidence must target realistic safety-critical workflows. |
| CRQ-65 | What information must be visible beside every result: source/version, review status, formula, units, applicability, warning, independent-check requirement, or local-policy name? | The interface must balance traceability with rapid clinical scanning. |

## Review And Release

| ID | Question | Why it matters |
| --- | --- | --- |
| CRQ-70 | What review interval should apply to calculations, medicines, national guidance, and local policies? | Every approved item requires a review-due date. |
| CRQ-71 | What events trigger immediate review: guideline update, formulary change, incident, near miss, user report, dependency change, or platform update? | Change control must remain responsive between scheduled reviews. |
| CRQ-72 | Who may approve a clinical item, who independently verifies calculations, and who accepts residual risk for release? | Contributor status alone does not confer a governance role. |
| CRQ-73 | Which platforms and device classes should be included in the first evaluated release? | Each claimed platform needs installation, offline, usability, update, and recovery evidence. |
| CRQ-74 | What clinical claims and user-facing labelling are acceptable for the first evaluated build? | Claims determine evidence, regulatory scope, and release controls. |
