# Clinical Safety

## Product

Neomate 2 is an offline-capable Flutter clinical calculator and guidance-reference application for appropriately trained neonatal healthcare professionals. The proposed intended purpose is recorded in [spec/intended-purpose.md](spec/intended-purpose.md).

It is not a diagnostic system, prescribing system, electronic patient record, or substitute for clinical judgement, local policy, independent calculation checks, or current authoritative clinical sources.

## Safety Status

**Not approved for clinical deployment or patient-care use.** The repository contains inherited legacy clinical content and calculation logic. It must not be distributed or submitted to an app store until the safety case, hazard controls, clinical-content review, evidence traceability, usability assessment, independent calculation verification, cybersecurity assessment, and release gates are completed and signed off by the responsible governance roles.

## Intended Users And Environment

The proposed intended users are appropriately trained neonatal clinicians in a UK NICU context. The target platforms are Android, iOS, macOS, Windows, Linux, and web. The application must remain usable offline. Platform-specific device controls, update and rollback mechanisms, and data-processing boundaries require verification before any clinical release.

## Safety Ownership

Dr Marcus Baw currently holds the product owner, Clinical Safety Officer, clinical content lead, engineering lead, quality lead, security lead, and release-approval roles for the Neomate team and RCPCH. Formal delegation and an independent review arrangement must be recorded before clinical deployment.

## Development Review Posture

At the direction of the Clinical Safety Officer, locally run development builds expose every implemented workflow without requiring prior clinical sign-off or a current review decision. Configured protocol dose, concentration, route, and access constraints are displayed as non-blocking review advisories so that reviewers can exercise and assess the calculations. This posture applies only to source-run development builds available to the internal development team; clinical release and distribution gates remain unchanged.

## Safety Artefacts

- [clinical-safety/SAFETY-PLAN.md](clinical-safety/SAFETY-PLAN.md) - lifecycle, responsibilities, and release gates.
- [clinical-safety/SAFETY-CASE.md](clinical-safety/SAFETY-CASE.md) - safety argument and evidence status.
- [clinical-safety/HAZARD-LOG.md](clinical-safety/HAZARD-LOG.md) - initial hazards and required controls.
- [qms/regulatory-assessment.md](qms/regulatory-assessment.md) - draft medical-device applicability and requested Class I route assessment, sources, decision owners and reassessment triggers.
- [qms/README.md](qms/README.md) - draft quality system, evidence controls, evaluation/risk/PMS plans and registration-readiness register.

## Change Rule

Any change affecting clinical content, a calculation, validation, units, warning, workflow, source, or deployment context must update the linked safety artefacts in the same pull request. Changes must identify reviewed evidence and require appropriate clinical review.
