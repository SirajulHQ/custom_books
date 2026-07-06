import 'package:flutter/material.dart';
import 'package:custom_books/features/home/models/cash_flow_point.dart';
import 'package:custom_books/features/home/models/income_expense_point.dart';
import 'package:custom_books/features/home/models/expense_item.dart';

final List<CashFlowPoint> cashFlowData = [
  CashFlowPoint('Jan', 0, 1250, 450, 800),
  CashFlowPoint('Feb', 800, 2100, 980, 1920),
  CashFlowPoint('Mar', 1920, 3500, 1200, 4220),
  CashFlowPoint('Apr', 4220, 1800, 2100, 3920),
  CashFlowPoint('May', 3920, 4200, 850, 7270),
  CashFlowPoint('Jun', 7270, 2800, 1950, 8120),
  CashFlowPoint('Jul', 8120, 1500, 2300, 7320),
  CashFlowPoint('Aug', 7320, 3800, 1100, 10020),
  CashFlowPoint('Sep', 10020, 2200, 1850, 10370),
  CashFlowPoint('Oct', 10370, 4500, 2200, 12670),
  CashFlowPoint('Nov', 12670, 1900, 2800, 11770),
  CashFlowPoint('Dec', 11770, 5200, 1500, 15470),
];

final List<IncomeExpensePoint> incomeExpenseData = [
  IncomeExpensePoint('Jan', 1250, 450),
  IncomeExpensePoint('Feb', 2100, 980),
  IncomeExpensePoint('Mar', 3500, 1200),
  IncomeExpensePoint('Apr', 1800, 2100),
  IncomeExpensePoint('May', 4200, 850),
  IncomeExpensePoint('Jun', 2800, 1950),
  IncomeExpensePoint('Jul', 1500, 2300),
  IncomeExpensePoint('Aug', 3800, 1100),
  IncomeExpensePoint('Sep', 2200, 1850),
  IncomeExpensePoint('Oct', 4500, 2200),
  IncomeExpensePoint('Nov', 1900, 2800),
  IncomeExpensePoint('Dec', 5200, 1500),
];

final List<ExpenseItem> topExpenses = [
  ExpenseItem('Salaries & Wages', 8500, 45.5, const Color(0xFF3B82F6)),
  ExpenseItem('Rent & Utilities', 3200, 17.1, const Color(0xFF8B5CF6)),
  ExpenseItem('Marketing', 2800, 15.0, const Color(0xFF10B981)),
  ExpenseItem('Supplies', 2100, 11.2, const Color(0xFFF59E0B)),
  ExpenseItem('Insurance', 1500, 8.0, const Color(0xFFEF4444)),
  ExpenseItem('Other', 600, 3.2, const Color(0xFF94A3B8)),
];
