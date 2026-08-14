///
///
///   Neomate 2.0
///
///   Original app by Christopher Kelly
///
///   Reimplemented for Dart/Flutter by Lee Collier
///
///   HTML resources
///
///

class Reference {
  String heading;
  String subheading;
  String abstract;
  String? jumpTitle;
  List<String> sections;

  Reference(
      {required this.heading,
      required this.subheading,
      required this.abstract,
      required this.sections,
      this.jumpTitle});
}

List<Reference> referenceDb = [
  Reference(
    heading: 'BAPM Guidelines for Extreme Prematurity',
    subheading:
        'Helpful for counselling parents, based on consensus and most recent evidence available',
    abstract:
        '''<p>The information below comes from <a href="http://www.bapm.org/publications/documents/guidelines/Approved_manuscript_preterm_final.pdf">The Management of Babies born Extremely Preterm at less than 26 weeks of gestation</a>,
    A Framework for Clinical Practice at the time of Birth, British Association of Perinatal Medicine 2008.</p>
		<p>Please read the <a href="http://www.bapm.org/publications/documents/guidelines/Approved_manuscript_preterm_final.pdf">full report</a>, but for speed, a key passage is reproduced below.</p>''',
    sections: [
      '''<p>A Framework for Clinical Practice based on consensus and the most recent evidence available follows:</p>
      <h3>(A) LESS THAN 23+0 WEEKS</h3>
      <p>If gestational age is <i><b>certain </b></i>and less than 23+0 (i.e. at 22 weeks) it would be considered in the best interests of the baby, and standard practice, for resuscitation not to be carried out.
      If the parents wish they should have the opportunity to discuss outcomes with a second senior member of the perinatal team.</p>
      <p>In the EPICure study of all babies born in 1995 in the UK and Eire at &lt;26 weeks gestational age, only two babies reported at &lt;23 weeks survived to discharge and one has severe disability.</p>
      <p>In the EPICure 2 study (2006) survival remains extremely rare at this gestational age, with a high incidence of early major morbidity in the few who are discharged home.</p>
      <h3>(B) 23+0 to 23+6 WEEKS</h3>
      <p>If gestational age is <i><b>certain </b></i>at 23+0 - 23+6 (i.e. at 23 weeks) and the fetal heart is heard during labour,
      a professional experienced in resuscitation should be available to attend the birth. In the best interests of the baby a decision not to start resuscitation is an appropriate approach particularly if the parents have expressed this wish.
      However, if resuscitation is started with lung inflation using a mask, the response of the heart rate will be critical in deciding whether to continue or to stop and sensitively explain to the parents the futility of further interventions.</p>
      <p>The EPICure study (1995) reported in 2000 that at 23 weeks 121/241 (50%) of live born babies were admitted for intensive care of whom 105 (80%) died in hospital. 26 babies were discharged home, one died and 14 (54%) have a moderate or severe disability at six years.</p>
      <p>Early findings in the EPICure 2 study (2006) show that at this gestational age survival has not increased significantly and there has been no change in early major morbidity.</p>
      <h3>(C)4+0 to 24+6 WEEKS</h3>
      <p>If gestational age is <b>certain </b>at 24+0 - 24+6 resuscitation should be commenced unless the parents and clinicians have considered that the baby will be born severely compromised. However the response of the heart rate to lung inflation using a mask will be critical in deciding whether to proceed to intensive care. If the baby is assessed to be more immature than expected, deciding not to start resuscitation may be considered in the best interest of the baby.</p>
      <p>In the 1995 study, although 313/382 (78%) of babies born at this gestational age (313) were given intensive care, 198 (66%) died. Half of the survivors (52) have a moderate or severe disability at six years.</p><p class="s9">Early findings in the EPICure 2 study (2006) show that at this gestational age survival has increased significantly by 12%. More babies were treated for retinopathy of prematurity but there is no evidence of any change in other early major morbidity.</p>
      <h3>(D)25 WEEKS AND GREATER</h3><p>When gestational age is 25+0 weeks or more, survival is now considerably greater than in 1995. It is appropriate to resuscitate babies at this gestation and, if the response is encouraging, to start intensive care.</p>
      <p>In the 1995 study389/424 (92%) babies born alive at 25 weeks were admitted for intensive care but 171 (48%) died.27% of the survivors had no identifiable impairment at six years.</p>
      <p>In 2006 survival had increased significantly from 54% to 67%by 13%, but there is no evidence of any change in early major morbidity.</p>
      <h3>(E)UNCERTAIN GESTATIONAL AGE</h3>
      <p>If gestational age is uncertain, (i.e. no dating ultrasound scan) but thought to be &gt;23+0 weeks, an ultrasound scan by an experienced sonographer should be carried out if time permits.
      If the fetal heart is heard during labour, a professional experienced in resuscitation and another clinician (neonatal nurse or trainee paediatrician) should be called to attend birth.
      A decision should then be made, in the best interests of the baby, as to whether resuscitation should begin with mask ventilation. Once begun, the response of heart rate to lung inflation will be crucial in judging how long to continue resuscitation.
      If there is any uncertainty about management guidance from more senior staff should be sought urgently.</p>''',
      '''
      <h2>Intensive care</h2>
      <p>The response of the baby to mask ventilation is critical in deciding whether to commence intensive care.
      If  the heart rate increases rapidly and the colour improves, appropriate ventilatory support, including intubation and surfactant therapy, should be given and the baby transferred to the neonatal unit for further assessment.</p><p>
      There is no evidence to support the use of adrenaline by any route, or chest compressions, during resuscitation at gestational age &lt;26 weeks.</p><p>Management should be decided by doctors and nurses experienced in neonatal intensive care.</p>
      ''',
      '''<h2>Withholding or withdrawing resuscitation or intensive care</h2>
      <p>When resuscitation or intensive care is withheld or withdrawn, the baby should be given all the care needed for his/her comfort and the parents encouraged by appropriate staff to hold and spend time with their baby, if they wish, in a quiet and private location.'''
    ],
  ),
  Reference(
    heading: 'Cerebral Function Monitoring',
    jumpTitle: 'cfm',
    subheading: 'A brief introduction to CFM interpretation in the term baby',
    abstract:
        'The Cerebral Function Monitor (CFM) records a single channel of EEG and provides information about global cerebral activity. CFM can be helpful in assessing hypoxic-ischaemic encephalopathy after an asphyxial insult, and for providing information about duration, intensity and frequence of neonatal seizures.',
    sections: [
      '''
			<b>Source:</b> TOBY CFM Manual, Prof Denis Azzopardi</div>

			<h3>Key points to note</h3>
			<ul>
			<li>The CFM does not give information about EEG frequency.</li>
			<li>Focal lesions may not be identified because the signal is obtained from a single channel. Following asphyxia the occurrence of a moderately or severely abnormal trace has a positive predictive value for abnormal outcome in the order of >70%.</li>
			<li>Medications may affect the record. Anticonvulsants or sedatives such as morphine or chloral hydrate may transiently suppress the CFM record.</li>
			</ul>
''',
      '''
			<h3>Normal trace</h3>
			<p>In healthy full term infants the trace alters in width according to the state of the infant.
      The trace is narrower when the infant is awake and widens during sleep. These changes in the width of the trace with infant state are called sleep/wake cycling.
      In normal infants the width of the trace varies from approximately 10-40 microvolts.</p>
      <p>A sample of a normal trace is given below:</p><br/>
      <p><img src="asset:graphics/cfm/normal.jpg"></p>

			<h3>Moderately Abnormal Trace</h3>
			<p>A moderately abnormal trace has an upper margin that is greater than 10 microvolts and a lower margin less than 5 microvolts. The trace therefore appears wider than in normal infants. This appearance can be seen in infants with moderately severe encephalopathy, or immediately after administration of drugs such as anticonvulsants and sedatives. This
			pattern may also be seen in pre term infants (below 36 weeks gestation).A sample of a moderately abnormal trace is shown below:</p><br/>
			<p><img src="asset:graphics/cfm/modabnormal.jpg"></p>

			<h3>Severely Abnormal Trace</h3>
			<p>A severely abnormal trace is characterised by a general suppression of amplitude so that the trace appears narrow and of low voltage. The upper margin of the trace is less than 10 microvolts. The lower margin is usually less than 5 microvolts (on occasion the lower margin may be transiently greater than 5 microvolts whilst the upper margin is less than 10 microvolts). This pattern may be accompanied by brief bursts of higher voltage spikes, which appear as single spikes above the background activity. This appearance is sometimes called “burst suppression”. A severely abnormal trace is usually seen with severe encephalopathy and is often accompanied by seizure activity.
			</p><p>Two examples of severely abnormal traces are shown here:</p>
			<p><img src="asset:graphics/cfm/sevabnormal1.jpg"></p>
			<p><img src="asset:graphics/cfm/sevabnormal2.jpg"></p>
''',
      '''
			<h3>Seizures</h3>
			<p>Seizures may only be identified if they are sufficiently prolonged, i.e. more than 2-3 minutes. Shorter lasting discharges may be missed since the CFM is recorded at a very slow speed. Two main seizure patterns may be seen.</p>
			<ol><li>There is a sudden rise and narrowing of the trace (reflecting the increase in EEG voltage).</li>
			<li>A narrowing of the trace without a rise in voltage may be seen. The trace returns to the previous appearance when the seizure activity stops.</li></ol>

      
			<h3>Notes</h3>
			<ol><li>It may be difficult to distinguish burst suppression from brief seizures in a severely abnormal trace - but the distinction is not important.</li>
			<li>An isolated sudden change in the trace suggestive of seizure may be difficult to interpret in the absence of any clinical observation. Artefact due to touching the infant may cause diagnostic difficulty.</li>
			<li>It may not be possible to comment on the background of the trace if seizures are very frequent.</li>
			<li>Continuous seizure activity may be difficult to recognise because the trace may appear to be of normal voltage. However, with long term recording it may be possible to identify when seizure activity stops.</li></ol>


			<h3>This trace demonstrates both burst suppression and seizures:</h3>
			<img src="asset:graphics/cfm/seizures2.jpg">

			<h3>This trace shows borderline normal amplitude with seizure developing towards the end of the trace:</h3>
			<img src="asset:graphics/cfm/seizures3.jpg">

			<h3>In this trace, note two seizures on otherwise normal amplitude:</h3>
			<img src="asset:graphics/cfm/seizures4.jpg">

			<h3>Reduction in seizures following increase in anticonvulsant.</h3>
			<img src="asset:graphics/cfm/seizures5.jpg">

			<h3>Severely abnormal trace with burst suppression and probable seizures. It may be difficult to distinguish between bursts and seizures but both are often present in severely abnormal traces.</h3>
			<img src="asset:graphics/cfm/seizures6.jpg">

			<h3>Note effect of sedative (chloral hydrate) on amplitude:</h3>
			<img src="asset:graphics/cfm/chloral.jpg">

			<p>Thank you to Prof Denis Azzopardi for letting us reproduce these examples here.
      For more examples, please visit the <a href="https://www.npeu.ox.ac.uk/downloads/files/toby/TOBY-CFM-Manual.pdf">TOBY CFM Manual</a> (external link).</p>

'''
    ],
  ),
  Reference(
    heading: 'Endotracheal tube length',
    jumpTitle: 'ETTlength',
    subheading:
        'A reference table showing gestation, estimated weight and recommended ETT length at the lips.',
    abstract:
        'Use the following table to insert the ET tube to the optimum length. Always confirm position by chest x-ray: tube tip should be seen at level of T1-T2.',
    sections: [
      '''
<table  border="0" style="table-layout: fixed; width: 280px;"> 
  <tr style="font-weight:bold;padding-left:10px;padding-bottom:5px;">
    <td style="width:100px; height:50px;">ETT Length<br/>at Lips (cm)</td>
    <td style="width:100px; height:50px;">Gestation<br/>(weeks)</td>
    <td style="width:80px; height:50px;">Weight<br/>(kg)</td>
  </tr>
  <tr style="background-color:rgb(235,200,210);line-height:20px;padding-left:10px;padding-bottom:5px;">
    <td style="vertical-align:center" >5.5</td>
    <td style="vertical-align:center">23-24</td>
    <td style="vertical-align:center">0.5-0.6</td>
  </tr>
  <tr style="line-height:20px;;padding-left:10px;padding-bottom:5px;">
    <td>6.0</td>
    <td>25-26</td>
    <td>0.7-0.8</td>
  </tr>
 <tr style="background-color:rgb(235,200,210);line-height:20px;padding-left:10px;padding-bottom:5px;">
    <td>6.5</td>
    <td>27-29</td>
    <td>0.9-1.0</td>
  </tr>
  <tr style="line-height:20px;padding-left:10px;padding-bottom:5px;">
    <td>7.0</td>
    <td>30-32</td>
    <td>1.1-1.4</td>
  </tr>
 <tr style="background-color:rgb(235,200,210);line-height:20px;padding-left:10px;padding-bottom:5px;">
    <td>7.5</td>
    <td>33-34</td>
    <td>1.5-1.8</td>
  </tr>
  <tr style="line-height:20px;padding-left:10px;padding-bottom:5px;">
    <td>8.0</td>
    <td>35-37</td>
    <td>1.9-2.4</td>
  </tr>
 <tr style="background-color:rgb(235,200,210);line-height:20px;padding-left:10px;padding-bottom:5px;">
    <td>8.5</td>
    <td>38-40</td>
    <td>2.5-3.1</td>
  </tr>
  <tr style="line-height:20px;padding-left:10px;padding-bottom:5px;">
    <td>9.0</td>
    <td>41-43</td>
    <td>3.2-4.2</td>
  </tr>
</table>
    <p><strong>Endotracheal tube length for neonatal intubation</strong> Kempley, S.T., Moreiras, J.W., Petrone, F.L., 2008. Resuscitation, 77, pp.369–373. <br><br>Available at: <a href="http://dx.doi.org/10.1016/j.resuscitation.2008.02.002" target="_system" class="external">ScienceDirect</a> | <a href="http://www.ncbi.nlm.nih.gov/pubmed/18372092" target="_system" class="external">Pubmed</a><br><br></p>'''
    ],
  ),
];

