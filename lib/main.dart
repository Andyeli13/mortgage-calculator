import 'package:flutter/material.dart';

import 'summary_screen.dart';

void main() => runApp(const MortgageApp());

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
