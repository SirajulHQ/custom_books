import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/features/home/models/cash_flow_point_model.dart';
import 'package:custom_books/features/home/models/dashboard_overview_model.dart';
import 'package:custom_books/features/home/models/dashboard_project_model.dart';
import 'package:custom_books/features/home/models/expense_item_model.dart';
import 'package:custom_books/features/home/models/income_expense_point_model.dart';
import 'package:custom_books/features/home/models/support_item_model.dart';
import 'package:custom_books/features/home/models/update_item_model.dart';
import 'package:custom_books/features/home/viewmodels/cash_flow_viewmodel.dart';
import 'package:custom_books/features/home/viewmodels/dashboard_overview_viewmodel.dart';
import 'package:custom_books/features/home/viewmodels/dashboard_projects_viewmodel.dart';
import 'package:custom_books/features/home/viewmodels/expenses_viewmodel.dart';
import 'package:custom_books/features/home/viewmodels/income_expense_viewmodel.dart';
import 'package:custom_books/features/home/viewmodels/support_viewmodel.dart';
import 'package:custom_books/features/home/viewmodels/updates_viewmodel.dart';
import 'package:flutter/material.dart';

/// Palette for cycling expense category colours.
const _expenseColors = [
  Color(0xFF3B82F6),
  Color(0xFF8B5CF6),
  Color(0xFF10B981),
  Color(0xFFF59E0B),
  Color(0xFFEF4444),
  Color(0xFF94A3B8),
];

class DashboardController extends ChangeNotifier {
  // ── ViewModels ────────────────────────────────────────────────────────────
  final _overviewVm = DashboardOverviewViewModel();
  final _projectsVm = DashboardProjectsViewModel();
  final _cashFlowVm = CashFlowViewModel();
  final _incomeExpenseVm = IncomeExpenseViewModel();
  final _expensesVm = ExpensesViewModel();
  final _supportVm = SupportViewModel();
  final _updatesVm = UpdatesViewModel();

  // ── Loading state ─────────────────────────────────────────────────────────
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isCashFlowLoading = false;
  bool get isCashFlowLoading => _isCashFlowLoading;

  bool _isIncomeExpenseLoading = false;
  bool get isIncomeExpenseLoading => _isIncomeExpenseLoading;

  bool _isExpensesLoading = false;
  bool get isExpensesLoading => _isExpensesLoading;

  bool _isUpdatesLoading = false;
  bool get isUpdatesLoading => _isUpdatesLoading;

  // ── Error state ───────────────────────────────────────────────────────────
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // ── Data ──────────────────────────────────────────────────────────────────
  DashboardOverviewModel? _overview;
  DashboardOverviewModel? get overview => _overview;

  DashboardProjectModel? _projects;
  DashboardProjectModel? get projects => _projects;

  List<CashFlowPoint> _cashFlow = [];
  List<CashFlowPoint> get cashFlow => _cashFlow;

  List<IncomeExpensePoint> _incomeExpense = [];
  List<IncomeExpensePoint> get incomeExpense => _incomeExpense;

  List<ExpenseItem> _expenses = [];
  List<ExpenseItem> get expenses => _expenses;

  // Period labels from API (used to populate dropdown sheets)
  List<String> _cashFlowPeriods = ['this_fiscal_year'];
  List<String> get cashFlowPeriods => _cashFlowPeriods;

  List<String> _incomeExpensePeriods = ['this_fiscal_year'];
  List<String> get incomeExpensePeriods => _incomeExpensePeriods;

  List<String> _expensePeriods = ['this_fiscal_year'];
  List<String> get expensePeriods => _expensePeriods;

  // Summary fields from Cash Flow API
  String _cashFlowAsOnLabel = '';
  String get cashFlowAsOnLabel => _cashFlowAsOnLabel;

  String _cashFlowCurrency = 'INR';
  String get cashFlowCurrency => _cashFlowCurrency;

  // Summary totals from Income/Expense API
  String _incomeTotal = '0.00';
  String get incomeTotal => _incomeTotal;

  String _expenseTotal = '0.00';
  String get expenseTotal => _expenseTotal;

  String _incomeExpenseCurrency = 'INR';
  String get incomeExpenseCurrency => _incomeExpenseCurrency;

  // Currency from Expenses API
  String _expensesCurrency = 'INR';
  String get expensesCurrency => _expensesCurrency;

  String _expensesTotalExpense = '0.00';
  String get expensesTotalExpense => _expensesTotalExpense;

  List<UpdateItemModel>? _updates;
  List<UpdateItemModel>? get updates => _updates;

  SupportDataModel? _support;
  SupportDataModel? get support => _support;

  // ── Public methods ────────────────────────────────────────────────────────

