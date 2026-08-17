# Agent Instructions

Neomate 2 is a Flutter rebuild of a legacy neonatal reference and calculation application. It is not approved for clinical deployment. This file is the entry point for AI coding agents.

## Read First

- [README.md](README.md) - purpose, status, and setup.
- [SAFETY.md](SAFETY.md) - safety status and clinical-change rules.
- [clinical-safety/SAFETY-PLAN.md](clinical-safety/SAFETY-PLAN.md) - assurance and release gates.
- [qms/README.md](qms/README.md) - QMS artefact index.
- [spec/README.md](spec/README.md) - product decisions and roadmap.
- [/home/marcus/code/house-style/AGENTS.md](/home/marcus/code/house-style/AGENTS.md) - adopted engineering standards.

## Core Invariants

- No build is clinically approved until documented safety and QMS release gates are met.
- Treat legacy clinical content, doses, formulas, thresholds, and sources as unverified inherited material until independently reviewed.
- Keep calculation logic deterministic and independently testable. Tests for clinical behaviour must link to a reviewed source and the relevant hazard where practical.
- Do not introduce patient data, clinical credentials, or production endpoints into the repository.
- Do not alter clinical behaviour without updating the safety artefacts and traceability record in the same change.
- Keep implementation history in engineering documentation, not user-facing copy. Clinical UI must describe current capability, evidence, review, and approval status without referring to a rewrite, rebuild, migration, legacy version, prototype, alpha, or demonstration.
- Keep every implemented workflow exercisable in internal development builds regardless of clinical review or sign-off status. Configured clinical constraints may produce visible review advisories but must not suppress otherwise valid calculations unless the Clinical Safety Officer explicitly changes this posture.

## Workflow

- `s/lint` - format check and static analysis.
- `s/test` - run the full Flutter test suite.

## Before Every Commit

```sh
s/lint
s/test
```

## Approval Required

Ask before publishing releases, submitting to an app store, changing clinical content, changing safety status, adding credentials, force-pushing, or taking any external action.
