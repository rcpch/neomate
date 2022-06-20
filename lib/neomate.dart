///
///
///   Neomate 2.0
///
///   Original app by Christopher Kelly
///
///   Reimplemented for Dart/Flutter by Lee Collier
///
///

// Define some classes for bolus drugs and infusions

enum DrugType {
  intubation,
  central,
  cardiac,
  sedative,
  neurology,
  emergency,
  generic,
}

enum DeliveryUnits {
  invalid,
  gPerKg,
  mgPerKg,
  microgramsPerKg,
  nanogramsPerKg,
}

Map<DeliveryUnits, double> mgFactor = {
  DeliveryUnits.gPerKg: 1000,
  DeliveryUnits.mgPerKg: 1,
  DeliveryUnits.microgramsPerKg: 0.001,
  DeliveryUnits.nanogramsPerKg: 0.000001,
  DeliveryUnits.invalid: 0,
};

Map<DeliveryUnits, String> stringUnits = {
  DeliveryUnits.gPerKg: 'g/kg',
  DeliveryUnits.mgPerKg: 'mg/kg',
  DeliveryUnits.microgramsPerKg: 'micrograms/kg',
  DeliveryUnits.nanogramsPerKg: 'nanograms/kg',
  DeliveryUnits.invalid: 'invalid',
};

enum DeliveryTime {
  invalid,
  perMinute,
  perHour,
  perDay,
}

Map<DeliveryTime, String> stringTime = {
  DeliveryTime.perMinute: '/min',
  DeliveryTime.perHour: '/h',
  DeliveryTime.perDay: '/day',
};

enum FluidType {
  // ignore: constant_identifier_names
  NS,
  // ignore: constant_identifier_names
  D5W,
  // ignore: constant_identifier_names
  D10W
}

Map<FluidType, String> stringFluid = {
  FluidType.NS: '0.9% saline',
  FluidType.D5W: '5% dextrose',
  FluidType.D10W: '10% dextrose',
};

abstract class Drug {
  // This base class allows us to have a few different types of drugs
  // that can be managed through the same interface

  final List<DrugType> types;
  final String name;
  final String qualifier;
  final String units;
  final String instructions;
  final String notes;
  final Drug? followOn;
  final double? weight;
  var calcString = 'Not calculated';

  Drug({
    required this.types,
    required this.name,
    this.qualifier = '',
    required this.units,
    required this.instructions,
    this.followOn,
    this.notes = '',
    this.weight,
  });

  Drug bindWeight(double myWeight);
}

class DrugMultiplier extends Drug {
  // Implements "Multiplier" drugs: this is where we take a weight and
  // multiply it by something to get the dose

  final String dose;
  final double multiplier;
  @override
  // ignore: overridden_fields
  final DrugMultiplier? followOn;

  static final invalid = DrugMultiplier(
    // We will use this static instance if we need to 'delete' a drug object
    types: [],
    name: '?',
    dose: '?',
    multiplier: 0,
    units: '?',
    instructions: '?',
  );

  DrugMultiplier({
    required types,
    required name,
    required this.dose,
    qualifier = '',
    required this.multiplier,
    required units,
    required instructions,
    this.followOn,
    notes = '',
    weight,
  }) : super(
            types: types,
            name: name,
            instructions: instructions,
            units: units,
            qualifier: qualifier,
            notes: notes,
            weight: weight) {
    if (weight is double) {
      if (weight.isNaN) {
        calcString = '?';
        return;
      }
      double calcDose = weight * multiplier;
      if (calcDose < 0.01) {
        calcString = 'Too low';
        return;
      }
      if (calcDose > 2000) {
        calcString = 'Too high';
        return;
      }
      if (calcDose < 0.1) {
        calcString = calcDose.toStringAsFixed(3);
        return;
      }
      if (calcDose < 1) {
        calcString = calcDose.toStringAsFixed(2);
        return;
      }
      if (calcDose < 100) {
        calcString = calcDose.toStringAsFixed(1);
        return;
      } else {
        calcString = calcDose.round().toString();
        return;
      }
    } else {
      calcString = '?';
      return;
    }
  }

