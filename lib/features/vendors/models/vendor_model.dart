import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:flutter/material.dart';

enum VendorStatus { active, inactive }

extension VendorStatusLabel on VendorStatus {
  String get label => switch (this) {
    VendorStatus.active => 'ACTIVE',
    VendorStatus.inactive => 'INACTIVE',
  };
}

extension VendorStatusColor on VendorStatus {
  Color get color => switch (this) {
    VendorStatus.active => Appcolors.success,
    VendorStatus.inactive => Appcolors.statusCancelled,
  };
}

enum VendorsSortField { createdTime, name, companyName, payables }

extension VendorsSortFieldLabel on VendorsSortField {
  String get label => switch (this) {
    VendorsSortField.createdTime => 'Created Time',
    VendorsSortField.name => 'Name',
    VendorsSortField.companyName => 'Company Name',
    VendorsSortField.payables => 'Payables',
  };
}

enum SortDirection { ascending, descending }

class VendorModel {
  final String id;
  final String displayName;
  final String companyName;
  final String email;
  final String phone;
  final double payables;
  final double unusedCredits;
  final VendorStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const VendorModel({
    required this.id,
    required this.displayName,
    this.companyName = '',
    this.email = '',
    this.phone = '',
    this.payables = 0,
    this.unusedCredits = 0,
    this.status = VendorStatus.active,
    required this.createdAt,
    required this.updatedAt,
  });

  VendorModel copyWith({
    String? id,
    String? displayName,
    String? companyName,
    String? email,
    String? phone,
    double? payables,
    double? unusedCredits,
    VendorStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return VendorModel(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      companyName: companyName ?? this.companyName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      payables: payables ?? this.payables,
      unusedCredits: unusedCredits ?? this.unusedCredits,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}
