# Open Queries

## Resolved Decisions

| ID | Decision | Status |
| --- | --- | --- |
| Q1 | Neomate 2 is intended to be a clinical calculator and guidance-reference app for neonatal care. | Proposed intended purpose recorded; regulatory classification remains open. |
| Q2 | The Neomate team and RCPCH own product, clinical safety, clinical content, engineering, quality, security, and release accountability. | Named role holders are still required before clinical release. |
| Q3 | New project code and artefacts are AGPL-3.0-or-later, Copyright (c) 2026 Neomate team and RCPCH. Rights in inherited Neomate-owned material have been transferred to RCPCH. | Resolved. Third-party material remains subject to its existing licence terms. |
| Q4 | The first approved release should aim to include all inherited clinical functions, subject to current-source review. | Content inventory and review remain open. |
| Q5 | The application must work offline and aims to support Android, iOS, macOS, Windows, Linux, and web. | Platform-specific release evidence remains open. |
| Q6 | Initial source families are RCPCH, Resuscitation Council UK, and the Neonatal Society. | Specific authoritative sources and local policies for each item remain open. |
| Q7 | Replace obsolete dependencies and patterns with current Flutter practices rather than preserving legacy implementation choices. | In progress under R2. |

## Further Resolved Decisions

| ID | Decision | Status |
| --- | --- | --- |
| Q8 | The intended product is likely Class IIa. The United Kingdom is the initial market; European Union and other markets are deferred. The product is intended to be free to use. | Planning assumption recorded. Formal classification, evidence route, and market-access route remain open. |
| Q9 | Dr Marcus Baw currently holds the Clinical Safety Officer, clinical content lead, quality lead, and release-approval roles. | Independent review and formal delegation remain required before clinical release. Contributors are listed in `README.md`. |
| Q10 | Neomate Ltd has transferred its rights in inherited Neomate material to RCPCH for continued maintenance and redistribution. | Resolved. Retain the executed transfer with the project governance records. |
| Q11 | Each relevant clinical source-code file must link to sources and clinical sign-off in comments. | Registry-level provenance fields and item-level implementation remain open. |
| Q12 | The application must operate 100% offline with no runtime network dependency. Native growth charts are out of scope. A future Rust RCPCH Digital Growth Charts component may be integrated through Flutter FFI. | Offline platform verification and update/rollback design remain open; FFI integration is deferred. |
