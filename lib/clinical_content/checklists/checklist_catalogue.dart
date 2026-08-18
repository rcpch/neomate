// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

// Clinical source IDs: SRC-006
// Clinical content IDs: CONTENT-CHECKLIST-CATALOGUE
// Clinical reviewer: none
// Clinical sign-off: none
// Review due: none
// Safety hazards: HZ-002, HZ-004, HZ-007
//
// STATUS: NOT APPROVED FOR CLINICAL USE. The records below preserve unverified
// checklist content for structured clinical review in an internal build.

import 'checklist.dart';

const clinicalChecklists = <ClinicalChecklist>[
  ClinicalChecklist(
    id: 'CHECKLIST-TRANSPORT-REFERRAL',
    title: 'Referral for transport',
    summary:
        'Information to prepare before calling a neonatal transport service.',
    sections: [
      ClinicalChecklistSection(title: 'Time-critical transfer', items: [
        ClinicalChecklistItem(
            id: 'transport-1',
            text:
                'Assess for unstable respiratory or cardiovascular failure not responding to appropriate management, including FiO₂ 100%, pH < 7.1 with pCO₂ > 9 kPa, arterial oxygen < 5 kPa on two consecutive gases, persistent unstable pneumothorax, or persistent hypotension with acidosis.'),
        ClinicalChecklistItem(
            id: 'transport-2', text: 'Intestinal perforation.'),
        ClinicalChecklistItem(
            id: 'transport-3',
            text:
                'Suspected duct-dependent cardiac lesion not responding to prostaglandin.'),
        ClinicalChecklistItem(
            id: 'transport-4',
            text:
                'Ventilated infant with tracheo-oesophageal fistula with or without atresia.'),
        ClinicalChecklistItem(id: 'transport-5', text: 'Gastroschisis.'),
      ]),
      ClinicalChecklistSection(title: 'Background information', items: [
        ClinicalChecklistItem(
            id: 'transport-6',
            text:
                'Antenatal, delivery and resuscitation history, including Apgar scores.'),
        ClinicalChecklistItem(
            id: 'transport-7',
            text:
                'Ventilation mode, settings, FiO₂, SpO₂, ETT size and length, latest gases, and ETT position on chest x-ray.'),
        ClinicalChecklistItem(
            id: 'transport-8',
            text:
                'Sedation, paralysis, infusions, blood glucose, inotropes and vascular access.'),
        ClinicalChecklistItem(
            id: 'transport-9',
            text: 'Temperature, antibiotics and congenital abnormalities.'),
      ]),
    ],
  ),
  ClinicalChecklist(
    id: 'CHECKLIST-TERM-RESPIRATORY-DISTRESS',
    title: 'Term newborn in respiratory distress',
    summary: 'Assessment prompts for a term baby with respiratory distress.',
    sections: [
      ClinicalChecklistSection(title: 'Assessment', items: [
        ClinicalChecklistItem(
            id: 'resp-1',
            text:
                'Assess work of breathing, pulse oximetry, blood gas including glucose, and consider an early chest x-ray.'),
        ClinicalChecklistItem(
            id: 'resp-2',
            text:
                'If sepsis is suspected, confirm antibiotics have been prescribed and given.'),
        ClinicalChecklistItem(
            id: 'resp-3',
            text:
                'Consider pneumothorax, diaphragmatic hernia and congenital anomalies.'),
        ClinicalChecklistItem(
            id: 'resp-4',
            text:
                'Consider evolving meconium aspiration syndrome and review the birth history.'),
        ClinicalChecklistItem(
            id: 'resp-5',
            text:
                'Review CPAP use and consider early intubation with FiO₂ > 40%, increasing distress, poor oxygenation or high pCO₂.'),
        ClinicalChecklistItem(
            id: 'resp-6',
            text:
                'Make a clear review and escalation plan and seek tertiary or transport advice if needed.'),
      ])
    ],
  ),
  ClinicalChecklist(
    id: 'CHECKLIST-EXTREME-PRETERM-DELIVERY',
    title: 'Extreme preterm delivery',
    summary:
        'Preparation prompts for the delivery of an extremely preterm baby.',
    sections: [
      ClinicalChecklistSection(title: 'Parents and team', items: [
        ClinicalChecklistItem(
            id: 'preterm-1',
            text:
                'Confirm the neonatal team has spoken to the parents and explored their ideas, concerns, expectations and support.'),
        ClinicalChecklistItem(
            id: 'preterm-2',
            text:
                'Notify the consultant, senior neonatal nurse and staff retrieving the incubator; allocate clear roles.'),
        ClinicalChecklistItem(
            id: 'preterm-3',
            text:
                'Confirm cord gases and all equipment, surfactant, batteries, gas and supplies are ready.'),
      ]),
      ClinicalChecklistSection(title: 'Thermoregulation and airway', items: [
        ClinicalChecklistItem(
            id: 'preterm-4',
            text:
                'Warm the room, use the overhead heater, prepare a food-grade plastic bag and hat.'),
        ClinicalChecklistItem(
            id: 'preterm-5',
            text:
                'Prepare an appropriately sized ETT and intended length; consider CO₂ detection and gastric tube placement.'),
      ]),
      ClinicalChecklistSection(
          title: 'Breathing, circulation and next steps',
          items: [
            ClinicalChecklistItem(
                id: 'preterm-6',
                text:
                    'Attach pre-ductal pulse oximetry and use the least pressure and oxygen concentration necessary.'),
            ClinicalChecklistItem(
                id: 'preterm-7',
                text:
                    'Plan dextrose, vascular access, fluid bolus and inotropic support.'),
            ClinicalChecklistItem(
                id: 'preterm-8',
                text:
                    'Arrange transfer advice if required and support early maternal breast milk expression.'),
          ]),
    ],
  ),
  ClinicalChecklist(
    id: 'CHECKLIST-TERM-COLLAPSE',
    title: 'Term baby collapse on the postnatal ward',
    summary:
        'Early assessment prompts after systematic newborn life support stabilisation.',
    sections: [
      ClinicalChecklistSection(title: 'Assessment and escalation', items: [
        ClinicalChecklistItem(
            id: 'collapse-1',
            text:
                'Check blood glucose and blood gas, including lactate if possible; consider metabolic and hypoglycaemic causes.'),
        ClinicalChecklistItem(
            id: 'collapse-2',
            text:
                'Consider bacterial and viral sepsis and start antibiotics where indicated.'),
        ClinicalChecklistItem(
            id: 'collapse-3',
            text:
                'Assess for cardiac disease using saturations, pre/post-ductal difference, femoral pulses and auscultation; consider prostaglandin where indicated.'),
        ClinicalChecklistItem(
            id: 'collapse-4',
            text:
                'Consider congenital anomaly, seizures and arrhythmia; pass an NG tube and obtain a chest x-ray where indicated.'),
        ClinicalChecklistItem(
            id: 'collapse-5',
            text:
                'Discuss early with tertiary neonatal intensive care or the transport service.'),
      ])
    ],
  ),
  ClinicalChecklist(
    id: 'CHECKLIST-ENCEPHALOPATHY',
    title: 'Term baby with encephalopathy',
    summary:
        'Initial assessment prompts following a suspected hypoxic insult at birth.',
    sections: [
      ClinicalChecklistSection(title: 'Early assessment', items: [
        ClinicalChecklistItem(
            id: 'hie-1',
            text:
                'Perform and document a formal neurological examination before muscle relaxants or sedatives where possible.'),
        ClinicalChecklistItem(id: 'hie-2', text: 'Obtain cord gases.'),
        ClinicalChecklistItem(
            id: 'hie-3',
            text:
                'Assess whether therapeutic hypothermia may be indicated and discuss early with the local cooling centre.'),
        ClinicalChecklistItem(
            id: 'hie-4',
            text: 'Consider cerebral function monitoring if available.'),
      ]),
      ClinicalChecklistSection(title: 'Information and referral', items: [
        ClinicalChecklistItem(
            id: 'hie-5',
            text:
                'Identify possible sentinel events and document timings of first heart rate, first gasp and regular respiration.'),
        ClinicalChecklistItem(
            id: 'hie-6',
            text:
                'Call the local cooling centre for advice as early as possible.'),
      ]),
    ],
  ),
  ClinicalChecklist(
    id: 'CHECKLIST-UNDERVENTILATED-BABY',
    title: 'The underventilated baby',
    summary:
        'Review prompts for a stable baby with suboptimal gases or oxygen saturation.',
    sections: [
      ClinicalChecklistSection(title: 'Targets and context', items: [
        ClinicalChecklistItem(
            id: 'under-1',
            text:
                'Confirm the intended saturation, pH and pCO₂ targets for this baby.'),
        ClinicalChecklistItem(
            id: 'under-2',
            text:
                'Review recent ventilation changes, procedures, nursing care and whether the baby tends to fluctuate.'),
      ]),
      ClinicalChecklistSection(
          title: 'Mechanical and ventilator factors',
          items: [
            ClinicalChecklistItem(
                id: 'under-3',
                text:
                    'Check ETT position, leak, chest movement and synchrony; assess analgesia, sedation or paralysis requirements.'),
            ClinicalChecklistItem(
                id: 'under-4',
                text:
                    'Review PIP, PEEP, rate, tidal volume, mean airway pressure, amplitude, frequency and dead space as applicable.'),
            ClinicalChecklistItem(
                id: 'under-5',
                text:
                    'Repeat gases and imaging according to the clinical plan and senior advice.'),
          ]),
    ],
  ),
  ClinicalChecklist(
    id: 'CHECKLIST-VENTILATED-DETERIORATION',
    title: 'Acute deterioration of a ventilated baby',
    summary: 'A DOPE-structured assessment of sudden deterioration.',
    sections: [
      ClinicalChecklistSection(title: 'Displacement and obstruction', items: [
        ClinicalChecklistItem(
            id: 'dope-1',
            text:
                'Compare ETT lip measurement with the documented length; assess chest movement, air entry, pressure delivery, leak and exhaled CO₂.'),
        ClinicalChecklistItem(
            id: 'dope-2',
            text:
                'Auscultate, manually ventilate, assess recent suction findings and consider an obstructing plug or pulmonary haemorrhage.'),
      ]),
      ClinicalChecklistSection(title: 'Pneumothorax and equipment', items: [
        ClinicalChecklistItem(
            id: 'dope-3',
            text:
                'Assess for pneumothorax using clinical examination, transillumination and urgent imaging as appropriate.'),
        ClinicalChecklistItem(
            id: 'dope-4',
            text:
                'Check ventilator alarms and trace the complete circuit with a second checker.'),
        ClinicalChecklistItem(
            id: 'dope-5',
            text:
                'If manual ventilation improves the situation, consider replacing the ventilator or circuit.'),
      ]),
    ],
  ),
  ClinicalChecklist(
    id: 'CHECKLIST-UNEXPECTED-POOR-CONDITION',
    title: 'Term baby born in unexpectedly poor condition',
    summary:
        'Prompts for a neonatal team attending an unexpectedly compromised term baby.',
    sections: [
      ClinicalChecklistSection(title: 'Stabilise and investigate', items: [
        ClinicalChecklistItem(
            id: 'poor-1',
            text:
                'Use a systematic newborn life support approach and re-evaluate regularly.'),
        ClinicalChecklistItem(
            id: 'poor-2',
            text: 'Clarify the history, antenatal problems and cord gas.'),
        ClinicalChecklistItem(
            id: 'poor-3',
            text:
                'Consider sepsis, hypoxic insult, drugs or toxins, diaphragmatic hernia and tracheo-oesophageal fistula.'),
      ]),
      ClinicalChecklistSection(title: 'Next steps', items: [
        ClinicalChecklistItem(
            id: 'poor-4',
            text:
                'Assess whether therapeutic hypothermia may be indicated and contact the local cooling centre.'),
        ClinicalChecklistItem(
            id: 'poor-5',
            text:
                'Seek early advice from a senior colleague, tertiary neonatal intensive care or transport service.'),
      ]),
    ],
  ),
  ClinicalChecklist(
    id: 'CHECKLIST-SUSPECTED-NEC',
    title: 'Suspected necrotising enterocolitis',
    summary: 'Initial management prompts for a baby with suspected NEC.',
    sections: [
      ClinicalChecklistSection(title: 'Airway and breathing', items: [
        ClinicalChecklistItem(
            id: 'nec-1',
            text: 'Consider early intubation and optimise ventilation.'),
        ClinicalChecklistItem(
            id: 'nec-2',
            text:
                'Assess and provide adequate analgesia; consider whether muscle relaxation is required.'),
      ]),
      ClinicalChecklistSection(title: 'Circulation and next steps', items: [
        ClinicalChecklistItem(
            id: 'nec-3',
            text:
                'Assess intravascular volume, blood-product requirements and the fluid-management plan.'),
        ClinicalChecklistItem(
            id: 'nec-4',
            text:
                'Monitor strict fluid balance and arrange blood products early where required.'),
        ClinicalChecklistItem(
            id: 'nec-5',
            text:
                'Insert a large-bore gastric tube, use free drainage and define an aspiration/replacement plan.'),
        ClinicalChecklistItem(
            id: 'nec-6',
            text:
                'Obtain abdominal imaging and assess for pneumoperitoneum, portal venous gas and pneumatosis.'),
        ClinicalChecklistItem(
            id: 'nec-7',
            text: 'Discuss early with the neonatal surgical centre.'),
      ]),
    ],
  ),
];
