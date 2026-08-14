# Rebuild Roadmap

Legend: [x] done, [~] in progress, [ ] not started

- [x] **R1 - Establish clinical safety, QMS, agent, and validation baseline**
- [x] **R2 - Establish current Flutter/Dart build compatibility and remove obsolete project assumptions** - the native shell has no legacy UI, state-management, navigation, HTML-rendering, or networking dependencies; strict analysis and the full test suite pass on Flutter 3.44.
- [x] **R3 - Inventory inherited calculations, checklists, reference content, sources, and licences** - captured in `spec/legacy-inventory-and-source-review.md`; item-level source approval and rights clearance remain release gates.
- [~] **R4 - Define approved intended purpose, system boundaries, users, deployment environment, and regulatory classification** - UK-first, free-to-use, likely Class IIa planning assumption is recorded; formal classification and conformity route remain open.
- [~] **R5 - Extract deterministic calculation domain modules from Flutter UI** - pure policy-driven patient weight and context handling is implemented; remaining calculation families are pending.
- [ ] **R6 - Build source-derived calculation conformance vectors and independent clinical verification**
- [ ] **R7 - Replace legacy presentation with accessible, usability-tested Flutter feature modules**
- [ ] **R8 - Establish controlled CI, dependency management, security scanning, and reproducible release builds**
- [ ] **R9 - Complete clinical safety case, QMS design controls, and release readiness review**
- [x] **R10 - Decide the growth/clinic feature scope and approved growth-data source** - native growth functionality is out of scope; potential Rust RCPCH Digital Growth Charts FFI integration is deferred to D49.
- [~] **R11 - Create the versioned clinical-content and protocol registries with provenance enforcement** - typed records and registry validation are implemented; approved real content and protocol records remain to be added.

## Delivery Plan

This plan deliberately puts medical-device assurance and market access last. No interim build is approved for clinical use. Each phase produces controlled technical and clinical evidence that is reused by the final medical-device work.

### Foundation

- [x] **D1 - Establish safety, QMS, licence, specification, and agent baseline**
- [x] **D2 - Inventory all available legacy implementations, sources, defects, and functional scope**
- [x] **D3 - Remove obsolete unversioned development logs and archive snapshots**
- [ ] **D4 - Confirm written provenance and redistribution rights for inherited code, content, images, and fonts**
- [x] **D5 - Create a source and clinical-sign-off comment convention for every clinical code file**

Completion criteria: every inherited asset and source file has a recorded disposition; no undocumented clinical material is copied into new feature modules.

### Offline Core

- [x] **D6 - Remove incompatible legacy Flutter dependencies and restore a clean Flutter 3.44 test build**
- [x] **D7 - Replace legacy global state, navigation, HTML rendering, and page-transition patterns with current Flutter architecture**
- [x] **D8 - Enforce a no-network runtime boundary in all application targets** - architecture tests reject networking dependencies, active Dart networking APIs, Android release internet permission, and Apple release network entitlements.
- [ ] **D9 - Define and test offline startup, restart, and full feature operation on Android, iOS, macOS, Windows, Linux, and web**
- [ ] **D10 - Define release signing, installation, update, and rollback procedures for every target platform without making clinical operation network-dependent**

Completion criteria: the app has no runtime network dependency, no analytics, no telemetry, no feedback collection, no patient persistence, and clean lint/test/build checks on supported developer targets.

### Domain And Content Platform

- [x] **D11 - Create typed source, clinical-sign-off, content, protocol, warning, and review-expiry records**
- [x] **D12 - Add registry enforcement tests for mandatory provenance, reviewer, review date, expiry date, and applicability fields**
- [x] **D13 - Create a deployment-profile model for local-network content without embedding local phone numbers or referral rules in the core product**
- [x] **D14 - Replace opaque HTML with typed, accessible, versioned clinical content rendering**
- [ ] **D15 - Define a controlled offline content-update format and verification method**

Completion criteria: a feature cannot render a clinical statement or protocol unless its registry record is complete and current.

Decision: inherited HTML is migration-source material only. No HTML renderer or HTML-based clinical content will ship in Neomate 2; rebuild all clinical presentation and logic as native Dart and Flutter components.

### Calculation Engine

