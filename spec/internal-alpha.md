# Internal Alpha Demo

## Purpose

The internal alpha is a Flutter-native demonstration for the original Neomate authors and project collaborators. It demonstrates the rebuild architecture and selected inherited functionality across mobile, desktop, and web surfaces. It is not clinically reviewed, not approved for patient care, and not a distributable medical-device release.

## Demonstrable Scope

- Adaptive Flutter-native home screen for phone and desktop layouts, using the inherited Neomate logo and Lato type family.
- Prominent session-only baby-weight context passed into available calculator workflows, with measured/estimated status visible.
- Familiar clinical accordion categories loosely correlated with the original Neomate task layout while retaining native Flutter controls and accessibility semantics.
- Familiar bottom navigation for workspace, calculators, checklists, and references; unavailable areas remain visibly gated pending review.
- Native calculator navigation with no HTML renderer or runtime network dependency.
- Live weight validation, mean airway pressure, oxygenation index, daily fluid volume, glucose infusion rate, electrolyte requirement, and additive stock-volume calculations.
- Inherited ETT internal-diameter, oral lip-length, UVC insertion-length, and UAC insertion-length aids with explicit position-confirmation warnings.
- Nine inherited named infusion preparation protocols: dopamine, dobutamine, adrenaline, noradrenaline, dinoprostone, morphine, vecuronium, clonazepam, and midazolam.
- Explicit separation of sedation from neuromuscular paralysis, including a prominent warning that vecuronium provides neither analgesia nor sedation.
- Enforced inherited dose, concentration, intravenous-route, and central/umbilical-venous-access controls.
- Native source and review-status presentation.
- Controlled invalid-input and no-result states.
- Persistent internal-alpha warnings stating that outputs are not approved for patient care.
- No analytics, telemetry, network requests, or patient-data persistence.

Clinical guidance and checklist destinations remain visibly unavailable because approved content has not yet been migrated.

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
3. Raise the dose or lower the pump rate to demonstrate enforced concentration limits, then select peripheral access to demonstrate the line-access refusal.
4. Open **Sedation and paralysis**, select vecuronium, and point out that paralysis is explicitly distinguished from analgesia and sedation.
5. Open **Neurology** and show that the inherited clonazepam default is refused because it exceeds its own stated concentration ceiling.
6. Open **Intubation and airway** and **Central lines** to show the inherited ETT/UVC/UAC aids and mandatory placement-confirmation warnings.
7. Open **Intravenous fluids**, then **Electrolytes and compounding**, to show the explicit prescription and stock-preparation steps.
8. Open **Oxygenation index** and change ventilator values to show live native calculation results.
9. Enter an invalid weight to demonstrate a controlled refusal rather than a misleading result.
10. Use the bottom **Calculators** destination to show the complete alpha calculator catalogue.
11. Open **References** to show inherited/proposed source status and zero clinical sign-offs.
12. Confirm that locked category actions and checklists remain unavailable pending review.

## Known Limitations

- No clinical calculation or protocol has independent clinical sign-off.
- The fluid alpha uses a deliberately broad inherited engineering guard of 1-300 mL/kg/day, not a prescribing range. A reviewed local fluid policy is still required.
- The electrolyte alpha uses a deliberately broad 0.1-100 mmol/kg/day engineering guard, not a prescribing range. Users must enter a prescription already selected from an approved policy and independently verify the stock preparation.
- Infusion values remain inherited baselines pending verification against current BNFC, Medusa, and the approved local formulary.
- Dinoprostone retains the inherited discrepancy between its enforced 1-20 nanograms/kg/min range and displayed usual 5-10 nanograms/kg/min range.
- Morphine retains conflicting inherited ranges: 0-60 micrograms/kg/hour in numeric fields, 5-20 in displayed text, and occasional use up to 40 in narrative text. The alpha refuses zero and enforces 5-60; its upper range and inherited concentration ceiling require review.
- Vecuronium retains conflicting concentration fields; the stricter human-readable 2 mg/mL ceiling is enforced. Its protocol remains unreviewed, and paralysis must never be mistaken for analgesia or sedation.
- Clonazepam retains a default preparation that exceeds its own stated 12 micrograms/mL ceiling at common neonatal weights. The alpha refuses that output, and clinical review must determine whether the protocol should be retired.
- Midazolam retains conflicting inherited dose ranges of 10-60, 30-60, and 30-300 micrograms/kg/hour. The shared numeric 30-300 bounds are enforced pending clinical resolution.
- The ETT lip-length aid retains the HTML predecessor's "below 5.5 cm" output below 500 g; the Dart predecessor instead returned 5.5 cm throughout the sub-700 g band. This discrepancy requires clinical resolution.
- ETT and umbilical-line outputs are initial aids only. They do not confirm final position and remain pending current BAPM/local-policy review.
- No treatment interpretation, escalation threshold, compatibility advice, diluent selection, or local policy is presented.
- Apple and Windows platform builds have not yet been verified.
