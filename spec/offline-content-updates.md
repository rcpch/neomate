# Offline Clinical Content Updates

## Decision

Neomate 2 does not support runtime clinical-content downloads, remote configuration, web content, side-loaded content packs, or an in-app content update channel.

Approved clinical content and protocol records are native Dart data compiled into the signed application release. A clinical-content update is an application release and follows the same source review, testing, build provenance, signing, approval, distribution, and rollback controls as a code change.

## Update Format

The controlled source format is the typed Dart registry defined under `lib/clinical_content/`:

- `ClinicalSource` records identify evidence.
- `ClinicalSignOff` records identify review decisions.
- `ClinicalContent` and `ClinicalProtocol` records hold versioned artefacts.
- `DeploymentProfile` records select only registered artefact IDs.
- Native `ClinicalContentDocument` blocks define rendered content without HTML.

Each clinical Dart file follows [clinical-source-convention.md](clinical-source-convention.md). The committed source and lockfile are the preferred form for review; generated binaries are not the source of truth.

## Verification

Before an application build can be accepted:

- Registry policy tests must reject missing, duplicate, expired, unapproved, or untraceable artefacts.
- Calculation and protocol tests must pass against approved source-derived vectors.
- Deployment profiles must reference only correctly typed registered artefacts.
- The no-network architecture tests must pass.
- The application version, source revision, Flutter version, lockfile, build platform, signing identity, and resulting artefact digest must be retained in the release record.

## Rollback

Rollback means distributing or reinstalling a previously approved, signed application release whose clinical-content review remains valid. A release must not be rolled back to content that has expired, been superseded for safety reasons, or contains a known unresolved defect. Emergency withdrawal and replacement procedures remain to be defined per distribution platform under D10 and D39.

## Future Changes

Any proposal for downloadable or separately signed content is a new safety, security, regulatory, and architecture decision. It requires a documented threat model, key-management design, anti-rollback controls, atomic installation, expiry handling, offline recovery, hazard assessment, and independent approval before implementation.
