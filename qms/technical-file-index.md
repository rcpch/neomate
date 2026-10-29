# Technical Documentation Index

Document: TF-001. Revision/status/approval: see the [controlled document index](README.md#controlled-document-index).

## Release Evidence Structure

This is a preparation index, not a completed technical file. The quality lead must create a release-specific manifest referencing immutable document revisions, approved external record IDs, executed results and artefact digests. Existing files listed below are starting evidence only; their existence does not establish adequacy or conformity. Record missing, rejected and not-applicable dispositions explicitly.

| Section | Required content | Starting location / current gap |
| --- | --- | --- |
| TF-01 Device identity and responsibility | Legal manufacturer/address, signatory, product identifiers, variants, exact version/profile/platforms and lifetime | REG-001; manufacturer and final configuration pending |
| TF-02 Intended purpose and classification | Population/limits, users, environment, clinical claims, module boundaries, market, qualification/classification rule rationale and approved route | spec/intended-purpose.md; REG-001; final determination pending |
| TF-03 Legal and standards mapping | Essential-requirements clause-by-clause checklist, standards editions/amendments/designation/applicability, evidence and exceptions | Detailed mapping pending; structure below |
| TF-04 Design and manufacture | Requirements, architecture/interfaces, source revision, clinical-content/profile versions, component/SOUP inventory, build/signing/distribution controls | DEV-001; spec/; source and lockfiles; reviewed design-history baseline pending |
| TF-05 Risk management | Approved policy/criteria, analysis, control verification, residual and overall benefit-risk, risk report, safety case and transferred controls | RISK-001; clinical-safety/; assessment/acceptance pending |
| TF-06 Verification and validation | Source-derived independent vectors, requirements/control traceability, test protocols/results/deviations, platform, offline, security and usability evidence | test/; DEV-001; EVAL-001; release-specific evidence pending |
| TF-07 Clinical evaluation | Approved protocol, source/literature search and appraisal, claims evidence, evaluation report, follow-up rationale | EVAL-001; spec/source-register.md; executed evaluation pending |
| TF-08 Product information | Labels/about screen, manufacturer details, identity/version, marking, IFU, limits/warnings, platform requirements, support/reporting and safe update/end-of-life information | Approved copies and consistency review pending |
| TF-09 Post-market and field action | PMS plan/report baseline and schedule, contact/cover, vigilance/CAPA, distribution traceability and offline recall exercise | PMS-001; operational evidence pending |
| TF-10 Conformity and registration | Authorised declaration, any applicable body certificate, approved marking, submitted DORS data and registration confirmation/maintenance owner | Conditional on REG-001; none asserted |
| TF-11 Release and retention | Evidence manifest, exact binaries/checksums, approvals, known anomalies, installed verification, supply/channel records and retention/restore evidence | REL-001; REC-001; executed release pack pending |

## Essential-requirements Mapping

For the GB UKCA route use the applicable Annex I essential requirements as modified by Schedule 2A, verified against operative legislation. Do not substitute an EU MDR GSPR checklist without a separately justified route. The quality/regulatory reviewer must enumerate every clause/subclause and approve each applicability decision. This baseline has not yet enumerated them and cannot be used to claim full coverage.

Required row fields: exact clause/reference and controlled text/version; applicable/not applicable with device-specific rationale; design measure; standard/clause or alternative method; requirement/hazard links; objective evidence IDs and versions; gaps; reviewer and disposition/date.

Initial topic prompts include general safety/performance and benefit-risk; design risk reduction; software repeatability/reliability/performance; verification/validation; active-device and combination-use requirements where applicable; and information supplied with the device. Physical-material, sterility and similar provisions need reasoned applicability decisions rather than blanket deletion for software.

## Registration Data Preparation

Use the current MHRA DORS attributes (REG-001 S5) when preparing submission. Required preparation fields include manufacturer legal name/address and organisation type, authorised administrative contacts, representative mandate where applicable, legislation, approved class, GMDN term/code, trade name, model/version, catalogue/reference, UDI fields where applicable, applicable characteristics, declaration and any required certificates. All final values are [PENDING]; do not invent GMDN, UDI or registration numbers.

Record field-level consistency checks against the declaration, IFU/about screen, technical file, app-store listing and release manifest. Identify who will maintain registration, assess version/characteristic changes and pay the applicable annual fees. Current fees and DORS behaviour must be checked at submission; do not rely on an old one-off-fee assumption. Preparation does not authorise an external submission.
