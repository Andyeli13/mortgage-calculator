import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'modify_screen.dart';
import 'mortgage_provider.dart';

/// Screen 1 watches the provider and rebuilds whenever the data changes.
class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

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

  /// Alert dialog that confirms the terms and conditions.
  Future<void> _showTermsDialog(BuildContext context) async {
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
    if (context.mounted) {
      context.read<MortgageProvider>().setTermsAccepted(agreed ?? false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MortgageProvider>();
    final mortgage = provider.mortgage;

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
            _row('Amount', mortgage.getFormattedAmount()),
            _row('Years', '${mortgage.getYears()}'),
            _row('Interest Rate', mortgage.getFormattedRate()),
            const Divider(color: Colors.red, thickness: 3),
            _row('Monthly Payment', mortgage.formattedMonthlyPayment()),
            _row('Total Payment', mortgage.formattedTotalPayment()),

            // Check box placed right after Total Payment
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              title: const Text('Terms and Conditions'),
              value: provider.termsAccepted,
              onChanged: (checked) {
                if (checked == true) {
                  _showTermsDialog(context);
                } else {
                  context.read<MortgageProvider>().setTermsAccepted(false);
                }
              },
            ),

            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ModifyScreen()),
                  );
                },
                child: const Text('MODIFY DATA'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
