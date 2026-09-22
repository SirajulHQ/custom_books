class DashboardProjectModel {
  final String unbilledHours;
  final String unbilledExpenses;
  final String currency;

  DashboardProjectModel({
    required this.unbilledHours,
    required this.unbilledExpenses,
    this.currency = 'INR',
  });

  String get currencySymbol {
    switch (currency) {
      case 'INR': return '₹';
      case 'USD': return '\$';
      case 'EUR': return '€';
      case 'GBP': return '£';
      default: return '$currency ';
    }
  }

  factory DashboardProjectModel.fromJson(Map<String, dynamic> json) {
    return DashboardProjectModel(
      unbilledHours: json['unbilled_hours']?.toString() ?? '00:00',
      unbilledExpenses: json['unbilled_expenses']?.toString() ?? '0.00',
      currency: json['currency'] as String? ?? 'INR',
    );
  }
}
