
/// Status of an inventory adjustment entry.
enum AdjustmentStatus { draft, completed }

extension AdjustmentStatusX on AdjustmentStatus {
  String get label {
    switch (this) {
      case AdjustmentStatus.draft:
        return 'DRAFT';
      case AdjustmentStatus.completed:
        return 'COMPLETED';
    }
  }
}

/// Fields the adjustments list can be sorted by.
enum AdjustmentSortField { date, reason, createdTime, lastModifiedTime }

extension AdjustmentSortFieldX on AdjustmentSortField {
  String get label {
    switch (this) {
      case AdjustmentSortField.date:
        return 'Date';
      case AdjustmentSortField.reason:
        return 'Reason';
      case AdjustmentSortField.createdTime:
        return 'Created Time';
      case AdjustmentSortField.lastModifiedTime:
        return 'Last Modified Time';
    }
  }
}

/// A single stock/inventory adjustment record.
class InventoryAdjustment {
  final String id;
  final String reason;
  final DateTime date;
  final String createdBy;
  final int quantityChange;
  final double value;
  final AdjustmentStatus status;
  final DateTime createdAt;
  final DateTime lastModifiedAt;

  const InventoryAdjustment({
    required this.id,
    required this.reason,
    required this.date,
    required this.createdBy,
    required this.quantityChange,
    required this.value,
    required this.status,
    required this.createdAt,
    required this.lastModifiedAt,
  });

  InventoryAdjustment copyWith({
    String? reason,
    DateTime? date,
    String? createdBy,
    int? quantityChange,
    double? value,
    AdjustmentStatus? status,
    DateTime? lastModifiedAt,
  }) {
    return InventoryAdjustment(
      id: id,
      reason: reason ?? this.reason,
      date: date ?? this.date,
      createdBy: createdBy ?? this.createdBy,
      quantityChange: quantityChange ?? this.quantityChange,
      value: value ?? this.value,
      status: status ?? this.status,
      createdAt: createdAt,
      lastModifiedAt: lastModifiedAt ?? this.lastModifiedAt,
    );
  }
}
