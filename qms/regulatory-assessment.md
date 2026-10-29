# Medical-device Applicability And Regulatory Assessment

Document: REG-001. Revision/status/approval: see the [controlled document index](README.md#controlled-document-index).

## Assessment Record

| Field | Current assessment |
| --- | --- |
| Prepared | 2026-10-29; repository/source review, draft for human determination |
| Responsible decision-maker | Product owner Dr Marcus Baw; legal manufacturer and competent regulatory reviewer confirmation [PENDING] |
| Decision / approval date | [PENDING]; no classification determination made |
| Next review | Before QMS adoption and before scope freeze, declaration, registration, or clinical supply; proposed calendar backstop 2027-01-29 |
| Product / population / users | Neomate 2; neonatal patients; trained neonatal healthcare professionals in NICU settings |
| Intended functionality | Clinical references/checklists, weight-based drug and infusion preparation, fluids/electrolytes, airway/line aids, ventilation/oxygenation calculations; final release feature list [PENDING] |
| Boundary | Standalone Flutter software; manual input, no intended hardware control, patient persistence, telemetry, or runtime network dependency; verify the exact release |
| Markets | Existing UK-first intention; proposed initial assessment is Great Britain (England, Scotland, Wales). Northern Ireland inclusion requires an explicit separate route decision |
| Requested route | Assess Class I UKCA under the UK MDR 2002 as amended, Part II; eligibility not established |
| Previous assumption | spec/intended-purpose.md and Q8 previously said “likely Class IIa”; retained as decision history, not an approved classification |
| Current conclusion | Medical-device obligations potentially apply to the proposed clinical calculation/decision-support functions. Classification and route remain unresolved; proceed with QMS and technical-file preparation |

The exclusions “not a prescribing system” and “not a diagnostic system” do not by themselves settle classification. Assess actual intended use, outputs, clinical claims, presentation, foreseeable use, and how clinicians act on the results. Numeric output alone also does not determine whether a regulatory measuring function exists. Free supply and public source availability are not exemptions from product obligations.

## Classification Work Required

The regulatory reviewer must record an assessment for the final product, its modules and their relationships, using the current applicable legislation and software guidance. Record exact rule references, relevant definitions, applicability rationale, evidence and conclusion, including why competing higher-risk rules do or do not apply. Do not select a residual Class I rule until applicable specific rules have been evaluated.

| Function group | Questions to resolve with the clinical and regulatory reviewers | Evidence required |
| --- | --- | --- |
| References and checklists | Mere reference retrieval or patient-specific decision/treatment support? Do workflow and claims change qualification? | Item catalogue, claims, screens, clinician task analysis |
| Medicines, infusions, fluids and compounding | How do patient-specific outputs influence treatment? Any device-driving/influencing relationship? What happens if a result is wrong? | Protocol inventory, intended actions, risk analysis, software-guidance clinical-calculator assessment |
| Airway and line-length aids | How do recommendations influence selection/placement or use of another device? | Workflow, device relationship, claims and limitations |
| Ventilation / oxygenation | Do calculations provide diagnostic/monitoring information or influence treatment/device use? | Inputs/outputs, monitoring context, task and claims evidence |
| Whole application and variants | Which rules apply to the combined product? Is modular separation genuine? Any measuring function, accessory, IVD, or other special status? | Architecture/boundaries, variant inventory, documented inclusion/exclusion of relevant rules |

No hardware integration is currently intended, but confirm the “drives or influences a device” assessment against actual clinical use rather than only connection method. Record GB classification separately from any future EU MDR classification, including Rule 11 where applicable; a GB conclusion must not be exported to Northern Ireland or the EU. IEC 62304 software safety class A/B/C is a separate determination and must not be inferred from device Class I/IIa/IIb/III.

## Conditional Great Britain Class I Route

If the manufacturer approves a substantiated Class I determination:

1. Identify the legal manufacturer, address, authorised signatory, product/version/configuration, intended purpose, claims, markets, distribution channels, and applicable legislation. Check the operative framework again at the proposed supply date.
2. Complete the technical documentation, including clause-level essential-requirements applicability/evidence, clinical evaluation, risk analysis, design verification/validation, labelling/IFU, and post-market arrangements. See TF-001.
3. Determine and document whether sterile or measuring-function provisions apply. A non-sterile, non-measuring Class I device can ordinarily use manufacturer self-declaration for UKCA. Where sterility or a measuring function applies, involve an appropriate UK Approved Body for those aspects. Record the procedure selected and rationale.
4. Have the authorised manufacturer sign a configuration-specific declaration of conformity only after the applicable evidence is complete. Confirm the Annex VII route as modified by Schedule 2A or other applicable procedure. Approve the mark placement and labelling; do not apply a mark from this draft.
5. Prepare DORS information and register before placing on the GB market. Retain MHRA confirmation, submitted data, declaration, relevant certificates, and fee/maintenance arrangements. Registration is not MHRA approval, accreditation, or endorsement.
6. Authorise distribution only after REL-001 passes, with defined support, device lifetime, PMS period, safety communication, updates, and withdrawal arrangements. Keep registration current and assess changes for update/re-registration.

No claim is made that an ISO 13485 certificate is universally mandatory for ordinary GB Class I self-declaration. This QMS is a proposed operational control framework; whether certification or a particular conformity-assessment quality-system route is needed depends on the approved device and route. Standards are voluntary tools for demonstrating relevant requirements, not substitutes for those requirements.

## Standards And Other Assurance Domains

| Instrument / framework | Proposed use | Remaining decision |
| --- | --- | --- |
| UK MDR 2002 as amended, including Part II and Part 4A | GB legal route, essential requirements, conformity, registration, PMS/vigilance | Review operative text, applicable provisions and changes at decision date |
| ISO 13485 | Structure QMS process controls | Confirm edition/amendments, applicability, purchased access, clause gap analysis, certification strategy |
| ISO 14971 | Medical-device risk management | Confirm edition, adoption and acceptability policy; map to RISK-001 |
| IEC 62304 | Software lifecycle and software safety classification | Confirm edition/amendments, class rationale and activities; map to DEV-001 |
| IEC 62366-1 | Usability engineering for clinical tasks | Confirm edition/amendments and evaluation approach; map to EVAL-001 |
| Software cybersecurity / product information standards | Select applicable controls and labelling/IFU requirements | Assess relevant standards, editions, scope and designation; do not assume compliance from names alone |
| DCB0129 / DCB0160 | Preserve manufacturer clinical-safety work and deployer hand-off | Document applicability to standalone SaMD and each deployment; retain existing safety gates pending review |
| Data protection, NHS procurement / information standards | Privacy/security assessment and deployment obligations | Assess actual data processing, support records, DTAC/other requirements where applicable |

No full standards texts or clause-by-clause standards conformity assessment were reviewed for this baseline. The standards register must later include edition, amendment, designation where relevant, clauses used, exceptions, owner, review date, and controlled copy location.

## Sources And Review Limits

Official HTML sources below were accessed on **2026-10-29**. Summaries support planning; they do not represent legal review of the consolidated legislation or review of linked PDF annexes. Before deciding classification, retain the exact applicable legislation/guidance version, relevant extracts and assessment in the controlled evidence store. Page currency differs: use the newer registration and PMS guidance for those topics rather than older overview text.

| ID | Source and page update | Relevance |
| --- | --- | --- |
| S1 | [MHRA: Regulating medical devices in the UK](https://www.gov.uk/guidance/regulating-medical-devices-in-the-uk), 2026-02-20 | GB/NI distinction; UKCA, CE and self-declaration framework |
| S2 | [MHRA: Guidance on Class I medical devices](https://www.gov.uk/government/collections/guidance-on-class-1-medical-devices), 2023-07-01 | Essential requirements, technical documentation, clinical evaluation, sterile/measuring aspects |
| S3 | [MHRA: Medical devices - software applications](https://www.gov.uk/government/publications/medical-devices-software-applications-apps), 2023-07-01 | Software qualification; linked standalone-software and clinical-calculator guidance require detailed review |
| S4 | [MHRA: Conformity assessment and the UKCA mark](https://www.gov.uk/guidance/medical-devices-conformity-assessment-and-the-ukca-mark), 2026-05-13 | Routes and designated standards; declaration before marking |
| S5 | [MHRA: Register medical devices to place on the market](https://www.gov.uk/guidance/register-medical-devices-to-place-on-the-market), 2026-10-16 | Current DORS fields, registration maintenance, annual fee structure from April 2026, and NI changes; verify fees at submission |
| S6 | [MHRA: Requirements of the manufacturer's PMS system](https://www.gov.uk/government/publications/medical-devices-post-market-surveillance-requirements/requirements-of-the-manufacturers-pms-system), 2025-09-05 | PMS plan/report, periods, retention, review and provision on request |
| S7 | [MHRA: Vigilance reporting requirements](https://www.gov.uk/government/publications/medical-devices-post-market-surveillance-requirements/vigilance-reporting-requirements), 2025-09-05 | Serious incidents, trends, FSCA, reporting clocks and MORE |

Legislative review targets: [UK MDR 2002, SI 2002/618, consolidated contents](https://www.legislation.gov.uk/uksi/2002/618/contents) and [PMS amendment, SI 2024/1368](https://www.legislation.gov.uk/uksi/2024/1368/contents/made). These are review targets, not claimed completed legal-text analysis.

## Decisions, Actions And Reassessment

Open actions are QMS-A01 to QMS-A04 and QMS-A12 in QMS-003. The product owner must confirm manufacturer identity, market boundary, classification reviewer and final intended purpose. Preserve professional advice with author, date, scope, assumptions and disposition. Approval fields remain [PENDING].

Reassess on any change to intended purpose, claims, population, functions, inputs/outputs, supported platforms, local profiles, device interaction, patient data, distribution/market, relevant law/guidance, or incident evidence. Review before releasing an affected change. If Class I is not substantiated, revise the route and evidence plan before declaration or registration; the QMS work remains reusable.
