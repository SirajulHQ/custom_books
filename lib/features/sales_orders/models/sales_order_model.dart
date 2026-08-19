import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:flutter/material.dart';

enum SalesOrderStatus { draft, confirmed, invoiced, cancelled }

extension SalesOrderStatusLabel on SalesOrderStatus {
  String get label => switch (this) {
    SalesOrderStatus.draft => 'DRAFT',
    SalesOrderStatus.confirmed => 'CONFIRMED',
    SalesOrderStatus.invoiced => 'INVOICED',
    SalesOrderStatus.cancelled => 'CANCELLED',
  };
}

extension SalesOrderStatusColor on SalesOrderStatus {
  Color get color => switch (this) {
    SalesOrderStatus.draft => AppColors.statusDraft,
    SalesOrderStatus.confirmed => AppColors.primaryLight,
    SalesOrderStatus.invoiced => AppColors.success,
    SalesOrderStatus.cancelled => AppColors.error,
  };
}

enum SalesOrderSortField {
  createdTime,
  date,
  salesOrderNumber,
  referenceNumber,
  customerName,
  amount,
}

extension SalesOrderSortFieldLabel on SalesOrderSortField {
  String get label => switch (this) {
    SalesOrderSortField.createdTime => 'Created Time',
    SalesOrderSortField.date => 'Date',
    SalesOrderSortField.salesOrderNumber => 'Sales Order#',
    SalesOrderSortField.referenceNumber => 'Reference#',
    SalesOrderSortField.customerName => 'Customer Name',
    SalesOrderSortField.amount => 'Amount',
  };
}

class SalesOrderLineItem {
  final String id;
  final String itemName;
  final String description;
  final double quantity;
  final double rate;
  final double discount;
  final bool discountIsPercent;
  final double taxRate;

  const SalesOrderLineItem({
    required this.id,
    required this.itemName,
    this.description = '',
    required this.quantity,
    required this.rate,
    this.discount = 0,
    this.discountIsPercent = true,
    this.taxRate = 0,
  });

  double get gross => quantity * rate;
  double get discountAmount =>
      discountIsPercent ? gross * discount / 100 : discount;
  double get net => (gross - discountAmount).clamp(0, double.infinity);
  double get taxAmount => net * taxRate / 100;
  double get total => net + taxAmount;
}

class SalesOrderModel {
  final String id;
  final String salesOrderNumber;
  final String customerName;
  final String referenceNumber;
  final DateTime salesOrderDate;
  final DateTime? expectedShipmentDate;
  final String paymentTerms;
  final String deliveryMethod;
  final String salesperson;
  final bool taxInclusive;
  final List<SalesOrderLineItem> lineItems;
  final String customerNotes;
  final String termsAndConditions;
  final List<String> attachments;
  final SalesOrderStatus status;
  final bool isInvoiced;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SalesOrderModel({
    required this.id,
    required this.salesOrderNumber,
    required this.customerName,
    this.referenceNumber = '',
    required this.salesOrderDate,
    this.expectedShipmentDate,
    this.paymentTerms = 'Due on Receipt',
    this.deliveryMethod = '',
    this.salesperson = '',
    this.taxInclusive = false,
    this.lineItems = const [],
    this.customerNotes = '',
    this.termsAndConditions = '',
    this.attachments = const [],
    this.status = SalesOrderStatus.draft,
    this.isInvoiced = false,
    required this.createdAt,
    required this.updatedAt,
  });

  double get subTotal => lineItems.fold(0, (sum, item) => sum + item.net);
  double get taxAmount =>
      lineItems.fold(0, (sum, item) => sum + item.taxAmount);
  double get total => taxInclusive ? subTotal : subTotal + taxAmount;

  SalesOrderModel copyWith({
    String? id,
    String? salesOrderNumber,
    String? customerName,
    String? referenceNumber,
    DateTime? salesOrderDate,
    DateTime? expectedShipmentDate,
    String? paymentTerms,
    String? deliveryMethod,
    String? salesperson,
    bool? taxInclusive,
    List<SalesOrderLineItem>? lineItems,
    String? customerNotes,
    String? termsAndConditions,
    List<String>? attachments,
    SalesOrderStatus? status,
    bool? isInvoiced,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SalesOrderModel(
      id: id ?? this.id,
      salesOrderNumber: salesOrderNumber ?? this.salesOrderNumber,
      customerName: customerName ?? this.customerName,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      salesOrderDate: salesOrderDate ?? this.salesOrderDate,
      expectedShipmentDate: expectedShipmentDate ?? this.expectedShipmentDate,
      paymentTerms: paymentTerms ?? this.paymentTerms,
      deliveryMethod: deliveryMethod ?? this.deliveryMethod,
      salesperson: salesperson ?? this.salesperson,
      taxInclusive: taxInclusive ?? this.taxInclusive,
      lineItems: lineItems ?? this.lineItems,
      customerNotes: customerNotes ?? this.customerNotes,
      termsAndConditions: termsAndConditions ?? this.termsAndConditions,
      attachments: attachments ?? this.attachments,
      status: status ?? this.status,
      isInvoiced: isInvoiced ?? this.isInvoiced,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}
