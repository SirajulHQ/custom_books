import 'package:custom_books/features/home/controllers/cash_flow_controller.dart';
import 'package:custom_books/features/home/controllers/expenses_controller.dart';
import 'package:custom_books/features/home/controllers/income_expense_controller.dart';
import 'package:custom_books/features/home/controllers/overview_controller.dart';
import 'package:custom_books/features/home/controllers/projects_controller.dart';
import 'package:custom_books/features/home/controllers/support_controller.dart';
import 'package:custom_books/features/home/controllers/updates_controller.dart';
import 'package:custom_books/features/home/models/cash_flow_point_model.dart';
import 'package:custom_books/features/home/models/dashboard_overview_model.dart';
import 'package:custom_books/features/home/models/dashboard_project_model.dart';
import 'package:custom_books/features/home/models/expense_item_model.dart';
import 'package:custom_books/features/home/models/income_expense_point_model.dart';
import 'package:custom_books/features/home/models/support_item_model.dart';
import 'package:custom_books/features/home/models/update_item_model.dart';
import 'package:flutter/material.dart';

class DashboardController extends ChangeNotifier {

  final overviewController = OverviewController();
  final projectsController = ProjectsController();
  final cashFlowController = CashFlowController();
  final incomeExpenseController = IncomeExpenseController();
  final expensesController = ExpensesController();
  final updatesController = UpdatesController();
  final supportController = SupportController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  DashboardController() {

    overviewController.addListener(notifyListeners);
    projectsController.addListener(notifyListeners);
    cashFlowController.addListener(notifyListeners);
    incomeExpenseController.addListener(notifyListeners);
    expensesController.addListener(notifyListeners);
    updatesController.addListener(notifyListeners);
    supportController.addListener(notifyListeners);
  }

  DashboardOverviewModel? get overview => overviewController.overview;
  DashboardProjectModel? get projects => projectsController.projects;

  bool get isCashFlowLoading => cashFlowController.isLoading;
  List<CashFlowPoint> get cashFlow => cashFlowController.cashFlow;
  List<String> get cashFlowPeriods => cashFlowController.periods;
  String get cashFlowAsOnLabel => cashFlowController.asOnLabel;
  String get cashFlowCurrency => cashFlowController.currency;

  bool get isIncomeExpenseLoading => incomeExpenseController.isLoading;
  List<IncomeExpensePoint> get incomeExpense =>
      incomeExpenseController.incomeExpense;
  List<String> get incomeExpensePeriods => incomeExpenseController.periods;
  String get incomeTotal => incomeExpenseController.incomeTotal;
  String get expenseTotal => incomeExpenseController.expenseTotal;
  String get incomeExpenseCurrency => incomeExpenseController.currency;

  bool get isExpensesLoading => expensesController.isLoading;
  List<ExpenseItem> get expenses => expensesController.expenses;
  List<String> get expensePeriods => expensesController.periods;
  String get expensesCurrency => expensesController.currency;
  String get expensesTotalExpense => expensesController.totalExpense;

  bool get isUpdatesLoading => updatesController.isLoading;
  List<UpdateItemModel>? get updates => updatesController.updates;
  int get unreadUpdatesCount => updatesController.unreadCount;
  SupportDataModel? get support => supportController.support;

  Future<void> loadDashboard({
    String period = 'this_fiscal_year',
    String accountingMethod = 'accrual',
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.wait([
      overviewController.fetch(),
      projectsController.fetch(),
      cashFlowController.fetch(period: period),
      incomeExpenseController.fetch(
        period: period,
        accountingMethod: accountingMethod,
      ),
      expensesController.fetch(period: period),
    ]);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadCashFlow({required String period}) =>
      cashFlowController.load(period: period);

  Future<void> loadIncomeExpense({
    required String period,
    required String accountingMethod,
  }) => incomeExpenseController.load(
    period: period,
    accountingMethod: accountingMethod,
  );

  Future<void> loadExpenses({required String period}) =>
      expensesController.load(period: period);

  Future<void> loadUpdates() => updatesController.load();

  Future<void> loadSupport() => supportController.load();

  @override
  void dispose() {
    overviewController
      ..removeListener(notifyListeners)
      ..dispose();
    projectsController
      ..removeListener(notifyListeners)
      ..dispose();
    cashFlowController
      ..removeListener(notifyListeners)
      ..dispose();
    incomeExpenseController
      ..removeListener(notifyListeners)
      ..dispose();
    expensesController
      ..removeListener(notifyListeners)
      ..dispose();
    updatesController
      ..removeListener(notifyListeners)
      ..dispose();
    supportController
      ..removeListener(notifyListeners)
      ..dispose();
    super.dispose();
  }
}