  /// Loads overview + projects in parallel. Called on dashboard tab open.
  Future<void> loadDashboard({
    String period = 'this_fiscal_year',
    String accountingMethod = 'accrual',
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.wait([
      _fetchOverview(),
      _fetchProjects(),
      _fetchCashFlow(period: period),
      _fetchIncomeExpense(period: period, accountingMethod: accountingMethod),
      _fetchExpenses(period: period),
    ]);

    _isLoading = false;
    notifyListeners();
  }

  /// Called when the cash flow period picker changes.
  Future<void> loadCashFlow({required String period}) async {
    _isCashFlowLoading = true;
    notifyListeners();
    await _fetchCashFlow(period: period);
    _isCashFlowLoading = false;
    notifyListeners();
  }

  /// Called when the income/expense period or accounting method changes.
  Future<void> loadIncomeExpense({
    required String period,
    required String accountingMethod,
  }) async {
    _isIncomeExpenseLoading = true;
    notifyListeners();
    await _fetchIncomeExpense(
      period: period,
      accountingMethod: accountingMethod,
    );
    _isIncomeExpenseLoading = false;
    notifyListeners();
  }

  /// Called when the expense breakdown period picker changes.
  Future<void> loadExpenses({required String period}) async {
    _isExpensesLoading = true;
    notifyListeners();
    await _fetchExpenses(period: period);
    _isExpensesLoading = false;
    notifyListeners();
  }

  /// Called when the Updates tab is selected.
  Future<void> loadUpdates() async {
    _isUpdatesLoading = true;
    notifyListeners();
    await _fetchUpdates();
    _isUpdatesLoading = false;
    notifyListeners();
  }

  /// Called when the Support tab is selected.
  Future<void> loadSupport() async {
    await _fetchSupport();
    notifyListeners();
  }

  // ── Private fetch helpers ─────────────────────────────────────────────────

  Future<void> _fetchOverview() async {
    final resp = await _overviewVm.fetch();
    final int? status = resp?['_statusCode'] as int?;
    if (resp != null && status != null && status >= 200 && status < 300) {
      final data = resp['data'] as Map<String, dynamic>? ?? resp;
      _overview = DashboardOverviewModel.fromJson(data);
    } else {
      appLog(
        '⚠️ Overview fetch failed (status: $status)',
        name: 'DashboardController',
      );
    }
  }

  Future<void> _fetchProjects() async {
    final resp = await _projectsVm.fetch();
    final int? status = resp?['_statusCode'] as int?;
    if (resp != null && status != null && status >= 200 && status < 300) {
      final data = resp['data'] as Map<String, dynamic>? ?? resp;
      _projects = DashboardProjectModel.fromJson(data);
    } else {
      appLog(
        '⚠️ Projects fetch failed (status: $status)',
        name: 'DashboardController',
      );
    }
  }

  Future<void> _fetchCashFlow({required String period}) async {
    final resp = await _cashFlowVm.fetch(period: period);
    final int? status = resp?['_statusCode'] as int?;
    if (resp != null && status != null && status >= 200 && status < 300) {
      final data = resp['data'] as Map<String, dynamic>?;
      final raw = (data?['months'] as List<dynamic>?) ?? [];
      _cashFlow = raw
          .map((e) => CashFlowPoint.fromJson(e as Map<String, dynamic>))
          .toList();
      // Store summary fields
      _cashFlowAsOnLabel = data?['as_on_label'] as String? ?? '';
      _cashFlowCurrency = data?['currency'] as String? ?? 'INR';
      _cashFlowPeriods =
          (data?['available_periods'] as List<dynamic>?)
              ?.map((e) => (e as Map)['value'] as String? ?? '')
              .where((s) => s.isNotEmpty)
              .toList() ??
          ['this_fiscal_year'];
    } else {
      appLog(
        '⚠️ Cash flow fetch failed (status: $status)',
        name: 'DashboardController',
      );
    }
  }

  Future<void> _fetchIncomeExpense({
    required String period,
    required String accountingMethod,
  }) async {
    final resp = await _incomeExpenseVm.fetch(
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
      // Store summary fields
      _incomeTotal = data?['income_total']?.toString() ?? '0.00';
      _expenseTotal = data?['expense_total']?.toString() ?? '0.00';
      _incomeExpenseCurrency = data?['currency'] as String? ?? 'INR';
      _incomeExpensePeriods =
          (data?['available_periods'] as List<dynamic>?)
              ?.map((e) => (e as Map)['value'] as String? ?? '')
              .where((s) => s.isNotEmpty)
              .toList() ??
          ['this_fiscal_year'];
    } else {
      appLog(
        '⚠️ Income/expense fetch failed (status: $status)',
        name: 'DashboardController',
      );
    }
  }

  Future<void> _fetchExpenses({required String period}) async {
    final resp = await _expensesVm.fetch(period: period);
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
      _expensesTotalExpense = data?['total_expense']?.toString() ?? '0.00';
      _expensesCurrency = data?['currency'] as String? ?? 'INR';
      _expensePeriods =
          (data?['available_periods'] as List<dynamic>?)
              ?.map((e) => (e as Map)['value'] as String? ?? '')
              .where((s) => s.isNotEmpty)
              .toList() ??
          ['this_fiscal_year'];
    } else {
      appLog(
        '⚠️ Expenses fetch failed (status: $status)',
        name: 'DashboardController',
      );
    }
  }

  Future<void> _fetchUpdates() async {
    final resp = await _updatesVm.fetch();
    final int? status = resp?['_statusCode'] as int?;
    if (resp != null && status != null && status >= 200 && status < 300) {
      final raw = _extractList(resp['data']);
      _updates = raw
          .map((e) => UpdateItemModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      appLog(
        '⚠️ Updates fetch failed (status: $status)',
        name: 'DashboardController',
      );
    }
  }

  Future<void> _fetchSupport() async {
    final resp = await _supportVm.fetch();
    final int? status = resp?['_statusCode'] as int?;
    if (resp != null && status != null && status >= 200 && status < 300) {
      final data = resp['data'] as Map<String, dynamic>?;
      if (data != null) {
        _support = SupportDataModel.fromJson(data);
      }
    } else {
      appLog(
        '⚠️ Support fetch failed (status: $status)',
        name: 'DashboardController',
      );
    }
  }

  // ── Helper ────────────────────────────────────────────────────────────────

  /// Safely extracts a [List] from a response data field that may be either
  /// a direct List or a Map containing a list under a common key.
  List<dynamic> _extractList(dynamic data) {
    if (data is List) return data;
    if (data is Map) {
      for (final key in ['items', 'updates', 'support', 'results', 'data']) {
        final v = data[key];
        if (v is List) return v;
      }
    }
    return [];
  }
}
