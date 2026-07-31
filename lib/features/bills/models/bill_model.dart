enum BillStatus { draft, open, overdue, paid, partiallyPaid }

extension BillStatusLabel on BillStatus {
  String get label => switch (this) {
    BillStatus.draft => 'DRAFT',
    BillStatus.open => 'OPEN',
    BillStatus.overdue => 'OVERDUE',
    BillStatus.paid => 'PAID',
    BillStatus.partiallyPaid => 'PARTIALLY PAID',
  };
}

enum BillSortField { createdTime, date, billNumber, vendorName, amount }

extension BillSortFieldLabel on BillSortField {
  String get label => switch (this) {
    BillSortField.createdTime => 'Created Time',
    BillSortField.date => 'Date',
    BillSortField.billNumber => 'Bill#',
    BillSortField.vendorName => 'Vendor Name',
    BillSortField.amount => 'Amount',
  };
}

enum SortDirection { ascending, descending }

class BillModel {
  final String id;
  final String billNumber;
  final String vendorName;
  final DateTime billDate;
  final DateTime dueDate;
  final BillStatus status;
  final double total;
  final double balanceDue;
  final DateTime createdAt;
  final DateTime updatedAt;

  const BillModel({
    required this.id,
    required this.billNumber,
    required this.vendorName,
    required this.billDate,
    required this.dueDate,
    this.status = BillStatus.open,
    this.total = 0,
    this.balanceDue = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  BillModel copyWith({
    String? id,
    String? billNumber,
    String? vendorName,
    DateTime? billDate,
    DateTime? dueDate,
    BillStatus? status,
    double? total,
    double? balanceDue,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BillModel(
      id: id ?? this.id,
      billNumber: billNumber ?? this.billNumber,
      vendorName: vendorName ?? this.vendorName,
      billDate: billDate ?? this.billDate,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      total: total ?? this.total,
      balanceDue: balanceDue ?? this.balanceDue,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}
