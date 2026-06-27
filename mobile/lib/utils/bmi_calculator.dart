class BmiCalculator {
  static const double _heightInMeters = 1.7;

  static double? calculate(String weightText) {
    final weight = double.tryParse(weightText.trim());

    if (weight == null || weight <= 0) {
      return null;
    }

    final bmi = weight / (_heightInMeters * _heightInMeters);

    return double.parse(bmi.toStringAsFixed(1));
  }
}
