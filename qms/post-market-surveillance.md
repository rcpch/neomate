# Post-market Surveillance, Vigilance And Corrective Action

Document: PMS-001. Revision/status/approval: see the [controlled document index](README.md#controlled-document-index).

## Scope And Activation

This draft defines the proposed GB PMS system and pre-market problem-resolution process. The legal manufacturer remains responsible for vigilance even when tasks are delegated. The quality lead owns intake, tracking and CAPA; the CSO owns clinical harm assessment; engineering investigates technical causes; an appointed regulatory reporter and deputy manage reporting. Named reporter, deputy, monitored contact route, MORE access, cover and training are **[PENDING]** and must be exercised before supply.

The strengthened GB PMS regime took effect on 2025-06-16. REG-001 S6/S7 provide the source basis. Before clinical release approve a product-specific PMS baseline with device identity/version families, lifetime, PMS period, markets, first supply/put-into-service date, review dates, methods/thresholds and owners. None of those dates should be inferred from the age of inherited software. Determine whether any already-supplied product creates ongoing duties as a separate investigation.

## Collection And Analysis Plan

The app's no-network/no-telemetry boundary remains. Collect feedback through controlled external support routes, structured follow-up with neonatal units/clinician users, app-store feedback, source/guideline monitoring, vulnerability reports, relevant literature and publicly available safety information on similar devices. Assess how patient/public perspectives are relevant and achievable for a clinician-facing neonatal tool and record the approach. Lack of telemetry makes usage/exposure estimates uncertain; document denominators and uncertainty rather than equating downloads with clinical uses.

Proposed operating cadence: continuously receive reports with cover for calendar-day deadlines; review source/security signals and aggregate complaints monthly; obtain structured user feedback and review trends quarterly; review the overall PMS plan and clinical evaluation at least annually and after major signals. These cadences need resources and approval; they are not evidence of an operating service.

Before supply predefine incident categories, expected rates or justified alternatives, data sources, denominators, statistical/significance methods, thresholds and escalation rules. Repeated unit/weight errors, discrepant outputs, outdated protocols, unavailable updates, crashes and use errors require analysis even when no harm occurred. Any potentially serious issue triggers immediate clinical/reportability triage independently of routine trend thresholds. A significant adverse trend may need reporting in addition to individual incidents.

## Intake And Immediate Action

1. Record unique incident ID, earliest manufacturer awareness timestamp, reporter/channel, country, device/version/platform/profile, reported event, potential/actual harm, evidence preserved, linked hazards and immediate containment. Restrict identifiable information to the approved system; use de-identified references in Git.
2. Escalate potentially safety-relevant reports immediately to the CSO and reporter/deputy. Protect people and preserve the original artefact/configuration and logs. Do not alter evidence in a way that compromises investigation; assess MHRA notification requirements before destructive investigation.
3. Assess serious incident, use error, near miss, security consequence, trend and FSCA reporting requirements with rationale. If uncertain, submit within the relevant timeframe using available information and follow up; do not wait for complete root-cause analysis or a management meeting.
4. Track decision, accountable person, deadline, submission/acknowledgement reference, follow-ups and final report. A public issue or user Yellow Card report does not fulfil manufacturer reporting duties.

## GB Vigilance Clocks

Notify immediately on awareness of a reportable incident. The following are maximum periods from manufacturer awareness, not target waiting periods (REG-001 S7):

| Event | Maximum reporting period |
| --- | --- |
| Serious public health threat | 2 calendar days |
| Death or unanticipated serious deterioration in health | 10 calendar days |
| Other serious incident | 15 calendar days |

Serious incidents include events that might have led or might lead to serious harm, including intercepted use errors where criteria are met. The reporter must record how the clock was calculated and arrange cover for weekends/leave. Use the current MORE route/forms for incident, trend and relevant FSCA reports; check jurisdiction-specific requirements. This is a GB plan and does not substitute for NI/EU vigilance procedures.

## Field Safety Corrective Action And Offline Reach

Assess whether a correction affecting devices outside manufacturer control addresses risk of death/serious deterioration/public-health threat and constitutes FSCA. Notify the MHRA before undertaking FSCA, with proposed searchable field safety notice (FSN), affected versions/profiles, hazard evaluation, corrective action and communication plan. Where urgent protection is necessary, apply the urgent-action provisions in current guidance without delaying protective action; record chronology and notify promptly. Coordinate required UKRP/Approved Body communications where applicable.

The offline/no-persistence design requires a practical user-reach strategy: approved support contacts for deploying units, distributor/store notices, published safety notices, and app-store communication. New builds can display relevant notices without introducing runtime network access, but this cannot reach an old offline installation by itself. Record estimated affected users/configurations, contact channels, acknowledged required actions, unresolved reach and follow-up. Neither publishing a notice nor an email delivery receipt proves effective correction. Exercise this process with a simulated wrong-dose correction before clinical supply.

Record updates, safe replacement or withdrawal instructions, compatibility, unavailable-update handling and why rollback is clinically safe. Retain notices for the applicable period. Discontinuation or removing a store listing does not end duties for versions still in use. Review special notification requirements for overseas FSCA affecting the same device type, even if GB stock is unaffected.

## Nonconformity And CAPA

Use this process for test failures, source discrepancies, supplier defects, complaints, audit findings and process deviations before and after market entry:

1. Log the nonconformity and affected configuration; contain or quarantine the candidate/release where needed. Make the immediate correction separately from root-cause action.
2. Determine safety/regulatory impact and whether other features, profiles, platforms, supplied versions or processes share the cause. Link hazards and reportability assessment.
3. Investigate cause and open CAPA proportionate to recurrence/impact. Record owner, planned action, due date, verification method, effectiveness criterion and review date before implementation.
4. Implement through controlled change; independently verify relevant clinical fixes and assess new risks, evaluation, labelling and field action implications.
5. Close only after evidence shows correction and sustained effectiveness against the specified criterion, with quality/CSO review as relevant. Escalate overdue or ineffective actions to management and reopen when necessary. Do not waive legal obligations or unacceptable risks via a process deviation.

## PMS Outputs And Records

If Class I is confirmed, prepare the first PMS report (PMSR) within 3 years of first placement on the market or putting into service, whichever is sooner, and update when necessary and at least every 3 years. Proposed project practice is an annual PMSR review/update and immediate review on material signals. If another class is approved, select the corresponding PSUR requirements instead.

The report must identify configuration and reporting period, data/limitations, analysis, benefit-risk conclusions, clinical follow-up findings as applicable, preventive/corrective actions including FSCA and rationale, and changes to risk/evaluation/technical documentation. Make the current report available to MHRA within 3 UK working days on request. Relevant incident/FSCA investigation information also has 3-working-day provision requirements unless otherwise specified by MHRA.

Retain PMS records for at least the applicable non-implantable minimum of 10 years and through the entire PMS period if longer; final retention triggers/schedule are confirmed under QMS-002. Retain incident correspondence, report submissions and CAPA effectiveness evidence. Use REC-001 templates and an access-tested controlled store. Review the plan and reporting references whenever requirements change.
