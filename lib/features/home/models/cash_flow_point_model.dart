class CashFlowPoint {
  final String month;
  final double opening;
  final double income;
  final double outgoing;
  final double ending;

  CashFlowPoint(
    this.month,
    this.opening,
    this.income,
    this.outgoing,
    this.ending,
  );

  factory CashFlowPoint.fromJson(Map<String, dynamic> json) {
    double p(String key) =>
        double.tryParse(json[key]?.toString() ?? '') ?? 0;
    return CashFlowPoint(
      json['month'] as String? ?? '',
      p('opening_balance'),
      p('income'),
      p('outgoing'),
      p('ending_balance'),
    );
  }
}
