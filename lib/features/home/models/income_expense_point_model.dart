class IncomeExpensePoint {
  final String month;
  final double income;
  final double expense;

  IncomeExpensePoint(this.month, this.income, this.expense);

  factory IncomeExpensePoint.fromJson(Map<String, dynamic> json) {
    double p(String key) =>
        double.tryParse(json[key]?.toString() ?? '') ?? 0;
    return IncomeExpensePoint(
      json['month'] as String? ?? '',
      p('income'),
      p('expense'),
    );
  }
}
