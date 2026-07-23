class BankingData {
  final double cashInHand;
  final double bankBalance;
  final List<ChartDataPoint> chartData;
  final List<BankAccount> accounts;

  BankingData({
    required this.cashInHand,
    required this.bankBalance,
    required this.chartData,
    required this.accounts,
  });
}

class ChartDataPoint {
  final DateTime date;
  final double value;

  ChartDataPoint({required this.date, required this.value});
}

class BankAccount {
  final String id;
  final String name;
  final String icon;
  final double amountInZohoBooks;
  final double amountInBank;

  BankAccount({
    required this.id,
    required this.name,
    required this.icon,
    required this.amountInZohoBooks,
    required this.amountInBank,
  });
}