class NeomateHtml {
  static var cooling = '''
	<h1>When to consider treatment with cooling</h1>
	<p>The following information comes from the UK TOBY Clinician's Handbook found
  <a href="https://www.npeu.ox.ac.uk/downloads/files/tobyregister/Register-Clinicans-Handbook1-v4-07-06-10.pdf">here</a>.</p>

	<p><b>A. Infants ≥ 36 completed weeks gestation admitted to the neonatal unit
	with at least one of the following:</b></p>

	<ul><li>Apgar score of ≤5 at 10 minutes after birth</li>
	<li>Continued need for resuscitation, including endotracheal or mask ventilation, at 10 minutes after birth</li>
	<li>Acidosis within 60 minutes of birth (defined as any occurrence of umbilical cord, 
	arterial or capillary pH <7.00)</li>
	<li>Base Deficit ≥ 16 mmol/L in umbilical cord or any blood sample (arterial, venous 
	or capillary) within 60 minutes of birth </li></ul>
	<p>Infants that meet criteria A should be assessed for whether they meet the 
		neurological abnormality entry criteria (B):</p>

	<p><b>B. seizures or moderate to severe encephalopathy, consisting of:</b>
	<ul><li>Altered state of consciousness (reduced response to stimulation or absent 
	response to stimulation) and</li>
	<li>Abnormal tone (focal or general hypotonia, or flaccid) and</li>
	<li>Abnormal primitive reflexes (weak or absent suck or Moro response).</li>
  </ul>

	<p>Infants who meet criteria A and B may be considered for treatment with cooling.</p>

  <p>Once baby is stabilised and cooling started, you should consider <a href='neomate://cfm'>CFM monitoring.</a></p>
  ''';
  static var checklistPreamble =
      '''These checklists are concise and simple tools, aimed to support the skills of expert neonatal staff.
      They are not intended to replace local guidelines.We recommend reading the principles of Crisis Resource Management to help manage difficult situations on NICU.''';

