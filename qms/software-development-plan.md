# Software Development Plan

Document: DEV-001. Revision/status/approval: see the [controlled document index](README.md#controlled-document-index).

## Scope

This plan governs the controlled redevelopment of the inherited Neomate application code into a maintained Flutter product. It applies to source code, clinical content, tests, build configuration, dependencies, safety documentation, and release artefacts.

## Lifecycle Baseline

1. Define and approve intended purpose, users, environment, system boundaries, offline behaviour, platform support, and software safety classification.
2. Inventory inherited functions and clinical content, then establish reviewed requirements and source traceability before claiming parity.
3. Modularise deterministic domain logic away from Flutter presentation and persistent state.
4. Implement against reviewed requirements with peer review and explicit clinical review for safety-relevant changes.
5. Verify with unit, integration, widget, accessibility, source-derived calculation, regression, and negative tests appropriate to the risk.
6. Record anomalies, corrective actions, version, build provenance, supported platforms, and approval in the release record.
7. Maintain post-release monitoring, incident handling, content review, security updates, and controlled rollback.

## Configuration Control

- Git is the source of truth for versioned artefacts.
- `pubspec.yaml` and `pubspec.lock` are controlled dependencies and must be reviewed together.
- Generated platform files must not be hand-edited unless the change is documented and reproducible.
- Clinical content and calculation changes require linked safety and evidence updates.
- Releases require an immutable source revision, reproducible build instructions, test results, and approval record.
- Every claimed target platform requires its own build, test, usability, security, update, and rollback evidence.

## Records

Store design decisions in `spec/`, clinical-safety evidence in `clinical-safety/`, and controlled release evidence in the approved RCPCH QMS location. Reference external records by stable identifier from the corresponding Markdown artefact.

The approved external store, retention and retrieval controls must be confirmed under [QMS-002](document-control.md); naming a future location does not establish that it is operational.

## Design Inputs, Review And Traceability

Give requirements stable IDs. For each clinical feature define intended task/population/limits, source and version, inputs/units/ranges, formula/protocol, precision/rounding/tolerance, expected outputs and failure states, warnings/advisories, offline behaviour and acceptance criteria. Include security, accessibility and platform constraints. Obtain clinical/engineering review of the design inputs before treating implementation as conforming.

Maintain the architecture and interface specification, including separation of calculations from UI, patient-context handling, unit conversions, content/profile binding, trust boundaries, state lifecycle, dependencies and platform build differences. Document the IEC 62304 software safety classification rationale independently of regulatory device class; classification and applicable lifecycle activities remain [PENDING]. Existing source code is an implementation input, not an approved architecture review.

Use the change/traceability record in REC-001 to link requirement/source -> hazard/control -> design/implementation -> verification -> clinical/usability validation -> anomaly disposition -> released configuration. Review design at input approval, architecture approval, verification readiness and release readiness; record participants, competence, findings and closure evidence. Include independent review of safety-critical work.

## Verification, Validation And Problem Resolution

Approve test protocols and acceptance criteria before execution. Record tested SHA, clinical-content/profile versions, dependencies/toolchain, platform/OS/device, data, independent expected results and tolerances, actual results, deviations, reviewer and disposition. `s/lint` and `s/test` are engineering checks; retain their outputs for the tested revision and supplement them with source-derived independent clinical verification, integration and installed-product tests for every supplied platform. Do not label an unexecuted protocol as evidence.

Validate clinical claims and representative tasks under EVAL-001. Link safety-control effectiveness to RISK-001. Assess clinical content, localisation/units, warning presentation, invalid/non-finite states, offline startup/restart, dependency/platform failures, update integrity and recovery. Record unresolved anomalies and their safety/regulatory impact; a passing suite does not waive an unassessed anomaly.

Process nonconformities through PMS-001 before or after release. Any maintenance change, including dependency, source-content or local-profile changes, requires documented clinical/safety/security/classification impact, regression scope, evidence and release disposition. Emergency fixes retain review, verification and traceability with proportionate urgency; field corrections also follow PMS-001.

## Transfer, Supply And Retirement

Before clinical supply, freeze the design outputs and complete TF-001 and REL-001 for the exact binaries and content. Record build/signing authorisation, immutable artefact hashes, supported platforms, installation verification, approved product information, and channel/market. Keep internal development status distinct from a clinically released configuration using explicit manifests and approvals.

Software, clinical content and local profiles update through controlled signed application releases under [spec/offline-content-updates.md](../spec/offline-content-updates.md). No runtime content update or telemetry is introduced by this plan. Validate replacement/rollback compatibility and assess whether the previous version is clinically safe before recommending rollback.

Define supported device lifetime, OS support window, review/expiry handling, maintenance capacity and end-of-life notice period before release. Retirement requires a user/deployer transition plan, outstanding-incident/CAPA disposition, continued required PMS/vigilance and retained evidence; withdrawing download access does not remove already-installed offline copies.
