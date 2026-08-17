# Publication Readiness

This record separates publication of the source repository from distribution or deployment of Neomate for clinical use. Public source availability is not clinical approval and does not change the safety status recorded in `SAFETY.md`.

## Resolved Publication Concerns

- Rights in inherited Neomate-owned code, content, branding, images, fonts, repository history, and other custom assets are treated as resolved through transfer from Neomate Ltd to RCPCH.
- The repository and its full Git history have been scanned for secrets, including the contents of historical archive files; no credentials or secrets were found.
- No patient-identifiable information was found.
- Local configuration, private workspace material, credentials, signing files, and build outputs are excluded by `.gitignore`.
- Existing Git contributor names and email metadata are ordinary project attribution and are not treated as a publication blocker.
- Historical clinical code and content may remain available as clearly identified migration evidence. It is not an approved clinical specification.

## Remaining Source-Publication Prerequisites

- Add a public `SECURITY.md` identifying an approved private vulnerability-reporting route and supported-version policy.
- Add complete licence texts and attributions for redistributed third-party material, including the SIL Open Font License for Lato.
- Review public repository metadata and replace legacy application identifiers before they are used for RCPCH release signing or store distribution. The identifiers are not secrets and do not block source publication.
- Complete the final public-branch diff and secret scan immediately before the first push to the RCPCH repository.

## Not Source-Publication Blockers

- Open clinical-review questions, missing clinical sign-off, and incomplete medical-device assurance do not prevent publication of clearly labelled source code.
- They do prevent any claim that the application is clinically approved and continue to block clinical distribution, deployment, and patient-care use.
- Legacy clinical content may be published as migration evidence, but it must remain excluded from active application behaviour unless independently sourced, reviewed, tested, and approved.

## Clinical Release Gates

Clinical release remains governed by `SAFETY.md`, the clinical-safety file set, QMS records, the clinical review questions, and D42-D48 of the roadmap. Publication of this repository does not satisfy or bypass those gates.
