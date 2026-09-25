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

/// Parses the API `status` string into an [AdjustmentStatus].
AdjustmentStatus adjustmentStatusFromString(String? value) {
  switch (value?.toLowerCase()) {
    case 'completed':
    case 'adjusted':
      return AdjustmentStatus.completed;
    case 'draft':
    default:
      return AdjustmentStatus.draft;
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

/// A single line within an inventory adjustment (an item that was adjusted).
class AdjustmentLine {
  final String lineId;
  final String itemId;
  final String itemName;
  final String? sku;
  final double quantityAdjusted;
  final double rate;
  final double value;

  const AdjustmentLine({
    required this.lineId,
    required this.itemId,
    required this.itemName,
    this.sku,
    required this.quantityAdjusted,
    required this.rate,
    required this.value,
  });

  factory AdjustmentLine.fromJson(Map<String, dynamic> json) {
    return AdjustmentLine(
      lineId: (json['line_id'] ?? '').toString(),
      itemId: (json['item_id'] ?? '').toString(),
      itemName: (json['item_name'] ?? '').toString(),
      sku: _nullIfBlank(json['sku']),
      quantityAdjusted: _toDouble(json['quantity_adjusted']),
      rate: _toDouble(json['rate']),
      value: _toDouble(json['value']),
    );
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

  // Extra fields from the API (optional so mock/local construction still works).
  final String? organizationId;
  final String? adjustmentType;
  final String? referenceNumber;
  final String? description;
  final String? account;
  final String? direction;
  final String? currency;
  final bool stockApplied;
  final double quantityChangeExact;
  final List<AdjustmentLine> lines;

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
    this.organizationId,
    this.adjustmentType,
    this.referenceNumber,
    this.description,
    this.account,
    this.direction,
    this.currency,
    this.stockApplied = false,
    double? quantityChangeExact,
    this.lines = const [],
  }) : quantityChangeExact = quantityChangeExact ?? quantityChange * 1.0;

  factory InventoryAdjustment.fromJson(Map<String, dynamic> json) {
    final qtyExact = _toDouble(json['quantity_change']);
    final rawLines = (json['lines'] as List<dynamic>?) ?? const [];
    final created = _toDate(json['created_at']);
    final updated = _toDate(json['updated_at']);

    return InventoryAdjustment(
      id: (json['adjustment_id'] ?? json['id'] ?? '').toString(),
      reason: (json['reason'] ?? '').toString(),
      date: _toDate(json['date']) ?? DateTime.now(),
      createdBy: (json['adjusted_by_name'] ?? '').toString(),
      quantityChange: qtyExact.round(),
      quantityChangeExact: qtyExact,
      value: _toDouble(json['adjustment_value']),
      status: adjustmentStatusFromString(json['status']?.toString()),
      createdAt: created ?? DateTime.now(),
      lastModifiedAt: updated ?? created ?? DateTime.now(),
      organizationId: _nullIfBlank(json['organization_id']),
      adjustmentType: _nullIfBlank(json['adjustment_type']),
      referenceNumber: _nullIfBlank(json['reference_number']),
      description: _nullIfBlank(json['description']),
      account: _nullIfBlank(json['account']),
      direction: _nullIfBlank(json['direction']),
      currency: _nullIfBlank(json['currency']),
      stockApplied: json['stock_applied'] == true,
      lines: rawLines
          .whereType<Map<String, dynamic>>()
          .map(AdjustmentLine.fromJson)
          .toList(),
    );
  }

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
      organizationId: organizationId,
      adjustmentType: adjustmentType,
      referenceNumber: referenceNumber,
      description: description,
      account: account,
      direction: direction,
      currency: currency,
      stockApplied: stockApplied,
      quantityChangeExact: quantityChangeExact,
      lines: lines,
    );
  }
}

double _toDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString()) ?? 0.0;
}

String? _nullIfBlank(dynamic value) {
  if (value == null) return null;
  final str = value.toString().trim();
  return str.isEmpty ? null : str;
}

DateTime? _toDate(dynamic value) {
  if (value == null) return null;
  return DateTime.tryParse(value.toString());
}
