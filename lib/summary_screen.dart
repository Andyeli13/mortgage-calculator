import 'package:flutter/material.dart';

import 'modify_screen.dart';
import 'mortgage.dart';

/// Screen 1: shows the mortgage data and results.
class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  Mortgage _mortgage = Mortgage();
  bool _termsAccepted = false;

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(label, style: const TextStyle(fontSize: 16)),
          ),
          Expanded(
            flex: 3,
            child: Text(value, style: const TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  /// Opens the modify screen, passing a copy of the data, and waits for the updated Mortgage to come back when the user presses DONE.
  Future<void> _openModifyScreen() async {
    final result = await Navigator.push<Mortgage>(
      context,
      MaterialPageRoute(
        builder: (_) => ModifyScreen(mortgage: Mortgage.copy(_mortgage)),
      ),
    );
    if (result != null) {
      setState(() => _mortgage = result);
    }
  }

  /// Alert dialog that confirms the terms and conditions.
  Future<void> _showTermsDialog() async {
    final agreed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Terms and Conditions'),
        content: const Text(
          'Do you confirm that you have read and agree to the terms and '
          'conditions of this mortgage estimate? The figures shown are '
          'estimates only and do not include taxes, insurance or fees.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('DECLINE'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('AGREE'),
          ),
        ],
      ),
    );
    setState(() => _termsAccepted = agreed ?? false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mortgage Calculator'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _row('Amount', _mortgage.getFormattedAmount()),
            _row('Years', '${_mortgage.getYears()}'),
            _row('Interest Rate', _mortgage.getFormattedRate()),
            const Divider(color: Colors.red, thickness: 3),
            _row('Monthly Payment', _mortgage.formattedMonthlyPayment()),
            _row('Total Payment', _mortgage.formattedTotalPayment()),

            // Temrs and Conditions box placed right after Total Payment
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              title: const Text('Terms and Conditions'),
              value: _termsAccepted,
              onChanged: (checked) {
                if (checked == true) {
                  _showTermsDialog();
                } else {
                  setState(() => _termsAccepted = false);
                }
              },
            ),

            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: _openModifyScreen,
                child: const Text('MODIFY DATA'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
