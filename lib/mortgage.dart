import 'dart:math';

class Mortgage {
  double _amount = 0;
  int _years = 0;
  double _rate = 0;

  Mortgage() {
    setAmount(0.0);
    setYears(0);
    setRate(0.0);
  }

  /// Copy constructor, used when passing data to the modify screen.
  Mortgage.copy(Mortgage other) {
    _amount = other._amount;
    _years = other._years;
    _rate = other._rate;
  }

  void setAmount(double newAmount) {
    if (newAmount >= 0) _amount = newAmount;
  }

  void setYears(int newYears) {
    if (newYears >= 0) _years = newYears;
  }

  void setRate(double newRate) {
    if (newRate >= 0) _rate = newRate;
  }

  double getAmount() => _amount;
  int getYears() => _years;
  double getRate() => _rate;

  String getFormattedAmount() => _money(_amount);

  /// Interest rate as a percent string
  String getFormattedRate() {
    String s = (_rate * 100).toStringAsFixed(2);
    if (s.contains('.')) {
      s = s.replaceFirst(RegExp(r'0+$'), '');
      s = s.replaceFirst(RegExp(r'\.$'), '');
    }
    return '$s%';
  }

  double monthlyPayment() {
    final months = _years * 12;
    if (months == 0) return 0;
    final mRate = _rate / 12;
    if (mRate == 0) return _amount / months;
    final temp = pow(1 / (1 + mRate), months).toDouble();
    return _amount * mRate / (1 - temp);
  }

  String formattedMonthlyPayment() => _money(monthlyPayment());

  double totalPayment() => monthlyPayment() * _years * 12;

  String formattedTotalPayment() => _money(totalPayment());

  /// Money Format: ("$#,###.00").
  static String _money(double value) {
    final parts = value.toStringAsFixed(2).split('.');
    final whole = parts[0].replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (m) => ',',
    );
    return '\$$whole.${parts[1]}';
  }
}
