import 'package:flutter_test/flutter_test.dart';
import 'package:neomate2/main.dart';

void main() {
  testWidgets('shows the primary Neomate navigation destinations',
      (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('NeoMate NICU Calc'), findsOneWidget);
    expect(find.text('NICU Calc'), findsOneWidget);
    expect(find.text('Checklists'), findsOneWidget);
    expect(find.text('Reference'), findsOneWidget);
    expect(find.text('About'), findsOneWidget);
  });
}
