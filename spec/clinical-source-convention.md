# Clinical Source And Sign-Off Convention

Every active Dart file that defines clinical content, a clinical protocol, a formula, a threshold, a warning, or clinical applicability limits must place a structured comment block immediately below its SPDX header.

```dart
// Clinical source IDs: SRC-001, SRC-006
// Clinical content IDs: PROTOCOL-ADRENALINE-IV
// Clinical reviewer: Dr Example Reviewer
// Clinical sign-off: approved 2026-08-14
// Review due: 2027-08-14
// Safety hazards: HZ-001, HZ-006
```

The comments make the evidence visible beside the implementation. They do not replace the typed registry records, which are the machine-enforced source of truth.

## Rules

- Use stable IDs from the source, content, protocol, and hazard registries.
- Record the source edition or version and URL in the source registry, not only in prose comments.
- A clinical reviewer must be a named person, not a team or organisation.
- Sign-off must state `approved`, `rejected`, or `superseded` and use an ISO 8601 date.
- Every approved item must have a review-due date.
- A material clinical change invalidates existing sign-off until the revised item is reviewed.
- Files containing only generic UI, technical infrastructure, or non-clinical value types do not need a clinical comment block.
- Legacy files under `lib/legacy/` are migration evidence and are not approved clinical source files.