  @override
  DrugMultiplier bindWeight(double myWeight) {
    if (weight is double) {
      // If a weight is already bound then something is wrong, so return the invalid static instance
      return invalid;
    } else {
      // Build a new instance with the weight bound in
      return DrugMultiplier(
        types: types,
        name: name,
        dose: dose,
        qualifier: qualifier,
        multiplier: multiplier,
        units: units,
        instructions: instructions,
        notes: notes,
        followOn: (followOn == null) ? null : followOn!.bindWeight(myWeight),
        weight: myWeight,
      );
    }
  }
}

class DrugBanded extends Drug {
  // Implements "Banded" drugs: this is where we take a weight and
  // use a lookup table to find the dose

  final double minWeight;
  final double maxWeight;
  @override
  // ignore: overridden_fields
  final DrugBanded? followOn;
  final Map<double, String> bands;

  DrugBanded(
      {required types,
      required name,
      qualifier = '',
      required this.minWeight,
      required this.maxWeight,
      required units,
      required instructions,
      this.followOn,
      notes = '',
      weight,
      required this.bands})
      : super(
            types: types,
            name: name,
            instructions: instructions,
            units: units,
            qualifier: qualifier,
            notes: notes,
            weight: weight) {
    if (weight is double) {
      if (weight.isNaN) {
        calcString = '?';
        return;
      }
      if (weight > maxWeight) {
        calcString = 'Above max weight';
        return;
      }
      if (weight < minWeight) {
        calcString = 'Below min weight';
        return;
      }
      var ret = '?';
      for (var k in bands.keys) {
        if (weight >= k) {
          if (bands[k] is String) {
            ret = bands[k]!;
          }
        }
      }
      calcString = ret;
      return;
    }
    calcString = '?';
  }

  static final invalid = DrugBanded(
    // We will use this static instance if we need to 'delete' a drug object
    types: [],
    name: '?',
    minWeight: 0,
    maxWeight: 0,
    units: '?',
    instructions: '?',
    bands: {},
  );

  @override
  DrugBanded bindWeight(double myWeight) {
    if (weight is double) {
      // If a weight is already bound then something is wrong, so return the invalid static instance
      return invalid;
    } else {
      // Build a new instance with the weight bound in
      return DrugBanded(
        types: types,
        name: name,
        qualifier: qualifier,
        minWeight: minWeight,
        maxWeight: maxWeight,
        units: units,
        instructions: instructions,
        notes: notes,
        followOn: (followOn == null) ? null : followOn!.bindWeight(myWeight),
        weight: myWeight,
        bands: bands,
      );
    }
  }
}

class DrugInfo extends Drug {
  // Implements "Info" drugs: this is where we return some strings
  // that might have the weight substituted in for the user to do the calc

  @override
  // ignore: overridden_fields
  final DrugBanded? followOn;
  final String info;

  DrugInfo({
    required this.info,
    required types,
    required name,
    qualifier = '',
    required units,
    required instructions,
    this.followOn,
    notes = '',
    weight,
  }) : super(
            types: types,
            name: name,
            instructions: instructions,
            units: units,
            qualifier: qualifier,
            notes: notes,
            weight: weight) {
    if (weight is double) {
      if (weight.isNaN) {
        calcString = '?';
        return;
      }
      calcString = info.replaceAll("{w}", weight.toStringAsFixed(2));
    }
  }

  static final invalid = DrugInfo(
    // We will use this static instance if we need to 'delete' a drug object
    types: [], name: '?', units: '?', instructions: '?', info: '?',
  );

  @override
  DrugInfo bindWeight(double myWeight) {
    if (weight is double) {
      // If a weight is already bound then something is wrong, so return the invalid static instance
      return invalid;
    } else {
      // Build a new instance with the weight bound in
      return DrugInfo(
          types: types,
          name: name,
          qualifier: qualifier,
          units: units,
          instructions: instructions,
          notes: notes,
          followOn: (followOn == null) ? null : followOn!.bindWeight(myWeight),
          weight: myWeight,
          info: info);
    }
  }
}

class DrugInfusion extends Drug {
  List<FluidType> fluids;
  DeliveryUnits deliveryUnits;
  DeliveryTime deliveryTime;
  double startDose;
  double desiredRate;
  double syringe;
  double minConc;
  double maxConc;
  String minConcMsg;
  String maxConcMsg;
  double minDose;
  double maxDose;
  String doseMsg;
  String calcPreNarrative = 'Not calculated';
  String calcPostNarrative = 'Not calculated';
  String calcTop = 'Not calculated';
  String calcBottom = 'Not calculated';
  String calcRight = '';
  String calcDrugToAdd = 'Not calculated';

