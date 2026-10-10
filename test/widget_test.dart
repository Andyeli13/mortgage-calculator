import 'package:flutter_test/flutter_test.dart';
import 'package:mortgage_calculator/main.dart';

void main() {
  testWidgets('app starts at zero with the expected controls', (tester) async {
    await tester.pumpWidget(const MortgageApp());

    expect(find.text('Mortgage Calculator'), findsOneWidget);
    expect(find.text('\$0.00'), findsNWidgets(3)); // amount, monthly, total
    expect(find.text('Terms and Conditions'), findsOneWidget);
    expect(find.text('MODIFY DATA'), findsOneWidget);
  });
}