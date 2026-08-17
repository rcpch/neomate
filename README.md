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

The current non-clinical demonstration scope, build commands, and limitations are documented in [spec/internal-alpha.md](spec/internal-alpha.md).

## Governance

- [SAFETY.md](SAFETY.md) - clinical safety status and entry point.
- [clinical-safety/](clinical-safety/) - safety plan, safety case, and hazard log.
- [qms/](qms/) - software-development and release controls.
- [spec/](spec/) - durable product, terminology, and roadmap decisions.
- [Clinical review questions](spec/clinical-review-questions.md) - prioritised decisions for neonatal clinical reviewers.
- [agent-instructions.md](agent-instructions.md) - contributor and agent workflow.

## Contributors

The current contributors are listed alphabetically:

- Dr Marcus Baw
- Michael Barton - RCPCH Lead Developer
- Dr Katharine Jamieson - Neonatal consultant
- Dr Chris Kelly - Doctor, Guy's and St Thomas' Hospital
- Dr Lee Collier, STORKS Charity, Blizard Institute Queen Mary University of London
- Dr Syed Mohinuddin - Neonatal consultant, Children's Hospital of Eastern Ontario (CHEO)

## Licence

New Neomate 2 code and project artefacts are Copyright (c) 2026 Neomate team and RCPCH, licensed under the [GNU Affero General Public License v3.0 or later](LICENSE). Written documentation produced for this project is CC-BY-SA-4.0. Rights in inherited Neomate-owned material have been transferred to RCPCH for continued maintenance and redistribution.

Third-party material retains its existing rights and licence requirements. Publication of the source code does not constitute clinical approval; distribution or deployment for clinical use remains prohibited until the documented clinical-governance, safety, quality, and regulatory gates are met.
