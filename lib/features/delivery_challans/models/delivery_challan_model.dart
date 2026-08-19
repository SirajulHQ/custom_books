import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:flutter/material.dart';

enum DeliveryChallanStatus { draft, delivered, returned, cancelled }

extension DeliveryChallanStatusLabel on DeliveryChallanStatus {
  String get label => switch (this) {
    DeliveryChallanStatus.draft => 'DRAFT',
    DeliveryChallanStatus.delivered => 'DELIVERED',
    DeliveryChallanStatus.returned => 'RETURNED',
    DeliveryChallanStatus.cancelled => 'CANCELLED',
  };
}

extension DeliveryChallanStatusColor on DeliveryChallanStatus {
  Color get color => switch (this) {
    DeliveryChallanStatus.draft => AppColors.statusDraft,
    DeliveryChallanStatus.delivered => AppColors.success,
    DeliveryChallanStatus.returned => AppColors.warning,
    DeliveryChallanStatus.cancelled => AppColors.error,
  };
}

enum DeliveryChallanSortField {
  createdTime,
  date,
  challanNumber,
  customerName,
  amount,
}

extension DeliveryChallanSortFieldLabel on DeliveryChallanSortField {
  String get label => switch (this) {
    DeliveryChallanSortField.createdTime => 'Created Time',
    DeliveryChallanSortField.date => 'Date',
    DeliveryChallanSortField.challanNumber => 'Challan#',
    DeliveryChallanSortField.customerName => 'Customer Name',
    DeliveryChallanSortField.amount => 'Amount',
  };
}

class DeliveryChallanModel {
  final String id;
  final String challanNumber;
  final String customerName;
  final String referenceNumber;
  final DateTime challanDate;
  final String type; // e.g. 'Job Work' / 'Supply on Approval'
  final DeliveryChallanStatus status;
  final double total;
  final DateTime createdAt;
  final DateTime updatedAt;

  const DeliveryChallanModel({
    required this.id,
    required this.challanNumber,
    required this.customerName,
    this.referenceNumber = '',
    required this.challanDate,
    this.type = 'Job Work',
    this.status = DeliveryChallanStatus.draft,
    required this.total,
    required this.createdAt,
    required this.updatedAt,
  });

  DeliveryChallanModel copyWith({
    String? id,
    String? challanNumber,
    String? customerName,
    String? referenceNumber,
    DateTime? challanDate,
    String? type,
    DeliveryChallanStatus? status,
    double? total,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DeliveryChallanModel(
      id: id ?? this.id,
      challanNumber: challanNumber ?? this.challanNumber,
      customerName: customerName ?? this.customerName,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      challanDate: challanDate ?? this.challanDate,
      type: type ?? this.type,
      status: status ?? this.status,
      total: total ?? this.total,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}
