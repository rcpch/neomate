# QMS Adoption And Registration Readiness

Document: QMS-003. Revision/status/approval: see the [controlled document index](README.md#controlled-document-index).

Initial gap assessment: 2026-10-29. **No QMS adoption, classification approval, conformity declaration or registration completion is recorded.** Roles below are proposed accountable owners using the existing role allocation; they do not imply that work has been accepted or completed. Quality lead coordinates dates and evidence at the first management review.

Legend: [x] complete, [~] in progress, [ ] not started. IDs are permanent. This register owns QMS sub-actions; spec/roadmap.md remains the product roadmap (D42/D43/D45/D46/D47).

## Action Register

- [ ] **QMS-A01 - Confirm legal manufacturer and authority**. Owner: product owner / accountable management. Evidence: legal name/address, acceptance of statutory responsibility, signatory and delegations, resource commitment. Due: before QMS adoption. Blocks declaration and registration; project copyright statements are insufficient.
- [~] **QMS-A02 - Resolve intended purpose, market and Class I eligibility**. Owner: product owner and appointed regulatory reviewer. Evidence: final feature/claims catalogue, neonatal limits, GB/NI decision, rule-by-rule qualification/classification assessment and signed conclusion under REG-001. Due: before scope freeze. Class I is requested; prior Class IIa assumption remains unresolved.
- [ ] **QMS-A03 - Approve QMS and appoint independent reviewers**. Owner: accountable management / quality lead. Evidence: reviewed procedures, document approvals, competence/training, deputies/conflicts, audit arrangement and first management review. Due: before relying on procedures as effective or clinical supply.
- [~] **QMS-A04 - Complete legal/standards and essential-requirements mapping**. Owner: quality lead and regulatory reviewer. Evidence: current legislation review, standards editions/designation/applicability, clause-by-clause essential requirements and conformity-route decision. Starting evidence: REG-001/TF-001. Due: before conformity review.
- [~] **QMS-A05 - Establish design-history and clinical traceability baseline**. Owner: engineering and clinical content leads. Evidence: approved requirements, architecture, source/protocol/profile inventory, change records, independent vectors and requirement/control-to-result trace. Starting evidence: DEV-001, spec/, lib/, test/. Due: before release candidate acceptance.
- [ ] **QMS-A06 - Approve and execute risk management**. Owner: CSO and accountable management. Evidence: risk acceptability policy, rated analyses, implemented/control-effectiveness evidence, release-time constraints decision, overall benefit-risk report. Due: before clinical release. Existing hazards remain unassessed.
- [ ] **QMS-A07 - Qualify suppliers, components and tools**. Owner: engineering / quality leads. Evidence: component/SOUP and supplier register, risk-based tool validation, source licensing/current access, monitoring and continuity. Due: before clinical baseline acceptance.
- [~] **QMS-A08 - Establish controlled storage and retention**. Owner: quality / security leads. Evidence: approved system, access and confidentiality rules, retention schedule, immutable artefact exports, successful restore exercise. Git documentation exists; external controlled store and restore unverified. Due: before clinical evidence acceptance.
- [ ] **QMS-A09 - Execute clinical evaluation and usability validation**. Owner: clinical content lead and independent reviewers. Evidence: approved protocols/criteria, reproducible searches/appraisals, source-derived independent results, representative critical-task validation and clinical evaluation report. Due: before clinical release.
- [ ] **QMS-A10 - Operationalise PMS, vigilance and CAPA**. Owner: quality lead / CSO. Evidence: contact route and cover, MORE readiness/training, lifetime/PMS period, data/threshold plan, reporting exercise and simulated offline field correction; assess any existing product obligations. Due: before clinical supply.
- [ ] **QMS-A11 - Complete platform release and product-information pack**. Owner: engineering / release approver. Evidence: claimed-platform offline/security/usability/install/update/recovery results; signing/provenance; final IFU/labelling/store claims and approved support/withdrawal arrangements. Due: before clinical release.
- [ ] **QMS-A12 - Assemble and independently review conformity/registration pack**. Owner: quality lead, authorised manufacturer and regulatory reviewer. Evidence: TF-001 complete, resolved findings, signed declaration, body involvement if applicable, approved marking, field-checked DORS data, submission authority, fee/maintenance plan and subsequent confirmation. Due: before market placement. No external action authorised by this baseline.

## Gate Record

| Gate | Minimum closure evidence | Current disposition |
| --- | --- | --- |
| G1 Adopt QMS | Manufacturer authority, independent reviewers, effective procedures, competence and evidence store | Pending |
| G2 Approve route and design inputs | Intended purpose/claims, market, regulatory and software safety classifications, requirements, risk policy | Pending |
| G3 Accept release evidence | Source/requirements/control trace, technical and clinical validation, clinical evaluation, risk acceptance and product information | Pending |
| G4 Declare conformity and register | Approved technical file/route, authorised declaration, marking and required registration confirmation | Pending |
| G5 Authorise clinical supply | REL-001 complete for exact artefacts, market and channels; PMS and withdrawal operational | Pending |

For every closure record reviewer, date, exact evidence/configuration and unresolved conditions using REC-001. Never mark a gate complete solely because its document template exists. Review this register at each QMS working session and before release; record assigned dates at the first adoption review.
