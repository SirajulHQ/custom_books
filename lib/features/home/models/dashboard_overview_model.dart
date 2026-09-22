/// A single overdue-ageing bucket (e.g. "1-15 Days").
class OverdueBucket {
  final String label;
  final String amount; // raw numeric string, e.g. "0.00"
  final String amountDisplay; // formatted, e.g. "₹0.00"

  const OverdueBucket({
    required this.label,
    required this.amount,
    required this.amountDisplay,
  });

  factory OverdueBucket.fromJson(
    Map<String, dynamic> json,
    String fallbackLabel,
  ) {
    return OverdueBucket(
      label: json['label'] as String? ?? fallbackLabel,
      amount: json['amount']?.toString() ?? '0.00',
      amountDisplay: json['amount_display']?.toString() ?? '₹0.00',
    );
  }
}

/// Detailed breakdown for receivables or payables, shown in the bottom sheet.
class FinancialDetail {
  final String title;
  final String total;
  final String totalDisplay;
  final String current;
  final String currentDisplay;
  final String overdue;
  final String overdueDisplay;
  final int overdueCount;

  /// Ageing buckets in fixed order: 1-15, 16-30, 31-45, >45.
  final List<OverdueBucket> overdueSplit;

  const FinancialDetail({
    required this.title,
    required this.total,
    required this.totalDisplay,
    required this.current,
    required this.currentDisplay,
    required this.overdue,
    required this.overdueDisplay,
    required this.overdueCount,
    required this.overdueSplit,
  });

  /// Empty ageing buckets in fixed order, used when the API omits the split.
  static const emptySplit = <OverdueBucket>[
    OverdueBucket(label: '1-15 Days', amount: '0.00', amountDisplay: '₹0.00'),
    OverdueBucket(label: '16-30 Days', amount: '0.00', amountDisplay: '₹0.00'),
    OverdueBucket(label: '31-45 Days', amount: '0.00', amountDisplay: '₹0.00'),
    OverdueBucket(label: '> 45 Days', amount: '0.00', amountDisplay: '₹0.00'),
  ];

  factory FinancialDetail.fromJson(
    Map<String, dynamic> json,
    String fallbackTitle,
  ) {
    final split = json['overdue_split'] as Map<String, dynamic>? ?? const {};
    final buckets = split.isEmpty
        ? emptySplit
        : <OverdueBucket>[
            OverdueBucket.fromJson(
              split['days_1_15'] as Map<String, dynamic>? ?? const {},
              '1-15 Days',
            ),
            OverdueBucket.fromJson(
              split['days_16_30'] as Map<String, dynamic>? ?? const {},
              '16-30 Days',
            ),
            OverdueBucket.fromJson(
              split['days_31_45'] as Map<String, dynamic>? ?? const {},
              '31-45 Days',
            ),
            OverdueBucket.fromJson(
              split['days_over_45'] as Map<String, dynamic>? ?? const {},
              '> 45 Days',
            ),
          ];

    return FinancialDetail(
      title: json['title'] as String? ?? fallbackTitle,
      total: json['total']?.toString() ?? '0.00',
      totalDisplay: json['total_display']?.toString() ?? '₹0.00',
      current: json['current']?.toString() ?? '0.00',
      currentDisplay: json['current_display']?.toString() ?? '₹0.00',
      overdue: json['overdue']?.toString() ?? '0.00',
      overdueDisplay: json['overdue_display']?.toString() ?? '₹0.00',
      overdueCount: (json['overdue_count'] as num?)?.toInt() ?? 0,
      overdueSplit: buckets,
    );
  }

  /// A zeroed detail, used when the API omits the section.
  static const empty = FinancialDetail(
    title: '',
    total: '0.00',
    totalDisplay: '₹0.00',
    current: '0.00',
    currentDisplay: '₹0.00',
    overdue: '0.00',
    overdueDisplay: '₹0.00',
    overdueCount: 0,
    overdueSplit: emptySplit,
  );
}

class DashboardOverviewModel {
  final String receivables;
  final String payables;
  final int overdueInvoices;
  final int overdueBills;
  final String bankBalance;
  final String cashInHand;
  final String currency; // e.g. "INR"

  final FinancialDetail receivablesDetail;
  final FinancialDetail payablesDetail;

  DashboardOverviewModel({
    required this.receivables,
    required this.payables,
    required this.overdueInvoices,
    required this.overdueBills,
    required this.bankBalance,
    required this.cashInHand,
    this.currency = 'INR',
    this.receivablesDetail = FinancialDetail.empty,
    this.payablesDetail = FinancialDetail.empty,
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
      receivablesDetail: json['receivables_detail'] is Map<String, dynamic>
          ? FinancialDetail.fromJson(
              json['receivables_detail'] as Map<String, dynamic>,
              'Total Receivables',
            )
          : FinancialDetail.empty,
      payablesDetail: json['payables_detail'] is Map<String, dynamic>
          ? FinancialDetail.fromJson(
              json['payables_detail'] as Map<String, dynamic>,
              'Total Payables',
            )
          : FinancialDetail.empty,
    );
  }
}
