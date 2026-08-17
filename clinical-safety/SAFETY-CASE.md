# Clinical Safety Case

## Claim

Neomate 2 may only be deployed for its approved intended purpose when its residual clinical risk is demonstrated to be acceptable through controlled content, deterministic implementation, independent verification, usable presentation, and governed release.

## Current Argument Status

The claim is not established. This repository is an inherited codebase with unverified clinical content and legacy calculation logic. No clinical deployment is permitted.

Implemented workflows remain exercisable in internal development builds to support clinical review. This development-review posture does not contribute evidence of clinical approval and must not be carried into a distributable release without an explicit Clinical Safety Officer decision recorded against the final release controls.

## Required Evidence

| Argument element | Required evidence | Current status |
| --- | --- | --- |
| Intended purpose and scope are defined | Approved intended-purpose statement and excluded uses | Missing |
| Clinical content is correct and current | Source register, clinical review, review dates, and change records | Missing |
| Calculations are correct | Independent source-derived vectors, boundary tests, and review | Missing |
| Use-error hazards are controlled | Usability and accessibility evidence linked to hazards | Missing |
| Software changes are controlled | Reviewed changes, test evidence, build provenance, release record | In progress |
| Security and privacy risks are controlled | Threat assessment and deployment controls | Missing |
| Residual risks are accepted | Signed hazard-log and release approval | Missing |

## Evidence Rules

Automated tests provide implementation evidence only. They do not validate clinical sources or substitute for independent clinical review. Each clinical test must be traceable to a reviewed source before it contributes to release evidence.
