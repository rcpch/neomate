# Document And Record Control

Document: QMS-002. Revision/status/approval: see the [controlled document index](README.md#controlled-document-index).

## Controlled Changes

1. Assign a stable document/record ID and owner. Identify purpose, scope, current status, revision, and linked product configuration. Maintain the index in qms/README.md; never reuse an ID.
2. Propose a change in Git with its reason, affected requirements, hazards, sources, procedures, releases, and regulatory impact. Identify whether it is editorial or affects clinical/safety/regulatory behaviour. Keep superseded decisions traceable.
3. Obtain review by the process owner and a competent reviewer. Safety-relevant changes require CSO/clinical review; regulatory decisions require competent regulatory review; independent review requirements in QMS-001 apply.
4. Record the approver's identity and authority, exact document revision and Git SHA or immutable attachment digest, decision, date, scope, conditions, and evidence location. Git authorship, a merged change, generated text, and an unchecked checklist are not approvals.
5. After approval, record effective date, affected staff training/read acknowledgements, and superseded revision. If approved content changes, obtain a new approval; a later index-only entry may point back to the exact approved content.
6. Include effective documents and their approval records in each release evidence manifest. Archive previous baselines as superseded; prevent their accidental use as current instructions.

States: **draft**, **in review**, **approved/effective**, **superseded**, **withdrawn**. Evidence records additionally distinguish **planned**, **executed**, **reviewed**, and **accepted**. `[PENDING]` means missing information or decision, not not-applicable. A not-applicable decision needs rationale, reviewer, date, and scope.

## Records And Access

Use Markdown in Git for procedures, plans, de-identified requirements, hazard links, decisions, and record indexes. For executed records use REC-001 templates with a unique ID, such as CHG-001, CAPA-001, or REL-001-2026-01; keep the procedure ID distinct from the record ID. Record allocation is sequential within each prefix, checked against the record index before creation.

Maintain an evidence index containing record ID, title, owner, state, configuration, revision/digest, date, repository path or approved external system ID, access route, retention end/trigger, and related records. Initial QMS gaps are recorded in QMS-003. No executed clinical approval records are asserted by this baseline.

Store identifiable complaints, personnel files, executed legal agreements, credentials, and confidential clinical material only in a manufacturer-approved access-controlled system. Keep a de-identified reference and retrieval owner in Git. `[PENDING: system, access groups, backup owner, and access test]` blocks reliance on that system for release. `.private/` or a developer workstation is not the official controlled record store. Do not put patient information in Git, including issue discussions and screenshots.

## Retention And Integrity

- Proposed project policy: retain the technical file, declarations, design/change records, release artefacts, approvals, and safety evidence for at least 10 years after the last device in the relevant configuration is supplied; extend for device lifetime/PMS obligations, incident/legal holds, or longer applicable requirements. The quality lead must confirm the legal trigger and retention schedule before supply.
- GB Class I guidance describes a minimum of 5 years after the last products are manufactured for technical documentation/declarations. Newer PMS requirements require at least 10 years for non-implantable device PMS records and longer where the PMS period exceeds this. Apply the longer applicable period; do not infer that the older five-year guidance disposes of PMS duties. See REG-001 sources S2 and S6.
- Retain immutable build artefacts, checksums, toolchain/dependency identifiers, executed results, and reviews alongside the source baseline. CI links alone are insufficient where logs or artefacts expire. Use a durable evidence-store export.
- Proposed backup control: back up the controlled repository and external evidence store at least weekly, restrict write access, and verify recovery at least annually and before first clinical supply. Record recovery checks including an old release, its approvals, and artefact hashes. Provider and implemented schedule are [PENDING].
- Amend an executed record by a dated addendum referencing the original; preserve the original observation and distinguish corrections from later analysis. Avoid rewriting historical approval evidence.

The quality lead reviews the document index, external-source currency, permissions, overdue reviews, and retention holds at least annually and before release. Procedures are also reviewed after incidents, audit findings, or material regulatory changes.
