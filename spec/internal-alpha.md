# Internal Alpha Demo

## Purpose

The internal alpha is a Flutter-native demonstration for the original Neomate authors and project collaborators. It demonstrates the rebuild architecture and selected inherited functionality across mobile, desktop, and web surfaces. It is not clinically reviewed, not approved for patient care, and not a distributable medical-device release.

## Demonstrable Scope

- Adaptive Flutter-native home screen for phone and desktop layouts.
- Native calculator navigation with no HTML renderer or runtime network dependency.
- Live weight validation, mean airway pressure, oxygenation index, daily fluid volume, and glucose infusion rate calculations.
- Five inherited cardiac infusion preparation protocols: dopamine, dobutamine, adrenaline, noradrenaline, and dinoprostone.
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

1. Open the home screen and point out the offline/no-storage status and persistent development warning.
2. Open **Calculators**, then **Physiology and fluids**.
3. Change weight and ventilator values to show live native calculation results.
4. Enter an invalid weight to demonstrate a controlled refusal rather than a misleading result.
5. Open **Cardiac infusions** and show a valid dopamine preparation.
6. Raise the dose or lower the pump rate to demonstrate enforced concentration limits.
7. Select peripheral access to demonstrate the line-access refusal.
8. Open **References** to show inherited/proposed source status and zero clinical sign-offs.
9. Confirm that guidance and checklists remain unavailable pending review.

## Known Limitations

- No clinical calculation or protocol has independent clinical sign-off.
- The fluid alpha uses a deliberately broad inherited engineering guard of 1-300 mL/kg/day, not a prescribing range. A reviewed local fluid policy is still required.
- Infusion values remain inherited baselines pending verification against current BNFC, Medusa, and the approved local formulary.
- Dinoprostone retains the inherited discrepancy between its enforced 1-20 nanograms/kg/min range and displayed usual 5-10 nanograms/kg/min range.
- No treatment interpretation, escalation threshold, compatibility advice, diluent selection, or local policy is presented.
- Apple and Windows platform builds have not yet been verified.
