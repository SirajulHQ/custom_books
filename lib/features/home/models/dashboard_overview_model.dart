class DashboardOverviewModel {
  final String receivables;
  final String payables;
  final int overdueInvoices;
  final int overdueBills;
  final String bankBalance;
  final String cashInHand;
  final String currency; // e.g. "INR"

  DashboardOverviewModel({
    required this.receivables,
    required this.payables,
    required this.overdueInvoices,
    required this.overdueBills,
    required this.bankBalance,
    required this.cashInHand,
    this.currency = 'INR',
  });

  /// Returns a currency symbol for display (e.g. INR → ₹, USD → $, AED → AED).
  String get currencySymbol {
    switch (currency) {
      case 'INR':
        return '₹';
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      case 'GBP':
        return '£';
      case 'AED':
        return 'AED ';
      default:
        return '$currency ';
    }
  }

  factory DashboardOverviewModel.fromJson(Map<String, dynamic> json) {
    return DashboardOverviewModel(
      receivables: json['receivables']?.toString() ?? '0.00',
      payables: json['payables']?.toString() ?? '0.00',
      overdueInvoices: (json['overdue_invoices_count'] as num?)?.toInt() ?? 0,
      overdueBills: (json['overdue_bills_count'] as num?)?.toInt() ?? 0,
      bankBalance: json['bank_balance']?.toString() ?? '0.00',
      cashInHand: json['cash_in_hand']?.toString() ?? '0.00',
      currency: json['currency'] as String? ?? 'INR',
    );
  }
}
