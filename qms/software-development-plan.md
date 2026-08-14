# Software Development Plan

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