  DrugInfusion({
    required types,
    required name,
    instructions = '',
    units = '',
    notes = '',
    qualifier = '',
    required this.deliveryUnits,
    required this.deliveryTime,
    required this.startDose,
    required this.fluids,
    required this.desiredRate,
    required this.syringe,
    required this.minConc,
    required this.maxConc,
    required this.minConcMsg,
    required this.maxConcMsg,
    required this.minDose,
    required this.maxDose,
    required this.doseMsg,
    weight,
  }) : super(
            types: types,
            name: name,
            instructions: instructions,
            units: units,
            qualifier: qualifier,
            notes: notes,
            weight: weight) {
    if (weight is double) {
      if (weight.isNaN) {
        calcDrugToAdd = '?';
        calcPreNarrative = '?';
        calcPostNarrative = '?';
        return;
      }

      // Construct the infusion details and calculation
      // calcTop, calcBottom and calcRight are strights to make up a display of the formula
      // Dose is the running total of the drug to be added to the syringe
      // calcPreNarrative is a description of the calculation

      calcPreNarrative =
          '$desiredRate mL/h gives $startDose ${stringUnits[deliveryUnits]}${stringTime[deliveryTime]}';
      double dose = 0.0;

      calcTop =
          '$startDose (${stringUnits[deliveryUnits]}${stringTime[deliveryTime]})';
      dose = startDose *
          mgFactor[deliveryUnits]!; // easier to start everything at mg
      if (deliveryTime == DeliveryTime.perMinute) {
        calcTop += ' x 60 (mins)';
        dose *= 60;
      }
      if (deliveryTime == DeliveryTime.perDay) {
        calcTop += ' \u00F7 24 (hours)';
        dose /= 24;
      }
      calcTop += ' x $weight (kg) x $syringe (mL syringe)';
      dose = dose * weight * syringe;
      calcBottom = '$desiredRate (mL/h rate)';
      dose /= desiredRate;

      // we always end up with mg, now need to rationalise
      // the starting point is to stay in mg
      var doseUnits = 'mg';
      var doseFactor = mgFactor[deliveryUnits]!;

      if (dose > 1000) {
        //it's a large number so convert to grams
        doseFactor = mgFactor[deliveryUnits]! / 1000;
        dose /= 1000;
        doseUnits = 'grams';
      } else if (dose < 0.1) {
        //it's a small number so convert to micrograms
        doseFactor = mgFactor[deliveryUnits]! * 1000;
        dose *= 1000;
        doseUnits = 'micrograms';
      }

      if (doseFactor < 1) {
        calcBottom += ' x ${(1 / doseFactor).toString()} (for $doseUnits)';
      }
      if (doseFactor > 1) {
        calcRight += ' x ${doseFactor.toString()} (for $doseUnits)';
      }

      // Make a string of the appropriate fluid types
      var stringFluids = '';
      for (var fluid in fluids) {
        stringFluids += (stringFluids.isNotEmpty)
            ? ' or ${stringFluid[fluid]}'
            : '${stringFluid[fluid]}';
      }

      // Throw away some precision depending on the size of the number
      var doseString = dose.toStringAsFixed(2);
      if (doseString.length > 5) {
        doseString = dose.toStringAsFixed(1);
      }
      if (doseString.length > 4) {
        doseString = dose.toStringAsFixed(0);
      }

      calcDrugToAdd = '$doseString $doseUnits';

      calcPostNarrative =
          'Add $doseString $doseUnits of $name to the syringe, then make up to $syringe mL with $stringFluids';

      // Strip trailing zeros throghout

      calcPreNarrative = calcPreNarrative.replaceAll('.0 ', ' ');
      calcTop = calcTop.replaceAll('.0 ', ' ');
      calcBottom = calcBottom.replaceAll('.0 ', ' ');
      calcRight = calcRight.replaceAll('.0 ', ' ');
      calcDrugToAdd = calcDrugToAdd.replaceAll('.0 ', ' ');
      calcPostNarrative = calcPostNarrative.replaceAll('.0 ', ' ');
      return;
    }
  }

