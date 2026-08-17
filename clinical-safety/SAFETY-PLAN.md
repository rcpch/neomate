# Clinical Safety Plan

## Purpose

This plan defines the minimum clinical-safety controls for the Neomate 2 rebuild. It supports, but does not replace, the RCPCH clinical-safety process and required DCB0129 and deployment DCB0160 activities.

## Responsibilities

| Role | Responsibility | Named Person |
| --- | --- | --- |
| Product owner | Owns intended purpose, scope, and release decision | Dr Marcus Baw |
| Clinical Safety Officer | Owns clinical-safety assessment and safety-case approval | Dr Marcus Baw |
| Clinical content lead | Reviews sources, local-policy alignment, and wording | Dr Marcus Baw |
| Engineering lead | Owns implementation, verification evidence, and configuration control | Dr Marcus Baw |
| Quality lead | Owns QMS records, traceability, and release record | Dr Marcus Baw |

## Development Controls

- Record the intended purpose, users, environment, and excluded uses before defining a release candidate.
- Trace each clinical calculation, threshold, dose, warning, and checklist item to an authoritative, reviewed source with a version and review date.
- Keep calculation functions deterministic and separate from Flutter UI and I/O.
- Verify calculations independently with source-derived vectors and boundary cases. Legacy behaviour is not sufficient evidence.
- Review all clinical-content and safety-relevant code changes by the Clinical Safety Officer or delegated clinical content lead.
- Keep implemented workflows exercisable in internal development builds for clinical review. Review status and configured protocol constraints may inform visible advisories but must not suppress a finite calculation in this review environment.
- Before clinical release, establish and record independent clinical and quality review arrangements to avoid sole-review of safety-critical work.
- Review security, privacy, device, offline, and update behaviour before deployment.
- Verify offline behaviour and every claimed target platform independently before including it in a clinical release.
- Preserve change, review, test, and release evidence in version control or the approved QMS system.

## Release Gates

A clinical release requires documented approval that all of the following are complete:

- Intended purpose, users, environment, contraindications, and residual-risk acceptability are approved.
- The safety case and hazard log are current, with evidence for every safety control.
- Clinical content and source traceability are reviewed and current.
- Independent source-derived calculation verification, boundary testing, and regression testing pass.
- Usability and accessibility assessment has addressed use-error hazards.
- Cybersecurity, privacy, configuration, update, and rollback controls are approved.
- The software version, build provenance, supported platforms, and release artefacts are recorded.
- The Clinical Safety Officer, product owner, and quality lead approve release.

## Review Cadence

Review the hazard log and safety case for every safety-relevant change, before each release candidate, following an incident or near miss, and at least annually while the product is maintained.
