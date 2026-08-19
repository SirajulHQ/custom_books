import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:flutter/material.dart';

enum PurchaseOrderStatus { draft, issued, billed, cancelled }

extension PurchaseOrderStatusLabel on PurchaseOrderStatus {
  String get label => switch (this) {
    PurchaseOrderStatus.draft => 'DRAFT',
    PurchaseOrderStatus.issued => 'ISSUED',
    PurchaseOrderStatus.billed => 'BILLED',
    PurchaseOrderStatus.cancelled => 'CANCELLED',
  };
}

extension PurchaseOrderStatusColor on PurchaseOrderStatus {
  Color get color => switch (this) {
    PurchaseOrderStatus.draft => AppColors.statusDraft,
    PurchaseOrderStatus.issued => AppColors.primaryLight,
    PurchaseOrderStatus.billed => AppColors.success,
    PurchaseOrderStatus.cancelled => AppColors.error,
  };
}

enum PurchaseOrderSortField {
  createdTime,
  date,
  purchaseOrderNumber,
  vendorName,
  amount,
}

extension PurchaseOrderSortFieldLabel on PurchaseOrderSortField {
  String get label => switch (this) {
    PurchaseOrderSortField.createdTime => 'Created Time',
    PurchaseOrderSortField.date => 'Date',
    PurchaseOrderSortField.purchaseOrderNumber => 'Purchase Order#',
    PurchaseOrderSortField.vendorName => 'Vendor Name',
    PurchaseOrderSortField.amount => 'Amount',
  };
}

class PurchaseOrderModel {
  final String id;
  final String purchaseOrderNumber;
  final String vendorName;
  final String referenceNumber;
  final DateTime orderDate;
  final DateTime? expectedDeliveryDate;
  final PurchaseOrderStatus status;
  final double total;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PurchaseOrderModel({
    required this.id,
    required this.purchaseOrderNumber,
    required this.vendorName,
    this.referenceNumber = '',
    required this.orderDate,
    this.expectedDeliveryDate,
    this.status = PurchaseOrderStatus.draft,
    this.total = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  PurchaseOrderModel copyWith({
    String? id,
    String? purchaseOrderNumber,
    String? vendorName,
    String? referenceNumber,
    DateTime? orderDate,
    DateTime? expectedDeliveryDate,
    PurchaseOrderStatus? status,
    double? total,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PurchaseOrderModel(
      id: id ?? this.id,
      purchaseOrderNumber: purchaseOrderNumber ?? this.purchaseOrderNumber,
      vendorName: vendorName ?? this.vendorName,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      orderDate: orderDate ?? this.orderDate,
      expectedDeliveryDate: expectedDeliveryDate ?? this.expectedDeliveryDate,
      status: status ?? this.status,
      total: total ?? this.total,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}
