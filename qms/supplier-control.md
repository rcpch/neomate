# Supplier, Dependency And Tool Control

Document: SUP-001. Revision/status/approval: see the [controlled document index](README.md#controlled-document-index).

## Scope

Assess external inputs that can affect safety, quality, evidence or continued supply: Flutter/Dart and operating platforms, Pub packages and transitive components, clinical-source providers, build/CI/signing services, test tools, content assets, distribution stores, record storage, and outsourced review. Classify software of unknown provenance or software not developed under this QMS explicitly in the software lifecycle records where applicable.

## Assessment And Acceptance

Before first use in a clinical baseline, engineering/quality records supplier/component ID, purpose, exact version/digest, source and licence, maintenance/support, known anomalies/vulnerabilities, failure impact, update/end-of-life route, evaluation method, acceptance criteria, owner and review date. Clinical sources require population/applicability/version/currency review by the clinical content lead. For critical services record contractual responsibilities, continuity, evidence export and incident notification.

For each build/test/QMS tool, assess the consequence of an incorrect output and the need for validation proportionate to intended use and risk. Record the actual validation evidence or a reviewed rationale for its extent. For example, establish that a test runner reports a deliberately failing calculation fixture as failed, and that archived reports identify the tested revision. Do not assume a tool is validated solely because it is widely used.

Acceptance requires a competent reviewer and a documented conclusion. Automated dependency scans support assessment but do not establish clinical suitability. AI-generated content/code is unverified input requiring the same source, review and verification controls; an AI system cannot provide independent clinical sign-off.

## Ongoing Control

Use the reviewed `.mise.toml`, `pubspec.yaml`, `pubspec.lock`, workflow configuration and release inputs as configuration evidence. Capture a version-specific component inventory/SBOM, licences and known anomalies in each release pack. Review updates, advisories and supplier end-of-life at least monthly as a proposed cadence and before release; evaluate safety/security and classification impact under DEV-001 before accepting an update. Verify the current official package/version before changing dependency files under repository rules.

Initial assessment queue: Flutter/Dart toolchain; all direct and transitive Pub dependencies; GitHub CI/actions and signing/distribution; current clinical-source access; evidence storage and independent reviewers. Existing version pinning and tests are available inputs; no supplier acceptance or tool-validation completion is asserted here. Use REC-001 and QMS-A07 to establish the executed register.
