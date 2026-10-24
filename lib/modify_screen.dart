import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'mortgage_provider.dart';

/// Screen 2: Pressing DONE sends the new values to the provider
class ModifyScreen extends StatefulWidget {
  const ModifyScreen({super.key});

  @override
  State<ModifyScreen> createState() => _ModifyScreenState();
}

class _ModifyScreenState extends State<ModifyScreen> {
  static const double _itemHeight = 48;

  // Interest rates from 2% to 15% in increments of 0.25
  final List<double> _rates = List.generate(53, (i) => 2 + i * 0.25);

  late int _years;
  late double _selectedRate; // in percent
  late final TextEditingController _amountController;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    final m = context.read<MortgageProvider>().mortgage;
    _years = [10, 15, 30].contains(m.getYears()) ? m.getYears() : 30;
    _amountController = TextEditingController(
      text: m.getAmount().toStringAsFixed(2),
    );

    // Find the list entry closest to the saved rate
    final currentPct = m.getRate() * 100;
    int index = 0;
    double best = double.infinity;
    for (int i = 0; i < _rates.length; i++) {
      final diff = (_rates[i] - currentPct).abs();
      if (diff < best) {
        best = diff;
        index = i;
      }
    }
    _selectedRate = _rates[index];
    _scrollController = ScrollController(
      initialScrollOffset: index * _itemHeight,
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _done() {
    final amount = double.tryParse(_amountController.text.trim());
    if (amount == null || amount < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount.')),
      );
      return;
    }
    context.read<MortgageProvider>().updateMortgage(
      amount: amount,
      years: _years,
      rate: _selectedRate / 100,
    );
    Navigator.pop(context);
  }

  Widget _yearOption(int value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<int>(
          value: value,
          groupValue: _years,
          onChanged: (v) => setState(() => _years = v!),
        ),
        Text('$value', style: const TextStyle(fontSize: 16)),
      ],
    );
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
            // Years: radio buttons
            Row(
              children: [
                const SizedBox(
                  width: 110,
                  child: Text('Years', style: TextStyle(fontSize: 16)),
                ),
                _yearOption(10),
                _yearOption(15),
                _yearOption(30),
              ],
            ),
            const SizedBox(height: 16),

            // Amount: text field
            Row(
              children: [
                const SizedBox(
                  width: 110,
                  child: Text('Amount', style: TextStyle(fontSize: 16)),
                ),
                Expanded(
                  child: TextField(
                    controller: _amountController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Interest rate: ListView from 2% to 15% in 0.25 increments
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 110,
                  child: Padding(
                    padding: EdgeInsets.only(top: 12),
                    child: Text(
                      'Interest Rate',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: _itemHeight * 4,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: ListView.builder(
                      controller: _scrollController,
                      itemExtent: _itemHeight,
                      itemCount: _rates.length,
                      itemBuilder: (context, i) {
                        final rate = _rates[i];
                        final selected = rate == _selectedRate;
                        return ListTile(
                          selected: selected,
                          selectedTileColor: Colors.indigo.withValues(
                            alpha: 0.12,
                          ),
                          title: Text('${rate.toStringAsFixed(2)}%'),
                          trailing: selected ? const Icon(Icons.check) : null,
                          onTap: () => setState(() => _selectedRate = rate),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            Center(
              child: ElevatedButton(
                onPressed: _done,
                child: const Text('DONE'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
