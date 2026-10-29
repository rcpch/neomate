# Quality Management System

**Draft QMS baseline, 29 October 2026. Not approved for clinical deployment, conformity declaration, or registration submission.** Class I is the requested route under assessment; neither Class I eligibility nor ISO 13485 certification is established by these documents.

## Start Here

1. [Quality manual](quality-manual.md) - scope, accountability, quality objectives, and process map.
2. [Regulatory assessment](regulatory-assessment.md) - medical-device applicability, Great Britain Class I route, classification questions, and dated MHRA references.
3. [Readiness register](readiness-register.md) - evidence gaps, accountable roles, decisions, and adoption gates.
4. [Document and record control](document-control.md) - how drafts become approved procedures and evidence is retained.

## Controlled Document Index

All QMS documents below are draft revision 0.1, prepared on 2026-10-29, with quality lead as document custodian. Approval and effective date are **[PENDING]**. This index controls the existing development plan and release checklist as well as the new documents. Subsequent revisions must update this index and include an approval record identifying the exact source revision. Existing project safety rules remain in force while these procedures await adoption.

| ID | Document | Accountable process owner |
| --- | --- | --- |
| QMS-001 | [Quality manual](quality-manual.md) | Quality lead |
| QMS-002 | [Document and record control](document-control.md) | Quality lead |
| REG-001 | [Medical-device and regulatory assessment](regulatory-assessment.md) | Product owner; regulatory reviewer appointment pending |
| DEV-001 | [Software development plan](software-development-plan.md) | Engineering lead |
| RISK-001 | [Risk management plan](risk-management-plan.md) | Clinical Safety Officer |
| EVAL-001 | [Clinical evaluation and usability plan](clinical-evaluation-plan.md) | Clinical content lead |
| SUP-001 | [Supplier, dependency, and tool control](supplier-control.md) | Engineering lead |
| PMS-001 | [Post-market surveillance, vigilance, and corrective action](post-market-surveillance.md) | Quality lead and Clinical Safety Officer |
| TF-001 | [Technical documentation index](technical-file-index.md) | Quality lead |
| REL-001 | [Release checklist](release-checklist.md) | Release approver |
| REC-001 | [Record templates](record-templates.md) | Quality lead |
| QMS-003 | [Readiness register](readiness-register.md) | Quality lead |

The clinical safety plan, case, and hazard log remain authoritative at [clinical-safety/](../clinical-safety/). Clinical source provenance remains in [spec/source-register.md](../spec/source-register.md). Reuse evidence by stable link rather than duplicating it.

## Basis And Limits

The structure follows the repository-native, evidence-linked approach in [SAFETY.md](https://github.com/pacharanero/SAFETY.md), reviewed from the local `/home/marcus/code/SAFETY.md/` guide, particularly its [risk-management crosswalk](https://github.com/pacharanero/SAFETY.md/blob/main/spec/mappings/iso14971-dcb-to-safety-md.md). That guide supports clinical safety documentation; it does not supply a complete medical-device QMS. Regulatory sources and their review limits are recorded in REG-001.

Procedures, plans, executed records, and approvals have different evidential weight. An empty template or passing software test does not demonstrate that a procedure has operated, a clinical claim is supported, or a risk is acceptable. The readiness register tracks these gaps explicitly.
