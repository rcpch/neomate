# Internal Alpha Demo

## Purpose

The internal alpha is a Flutter-native demonstration for the original Neomate authors and project collaborators. It demonstrates the rebuild architecture and selected inherited functionality across mobile, desktop, and web surfaces. It is not clinically reviewed, not approved for patient care, and not a distributable medical-device release.

## Demonstrable Scope

- Adaptive Flutter-native home screen for phone and desktop layouts, using the inherited Neomate logo and Lato type family.
- Prominent session-only baby-weight context passed into available calculator workflows, with measured/estimated status visible.
- Familiar clinical accordion categories loosely correlated with the original Neomate task layout while retaining native Flutter controls and accessibility semantics.
- Familiar bottom navigation for workspace, calculators, checklists, and references, including ten native interactive checklist review workflows and direct cooling/admission entry points.
- Native calculator navigation with no HTML renderer or runtime network dependency.
- Live weight validation, mean airway pressure, oxygenation index, daily fluid volume, glucose infusion rate, electrolyte requirement, and additive stock-volume calculations.
- Inherited ETT internal-diameter, oral lip-length, UVC insertion-length, and UAC insertion-length aids with explicit position-confirmation warnings.
- Nine inherited named infusion preparation protocols: dopamine, dobutamine, adrenaline, noradrenaline, dinoprostone, morphine, vecuronium, clonazepam, and midazolam.
- Explicit separation of sedation from neuromuscular paralysis, including a prominent warning that vecuronium provides neither analgesia nor sedation.
- Non-blocking review advisories for configured dose, concentration, route, and vascular-access constraints.
- Native source and review-status presentation.
- In-app clinical change log for retired inherited algorithms, including copyable links to governing and supporting evidence.
- Controlled invalid-input and no-result states.
- Persistent internal-alpha warnings stating that outputs are not approved for patient care.
- No analytics, telemetry, network requests, or patient-data persistence.

Checklist completion state is ephemeral and resets when a checklist is closed. It is intended to support structured content review without storing patient or task data.

## Run Locally

```sh
flutter pub get --enforce-lockfile
s/lint
s/test
flutter run -d linux
flutter run -d chrome
```

For Flutter MCP interaction, use the isolated development entrypoint:

```sh
s/linux-driver
```

The production entrypoint never enables Flutter Driver; the driver target is isolated under `test_driver/driver_main.dart`.

Use `flutter devices` to list locally available Android or Apple devices and simulators.

## Build Demonstration Artefacts

```sh
flutter build apk --release
flutter build linux --release
flutter build web --release
```

Successful artefacts are written to:

- Android APK: `build/app/outputs/flutter-apk/app-release.apk`
- Linux bundle: `build/linux/x64/release/bundle/`
- Web bundle: `build/web/`

The internal-alpha Android APK falls back to the standard debug signing key when `android/key.properties` is absent. This makes local installation possible but is not acceptable for distribution or clinical release. A controlled release key, provenance record, and rollback procedure remain release gates.

iOS and macOS must be built and exercised on macOS with Xcode. Windows must be built and exercised on Windows. Successful compilation on Linux does not provide evidence for those platforms.

## Demo Script

1. Open the home screen and point out the familiar Neomate branding, weight-first workflow, offline/no-storage status, and persistent development warning.
2. Change the workspace weight and open **Cardiac drugs** to demonstrate that the session weight is carried into the named infusion workflow.
3. Raise the dose or lower the pump rate to demonstrate that configured concentration limits appear as advisories while the calculated result remains visible, then select peripheral access to demonstrate the corresponding access advisory.
4. Open **Sedation and paralysis**, select vecuronium, and point out that paralysis is explicitly distinguished from analgesia and sedation.
5. Open **Neurology** and show that the inherited clonazepam default remains calculable while its stated concentration conflict is shown for review.
6. Open **Intubation and airway** and **Central lines** to show the inherited ETT/UVC/UAC aids and mandatory placement-confirmation warnings.
7. Open **Intravenous fluids**, then **Electrolytes and compounding**, to show the explicit prescription and stock-preparation steps.
8. Open **Oxygenation index** and change ventilator values to show live native calculation results.
9. Enter an invalid weight to demonstrate a controlled refusal rather than a misleading result.
10. Use the bottom **Calculators** destination to show the complete alpha calculator catalogue.
11. Open **References**, then **Clinical change log**, to show why resuscitation bicarbonate and empirical 2.5 mL/kg D10 were retired, with copyable evidence links.
12. Return to **References** to show inherited/proposed source status and zero clinical sign-offs.
13. Confirm that category actions without active implementations are labelled **Not implemented** rather than presented as clinically gated.

## Known Limitations

- No clinical calculation or protocol has independent clinical sign-off.
- Daily fluid review calculations accept every positive finite mL/kg/day entry; no clinical reference range is yet configured. A reviewed local fluid policy is still required.
- Electrolyte review calculations accept every positive finite mmol/kg/day entry; no clinical reference range is yet configured. Reviewers must enter a prescription and independently inspect the stock preparation.
- Infusion values remain inherited baselines pending verification against current BNFC, Medusa, and the approved local formulary.
- Dinoprostone retains the inherited discrepancy between its configured 1-20 nanograms/kg/min range and displayed usual 5-10 nanograms/kg/min range; calculations outside the configured range remain visible with an advisory.
- Morphine retains conflicting inherited ranges: 0-60 micrograms/kg/hour in numeric fields, 5-20 in displayed text, and occasional use up to 40 in narrative text. Positive finite doses remain calculable, with configured range and concentration conflicts shown as advisories.
- Vecuronium retains conflicting concentration fields; the stricter human-readable 2 mg/mL ceiling is recorded as an advisory threshold. Its protocol remains unreviewed, and paralysis must never be mistaken for analgesia or sedation.
- Clonazepam retains a default preparation that exceeds its own stated 12 micrograms/mL ceiling at common neonatal weights. The output remains visible with an advisory so clinical review can determine whether the protocol should be corrected or retired.
- Midazolam retains conflicting inherited dose ranges of 10-60, 30-60, and 30-300 micrograms/kg/hour. The shared numeric 30-300 bounds are displayed as review metadata rather than enforced.
- Inherited sodium bicarbonate resuscitation outputs are retired because RCUK 2025 no longer recommends bicarbonate in resuscitation. This does not prohibit separately reviewed post-resuscitation use under local policy.
- The inherited empirical 2.5 mL/kg D10 resuscitation bolus is retired; RCUK 2025 requires glucose measurement where possible and specifies 2 mL/kg D10 only when blood glucose is low. No replacement calculator is active.
- The ETT lip-length aid retains the HTML predecessor's "below 5.5 cm" output below 500 g; the Dart predecessor instead returned 5.5 cm throughout the sub-700 g band. This discrepancy requires clinical resolution.
- ETT and umbilical-line outputs are initial aids only. They do not confirm final position and remain pending current BAPM/local-policy review.
- No treatment interpretation, escalation threshold, compatibility advice, diluent selection, or local policy is presented.
- Apple and Windows platform builds have not yet been verified.
