///
///
///   Neomate 2.0
///
///   Original app by Christopher Kelly
///
///   Reimplemented for Dart/Flutter by Lee Collier
///
///

import 'dart:math';

// Surprisingly there is no built-in function to round to decimal places

extension Precision on double {
  double toPrecision(int fractionDigits) {
    double mod = (pow(10, fractionDigits.toDouble())).toDouble();
    return ((this * mod).round().toDouble() / mod);
  }
}

// Define some classes for bolus drugs and infusions

enum DrugType {
  intubation,
  central,
  cardiac,
  sedative,
  neurology,
  emergency,
  bolus,
  generic,
}

enum DeliveryUnits {
  invalid,
  gPerKg,
  mgPerKg,
  microgramsPerKg,
  nanogramsPerKg,
}

enum MapUnits {
  cmH2O,
  mmHg,
}

enum PaO2Units {
  kPa,
  mmHg,
}

class OIResults {
  String formulaTop;
  String formulaBottom;
  double result;
  String resultString;
  String mmHgToCmH2O;
  String kPaToMmHg;
  String warning;

  OIResults({
    required this.formulaTop,
    required this.formulaBottom,
    required this.result,
    required this.resultString,
    required this.mmHgToCmH2O,
    required this.kPaToMmHg,
    required this.warning,
  });
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

Map<DeliveryUnits, String> stringShortUnits = {
  DeliveryUnits.gPerKg: 'g/kg',
  DeliveryUnits.mgPerKg: 'mg/kg',
  DeliveryUnits.microgramsPerKg: 'mcg/kg',
  DeliveryUnits.nanogramsPerKg: 'ng/kg',
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

class IVInfusionDetails {
  // Used as a type to pass details of a daily infusion calculation
  final String total;
  final String sodium;
  final String potassium;
  final String girTop;
  final String girBottom;
  final String girResult;
  final String sodiumTop;
  final String potassiumTop;
  final String electrolyteBottom;
  final String dexTop;
  final String dexBottom;
  final String dexSummary;

  IVInfusionDetails({
    required this.total,
    required this.sodium,
    required this.potassium,
    required this.sodiumTop,
    required this.potassiumTop,
    required this.electrolyteBottom,
    required this.girTop,
    required this.girBottom,
    required this.girResult,
    required this.dexTop,
    required this.dexBottom,
    required this.dexSummary,
  });
}

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

enum FormulaType {
  UVC,
  UAC,
  invalid,
}

class DrugFormula extends Drug {
  FormulaType formulaType;
  String calcFormula = '';

  DrugFormula({
    required types,
    required this.formulaType,
    required name,
    qualifier = '',
    required units,
    required instructions,
    followOn,
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
      } else {
        switch (formulaType) {
          case FormulaType.UAC:
            calcFormula = '($weight kg x 3) + 9';
            calcString = ((weight * 3) + 9).toStringAsFixed(1);
            break;
          case FormulaType.UVC:
            calcFormula = '($weight kg x 1.5) + 5.5';
            calcString = ((weight * 1.5) + 5.5).toStringAsFixed(1);
            break;
          default:
        }
      }
    }
  }

  static final invalid = DrugFormula(
      formulaType: FormulaType.invalid,
      types: [],
      name: '',
      instructions: '',
      units: '');

  @override
  DrugFormula bindWeight(double myWeight) {
    if (weight is double) {
      // If a weight is already bound then something is wrong, so return the invalid static instance
      return invalid;
    } else {
      // Build a new instance with the weight bound in
      return DrugFormula(
        formulaType: formulaType,
        types: types,
        name: name,
        qualifier: qualifier,
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
  String doseRange;
  String calcPreNarrative = 'Not calculated';
  String calcPostNarrative = 'Not calculated';
  String calcTop = 'Not calculated';
  String calcBottom = 'Not calculated';
  String calcRight = '';
  String calcDrugToAdd = 'Not calculated';
  bool dilute;
  String concentratedCalc = '';
  String concentratedDoseRange = '';

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
    required this.doseRange,
    weight,
    this.dilute = false,
    this.concentratedDoseRange = '',
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
      // calcTop, calcBottom and calcRight are strings to make up a display of the formula
      // Dose is the running total of the drug to be added to the syringe
      // calcPreNarrative is a description of the calculation

      calcPreNarrative =
          '$desiredRate mL/h = $startDose ${stringUnits[deliveryUnits]}${stringTime[deliveryTime]}';
      double dose = 0.0;

      calcTop =
          '$startDose (${stringShortUnits[deliveryUnits]}${stringTime[deliveryTime]})';
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

      // Create dilute solution
      if (dilute) {
        var concentratedRate = desiredRate / 10;
        var concentratedDose = dose * 10;

        concentratedCalc =
            '$dose $doseUnits x 10 = $concentratedDose $doseUnits in 50mL syringe';
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

      // Create dilute solution
      if (dilute) {
        var concentratedRate = desiredRate / 10;
        var concentratedDose = dose * 10;

        var concentratedDoseString = concentratedDose.toStringAsFixed(2);

        if (concentratedDoseString.length > 5) {
          concentratedDoseString = concentratedDose.toStringAsFixed(1);
        }
        if (concentratedDoseString.length > 4) {
          concentratedDoseString = concentratedDose.toStringAsFixed(0);
        }

        concentratedCalc =
            '${dose.toStringAsFixed(2)} $doseUnits x 10 = $concentratedDoseString $doseUnits in 50mL syringe';
      }

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
      doseRange: '',
      dilute: false);

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
          doseRange: doseRange,
          dilute: dilute,
          concentratedDoseRange: concentratedDoseRange);
    }
  }
}

class Neomate {
  double fiO2 = double.nan;
  double MAP = double.nan;
  double paO2 = double.nan;
  double babyWeight = double.nan;
  bool weightIsEst = false;
  bool weightValid = false;

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
    // Central line drugs
    DrugFormula(
      types: [DrugType.central],
      formulaType: FormulaType.UVC,
      name: 'UVC',
      qualifier: 'Umbilical Venous Catheter',
      units: 'cm',
      instructions: 'plus stump',
    ),
    DrugFormula(
      types: [DrugType.central],
      formulaType: FormulaType.UAC,
      name: 'UAC',
      qualifier: 'Umbilical Arterial Catheter',
      units: 'cm',
      instructions: 'plus stump',
    ),
    DrugInfo(
        name: 'Heparin',
        info:
            'Add 50 units heparin to 50mL sodium chloride 0.45%. Infuse at 0.5 mL/h',
        types: [DrugType.central],
        units: '',
        instructions: ''),
    DrugInfo(
        name: 'Heparin Bicarbonate',
        info: 'Need to confirm',
        types: [DrugType.central],
        units: '',
        instructions: ''),
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
        doseRange: '5-20 microrams/kg/min',
        doseMsg: '1-4 mL/h gives 5-20 mcg/kg/min, via central line.',
        dilute: true,
        concentratedDoseRange: '0.1-0.4 mL/h gives 5-20 mcg/kg/min'),
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
        doseRange: '2-20 micrograms/kg/min',
        doseMsg: '0.4-4 mL/h gives 2-20 mcg/kg/min, via central line',
        concentratedDoseRange: '0.1-0.4 mL/h gives 5-20 mcg/kg/min',
        dilute: true),
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
        doseRange: '100-500 nanograms/kg/min',
        doseMsg:
            '0.1-0.5 mL/h gives 100-500 nanograms/kg/min, via central line'),
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
        doseRange: '100-500 nanograms/kg/min',
        doseMsg:
            '0.1-0.5 mL/h gives 100-500 nanograms/kg/min, via central line'),
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
        doseRange: '5-10 nanograms/kg/min',
        doseMsg: '0.5-1 mL/h gives 5-10 nanograms/kg/min'),
    // Sedative Drugs
    DrugInfusion(
        types: [DrugType.sedative],
        name: 'Morphine',
        deliveryUnits: DeliveryUnits.microgramsPerKg,
        deliveryTime: DeliveryTime.perHour,
        units: 'mcg/kg/hr',
        startDose: 5,
        fluids: [FluidType.D5W, FluidType.NS],
        desiredRate: 0.1,
        syringe: 50,
        minConc: 0,
        maxConc: 1500,
        minConcMsg: '',
        maxConcMsg: 'Higher than recommended concentration.',
        minDose: 0,
        maxDose: 60,
        doseRange: '5-20 micrograms/kg/hour',
        doseMsg:
            '0.1-0.4 mL/h gives 5-20 mcg/kg/h, usual range but doses up to 40 mcg/kg/h may occasionally be used',
        dilute: false),
    DrugInfusion(
        types: [DrugType.sedative],
        name: 'Vecuronium',
        deliveryUnits: DeliveryUnits.microgramsPerKg,
        deliveryTime: DeliveryTime.perHour,
        units: 'mcg/kg/hr',
        startDose: 50,
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
        doseRange: '50-200 micrograms/kg/hour',
        doseMsg: '1-4 mL/h gives 50-200 mcg/kg/h',
        concentratedDoseRange: '0.1-0.4 mL/h gives 50-200 mcg/kg/h',
        dilute: true),
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
        doseRange: '10-40 micrograms/kg/hour',
        doseMsg: '1-4 mL/h gives 10-40 mcg/kg/hr',
        dilute: true),
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
        doseRange: '30-60 micrograms/kg/hour',
        doseMsg: '0.1-0.2 mL/h gives 30-60 mcg/kg/h'),
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
      name: 'Sodium bicarbonate 4.2%',
      dose: '2 mL/kg',
      qualifier: '1 mmol/kg for emergency resuscitation',
      multiplier: 2,
      units: 'mL',
      instructions: 'of sodium bicarbonate 4.2% via central line',
      notes:
          'double check concentration, 4.2% and 8.4% forms are easily confused',
    ),
    DrugMultiplier(
      types: [
        DrugType.emergency,
        DrugType.bolus,
      ],
      name: '0.9% saline bolus',
      dose: '10 mL/kg',
      multiplier: 10,
      units: 'mL',
      instructions: 'IV over 20-30 minutes',
    ),
    DrugMultiplier(
      types: [
        DrugType.emergency,
        DrugType.bolus,
      ],
      name: 'Dextrose 10% bolus',
      dose: '2.5 mL/kg',
      multiplier: 2.5,
      units: 'mL',
      instructions: 'IV over 20-30 minutes',
    ),
    DrugInfo(
      types: [DrugType.emergency],
      name: 'Sodium bicarbonate',
      qualifier: 'Full correction',
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
      weightValid = false;
      return false;
    } else {
      // Lots of fiddling for type and null safety
      babyWeight = weightEstimates[gestation] ?? double.nan;
      if (!babyWeight.isNaN) {
        babyWeight = babyWeight / 1000;
        weightValid = true;
        return true;
      } else {
        weightValid = false;
        return false;
      }
    }
  }

  bool setWeightGrams(double newWeightGrams) {
    double newWeight = newWeightGrams / 1000;
    if (newWeight > minWeight && newWeight < maxWeight) {
      babyWeight = newWeight;
      print('New weight in class $babyWeight');
      weightValid = true;
      return true;
    } else {
      babyWeight = double.nan;
      weightValid = false;
      return false;
    }
  }

  String weightString() {
    if (babyWeight.isNaN) {
      return 'Weight';
    } else {
      return '${(babyWeight * 1000).toStringAsFixed(0)} g';
    }
  }

  String weightStringShort() {
    if (babyWeight.isNaN) {
      return '';
    } else {
      return '${(babyWeight * 1000).round().toString()} g';
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

  static OIResults oiCalculator({
    required double inspiredO2,
    required double map,
    required double paO2,
    required MapUnits mapUnits,
    required PaO2Units paO2Units,
  }) {
    var mmHgToCmH2O = '';
    var kPaToMmHg = '';
    var warning = '';

    if (mapUnits == MapUnits.mmHg) {
      var oldunits = map;
      map = map * 1.36;
      mmHgToCmH2O =
          'To convert MAP units: $oldunits mmHg x 1.36 = ${map.toStringAsFixed(1)} cmH\u2082O';
    }

    if (paO2Units == PaO2Units.kPa) {
      var oldunits = paO2;
      paO2 = paO2 * 7.5;
      kPaToMmHg =
          'To convert PaO\u2082 units: $oldunits kPa x 7.5 = ${paO2.toStringAsFixed(1)} mmHg';
    }

    var result = (map * inspiredO2) / paO2;
    var formulaTop =
        '${map.toStringAsFixed(1)} (cmH\u2082O Mean Airway Pressure) x ${inspiredO2.toStringAsFixed(0)} (% FiO\u2082)';
    var formulaBottom = '${paO2.toStringAsFixed(1)} (mmHg PaO\u2082)';

    var resultString = result.toStringAsFixed(1);

    return OIResults(
      formulaTop: formulaTop,
      formulaBottom: formulaBottom,
      result: result,
      resultString: resultString,
      mmHgToCmH2O: mmHgToCmH2O,
      kPaToMmHg: kPaToMmHg,
      warning: warning,
    );
  }

  IVInfusionDetails maintIV(
      {required double dex,
      required double sodium,
      required double potassium,
      required double total}) {
    // these are all worked out for 500 mL bag
    // electrolytes are in mmol/kg

    // Daily totals
    var mLperDay = total * babyWeight;
    var mLperHour = (mLperDay / 24).toPrecision(1);

    var stringTotal =
        '$babyWeight kg x ${total.toStringAsFixed(0)} mL/kg/day = ${mLperDay.toStringAsFixed(1)} mL/day \ndivided by 24 = ${mLperHour.toStringAsFixed(1)} mL/hour infusion rate';
    stringTotal = stringTotal.replaceAll('.0 ', ' ');

    // Glucose infusion rate
    var girResult = (dex * 1000 * mLperHour) / (babyWeight * 60 * 100);
    print(girResult);
    var girTop =
        '$dex (%) x 1000 (mg/g) x ${mLperHour.toStringAsFixed(1)} (mL/h rate) ';
    var girBottom = '$babyWeight (kg) x 60 (min/h) x 100 (mL/dL)';
    var girResultString = '= ${girResult.toStringAsFixed(1)} mg/kg/min';

    girTop = girTop.replaceAll('.0 ', ' ');

    var dexTop = '';
    var dexBottom = '500 mL bag';
    var dexSummary = '';

    // Non-standard dextrose
    if (dex < 10 && dex > 5) {
      var proportionDex = (50 - dex) / (50 - 5);
      var addFifty = (((1 - proportionDex) * 500) * 10) / 10;
      addFifty = addFifty.toPrecision(1);
      var remainingFive = 500 - addFifty;
      dexTop =
          '(500 - $addFifty = $remainingFive mL x 5%) + ($addFifty mL x 50%)';
      dexSummary =
          'Take a 500mL bag of 5% dextrose, remove $addFifty mL then add $addFifty mL of 50% dextrose';
    }
    if (dex > 10) {
      var proportionDex = (50 - dex) / (50 - 10);
      var addFifty = (((1 - proportionDex) * 500) * 10) / 10;
      addFifty = addFifty.toPrecision(1);
      var remainingTen = 500 - addFifty;
      dexTop =
          '(500 - $addFifty = $remainingTen mL x 10%) + ($addFifty mL x 50%)';
      dexSummary =
          'Take a 500mL bag of 10% dextrose, remove $addFifty mL then add $addFifty mL of 50% dextrose';
    }

    // Electrolytes
    var sodiumToAdd = (sodium * babyWeight * 500) / mLperDay;
    var sodiumString =
        '= ${sodiumToAdd.toStringAsFixed(2)} mmol sodium added to 500mL bag';
    var sodiumTop = '$sodium (mmol/kg/day) x $babyWeight (kg) x 500 (mL bag)';

    var potassiumToAdd = (potassium * babyWeight * 500) / mLperDay;
    var potassiumString =
        '= ${potassiumToAdd.toStringAsFixed(2)} mmol potassium added to 500mL bag';
    var potassiumTop =
        '$potassium (mmol/kg/day) x $babyWeight (kg) x 500 (mL bag)';

    var electrolyteBottom = '${mLperDay.toStringAsFixed(1)} (mL/day)';

    return IVInfusionDetails(
      total: stringTotal,
      dexTop: dexTop,
      dexBottom: dexBottom,
      dexSummary: dexSummary,
      girTop: girTop,
      girBottom: girBottom,
      girResult: girResultString,
      sodium: sodiumString,
      potassium: potassiumString,
      sodiumTop: sodiumTop,
      potassiumTop: potassiumTop,
      electrolyteBottom: electrolyteBottom,
    );
  }
}
