import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/features/home/models/income_expense_point_model.dart';
import 'package:custom_books/features/home/viewmodels/income_expense_viewmodel.dart';
import 'package:flutter/material.dart';

class IncomeExpenseController extends ChangeNotifier {
  final _vm = IncomeExpenseViewModel();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<IncomeExpensePoint> _incomeExpense = [];
  List<IncomeExpensePoint> get incomeExpense => _incomeExpense;

  List<String> _periods = ['this_fiscal_year'];
  List<String> get periods => _periods;

  String _incomeTotal = '0.00';
  String get incomeTotal => _incomeTotal;

  String _expenseTotal = '0.00';
  String get expenseTotal => _expenseTotal;

  String _currency = 'INR';
  String get currency => _currency;

  Future<void> load({
    required String period,
    required String accountingMethod,
  }) async {
    _isLoading = true;
    notifyListeners();
    await fetch(period: period, accountingMethod: accountingMethod);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetch({
    required String period,
    required String accountingMethod,
  }) async {
    final resp = await _vm.fetch(
      period: period,
      accountingMethod: accountingMethod,
    );
    final int? status = resp?['_statusCode'] as int?;
    if (resp != null && status != null && status >= 200 && status < 300) {
      final data = resp['data'] as Map<String, dynamic>?;
      final raw = (data?['months'] as List<dynamic>?) ?? [];
      _incomeExpense = raw
          .map((e) => IncomeExpensePoint.fromJson(e as Map<String, dynamic>))
          .toList();
      _incomeTotal = data?['income_total']?.toString() ?? '0.00';
      _expenseTotal = data?['expense_total']?.toString() ?? '0.00';
      _currency = data?['currency'] as String? ?? 'INR';
      _periods =
          (data?['available_periods'] as List<dynamic>?)
              ?.map((e) => (e as Map)['value'] as String? ?? '')
              .where((s) => s.isNotEmpty)
              .toList() ??
          ['this_fiscal_year'];
    } else {
      appLog(
        '⚠️ Income/expense fetch failed (status: $status)',
        name: 'IncomeExpenseController',
      );
    }
  }
}
