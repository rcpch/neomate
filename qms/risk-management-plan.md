# Risk Management Plan

Document: RISK-001. Revision/status/approval: see the [controlled document index](README.md#controlled-document-index).

## Scope And File Structure

Risk management covers the complete supplied device and foreseeable use through retirement, including clinical content, arithmetic/units, use error, platform behaviour, dependency/security failures, offline operation, content currency, update/recovery, support, and distribution. The CSO leads this work with engineering, neonatal clinical/pharmacy expertise, and independent review. Manufacturer management must approve risk policy and delegation.

Reuse [clinical-safety/HAZARD-LOG.md](../clinical-safety/HAZARD-LOG.md), [SAFETY-CASE.md](../clinical-safety/SAFETY-CASE.md), and [SAFETY-PLAN.md](../clinical-safety/SAFETY-PLAN.md). The hazard log is the initial risk register, not a completed ISO 14971 file. Add device-specific fields and linked analysis records while retaining existing HZ identifiers. Keep medical-device and DCB conclusions separately reviewable using the SAFETY.md crosswalk referenced in qms/README.md.

## Analysis And Evaluation

Before evaluating residual risk, the CSO proposes and manufacturer management approves severity definitions, probability definitions (including probability of exposure and harm where appropriate), treatment of uncertainty, individual and overall acceptability criteria, benefit-risk escalation, and authorised decision-makers. **These criteria and ratings are [PENDING]; existing “Unassessed” values remain unassessed.** Do not equate device Class I with low clinical consequence or assign risk scores from test pass rates.

For each use scenario record: hazard, reasonably foreseeable sequence of events, hazardous situation, exposed person, possible harm, causes, initial severity/probability/risk, uncertainty, controls, control requirements and implementation links, control verification, new risks introduced by controls, residual risk, acceptability decision/authority, clinical benefit-risk assessment where needed, communication, owner and review state. Identify normal use and foreseeable misuse, including emergency use, interrupted tasks, incorrect weight/units, copied outputs, review-expired content and unsupported platforms.

Initial workshop scope includes HZ-001/HZ-006 calculation and protocol failures; HZ-002/HZ-007 obsolete sources; HZ-003 inappropriate population; HZ-004 use error; HZ-005 unapproved or old build use; and HZ-008 security/privacy. Check for gaps such as failure to reach offline users during an urgent correction. A workshop and ratings have not yet been completed.

## Control Selection And Evidence

Prefer safe design, then protective measures, then information/training. Warnings or independent user checks must not silently substitute for an achievable design control. For each chosen measure, justify effectiveness and feasibility, assess interactions, and verify implementation and clinical effectiveness.

Example trace structure, **not an acceptance record**: HZ-001 -> a unit-explicit calculation requirement -> deterministic domain function -> source-derived independent expected vectors -> input/result UI validation -> clinical reviewer assessment -> residual-risk decision -> exact released configuration. Existing implementation tests cannot alone establish source correctness or clinical validation.

The internal development posture remains as directed in SAFETY.md: configured clinical constraints are non-blocking review advisories. The CSO must make a separate documented decision on release-time controls and validate that posture before clinical distribution. This draft changes no calculation or runtime gate.

## Review And Release Output

Review risks on each safety-relevant change, source/security alert, complaint or incident, before release and at least annually. Document individual residual-risk decisions, overall residual-risk evaluation against the approved policy, risk-control completeness, consistency with clinical evaluation/IFU, and transferred controls. Record a risk-management report for each clinical release with reviewer independence and approval; outstanding unacceptable or unassessed release risks block release.

Where DCB obligations apply, supply the clinical safety case report and explicit deployer assumptions, residual risks, local verification and transferred controls. Deployers assess their own DCB0160 responsibilities; manufacturer risk work does not discharge them. PMS-001 feeds new evidence back into the risk file and clinical evaluation for released and future configurations.
