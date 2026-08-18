import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:flutter/material.dart';

class InvoiceModel {
  final String id;
  final String invoiceNumber;
  final String customerId;
  final String customerName;
  final DateTime invoiceDate;
  final DateTime dueDate;
  final String terms;
  final String placeOfSupply;
  final String? orderNumber;
  final String? salesperson;
  final String? subject;
  final bool isTaxInclusive;
  final List<InvoiceLineItem> lineItems;
  final String? customerNotes;
  final String? termsAndConditions;
  final List<String> emailCommunications;
  final bool paymentReceived;
  final List<String> attachments;
  final double subTotal;
  final double taxAmount;
  final double total;
  final InvoiceStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;

  InvoiceModel({
    required this.id,
    required this.invoiceNumber,
    required this.customerId,
    required this.customerName,
    required this.invoiceDate,
    required this.dueDate,
    required this.terms,
    required this.placeOfSupply,
    this.orderNumber,
    this.salesperson,
    this.subject,
    this.isTaxInclusive = false,
    this.lineItems = const [],
    this.customerNotes,
    this.termsAndConditions,
    this.emailCommunications = const [],
    this.paymentReceived = false,
    this.attachments = const [],
    required this.subTotal,
    required this.taxAmount,
    required this.total,
    this.status = InvoiceStatus.draft,
    required this.createdAt,
    this.updatedAt,
  });
}

class InvoiceLineItem {
  final String id;
  final String itemId;
  final String itemName;
  final String? description;
  final double quantity;
  final String unit;
  final double rate;
  final double amount;
  final double? discount;
  final double? taxRate;
  final double? taxAmount;

  InvoiceLineItem({
    required this.id,
    required this.itemId,
    required this.itemName,
    this.description,
    required this.quantity,
    required this.unit,
    required this.rate,
    required this.amount,
    this.discount,
    this.taxRate,
    this.taxAmount,
  });
}

enum InvoiceStatus { draft, sent, paid, partiallyPaid, overdue, cancelled }

extension InvoiceStatusLabel on InvoiceStatus {
  String get label => switch (this) {
    InvoiceStatus.draft => 'DRAFT',
    InvoiceStatus.sent => 'SENT',
    InvoiceStatus.paid => 'PAID',
    InvoiceStatus.partiallyPaid => 'PARTIALLY PAID',
    InvoiceStatus.overdue => 'OVERDUE',
    InvoiceStatus.cancelled => 'CANCELLED',
  };
}

extension InvoiceStatusColor on InvoiceStatus {
  Color get color => switch (this) {
    InvoiceStatus.draft => Appcolors.statusDraft,
    InvoiceStatus.sent => Appcolors.primaryLight,
    InvoiceStatus.paid => Appcolors.success,
    InvoiceStatus.partiallyPaid => Appcolors.warning,
    InvoiceStatus.overdue => Appcolors.error,
    InvoiceStatus.cancelled => Appcolors.statusCancelled,
  };
}
