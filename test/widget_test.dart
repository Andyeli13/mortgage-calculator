import 'package:flutter_test/flutter_test.dart';
import 'package:mortgage_calculator/main.dart';
import 'package:mortgage_calculator/mortgage_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> pumpApp(WidgetTester tester, MortgageProvider provider) async {
  await tester.pumpWidget(
    ChangeNotifierProvider.value(value: provider, child: const MortgageApp()),
  );
}

void main() {
  testWidgets('first launch starts at zero', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final provider = MortgageProvider();
    await provider.load();
    await pumpApp(tester, provider);

    expect(find.text('Mortgage Calculator'), findsOneWidget);
    expect(find.text('\$0.00'), findsNWidgets(3)); // amount, monthly, total
    expect(find.text('MODIFY DATA'), findsOneWidget);
  });

  testWidgets('relaunch shows the values saved last time', (tester) async {
    // Pretend the user saved these values in a previous run of the app
    SharedPreferences.setMockInitialValues({
      'amount': 250000.0,
      'years': 15,
      'rate': 0.04,
    });
    final provider = MortgageProvider();
    await provider.load();
    await pumpApp(tester, provider);

    expect(find.text('\$250,000.00'), findsOneWidget);
    expect(find.text('15'), findsOneWidget);
    expect(find.text('4%'), findsOneWidget);
  });
}
