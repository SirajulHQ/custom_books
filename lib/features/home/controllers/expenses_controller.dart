import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/features/home/models/expense_item_model.dart';
import 'package:custom_books/features/home/viewmodels/expenses_viewmodel.dart';
import 'package:flutter/material.dart';

const _expenseColors = [
  Color(0xFF3B82F6),
  Color(0xFF8B5CF6),
  Color(0xFF10B981),
  Color(0xFFF59E0B),
  Color(0xFFEF4444),
  Color(0xFF94A3B8),
];

class ExpensesController extends ChangeNotifier {
  final _vm = ExpensesViewModel();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<ExpenseItem> _expenses = [];
  List<ExpenseItem> get expenses => _expenses;

  List<String> _periods = ['this_fiscal_year'];
  List<String> get periods => _periods;

  String _currency = 'INR';
  String get currency => _currency;

  String _totalExpense = '0.00';
  String get totalExpense => _totalExpense;

  Future<void> load({required String period}) async {
    _isLoading = true;
    notifyListeners();
    await fetch(period: period);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetch({required String period}) async {
    final resp = await _vm.fetch(period: period);
    final int? status = resp?['_statusCode'] as int?;
    if (resp != null && status != null && status >= 200 && status < 300) {
      final data = resp['data'] as Map<String, dynamic>?;
      final raw = (data?['categories'] as List<dynamic>?) ?? [];
      _expenses = raw.asMap().entries.map((entry) {
        final fallbackColor = _expenseColors[entry.key % _expenseColors.length];
        return ExpenseItem.fromJson(
          entry.value as Map<String, dynamic>,
          fallbackColor: fallbackColor,
        );
      }).toList();
      _totalExpense = data?['total_expense']?.toString() ?? '0.00';
      _currency = data?['currency'] as String? ?? 'INR';
      _periods =
          (data?['available_periods'] as List<dynamic>?)
              ?.map((e) => (e as Map)['value'] as String? ?? '')
              .where((s) => s.isNotEmpty)
              .toList() ??
          ['this_fiscal_year'];
    } else {
      appLog(
        '⚠️ Expenses fetch failed (status: $status)',
        name: 'ExpensesController',
      );
    }
  }
}
