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

enum PaymentReceivedSortField {
  createdTime,
  date,
  paymentNumber,
  customerName,
  amount,
}

extension PaymentReceivedSortFieldLabel on PaymentReceivedSortField {
  String get label => switch (this) {
    PaymentReceivedSortField.createdTime => 'Created Time',
    PaymentReceivedSortField.date => 'Date',
    PaymentReceivedSortField.paymentNumber => 'Payment#',
    PaymentReceivedSortField.customerName => 'Customer Name',
    PaymentReceivedSortField.amount => 'Amount',
  };
}

enum SortDirection { ascending, descending }

class PaymentReceivedModel {
  final String id;
  final String paymentNumber;
  final String customerName;
  final List<String> invoiceNumbers;
  final DateTime paymentDate;
  final PaymentMode mode;
  final String referenceNumber;
  final double amount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PaymentReceivedModel({
    required this.id,
    required this.paymentNumber,
    required this.customerName,
    this.invoiceNumbers = const [],
    required this.paymentDate,
    this.mode = PaymentMode.cash,
    this.referenceNumber = '',
    required this.amount,
    required this.createdAt,
    required this.updatedAt,
  });

  PaymentReceivedModel copyWith({
    String? id,
    String? paymentNumber,
    String? customerName,
    List<String>? invoiceNumbers,
    DateTime? paymentDate,
    PaymentMode? mode,
    String? referenceNumber,
    double? amount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PaymentReceivedModel(
      id: id ?? this.id,
      paymentNumber: paymentNumber ?? this.paymentNumber,
      customerName: customerName ?? this.customerName,
      invoiceNumbers: invoiceNumbers ?? this.invoiceNumbers,
      paymentDate: paymentDate ?? this.paymentDate,
      mode: mode ?? this.mode,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      amount: amount ?? this.amount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}
