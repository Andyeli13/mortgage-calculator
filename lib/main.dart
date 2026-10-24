import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'mortgage_provider.dart';
import 'summary_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load saved loan data before the first screen appears
  final provider = MortgageProvider();
  await provider.load();

  runApp(
    ChangeNotifierProvider.value(value: provider, child: const MortgageApp()),
  );
}

class MortgageApp extends StatelessWidget {
  const MortgageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mortgage Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const SummaryScreen(),
    );
  }
}
