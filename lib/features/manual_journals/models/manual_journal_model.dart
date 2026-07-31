enum ManualJournalStatus { draft, published }

extension ManualJournalStatusLabel on ManualJournalStatus {
  String get label => switch (this) {
    ManualJournalStatus.draft => 'DRAFT',
    ManualJournalStatus.published => 'PUBLISHED',
  };
}

enum ManualJournalSortField { createdTime, date, journalNumber, amount }

extension ManualJournalSortFieldLabel on ManualJournalSortField {
  String get label => switch (this) {
    ManualJournalSortField.createdTime => 'Created Time',
    ManualJournalSortField.date => 'Date',
    ManualJournalSortField.journalNumber => 'Journal#',
    ManualJournalSortField.amount => 'Amount',
  };
}

enum SortDirection { ascending, descending }

class ManualJournalModel {
  final String id;
  final String journalNumber;
  final String referenceNumber;
  final DateTime journalDate;
  final String notes;
  final ManualJournalStatus status;
  final double amount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ManualJournalModel({
    required this.id,
    required this.journalNumber,
    this.referenceNumber = '',
    required this.journalDate,
    this.notes = '',
    this.status = ManualJournalStatus.draft,
    this.amount = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  ManualJournalModel copyWith({
    String? id,
    String? journalNumber,
    String? referenceNumber,
    DateTime? journalDate,
    String? notes,
    ManualJournalStatus? status,
    double? amount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ManualJournalModel(
      id: id ?? this.id,
      journalNumber: journalNumber ?? this.journalNumber,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      journalDate: journalDate ?? this.journalDate,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      amount: amount ?? this.amount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}
