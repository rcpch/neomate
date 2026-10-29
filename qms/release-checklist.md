# Release Checklist

Document: REL-001. Revision/status/approval: see the [controlled document index](README.md#controlled-document-index).

Do not mark a version for clinical deployment unless every applicable item has approved evidence.

Create a version-specific release record using [REC-001](record-templates.md). For each item reference immutable evidence, reviewer and decision date. Not-applicable dispositions require approved rationale. The blank checklist is not a release authorisation; internal development builds remain subject to SAFETY.md.

- [ ] Intended purpose, users, deployment environment, and excluded uses are approved.
- [ ] Regulatory and SaMD classification assessment is approved.
- [ ] Legal manufacturer, authorised signatory, exact market and conformity route are confirmed under REG-001; regulatory device class and software safety class are separately justified.
- [ ] Effective QMS procedures, competence, independent reviewers, audit/management review and controlled evidence storage are established.
- [ ] Clinical Safety Officer, product owner, clinical content lead, engineering lead, and quality lead are assigned.
- [ ] Clinical safety case and hazard log are current and residual risks are accepted.
- [ ] All clinical content, calculation methods, thresholds, and warnings are traced to current reviewed sources.
- [ ] Independent source-derived calculation vectors and boundary tests pass.
- [ ] Full automated test suite, static analysis, formatting, accessibility, and supported-device checks pass.
- [ ] Cybersecurity, privacy, dependency, signing, update, offline, and rollback controls are approved.
- [ ] Release version, source revision, build provenance, supported platforms, and known limitations are recorded.
- [ ] User-facing labelling, instructions, warnings, and support/incident routes are approved.
- [ ] TF-001 technical documentation and clause-level essential-requirements mapping are complete for the exact configuration.
- [ ] Clinical evaluation report, usability validation, risk-management report and overall residual-risk acceptance are approved.
- [ ] Suppliers/components and safety-relevant tools are assessed, with validation evidence where required.
- [ ] Known anomalies have documented clinical/safety/regulatory dispositions; no unacceptable or unassessed release risks remain.
- [ ] PMS plan, device lifetime/PMS period, vigilance reporter/deputy and external support route are operational; reporting and offline field-correction exercises are recorded.
- [ ] Applicable declaration of conformity is signed by an authorised manufacturer representative, any required body assessment is complete, and marking is approved.
- [ ] Required registration confirmation is retained before market placement; submitted data match the technical file, product information and artefacts, with a maintenance/fee owner assigned.
- [ ] Distribution channels, supported configurations, safe update/withdrawal arrangements and long-term evidence/artefact retention are confirmed.
- [ ] Required governance approvals are recorded in the release record.
