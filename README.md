# Neomate 2

Neomate 2 is a Flutter rebuild of the legacy Neomate neonatal reference and calculation app for NICU clinical staff.

## Status

This repository contains inherited clinical content and calculation logic that is being modernised. It is **not approved for clinical deployment or clinical decision-making**. Do not distribute a build, use it in patient care, or represent its outputs as clinically validated until the clinical-safety, quality-management, evidence-review, and release gates in [SAFETY.md](SAFETY.md) are complete.

## Development

Install a current stable Flutter SDK, then run:

```sh
flutter pub get
s/lint
s/test
```

## Governance

- [SAFETY.md](SAFETY.md) - clinical safety status and entry point.
- [clinical-safety/](clinical-safety/) - safety plan, safety case, and hazard log.
- [qms/](qms/) - software-development and release controls.
- [spec/](spec/) - durable product, terminology, and roadmap decisions.
- [agent-instructions.md](agent-instructions.md) - contributor and agent workflow.

## Licence

New Neomate 2 code and project artefacts are Copyright (c) 2026 Neomate team and RCPCH, licensed under the [GNU Affero General Public License v3.0 or later](LICENSE). Written documentation produced for this project is CC-BY-SA-4.0.

Inherited code, clinical content, images, fonts, and third-party references retain their existing rights and must be inventoried and cleared before distribution. Distribution remains prohibited pending that provenance review and clinical governance approval.
