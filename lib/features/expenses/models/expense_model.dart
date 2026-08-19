import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:flutter/material.dart';

enum ExpenseStatus { unbilled, billed, reimbursed, nonBillable }

extension ExpenseStatusLabel on ExpenseStatus {
  String get label => switch (this) {
    ExpenseStatus.unbilled => 'UNBILLED',
    ExpenseStatus.billed => 'BILLED',
    ExpenseStatus.reimbursed => 'REIMBURSED',
    ExpenseStatus.nonBillable => 'NON-BILLABLE',
  };
}

extension ExpenseStatusColor on ExpenseStatus {
  Color get color => switch (this) {
    ExpenseStatus.unbilled => AppColors.warning,
    ExpenseStatus.billed => AppColors.primaryLight,
    ExpenseStatus.reimbursed => AppColors.success,
    ExpenseStatus.nonBillable => AppColors.statusCancelled,
  };
}

enum ExpenseSortField { createdTime, date, category, amount }

extension ExpenseSortFieldLabel on ExpenseSortField {
  String get label => switch (this) {
    ExpenseSortField.createdTime => 'Created Time',
    ExpenseSortField.date => 'Date',
    ExpenseSortField.category => 'Category',
    ExpenseSortField.amount => 'Amount',
  };
}

enum SortDirection { ascending, descending }

class ExpenseModel {
  final String id;
  final String category;
  final String vendorName;
  final DateTime expenseDate;
  final String referenceNumber;
  final ExpenseStatus status;
  final double amount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ExpenseModel({
    required this.id,
    required this.category,
    this.vendorName = '',
    required this.expenseDate,
    this.referenceNumber = '',
    this.status = ExpenseStatus.unbilled,
    this.amount = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  ExpenseModel copyWith({
    String? id,
    String? category,
    String? vendorName,
    DateTime? expenseDate,
    String? referenceNumber,
    ExpenseStatus? status,
    double? amount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ExpenseModel(
      id: id ?? this.id,
      category: category ?? this.category,
      vendorName: vendorName ?? this.vendorName,
      expenseDate: expenseDate ?? this.expenseDate,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      status: status ?? this.status,
      amount: amount ?? this.amount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}
