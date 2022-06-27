///
///
///   Neomate 2.0
///
///   Original app by Christopher Kelly
///
///   Reimplemented for Dart/Flutter by Lee Collier
///
///   Checklist classes
///
///
///

class Checklist {
  String heading;
  String subheading;
  String abstract;
  List<ChecklistSection> sections;

  Checklist({
    required this.heading,
    required this.subheading,
    required this.abstract,
    required this.sections,
  });
}

class ChecklistSection {
  String sectionHeading;
  List<String> items;
  ChecklistSection({
    required this.sectionHeading,
    required this.items,
  });
}

List<Checklist> checklistDb = [
  Checklist(
      heading: 'Referral for Transport',
      subheading:
          'Information required to make a good referral to your neonatal transport service',
      abstract:
          '''Try to have the following information available before you call the transport team.
    For London NTS contact details, please <a href="http://london-nts.nhs.uk/professionals/make-a-referral/">click here</a>''',
      sections: [
        ChecklistSection(
          sectionHeading: 'Is this a time critical transfer?',
          items: [
            '''<p>Unstable respiratory or cardiovascular failure not responding to appropriate management, including:</p>
            <ul><li>requiring FiO2 100%</li>
						<li>pH < 7.1 and pCO2 > 9kPa</li>
						<li>arterial oxygen < 5kPa on 2 consecutive gas measurements</li>
						<li>persistent unstable pneumothorax despite chest drain</li>
						<li>persistent mean blood pressure below corrected gestational age, measured on arterial line; if measured with cuff only, there should be acidosis (pH < 7.1).</li></ul>''',
            '''Intestinal perforation''',
            '''Suspected duct-dependent cardiac lesion not responding to prostin''',
            '''Ventilated infant with tracheo-oesophageal fistula +/- atresia''',
            '''Gastroschisis'''
          ],
        ),
        ChecklistSection(
          sectionHeading: 'Background Information',
          items: [
            'Brief antenatal, delivery and resuscitation history, Apgar scores.',
            'Ventilation: mode, pressures, rate, Ti, FiO2, SpO2, ETT size/length, latest gas results. Is the ET tube tip between T1-T2 on CXR?',
            'Sedation and paralysis?',
            'Fluids: infusions running, blood sugars',
            'Inotropes required?',
            'Lines inserted',
            'Temperature',
            'Antibiotics given?',
            'Any other information: e.g. congenital abnormalities',
          ],
        ),
      ]),
  Checklist(
      heading: 'Term Newborn in Respiratory Distress',
      subheading:
          'Key things to consider when assessing a baby in respiratory distress',
      abstract:
          'While most babies will improve (e.g. transient tachypnoea of the newborn), it is very important to flag worsening respiratory distress, as it can be the only presenting sign of many underlying pathologies.',
      sections: [
        ChecklistSection(
          sectionHeading: '',
          items: [
            '''Have you assessed work of breathing, pulse oximetry (be concerned if SpO2 &lt; 95%) and blood gas (including glucose)? Consider an early CXR.''',
            '''If you are suspecting sepsis, have you ensured that antibiotics have been prescribed and given?''',
            '''Have you ruled out pneumothorax, diaphragmatic hernia and congenital anomalies?''',
            '''Could this be an evolving meconium aspiration syndrome? (Carefully recheck the birth history, and have a low threshold for intubation)''',
            '''Stop and think before using CPAP in term babies. Consider intubation early if:
                FiO2 > 40%
				        increasing respiratory distress
				        evidence of poor oxygenation or high pCO2''',
            '''Have you made a clear plan for review and escalation? (if in doubt, discuss with your tertiary neonatal intensive care unit,
            or neonatal transport service.)''',
          ],
        ),
      ]),
  Checklist(
    heading: 'Extreme Preterm Delivery',
    subheading: 'Key things to remember when attending a preterm delivery',
    abstract:
        'The following is a checklist to help guide the delivery of an extremely premature baby. The checklist is not a comprehensive how to guide - it provides reminders of only the most critical steps.',
    sections: [
      ChecklistSection(
        sectionHeading: 'Preparing Parents',
        items: [
          '''Has the neonatal team spoken to the parents?''',
          '''Have you explored their ideas, concerns and expectations?
					Ethics: <a href="#popbapmguidelines" data-corners="false">Ethical guidance from BAPM</a> is very helpful when speaking to parents, and also includes many relevant statistics.
					Statistics: An overview is helpful for some parents. The <a href="http://www.bliss.org.uk/Handlers/Download.ashx?IDMF=f3d01126-3af4-426d-b9cc-cc1287aaf9be" target="_system" class="external">Bliss information sheet on Epicure</a> can be useful here.'''
              '''Do the parents have adequate support?''',
        ],
      ),
      ChecklistSection(
        sectionHeading: 'Preparing Your Team',
        items: [
          '''Have you notified all important people? i.e. Consultant on-call, senior neonatal nurse, porters to retrieve incubator''',
          '''Have you allocated everybody clear roles?''',
          '''Does the midwife know to take cord gases?''',
          '''Is all necessary equipment ready, available, and checked? Don't forget surfactant, batteries, gas and supplies.''',
        ],
      ),
      ChecklistSection(
        sectionHeading: 'Thermoregulation',
        items: [
          '''Is the overhead heater switched onto full power?''',
          '''Do you have a plastic bag (food grade) ready? Remember not to cover the baby with towels while in the plastic bag.''',
          '''Is the room as warm as possible? Close doors, switch off air conditioning.''',
          '''Do you have a hat ready? Remember: hat on before intubation.''',
        ],
      ),
      ChecklistSection(
        sectionHeading: 'Airway management',
        items: [
          '''	Prepare an appropriately-sized endotracheal tube, and identify desired length before birth (<a href="#popett" data-corners="false">click here for table</a>). Ensure tube is at recommended length before surfactant delivery.''',
          '''	Consider using a CO2 detection method to confirm tube placement.''',
          '''	Consider gastric tube placement.''',
        ],
      ),
      ChecklistSection(
        sectionHeading: 'Breathing',
        items: [
          '''Have you attached a pulse oximeter to the right hand? The hand may remain inside the bag.''',
          '''Have you thought about using the least pressure and lowest oxygen concentration necessary? Start in air; if the chest is moving well, consider reducing the positive inspiratory pressure (PIP)''',
        ],
      ),
      ChecklistSection(
        sectionHeading: 'Circulation',
        items: [
          '''	When should the dextrose infusion begin? Do my local circumstances mean that I should insert a cannula and start dextrose on the labour ward before transfer to NICU?''',
          '''Have you prepared equipment for central umbilical lines? Aim to have lines inserted within the first hour after birth.''',
          '''Is there a need for a fluid bolus? Have you considered inotropic support prior to multiple fluid boluses?''',
        ],
      ),
      ChecklistSection(
        sectionHeading: 'Next steps',
        items: [
          '''If transfer is required, call your tertiary neonatal intensive care unit for advice, or contact your neonatal transport service.''',
          '''Early maternal breast milk - does the mother know how to express colostrum and the benefits for her baby?''',
        ],
      ),
    ],
  ),
  Checklist(
    heading: 'Term Baby Collapse on Postnatal Ward',
    subheading:
        'Checklist for early assessment and management of a term baby collapse of unknown cause',
    abstract:
        'After stabilisation with a systematic newborn life support approach, please use this checklist to help remember the critical steps in this situation.',
    sections: [
      ChecklistSection(
        sectionHeading: '',
        items: [
          '''Have you checked a blood sugar and blood gas (with lactate if possible)? Consider metabolic or hypoglycaemic causes''',
          '''Could this be sepsis? Also think viral causes. Have you started antibiotics?''',
          '''Have you considered a cardiac condition? Consider strongly if:
					SpO2 < 95% in the absence of respiratory distress, not responding to supplementary oxygen. (Check for a pre/post saturation difference).
					Femoral pulses are not palpable.
					A murmur is heard on auscultation.
          If any of the above are true, have you considered starting a prostaglandin E1 or E2 (Prostin) infusion?''',
          '''Could there be an undiagnosed congenital anomaly? (e.g. diaphragmatic hernia, tracheo-oesophageal fistula, oesophageal atresia etc?) Pass an NG tube and perform a CXR.''',
          '''Have you considered seizures or an arrhythmia?''',
          '''Discuss early with your tertiary neonatal intensive care unit, or neonatal transport service.''',
        ],
      )
    ],
  ),
  Checklist(
    heading: 'Term Baby with Encephalopathy',
    subheading:
        'Starting care for a term baby with a suspected hypoxic insult at birth',
    abstract:
        'Following stabilisation with a systematic standard newborn life support approach, use the following checklist to remember the most important steps in the management of a term baby with encephalopathy due to a suspected hypoxic insult',
    sections: [
      ChecklistSection(
        sectionHeading: 'Early Assessment',
        items: [
          '''<b>Have you performed a formal neurological examination?</b> Include <i>at least</i> tone, posture, suck and pupils. Perform this after arrival to your neonatal unit, and certainly before giving muscle relaxants or sedatives.
			''',
          '''<b>Have you asked for cord gases?</b>''',
          '''<p><b>Would this baby benefit from cooling?</b> (Remember Toby cooling criteria).</p>
					<ul><li>Still discuss with local cooling centre if only Criteria A is met.</li>
				<li>	Start passive cooling as soon as possible: turn off heater, remove incubator lid/open doors. Use rectal temperature monitoring if possible every 15 minutes (axilla if not available).
        When temperature reaches 34.5&deg;C, turn incubator heater on to avoid over-cooling.</li></ul>''',
          '''<b>Can you perform cerebral function monitoring (CFM)?</b> This is helpful information if available.'''
        ],
      ),
      ChecklistSection(
        sectionHeading: 'Information Gathering',
        items: [
          '''<b>Cause:</b> was there a sentinel event? For example: antepartum haemorrhage, abruption, cord prolapse''',
          '''<b>Timings:</b> first heart rate, first gasp, onset of regular respiration'''
        ],
      ),
      ChecklistSection(sectionHeading: 'Refer Early', items: [
        'Call your local cooling centre for advice as early as possible.'
      ])
    ],
  ),
  Checklist(
    heading: 'The Underventilated Baby',
    subheading:
        'Checklist to help optimise a baby with suboptimal blood gases or oxygen saturations',
    abstract:
        '''This checklist will help with optimising a stable baby with suboptimal blood gas or oxygen saturations.
        For an acute deterioration, please see Sudden Deterioration of a Ventilated Baby checklist.''',
    sections: [
      ChecklistSection(
        sectionHeading: 'What are your target numbers?',
        items: [
          '''Oxygen saturations: Term babies - should be 95% or above. Preterm babies - usually aim for 90-94%. Cardiologists may accept lower saturations in congenital heart disease.''',
          '''pH and CO<sub>2</sub>: For preterm babies, pCO<sub>2</sub> in the 7-8 kPa range or higher may be acceptable ("permissive hypercapnoea"), as long as pH remains above 7.25.'''
        ],
      ),
      ChecklistSection(
        sectionHeading: 'Is this acute or chronic?',
        items: [
          '''Recent changes: Has there been a recent change to ventilation that can be simply reversed?''',
          '''Recent events: Has the baby just had nursing cares or a procedure?''',
          '''Swinging: Does the baby tend to "swing" regardless of ventilator settings?''',
          '''If any of the above are true, and the baby is not deteriorating rapidly, consider close observation and repeat gas in 30 minutes.'''
        ],
      ),
      ChecklistSection(
        sectionHeading: 'Mechanical factors',
        items: [
          '''Tube position: Tip should be at T1-T2 on CXR.''',
          '''Pain / baby position: If the baby is "fighting", splinting, or asynchronous with the ventilator, consider analgesia, sedation or paralysis, and look for any underlying causes.'''
        ],
      ),
      ChecklistSection(sectionHeading: 'To improve oxygenation', items: [
        '''Conventional ventilation: Consider increasing PIP. For larger babies at lower rates, consider increasing PEEP to improve alveolar recruitment. Monitor tidal volume (do not exceed 7 ml/kg if possible, to avoid barotrauma)''',
        '''High frequency oscillation: Review CXR. Consider increasing mean airway pressure (MAP) to achieve chest inflation of 8-9 anterior ribs. Repeat CXR after 30 minutes. After senior advice, lowering the frequency may also improve oxygenation (but you may need to reduce amplitude, and monitor blood gases carefully for sudden hypocapnoea).'''
      ]),
      ChecklistSection(
          sectionHeading: 'To improve CO\u2082 clearance:',
          items: [
            '''Conventional ventilation: Consider increasing rate by 5-10 /min. Max frequency is usually 60 breaths/min.''',
            '''High frequency oscillation: Consider increasing amplitude (delta P) by 5-10 cmH<sub>2</sub>O. If you cannot increase amplitude, consider lowering the frequency under senior supervision.''',
            '''All ventilation strategies: Remove as much dead space as possible between the ET tube and ventilator circuit.'''
          ]),
    ],
  ),
  Checklist(
    heading: 'Acute Deterioration of a Ventilated Baby',
    subheading: 'Using the DOPE approach to assess a sudden deterioration',
    abstract:
        '''<p>This checklist helps assess a baby using the "DOPE" approach.  Consider ordering a chest x-ray whilst assessing clinically.</p>
        <p>If the baby becomes profoundly hypoxic or bradycardic, they should be immediately resuscitated using a systematic newborn life support approach.</p>
        <p>If the baby fails to improve, you need to consider the risk of removing the tube and attempting mask ventilation and reintubation.</p>
			<p>Most babies can be effectively mask ventilated whilst waiting for help. Babies with pulmonary haemorrhage or pneumothorax will deteriorate significantly on extubation, so be sure you have excluded these beforehand.</p>''',
    sections: [
      ChecklistSection(
        sectionHeading: 'Displacement of ET Tube?',
        items: [
          '''Check measurement at lips: Compare to documented length. An audible cry is another sign the baby has extubated.''',
          '''Examine: Check for asymmetrical chest movement (low tube), or absent/intermittent air entry (high or dislodged tube).
      Is the baby achieving intended pressures on the ventilator? What is the leak measurement? Check exhaled CO<sub>2</sub> if possible.'''
        ],
      ),
      ChecklistSection(
        sectionHeading: 'Obstructed tube?',
        items: [
          '''Auscultate: Switch to t-piece or bag and check air entry.''',
          '''Recent suction: Has blood or thick mucus recently been suctioned? Could there be an obstructing plug? Irrigate with saline and suction.
      If fresh blood is suctioned, get urgent senior help and consider increasing PEEP (or MAP if oscillated).''',
        ],
      ),
      ChecklistSection(
        sectionHeading: 'Could there be a pneumothorax?',
        items: [
          '''Cold light: In a darkened room, the affected side may transmit the light brightly.''',
          '''Consider urgent CXR''',
          '''Needle aspiration: In acute decompensation, consider needle aspiration while preparing a chest drain.'''
        ],
      ),
      ChecklistSection(
        sectionHeading: 'Could there be equipment failure?',
        items: [
          '''Alerts and alarms: Check ventilator for problems. Double check with someone else.''',
          '''Check circuit: Follow circuit from ventilator to patient and back. Ensure all connections are tight.''',
          '''Manual ventilation: If there is an improvement when manually ventilating, consider swapping out the ventilator/circuit for a replacement.''',
        ],
      )
    ],
  ),
  Checklist(
    heading: 'Term Baby Born in Unexpectedly Poor Condition',
    subheading:
        'Arrival at the birth of a baby born in poor condition for unknown reasons',
    abstract:
        '''	This checklist is intended to help the neonatal team arriving at the delivery of a baby born in unexpectedly poor condition.
    It provides only reminders of the steps that are easy to forget.''',
    sections: [
      ChecklistSection(
        sectionHeading: 'Stabilise the baby',
        items: [
          '''Use a standard systematic newborn life support approach.''',
          '''Re-evaluate regularly. How long has active resuscitation been continuing?'''
        ],
      ),
      ChecklistSection(
        sectionHeading: 'Why has this happened?',
        items: [
          '''Have you asked staff and midwife why they think the baby is in poor condition?''',
          '''Are there any specific antenatally diagnosed problems?''',
          '''Is there a cord gas available?''',
          '''Have you considered these common conditions?
				 <ul>
					<li>Sepsis</li>
					<li>Hypoxic insult (e.g. abruption)</li>
					<li>Drugs / toxins</li>
					<li>Unusual causes: e.g. diaphragmatic hernia, tracheo-oesophageal fistula</li></ul>
				'''
        ],
      ),
      ChecklistSection(
        sectionHeading: 'Next steps',
        items: [
          '''Would this baby benefit from cooling? (Remember <a href="#popcoolingdialog">Toby cooling criteria</a>. Consider passive cooling and discuss with your local network cooling centre.''',
          '''Seek advice from your senior colleague, tertiary neonatal intensive care unit, or neonatal transport service.'''
        ],
      ),
    ],
  ),
  Checklist(
    heading: 'Suspected Necrotising Enterocolitis (NEC)',
    subheading: 'Checklist for initial management of a baby with suspected NEC',
    abstract:
        'Babies with necrotising enterocolitis can deteriorate rapidly. Use this checklist to ensure you have not forgotten any key steps.',
    sections: [
      ChecklistSection(
        sectionHeading: 'Airway',
        items: [
          '''Have you intubated the baby? Early intubation is generally recommended''',
          '''Has the baby been given adequate analgesia? NEC is painful, leading babies to splint their diaphragm.
          Consider giving a morphine bolus followed by morphine infusion at 20-40 mcg/kg/hr. Also consider muscle relaxation.'''
        ],
      ),
      ChecklistSection(
        sectionHeading: 'Breathing',
        items: [
          '''Have you checked and optimised ventilator settings? Higher pressures and longer inspiratory times may be necessary.'''
        ],
      ),
      ChecklistSection(
        sectionHeading: 'Circulation',
        items: [
          '''Does the baby require a bolus? Intravascular depletion is likely to occur. Crystalloid bolus or blood products may be necessary.
        It may be wise to fluid restrict in the light of likely capillary leak and the need for volume boluses.''',
          '''Have you ordered blood products? It will take time to prepare a neonatal transfusion, so plan early.''',
          '''Strict fluid balance monitoring is essential.'''
        ],
      ),
      ChecklistSection(
        sectionHeading: 'Key next steps',
        items: [
          '''Have you inserted a large bore (size 6-8) gastric tube? Place on free drainage. Aspirate hourly. Consider replacement of aspirate volume.''',
          '''Have you ordered an AXR? Look for signs including pneumoperitoneum, portal veous gas and intramural gas (pneumatosis).''',
          '''Discuss early with your local neonatal surgical centre.''',
        ],
      ),
    ],
  ),
];
