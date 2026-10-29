# Quality Manual

Document: QMS-001. Revision/status/approval: see the [controlled document index](README.md#controlled-document-index).

## Scope And Quality Policy

The proposed QMS covers Neomate 2 requirements, design, clinical content, software implementation, verification, validation, release, supply, maintenance, incident response, and retirement. It includes all platform variants actually supplied and the build-time clinical-content/deployment profiles shipped with each. The product is an offline-capable neonatal reference and calculation application for trained healthcare professionals. The proposed purpose and exclusions remain in [spec/intended-purpose.md](../spec/intended-purpose.md).

The proposed quality policy is to supply only versions whose intended clinical use is supported by reviewed evidence, whose risks have been evaluated and controlled, and whose configuration, approvals, and maintenance arrangements can be reconstructed. Free-of-charge and open-source supply do not remove manufacturer responsibilities. This policy requires manufacturer adoption; adoption has not yet been recorded.

The initial planning route is Great Britain Class I UKCA, conditional on REG-001. Northern Ireland, EU, and other markets require separate decisions. No product feature is removed or re-described merely to achieve a preferred classification. No change to clinical approval status is made by adopting QMS documents.

## Organisation And Authority

| Role | Current position | Authority and required evidence |
| --- | --- | --- |
| Legal manufacturer / accountable management | [PENDING: legal entity and authorised representative of that entity] | Accept statutory duties, approve policy/resources, authorise declarations and market actions; copyright ownership does not establish this role |
| Product owner | Dr Marcus Baw, as recorded in SAFETY.md | Own scope, users, claims, resources, and product decisions |
| Quality lead | Dr Marcus Baw | Maintain controlled records, audit findings, CAPA, readiness, and management review |
| Clinical Safety Officer (CSO) | Dr Marcus Baw | Lead hazard assessment, clinical safety case, residual-risk decisions within delegated authority |
| Clinical content lead | Dr Marcus Baw | Own source review, clinical evaluation, content currency, and clinician validation |
| Engineering and security lead | Dr Marcus Baw | Own implementation, configuration, suppliers/tools, technical verification, cybersecurity and privacy assessment |
| Release approver | Dr Marcus Baw, subject to formal manufacturer delegation | Authorise only the exact configuration and market supported by the release evidence |
| Independent clinical, quality, and regulatory reviewers | [PENDING: people, competence, availability, conflicts, and appointment] | Review relevant evidence independently of its author; retain identity, scope, findings, and disposition |
| Incident deputy and reporting cover | [PENDING] | Maintain calendar-day vigilance coverage and access to reporting systems |

These named roles reflect existing repository statements, not new formal appointments. Management must record delegation, deputies, competence, and independent review before clinical supply. One person may hold several roles, but cannot provide the independent review of their own safety-critical work. Contributors listed in README.md are not automatically appointed reviewers or manufacturer representatives.

## Process Map

| Input / trigger | Process | Required output / hand-off |
| --- | --- | --- |
| Intended use, claims, market, legislation | REG-001 applicability and classification | Approved scope and route to design controls and technical file |
| Clinical sources, user needs, hazards | DEV-001, RISK-001, EVAL-001 | Reviewed requirements, controls, evaluation protocols, and traceability |
| Requirements and supplier components | DEV-001 and SUP-001 | Controlled implementation, build inputs, component/tool assessments |
| Release candidate and evidence | REL-001 and TF-001 | Approved version-specific technical file, declaration/registration evidence where required, controlled supply |
| Complaints, source changes, security alerts, audit findings | PMS-001 | Triage, vigilance, CAPA, risk/evaluation updates, controlled change |
| Process records and performance | Management review and internal audit | Actions, resource decisions, verified effectiveness, policy/procedure updates |

## Competence And Resources

Before assigning regulated work, retain the person's role, qualifications/relevant experience, training against effective procedures, assessed competence, assessor, date, and next review. Use REC-001. Identify gaps such as classification experience, neonatal pharmacy review, clinical evaluation, or incident reporting and allocate training or external expertise. Reading a document alone is not proof of competence. Review competence annually and when responsibilities or procedures change.

Approve time, independent reviewer capacity, access to current clinical sources and applicable standards, platform test equipment, signing-key custody, evidence storage, and incident cover. Standards editions, amendments, designation status, and applicability are pending review in REG-001; this manual makes no clause-level standards-conformance claim.

## Quality Objectives And Review

Proposed objectives, measured per release unless noted:

- Every released clinical requirement has reviewed provenance, hazard/control links, independent verification where relevant, and a validation disposition. Target: 100%; any gap blocks the claim or release scope.
- Every clinical release has an exact artefact manifest and authorised approvals. Target: 100%.
- All applicable serious-incident reports meet legal time limits. Target: 100%; monitor continuously and review each incident.
- No overdue safety-critical CAPA action is closed or waived without accountable risk review. Target: zero unreviewed overdue actions; review monthly.
- Every supplied platform has installation, offline operation, usability, update/recovery, and security evidence. Target: 100% of claimed platforms.

The quality lead records numerator, denominator, evidence, period, exceptions, and action. Missing data is reported as unknown, never as a successful target.

## Audit And Management Review

Before first clinical supply and at least annually thereafter, conduct an internal audit using a competent reviewer independent of the activity audited. Sample an actual clinical change from source to release, a supplier/tool assessment, an incident exercise, an evidence restore, and a CAPA effectiveness check. Record scope, criteria, sampled evidence, findings, owners, due dates, and follow-up. An author cannot self-certify independent audit completion.

Accountable management reviews the QMS before first clinical release, at least annually thereafter, and following a major incident or regulatory change. Inputs are audit results, objectives, feedback/complaints, PMS, vigilance, clinical-source changes, supplier performance, security, CAPA, previous actions, changes to regulations, and resources. Outputs are decisions on effectiveness, improvements, resource commitments, owners/dates, and any release restriction. Use REC-001; no review has yet been performed under this draft.
