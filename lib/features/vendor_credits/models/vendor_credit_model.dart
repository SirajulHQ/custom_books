import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:flutter/material.dart';

enum VendorCreditStatus { draft, open, closed, void_ }

extension VendorCreditStatusLabel on VendorCreditStatus {
  String get label => switch (this) {
    VendorCreditStatus.draft => 'DRAFT',
    VendorCreditStatus.open => 'OPEN',
    VendorCreditStatus.closed => 'CLOSED',
    VendorCreditStatus.void_ => 'VOID',
  };
}

extension VendorCreditStatusColor on VendorCreditStatus {
  Color get color => switch (this) {
    VendorCreditStatus.draft => Appcolors.statusDraft,
    VendorCreditStatus.open => Appcolors.primaryLight,
    VendorCreditStatus.closed => Appcolors.success,
    VendorCreditStatus.void_ => Appcolors.error,
  };
}

enum VendorCreditSortField {
  createdTime,
  date,
  creditNoteNumber,
  vendorName,
  amount,
}

extension VendorCreditSortFieldLabel on VendorCreditSortField {
  String get label => switch (this) {
    VendorCreditSortField.createdTime => 'Created Time',
    VendorCreditSortField.date => 'Date',
    VendorCreditSortField.creditNoteNumber => 'Credit Note#',
    VendorCreditSortField.vendorName => 'Vendor Name',
    VendorCreditSortField.amount => 'Amount',
  };
}

enum SortDirection { ascending, descending }

class VendorCreditModel {
  final String id;
  final String creditNoteNumber;
  final String vendorName;
  final String referenceNumber;
  final DateTime creditDate;
  final VendorCreditStatus status;
  final double total;
  final DateTime createdAt;
  final DateTime updatedAt;

  const VendorCreditModel({
    required this.id,
    required this.creditNoteNumber,
    required this.vendorName,
    this.referenceNumber = '',
    required this.creditDate,
    this.status = VendorCreditStatus.open,
    this.total = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  VendorCreditModel copyWith({
    String? id,
    String? creditNoteNumber,
    String? vendorName,
    String? referenceNumber,
    DateTime? creditDate,
    VendorCreditStatus? status,
    double? total,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return VendorCreditModel(
      id: id ?? this.id,
      creditNoteNumber: creditNoteNumber ?? this.creditNoteNumber,
      vendorName: vendorName ?? this.vendorName,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      creditDate: creditDate ?? this.creditDate,
      status: status ?? this.status,
      total: total ?? this.total,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}