- [x] **D16 - Extract weight validation and patient-context handling into a pure, unit-explicit domain module**
- [ ] **D17 - Extract ventilation and oxygenation-index calculations into pure modules with controlled result/error types**
- [ ] **D18 - Extract daily fluid, GIR, electrolyte, and compounding calculations into pure modules**
- [x] **D19 - Define named protocol calculation interfaces for drug bolus, line-length, and infusion preparation functions**
- [x] **D20 - Enforce protocol range, concentration, route, line, and denominator controls in the calculation engine**
- [x] **D21 - Exclude the generic infusion calculator from the first clinical release unless a separate safety case approves it** - no generic infusion feature exists in the active native app.

Completion criteria: no calculation lives in a widget; all invalid and non-finite inputs return controlled non-results; configured clinical limits are enforced in code.

### Clinical Content Review

- [ ] **D22 - Review and specify newborn-resuscitation content against RCUK 2025 and approved local policy**
- [ ] **D23 - Review and specify HIE/cooling content against BAPM 2025 and the selected network policy**
- [ ] **D24 - Review and specify extreme-preterm content against BAPM 2026**
- [ ] **D25 - Review and specify neonatal-infection content against NICE NG195, updated May 2026**
- [ ] **D26 - Review each medicine and infusion protocol against BNFC and the approved local neonatal formulary**
- [ ] **D27 - Review central-line and airway content against current BAPM guidance and local policy**
- [ ] **D28 - Obtain approved local neonatal fluid/pharmacy protocol and specify the fluid calculator from it**
- [ ] **D29 - Split all legacy checklists into independently sourced clinical-content records**
- [ ] **D30 - Retire or replace unconfirmed content, including legacy CFM images, “Need to confirm” text, and contradictory thresholds**

Completion criteria: every retained clinical statement and protocol has a named clinical reviewer, source/version, sign-off date, expiry date, and controlled test evidence.

### Verification And Usability

- [ ] **D31 - Build source-derived conformance vectors for all approved calculations and protocol preparations**
- [ ] **D32 - Add boundary, invalid-input, unit-conversion, and regression tests for every calculation**
- [ ] **D33 - Add widget tests for input validation, warnings, provenance display, no-result states, and navigation**
- [ ] **D34 - Complete accessibility review to WCAG 2.2 AA, including screen-reader semantics, text scaling, contrast, focus, and touch target checks**
- [ ] **D35 - Run usability assessment with representative neonatal clinicians, concentrating on high-risk tasks and use-error hazards**
- [ ] **D36 - Test offline operation and installation/recovery on every claimed release platform**

Completion criteria: test evidence is linked to source records and hazards; representative users have assessed the high-risk workflows; no claim of clinical readiness is made without independent clinical review.

### Product Readiness

- [ ] **D37 - Design the accessible Flutter feature modules and migrate approved functionality from the legacy interface**
- [ ] **D38 - Add controlled build provenance, dependency review, CI, reproducible builds, and release artefact retention**
- [ ] **D39 - Define support, incident, issue triage, corrective-action, content-update, and product-maintenance workflows**
- [ ] **D40 - Establish public documentation, source availability, and licence notices appropriate to AGPL-3.0-or-later distribution**
- [ ] **D41 - Produce a non-clinical beta build for technical and usability evaluation only**

Completion criteria: the product is technically mature, fully offline, reproducibly built, and has a controlled evidence trail ready to enter formal medical-device assurance.

### Medical Device And Market Access

- [ ] **D42 - Confirm UK classification, intended purpose, claims, applicable legislation, standards, and conformity-assessment route**
- [ ] **D43 - Establish the required quality-management system, design-history file, requirements traceability, risk-management file, and clinical-evaluation plan**
- [ ] **D44 - Complete DCB0129 clinical-safety documentation and define deployer DCB0160 responsibilities**
- [ ] **D45 - Complete formal risk management, cybersecurity, privacy, human-factors/usability, software lifecycle, and clinical evaluation evidence**
- [ ] **D46 - Obtain independent clinical, safety, quality, and regulatory review of the final release candidate**
- [ ] **D47 - Complete UK market-access actions and app-store submission controls for the free-to-use product**
- [ ] **D48 - Plan EU and other-market expansion as separate regulatory projects after UK launch**

Completion criteria: market-access evidence, approvals, labelling, post-market surveillance, vigilance, and release controls are complete for the UK. No EU claim is made until its separate route is completed.

### Deferred Integration

- [ ] **D49 - Assess the separate Rust RCPCH digital growth-chart implementation for Flutter FFI integration**

Completion criteria: the Rust component has independent data rights, API, security, performance, clinical, and interoperability evidence. It must not become an implicit dependency of the initial Neomate 2 release.