  static final invalid = DrugInfusion(
    types: [],
    name: '?',
    deliveryTime: DeliveryTime.invalid,
    deliveryUnits: DeliveryUnits.invalid,
    startDose: 0,
    fluids: [],
    desiredRate: 0,
    syringe: 0,
    minConc: 0,
    maxConc: 0,
    minConcMsg: '?',
    maxConcMsg: '?',
    minDose: 0,
    maxDose: 0,
    doseMsg: '?',
  );

  @override
  DrugInfusion bindWeight(double myWeight) {
    if (weight is double) {
      // If a weight is already bound then something is wrong, so return the invalid static instance
      return invalid;
    } else {
      // Build a new instance with the weight bound in
      return DrugInfusion(
        types: types,
        name: name,
        deliveryTime: deliveryTime,
        deliveryUnits: deliveryUnits,
        startDose: startDose,
        fluids: fluids,
        desiredRate: desiredRate,
        syringe: syringe,
        minConc: minConc,
        maxConc: maxConc,
        minConcMsg: minConcMsg,
        maxConcMsg: maxConcMsg,
        minDose: minDose,
        maxDose: maxDose,
        doseMsg: doseMsg,
        weight: myWeight,
      );
    }
  }
}

class Neomate {
  double fiO2 = double.nan;
  double MAP = double.nan;
  double paO2 = double.nan;
  double babyWeight = double.nan;
  bool weightIsEst = false;

  static double minWeight = 0.2;
  static double maxWeight = 6.0;
  static double minWeightGrams = 200;
  static double maxWeightGrams = 6000;

  static Map<int, double> weightEstimates = {
    /*Source: 50th centile average birthweight of male/female infants, using RCPCH UK–WHO Neonatal and Infant Close Monitoring Growth Chart 2009
    Cole TJ, Freeman JV, Preece MA. British 1990 growth reference centiles for weight, height, body mass index and head circumference fitted by maximum penalized likelihood.
    Stat.Med. 1998;17:407-29.*/
    23: 587,
    24: 686,
    25: 789,
    26: 896,
    27: 1007,
    28: 1125,
    29: 1253,
    30: 1398,
    31: 1565,
    32: 1756,
    33: 1966,
    34: 2191,
    35: 2423,
    36: 2658,
    37: 2888,
    38: 3106,
    39: 3307,
    40: 3484,
    41: 3636,
    42: 3772
  };

