import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'mortgage.dart';

/// Holds the app's state. Any change calls notifyListeners(). Loan inputs are saved with SharedPreferences
class MortgageProvider extends ChangeNotifier {
  static const String _amountKey = 'amount';
  static const String _yearsKey = 'years';
  static const String _rateKey = 'rate';

  Mortgage _mortgage = Mortgage();
  bool _termsAccepted = false;

  Mortgage get mortgage => _mortgage;
  bool get termsAccepted => _termsAccepted;

  /// Reads saved values from SharedPreferences.
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final m = Mortgage();
    m.setAmount(prefs.getDouble(_amountKey) ?? 0.0);
    m.setYears(prefs.getInt(_yearsKey) ?? 0);
    m.setRate(prefs.getDouble(_rateKey) ?? 0.0);
    _mortgage = m;
    notifyListeners();
  }

  /// Updates the state, refreshes the screens, then saves to disk.
  Future<void> updateMortgage({
    required double amount,
    required int years,
    required double rate, // decimal
  }) async {
    final m = Mortgage();
    m.setAmount(amount);
    m.setYears(years);
    m.setRate(rate);
    _mortgage = m;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_amountKey, amount);
    await prefs.setInt(_yearsKey, years);
    await prefs.setDouble(_rateKey, rate);
  }

  void setTermsAccepted(bool value) {
    _termsAccepted = value;
    notifyListeners();
  }
}
