import 'package:flutter_test/flutter_test.dart';
import 'package:neomate2/neomate.dart';

void main() {
  group('inherited calculation regression baseline', () {
    test('accepts weights strictly within the inherited neonatal range', () {
      final neomate = Neomate();

      expect(neomate.setWeightGrams(200), isFalse);
      expect(neomate.weightValid, isFalse);

      expect(neomate.setWeightGrams(1000), isTrue);
      expect(neomate.weightNumKg(), 1.0);
      expect(neomate.weightStringShort(), '1000 g');

      expect(neomate.setWeightGrams(6000), isFalse);
      expect(neomate.weightValid, isFalse);
    });

    test('calculates oxygenation index for stated legacy units', () {
      final results = Neomate.oiCalculator(
        inspiredO2: 50,
        map: 10,
        paO2: 10,
        mapUnits: MapUnits.cmH2O,
        paO2Units: PaO2Units.kPa,
      );

      final formula = results.resultLines.whereType<CalcFormula>().single;

      expect(results.heading, 'Oxygenation Index (OI) Calculation');
      expect(formula.result, '= 6.7 oxygenation index (ratio with no units)');
      expect(results.resultLines.whereType<CalcWarning>(), isEmpty);
    });

    test('preserves the inherited mean airway pressure calculation', () {
      final results = Neomate.mapCalc(
        rate: 60,
        ti: 0.4,
        te: 0.6,
        pip: 18,
        peep: 4,
      );

      final formulae = results.resultLines.whereType<CalcFormula>().toList();

      expect(formulae, hasLength(2));
      expect(formulae.last.result, ' = 9.6 cmH₂O Mean Airway Pressure');
    });
  });
}