  static var aboutPage = '''
      <h1>About NeoMate</h1>

      <p><i>Version 2.0 July 2022</i></p>

      <p>Development Build: 1.0.0.11</p>

			<p><b>Neomate</b> original app created by Dr Chris Kelly &nbsp;<a href="http://www.twitter.com/chrisck"><img src="images/twitter.png" width="15">@chrisck</a></p>

      <p><b>Neomate version 2</b> by Dr Lee Collier (Specialty Doctor, London NTS and Royal London Hospital)</p>

			<p><b>Clinical Lead:</b> Dr Syed Mohinuddin (Consultant Neonatologist, London NTS and Royal London Hospital).</p>

		  <p><b>Version 1 team</b> Pharmacists: Rachel Bowman and Veronica Chorro-Mari. Checklist group: Dr Syed Mohinuddin, Dr Chris Kelly, Dr Gin Thian Peh, Dr Lee Collier, Dr Neha Khanna, Dr Farah Sheikh and Kate Convery.</p>

			<p>Thank you to everyone who has offered feedback and suggestions for improvement, and to those who have helped test early versions of the app before release.</p>

			<p>Thank you to the nurses at Whipps Cross Hospital for helping pick the app's name.</p>

			<p>NeoMate is dedicated to the late Dr Andrew Kapetanakis - an inspirational neonatologist, and strong supporter of the London Neonatal Transfer Service.</p>

			<p>Published by London Neonatal Transfer Service, 8D Central Tower, Royal London Hospital, Whitechapel Road, London E1 1BB.</p>

			<h2>Usage Statistics</h2>
			<p>NeoMate collects basic usage statistics for the purposes of improving this app.</p>

			<h2>Legal Disclaimer</h2>
			<p>By continuing to use NeoMate (‘the App’), you acknowledge that you have read and agree to be bound by the terms of the disclaimer described below (‘the Disclaimer’). Please exit this application now if you do not wish to accept the terms of this disclaimer.</p>

			<p>NeoMate complies with the Medical Devices Directive (93/42/EEC).</p>

			<p>The London Neonatal Transfer Service confirms that the App is designed and manufactured to comply with the relevant Essential Requirements set out in the Medical Devices Directive (93/42/EEC). When used under the conditions and for the purposes intended, the App will not compromise the clinical condition or the safety of patients, or the safety and health of users or, where applicable, other persons.</p>

			<p>The information contained within the App is provided on an "as is" basis without any representations or warranties, express or implied.</p>

			<p>You acknowledge, and understand that the App is for use by professional neonatal staff only, and that it is intended to be used as a tool and guide to help treat babies more safely. The App is designed with safety functions in order to eliminate or reduce risks as far as possible. However, nothing in the App should be considered to be a substitution for medical expertise, experience and judgment.</p>

			<p>The team behind NeoMate will endeavour to maintain the app to represent the latest guidelines and advice from London NTS. However, London NTS does not warrant that the operation of the app is free from errors, and that the information contained within the app is accurate, complete, true and/or up-to-date.</p>

			<p>London NTS and its associated organisations will not be liable to you or to any other person for any indirect, special, incidental, exemplary, consequential or other damages arising out of any use or misuse of the App, under any circumstances whatsoever.</p>

			<p>London NTS shall have no liability arising out of any use of the App for any loss or injury caused by errors, omissions or inaccuracies in the App. This includes any decision made as a result of reliance on the App or the information within it.</p>

			<p>You agree to indemnify and hold London NTS harmless from any claim or demand, including costs and expenses, made by any third party as a result of your use or misuse of the App which is not in accordance with the instructions for use and/or under the conditions and/or for the purposes intended and any action you take which is or may be based on the information contained within the App.</p>

			<p>This disclaimer shall be governed by the laws of England and Wales, and any dispute will be submitted to the English courts.</p>

  
''';
}