  static List<Drug> drugDb = [
    // Intubation Drugs
    DrugBanded(
      types: [DrugType.intubation],
      name: 'Endotracheal tube size',
      minWeight: double.nan,
      maxWeight: double.nan,
      units: 'mm',
      instructions: 'internal diameter',
      bands: {
        0: "2.5",
        1: "3.0",
        2: "3.5",
        3: "3.5-4.0",
      },
    ),
    DrugBanded(
      types: [DrugType.intubation],
      name: 'Endotracheal tube length',
      minWeight: double.nan,
      maxWeight: double.nan,
      units: 'cm',
      instructions: 'at lips',
      bands: {
        0: "5.5",
        0.7: "6.0",
        0.9: "6.5",
        1.1: "7.0",
        1.5: "7.5",
        1.9: "8.0",
        2.5: "8.5",
        3.2: "9.0"
      },
    ),
    DrugMultiplier(
      types: [
        DrugType.intubation,
        DrugType.sedative,
      ],
      name: 'Fentanyl bolus',
      dose: '5 mcg/kg',
      multiplier: 5,
      units: 'micrograms',
      instructions: 'by slow IV push',
      notes: 'preferred drug for intubation',
    ),
    DrugMultiplier(
      types: [
        DrugType.intubation,
        DrugType.sedative,
      ],
      name: 'Morphine bolus',
      dose: '100 mcg/kg',
      multiplier: 100,
      units: 'micrograms',
      instructions: 'by slow IV push',
      notes: 'onset of action approx 15 minutes; peak action at 15-30 mins',
    ),
    DrugMultiplier(
      types: [DrugType.intubation],
      name: 'Atropine',
      dose: '20 mcg/kg',
      multiplier: 20,
      units: 'micrograms',
      instructions: 'by slow IV push',
    ),
    DrugMultiplier(
      types: [DrugType.intubation],
      name: 'Suxamethonium',
      dose: '2 mg/kg',
      multiplier: 2,
      units: 'mg',
      instructions: 'by slow IV push',
    ),
    DrugMultiplier(
      types: [DrugType.intubation],
      name: 'Poractant Alfa (Curosurf \u24c7)',
      dose: '200 mg/kg',
      qualifier: 'First dose',
      multiplier: 200,
      units: 'mg',
      instructions: 'via ET tube',
      notes: 'consider giving nearest whole vial',
      followOn: DrugMultiplier(
        types: [DrugType.intubation],
        name: 'Poractant Alfa (Curosurf \u24c7)',
        dose: '100 mg/kg',
        qualifier: 'Second dose',
        multiplier: 100,
        units: 'mg',
        instructions: 'via ET tube',
      ),
    ),
    // Cardiac Drugs
    DrugMultiplier(
        types: [DrugType.cardiac],
        name: '0.9% NaCl Bolus',
        dose: '10 mL/kg',
        multiplier: 10,
        units: 'mL',
        instructions: 'over 20-30 minutes IV'),
    // Sedative Drugs
    // Fentayl and Morphine already included under intubation
    DrugMultiplier(
      types: [DrugType.sedative],
      name: 'Pancuronium Bolus',
      dose: '100 mcg/kg',
      multiplier: 100,
      units: 'micrograms',
      instructions: 'by slow IV push',
      notes: 'for longer duration of action',
    ),
    DrugMultiplier(
      types: [DrugType.sedative],
      name: 'Vecuronium Bolus',
      dose: '100 mcg/kg',
      multiplier: 100,
      units: 'micrograms',
      instructions: 'by slow IV push',
      notes: 'for shorter duration of action',
    ),
    DrugInfusion(
        types: [DrugType.cardiac],
        name: 'Dopamine',
        deliveryUnits: DeliveryUnits.microgramsPerKg,
        deliveryTime: DeliveryTime.perMinute,
        units: 'mcg/kg/min',
        startDose: 5,
        fluids: [FluidType.D5W, FluidType.NS],
        desiredRate: 1,
        syringe: 50,
        minConc: 0,
        maxConc: 80,
        minConcMsg: '',
        maxConcMsg:
            'Concentrations higher than 1.6 mg/ml are not recommended, unless infused centrally (BNFc 2015).',
        minDose: 5,
        maxDose: 20,
        doseMsg: 'Usual dose 5-20 mcg/kg/min, <b>via central line</b>.'),
    DrugInfusion(
        types: [DrugType.cardiac],
        name: 'Dobutamine',
        deliveryUnits: DeliveryUnits.microgramsPerKg,
        deliveryTime: DeliveryTime.perMinute,
        units: 'mcg/kg/min',
        startDose: 5,
        fluids: [FluidType.D5W, FluidType.NS],
        desiredRate: 1,
        syringe: 50,
        minConc: 0,
        maxConc: 500,
        minConcMsg: '',
        maxConcMsg:
            'Concentrations higher than 10mg/ml are not commonly used (Medusa 2015)',
        minDose: 2,
        maxDose: 20,
        doseMsg: 'Usual dose 2-20 mcg/kg/min, via central line'),
    DrugInfusion(
        types: [DrugType.cardiac],
        name: 'Adrenaline',
        deliveryUnits: DeliveryUnits.nanogramsPerKg,
        deliveryTime: DeliveryTime.perMinute,
        units: 'ng/kg/min',
        startDose: 100,
        fluids: [FluidType.D5W, FluidType.NS],
        desiredRate: 0.1,
        syringe: 50,
        minConc: 0,
        maxConc: 12,
        minConcMsg: '',
        maxConcMsg:
            'DrugInfusions of >12mg in 50ml are not usually recommended (Medusa 2015).',
        minDose: 50,
        maxDose: 500,
        doseMsg: 'Usual dose 50-500 nanograms/kg/min, via central line'),
    DrugInfusion(
        types: [DrugType.cardiac],
        name: 'Noradrenaline',
        deliveryUnits: DeliveryUnits.nanogramsPerKg,
        deliveryTime: DeliveryTime.perMinute,
        units: 'ng/kg/min',
        startDose: 100,
        fluids: [FluidType.D5W, FluidType.NS],
        desiredRate: 0.1,
        syringe: 50,
        minConc: 0,
        maxConc: 2,
        minConcMsg: '',
        maxConcMsg:
            'Higher than recommended concentration: max. 40 micrograms/mL (higher concentrations can be used if fluid restricted) - BNFc Jan 2015.',
        minDose: 50,
        maxDose: 500,
        doseMsg: 'Usual dose 50-500 nanograms/kg/min, via central line'),
    DrugInfusion(
        types: [DrugType.cardiac],
        name: 'Dinoprostone',
        deliveryUnits: DeliveryUnits.nanogramsPerKg,
        deliveryTime: DeliveryTime.perMinute,
        units: 'ng/kg/min',
        startDose: 10,
        fluids: [FluidType.D5W, FluidType.NS],
        desiredRate: 1,
        syringe: 50,
        minConc: 0,
        maxConc: 0.05,
        minConcMsg: '',
        maxConcMsg:
            'Higher than recommended concentration: BNFc recommends dilution to 1 microgram/mL.',
        minDose: 1,
        maxDose: 20,
        doseMsg: 'Usual dose 5-10 nanograms/kg/min'),
    // Sedative Drugs
    DrugInfusion(
        types: [DrugType.sedative],
        name: 'Morphine',
        deliveryUnits: DeliveryUnits.microgramsPerKg,
        deliveryTime: DeliveryTime.perHour,
        units: 'mcg/kg/hr',
        startDose: 20,
        fluids: [FluidType.D5W, FluidType.NS],
        desiredRate: 1,
        syringe: 50,
        minConc: 0,
        maxConc: 1500,
        minConcMsg: '',
        maxConcMsg: 'Higher than recommended concentration.',
        minDose: 0,
        maxDose: 60,
        doseMsg: 'Usual dose 5-20 mcg/kg/hr, but higher doses may be used.'),
    DrugInfusion(
        types: [DrugType.sedative],
        name: 'Vecuronium',
        deliveryUnits: DeliveryUnits.microgramsPerKg,
        deliveryTime: DeliveryTime.perHour,
        units: 'mcg/kg/hr',
        startDose: 100,
        fluids: [FluidType.D5W, FluidType.NS],
        desiredRate: 1,
        syringe: 50,
        minConc: 4,
        maxConc: 200,
        minConcMsg:
            'Too dilute: Do not dilute to a concentration of less than 40micrograms in 1mL. (BNF for Children January 2015)',
        maxConcMsg:
            'Higher than recommended concentration: Dilute to an ideal maximum concentration of 2mg in 1mL. (BNF for Children January 2015)',
        minDose: 50,
        maxDose: 200,
        doseMsg: 'Usual dose 50-200 mcg/kg/hr'),
    // Neurology Drugs
    DrugMultiplier(
      types: [DrugType.neurology],
      name: 'Phenobarbital',
      dose: 'Loading dose 20 mg/kg',
      multiplier: 20,
      units: 'mg',
      instructions: 'given IV over 20 minutes',
      qualifier: 'loading dose',
      followOn: DrugMultiplier(
        types: [DrugType.neurology],
        name: 'Phenobarbital',
        dose: '10 mg/kg',
        multiplier: 10,
        units: 'mg',
        instructions: 'IV over 20 minutes',
        qualifier: 'subsequent dose',
      ),
    ),
    DrugMultiplier(
      types: [DrugType.neurology],
      name: 'Phenytoin',
      dose: 'Loading dose 18 mg/kg',
      multiplier: 18,
      units: 'mg',
      instructions: 'given IV over 30 minutes with close ECG monitoring',
    ),
    DrugMultiplier(
      types: [DrugType.neurology],
      name: 'Midazolam Bolus',
      dose: '300 mcg/kg',
      multiplier: 300,
      units: 'micrograms',
      instructions: 'IV over 5 minutes',
      notes: 'further dose after 10 minutes if required',
    ),
    DrugInfusion(
        types: [DrugType.neurology],
        name: 'Clonazepam',
        deliveryUnits: DeliveryUnits.microgramsPerKg,
        deliveryTime: DeliveryTime.perHour,
        units: 'mcg/kg/hr',
        startDose: 10,
        fluids: [FluidType.D5W, FluidType.NS],
        desiredRate: 1,
        syringe: 50,
        minConc: 0,
        maxConc: 0.6,
        minConcMsg: '',
        maxConcMsg:
            'Higher than recommended concentration: Dilute to a maximum concentration of 12micrograms in 1mL. (Medusa 2015)',
        minDose: 10,
        maxDose: 40,
        doseMsg: 'Usual dose 10-40 mcg/kg/hr'),
    DrugInfusion(
        types: [DrugType.neurology],
        name: 'Midazolam',
        deliveryUnits: DeliveryUnits.microgramsPerKg,
        deliveryTime: DeliveryTime.perHour,
        units: 'mcg/kg/hr',
        startDose: 30,
        fluids: [FluidType.D5W, FluidType.NS],
        desiredRate: 0.1,
        syringe: 50,
        minConc: 0,
        maxConc: 50,
        minConcMsg: '',
        maxConcMsg:
            'Higher than recommended concentration of 1mg / ml (Medusa 2015; BNF).',
        minDose: 30,
        maxDose: 300,
        doseMsg: 'Usual dose 10-60 mcg/kg/hr'),
    // Emergency Drugs
    DrugMultiplier(
      types: [DrugType.emergency],
      name: 'Adrenaline 1:10000',
      dose: '0.2 mL/kg',
      multiplier: 0.2,
      units: 'mL',
      instructions: 'IV stat then flush with 0.9% sodium chloride',
    ),
    DrugMultiplier(
      types: [DrugType.emergency],
      name: 'Dextrose 10% bolus',
      dose: '2.5 mL/kg',
      multiplier: 2.5,
      units: 'mL',
      instructions: 'IV over 20-30 minutes',
    ),
    DrugMultiplier(
      types: [DrugType.emergency],
      name: 'Sodium bicarbonate 4.2%',
      dose: '2 mL/kg',
      qualifier: '1 mmol/kg for emergency resuscitation',
      multiplier: 2,
      units: 'mL',
      instructions: 'of sodium bicarbonate 4.2% via central line',
      notes:
          'double check concentration, 4.2% and 8.4% forms are easily confused',
    ),
    DrugInfo(
      types: [DrugType.emergency],
      name: 'Sodium bicarbonate',
      qualifier: '',
      units: '',
      info: 'Base deficit (mmol/L) x 0.6 x weight ({w} kg)',
      instructions: '',
      notes:
          'Initially give half the above. Sodium bicarbonate 4.2% diluted with equal part water given IV over 30 minutes',
    ),
    DrugMultiplier(
      types: [DrugType.emergency],
      name: 'Adenosine',
      dose: '150 mcg/kg',
      multiplier: 150,
      units: 'micrograms',
      instructions:
          'IV stat into a large central vein followed immediately by a NaCl 0.9% flush',
      notes: 'escalating doses may be required',
    ),
  ];

