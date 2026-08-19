
enum PaymentMode { cash, bankTransfer, card, cheque, upi }

extension PaymentModeLabel on PaymentMode {
  String get label => switch (this) {
    PaymentMode.cash => 'Cash',
    PaymentMode.bankTransfer => 'Bank Transfer',
    PaymentMode.card => 'Card',
    PaymentMode.cheque => 'Cheque',
    PaymentMode.upi => 'UPI',
  };
}

enum PaymentMadeSortField {
  createdTime,
  date,
  paymentNumber,
  vendorName,
  amount,
}

extension PaymentMadeSortFieldLabel on PaymentMadeSortField {
  String get label => switch (this) {
    PaymentMadeSortField.createdTime => 'Created Time',
    PaymentMadeSortField.date => 'Date',
    PaymentMadeSortField.paymentNumber => 'Payment#',
    PaymentMadeSortField.vendorName => 'Vendor Name',
    PaymentMadeSortField.amount => 'Amount',
  };
}

class PaymentMadeModel {
  final String id;
  final String paymentNumber;
  final String vendorName;
  final List<String> billNumbers;
  final DateTime paymentDate;
  final PaymentMode mode;
  final String referenceNumber;
  final double amount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PaymentMadeModel({
    required this.id,
    required this.paymentNumber,
    required this.vendorName,
    this.billNumbers = const [],
    required this.paymentDate,
    this.mode = PaymentMode.cash,
    this.referenceNumber = '',
    this.amount = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  PaymentMadeModel copyWith({
    String? id,
    String? paymentNumber,
    String? vendorName,
    List<String>? billNumbers,
    DateTime? paymentDate,
    PaymentMode? mode,
    String? referenceNumber,
    double? amount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PaymentMadeModel(
      id: id ?? this.id,
      paymentNumber: paymentNumber ?? this.paymentNumber,
      vendorName: vendorName ?? this.vendorName,
      billNumbers: billNumbers ?? this.billNumbers,
      paymentDate: paymentDate ?? this.paymentDate,
      mode: mode ?? this.mode,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      amount: amount ?? this.amount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}
