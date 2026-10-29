# Neomate 2

Neomate 2 is a neonatal reference and calculation app for NICU clinical staff.

## Status

**This is an alpha evaluation and clinical review version. It is not ready or approved for clinical use.** Do not use its content or calculations for patient care, distribute a build for clinical use, or represent its outputs as clinically validated until the clinical-safety, quality-management, evidence-review, and release gates in [SAFETY.md](SAFETY.md) are complete.

## Development

Install [mise](https://mise.jdx.dev), then run:

```sh
s/setup
s/lint
s/test
```

`.mise.toml` pins the exact Flutter SDK version; `s/setup` installs it and fetches dependencies.

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