  Neomate();

  bool estimateWeight(int gestation) {
    if (gestation < 23 || gestation > 42) {
      babyWeight = double.nan;
      return false;
    } else {
      // Lots of fiddling for type and null safety
      babyWeight = weightEstimates[gestation] ?? double.nan;
      if (!babyWeight.isNaN) {
        babyWeight = babyWeight / 1000;
        return true;
      } else {
        return false;
      }
    }
  }

  bool setWeightGrams(double newWeightGrams) {
    double newWeight = newWeightGrams / 1000;
    if (newWeight > minWeight && newWeight < maxWeight) {
      babyWeight = newWeight;
      print('New weight in class $babyWeight');
      return true;
    } else {
      babyWeight = double.nan;
      return false;
    }
  }

  String weightString() {
    if (babyWeight.isNaN) {
      return 'Please enter a weight';
    } else {
      return weightIsEst
          ? '${babyWeight * 1000} g (Estimated)'
          : '${babyWeight * 1000} g';
    }
  }

  String weightStringShort() {
    if (babyWeight.isNaN) {
      return '';
    } else {
      return (babyWeight * 1000).round().toString();
    }
  }

  double weightNumGrams() {
    return babyWeight * 1000;
  }

  List<Drug> drugList(DrugType myType) {
    // Find all the drugs of a given type
    // Then return a list of new Drugs with the weight bound in
    var myList = drugDb.where((drug) => drug.types.contains(myType));
    List<Drug> newList = [];
    for (var drug in myList) {
      newList.add(drug.bindWeight(babyWeight));
    }
    return newList;
  }
}
