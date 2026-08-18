// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

// Clinical source IDs: SRC-001, SRC-006, SRC-008
// Clinical content IDs: PROTOCOL-BOLUS-CATALOGUE
// Clinical reviewer: none
// Clinical sign-off: none
// Review due: none
// Safety hazards: HZ-001, HZ-006, HZ-007
//
// STATUS: NOT APPROVED FOR CLINICAL USE. These records preserve named values
// for structured clinical review. Explicitly retired resuscitation bicarbonate
// and empirical D10 outputs are excluded.

enum BolusCategory { intubation, circulation, sedation, neurology, emergency }

class BolusProtocolRecord {
  const BolusProtocolRecord({
    required this.id,
    required this.category,
    required this.name,
    required this.dosePerKilogram,
    required this.doseLabel,
    required this.outputUnit,
    required this.instructions,
    this.qualifier,
    this.note,
  });

  final String id;
  final BolusCategory category;
  final String name;
  final double dosePerKilogram;
  final String doseLabel;
  final String outputUnit;
  final String instructions;
  final String? qualifier;
  final String? note;

  double amountForKilograms(double kilograms) => dosePerKilogram * kilograms;
}

const bolusProtocols = <BolusProtocolRecord>[
  BolusProtocolRecord(
      id: 'BOLUS-FENTANYL',
      category: BolusCategory.intubation,
      name: 'Fentanyl',
      dosePerKilogram: 5,
      doseLabel: '5 micrograms/kg',
      outputUnit: 'micrograms',
      instructions: 'Slow IV administration',
      note: 'Recorded as the preferred medicine for intubation.'),
  BolusProtocolRecord(
      id: 'BOLUS-MORPHINE',
      category: BolusCategory.intubation,
      name: 'Morphine',
      dosePerKilogram: 100,
      doseLabel: '100 micrograms/kg',
      outputUnit: 'micrograms',
      instructions: 'Slow IV administration',
      note:
          'Recorded onset approximately 15 minutes; peak effect 15-30 minutes.'),
  BolusProtocolRecord(
      id: 'BOLUS-ATROPINE',
      category: BolusCategory.intubation,
      name: 'Atropine',
      dosePerKilogram: 10,
      doseLabel: '10 micrograms/kg',
      outputUnit: 'micrograms',
      instructions: 'Slow IV administration'),
  BolusProtocolRecord(
      id: 'BOLUS-SUXAMETHONIUM',
      category: BolusCategory.intubation,
      name: 'Suxamethonium',
      dosePerKilogram: 2,
      doseLabel: '2 mg/kg',
      outputUnit: 'mg',
      instructions: 'Slow IV administration'),
  BolusProtocolRecord(
      id: 'BOLUS-PORACTANT-FIRST',
      category: BolusCategory.intubation,
      name: 'Poractant alfa',
      qualifier: 'First dose',
      dosePerKilogram: 200,
      doseLabel: '200 mg/kg',
      outputUnit: 'mg',
      instructions: 'Via endotracheal tube',
      note: 'Consider the nearest whole vial.'),
  BolusProtocolRecord(
      id: 'BOLUS-PORACTANT-SECOND',
      category: BolusCategory.intubation,
      name: 'Poractant alfa',
      qualifier: 'Subsequent dose',
      dosePerKilogram: 100,
      doseLabel: '100 mg/kg',
      outputUnit: 'mg',
      instructions: 'Via endotracheal tube'),
  BolusProtocolRecord(
      id: 'BOLUS-SALINE',
      category: BolusCategory.circulation,
      name: 'Sodium chloride 0.9%',
      dosePerKilogram: 10,
      doseLabel: '10 mL/kg',
      outputUnit: 'mL',
      instructions: 'IV over 20-30 minutes'),
  BolusProtocolRecord(
      id: 'BOLUS-PANCURONIUM',
      category: BolusCategory.sedation,
      name: 'Pancuronium',
      dosePerKilogram: 100,
      doseLabel: '100 micrograms/kg',
      outputUnit: 'micrograms',
      instructions: 'Slow IV administration',
      note: 'Neuromuscular paralysis; does not provide analgesia or sedation.'),
  BolusProtocolRecord(
      id: 'BOLUS-VECURONIUM',
      category: BolusCategory.sedation,
      name: 'Vecuronium',
      dosePerKilogram: 100,
      doseLabel: '100 micrograms/kg',
      outputUnit: 'micrograms',
      instructions: 'Slow IV administration',
      note: 'Neuromuscular paralysis; does not provide analgesia or sedation.'),
  BolusProtocolRecord(
      id: 'BOLUS-PHENOBARBITAL-LOADING',
      category: BolusCategory.neurology,
      name: 'Phenobarbital',
      qualifier: 'Loading dose',
      dosePerKilogram: 20,
      doseLabel: '20 mg/kg',
      outputUnit: 'mg',
      instructions: 'IV over 20 minutes'),
  BolusProtocolRecord(
      id: 'BOLUS-PHENOBARBITAL-SUBSEQUENT',
      category: BolusCategory.neurology,
      name: 'Phenobarbital',
      qualifier: 'Subsequent dose',
      dosePerKilogram: 10,
      doseLabel: '10 mg/kg',
      outputUnit: 'mg',
      instructions: 'IV over 20 minutes'),
  BolusProtocolRecord(
      id: 'BOLUS-PHENYTOIN',
      category: BolusCategory.neurology,
      name: 'Phenytoin',
      dosePerKilogram: 18,
      doseLabel: '18 mg/kg',
      outputUnit: 'mg',
      instructions: 'IV over 30 minutes with close ECG monitoring'),
  BolusProtocolRecord(
      id: 'BOLUS-MIDAZOLAM',
      category: BolusCategory.neurology,
      name: 'Midazolam',
      dosePerKilogram: 300,
      doseLabel: '300 micrograms/kg',
      outputUnit: 'micrograms',
      instructions: 'IV over 5 minutes',
      note: 'A further dose after 10 minutes was recorded as an option.'),
  BolusProtocolRecord(
      id: 'BOLUS-ADRENALINE-RESUSCITATION',
      category: BolusCategory.emergency,
      name: 'Adrenaline 1:10,000',
      dosePerKilogram: 0.2,
      doseLabel: '0.2 mL/kg',
      outputUnit: 'mL',
      instructions: 'IV, then flush with sodium chloride 0.9%'),
  BolusProtocolRecord(
      id: 'BOLUS-ADENOSINE',
      category: BolusCategory.emergency,
      name: 'Adenosine',
      dosePerKilogram: 150,
      doseLabel: '150 micrograms/kg',
      outputUnit: 'micrograms',
      instructions:
          'Rapid IV administration followed immediately by sodium chloride 0.9% flush',
      note: 'Escalating doses may be required.'),
];
