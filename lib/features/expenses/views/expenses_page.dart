import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/widgets/active_filter_banner.dart';
import 'package:custom_books/core/widgets/empty_state_widget.dart';
import 'package:custom_books/core/widgets/list_control_bar.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/core/widgets/custom_add_button.dart';
import 'package:custom_books/core/widgets/custom_search_field.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/core/widgets/status_chip.dart';
import 'package:custom_books/features/drawer/views/custom_drawer.dart';
import 'package:custom_books/features/expenses/models/expense_model.dart';
import 'package:custom_books/features/expenses/views/add_expense_page.dart';
import 'package:custom_books/features/expenses/views/expense_details_page.dart';
import 'package:custom_books/features/expenses/widgets/expense_filter_sheet.dart';
import 'package:custom_books/features/expenses/widgets/expense_sort_sheet.dart';
import 'package:custom_books/features/expenses/widgets/expenses_more_options_sheet.dart';
import 'package:flutter/material.dart';
import 'package:custom_books/core/utils/date_formatter.dart';
import 'package:custom_books/core/enums/sort_direction.dart';

class ExpensesPage extends StatefulWidget {
  const ExpensesPage({super.key});

  @override
  State<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  final TextEditingController _searchController = TextEditingController();

  int _selectedTab = 0; // 0: All, 1: Unbilled, 2: Billed
  bool _searchOpen = false;
  ExpenseStatus? _statusFilter;
  ExpenseSortField _sortField = ExpenseSortField.createdTime;
  SortDirection _sortDirection = SortDirection.descending;

  late List<ExpenseModel> _expenses;

  @override
  void initState() {
    super.initState();
    _expenses = [
      ExpenseModel(
        id: '1',
        category: 'Fuel/Mileage',
        vendorName: 'ADNOC Distribution',
        expenseDate: DateTime(2026, 7, 3),
        referenceNumber: 'EXP-0012',
        status: ExpenseStatus.unbilled,
        amount: 320.50,
        createdAt: DateTime(2026, 7, 3, 10, 0),
        updatedAt: DateTime(2026, 7, 3, 10, 0),
      ),
      ExpenseModel(
        id: '2',
        category: 'Office Supplies',
        vendorName: 'Gulf Office Supplies',
        expenseDate: DateTime(2026, 7, 2),
        referenceNumber: 'EXP-0011',
        status: ExpenseStatus.billed,
        amount: 145.00,
        createdAt: DateTime(2026, 7, 2, 9, 30),
        updatedAt: DateTime(2026, 7, 2, 9, 30),
      ),
      ExpenseModel(
        id: '3',
        category: 'Travel',
        vendorName: 'Emirates Airlines',
        expenseDate: DateTime(2026, 7, 1),
        referenceNumber: 'EXP-0010',
        status: ExpenseStatus.reimbursed,
        amount: 1850.75,
        createdAt: DateTime(2026, 7, 1, 14, 0),
        updatedAt: DateTime(2026, 7, 1, 14, 0),
      ),
      ExpenseModel(
        id: '4',
        category: 'Meals & Entertainment',
        vendorName: 'The Cheesecake Factory',
        expenseDate: DateTime(2026, 6, 29),
        referenceNumber: 'EXP-0009',
        status: ExpenseStatus.nonBillable,
        amount: 275.25,
        createdAt: DateTime(2026, 6, 29, 20, 15),
        updatedAt: DateTime(2026, 6, 29, 20, 15),
      ),
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ExpenseModel> get _visibleExpenses {
    final query = _searchController.text.trim().toLowerCase();
    final list = _expenses.where((expense) {
      if (_selectedTab == 1 && expense.status != ExpenseStatus.unbilled) {
        return false;
      }
      if (_selectedTab == 2 && expense.status != ExpenseStatus.billed) {
        return false;
      }
      if (_statusFilter != null && expense.status != _statusFilter) {
        return false;
      }
      return query.isEmpty ||
          expense.category.toLowerCase().contains(query) ||
          expense.vendorName.toLowerCase().contains(query) ||
          expense.referenceNumber.toLowerCase().contains(query);
    }).toList();

    list.sort((a, b) {
      int result;
      switch (_sortField) {
        case ExpenseSortField.createdTime:
          result = a.createdAt.compareTo(b.createdAt);
        case ExpenseSortField.date:
          result = a.expenseDate.compareTo(b.expenseDate);
        case ExpenseSortField.category:
          result = a.category.toLowerCase().compareTo(b.category.toLowerCase());
        case ExpenseSortField.amount:
          result = a.amount.compareTo(b.amount);
      }
      return _sortDirection == SortDirection.ascending ? result : -result;
    });

    return list;
  }

  Future<void> _addNewExpense() async {
    final result = await Navigator.push<ExpenseModel>(
      context,
      MaterialPageRoute(builder: (_) => const AddExpensePage()),
    );
    if (result != null && mounted) {
      setState(() => _expenses.insert(0, result));
      ToastificationHelper.showSuccess(context, 'Expense created successfully');
    }
  }

  void _showMoreOptions() {
    ExpensesMoreOptionsSheet.show(
      context,
      onExport: () =>
          ToastificationHelper.showSuccess(context, 'Expenses exported'),
      onRefresh: () => setState(() {}),
    );
  }

  void _openFilterSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ExpenseFilterSheet(
        selectedStatus: _statusFilter,
        onSelected: (status) => setState(() => _statusFilter = status),
      ),
    );
  }

  void _openSortSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ExpenseSortSheet(
        selectedField: _sortField,
        selectedDirection: _sortDirection,
        onApply: (field, direction) {
          setState(() {
            _sortField = field;
            _sortDirection = direction;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final visibleList = _visibleExpenses;

    return Scaffold(
      backgroundColor: context.colors.background,
      drawer: const DrawerView(currentRoute: 'expenses'),
      floatingActionButton: CustomAddButton(onPressed: _addNewExpense),
      body: NestedScrollView(
        physics: const BouncingScrollPhysics(),
        headerSliverBuilder: (context, _) => [
          CustomSliverAppBar(
            title: 'Expenses',
            subtitle:
                '${_expenses.length} expense${_expenses.length == 1 ? '' : 's'}',
            leadingType: AppBarLeadingType.menu,
            actions: [
              AppBarIconButton(
                icon: _searchOpen ? Icons.close_rounded : Icons.search_rounded,
                onPressed: () => setState(() {
                  _searchOpen = !_searchOpen;
                  if (!_searchOpen) _searchController.clear();
                }),
              ),
              SizedBox(width: Dimensions.width10),
              AppBarIconButton(
                icon: Icons.more_vert_rounded,
                color: AppColors.accent,
                onPressed: _showMoreOptions,
              ),
              SizedBox(width: Dimensions.width20),
            ],
          ),
        ],
        body: Column(
          children: [
            if (_searchOpen)
              ListSearchField(
                controller: _searchController,
                hintText: 'Search by category, vendor or reference',
                onChanged: (_) => setState(() {}),
              ),
            ListControlBar(
              tabs: const ['All', 'Unbilled', 'Billed'],
              selectedTab: _selectedTab,
              onTabSelected: (i) => setState(() {
                _selectedTab = i;
                _statusFilter = null;
              }),
              filterActive: _statusFilter != null,
              onFilterTap: _openFilterSheet,
              onSortTap: _openSortSheet,
            ),
            if (_statusFilter != null)
              ActiveFilterBanner(
                label: 'Status: ${_statusFilter!.label}',
                onClear: () => setState(() => _statusFilter = null),
              ),
            Expanded(
              child: visibleList.isEmpty
                  ? const EmptyStateWidget(
                      icon: Icons.receipt_long_outlined,
                      title: 'No expenses found',
                      subtitle: 'Tap the + button to record a new expense.',
                    )
                  : RefreshIndicator(
                      onRefresh: () async => setState(() {}),
                      child: ListView.builder(
                        padding: EdgeInsets.fromLTRB(
                          Dimensions.width20,
                          0,
                          Dimensions.width20,
                          Dimensions.listBottomSpace,
                        ),
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        itemCount: visibleList.length,
                        itemBuilder: (context, index) =>
                            _expenseTile(visibleList[index]),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _expenseTile(ExpenseModel expense) {
    return InkWell(
      borderRadius: BorderRadius.circular(Dimensions.radius15),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ExpenseDetailsPage(expense: expense)),
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: Dimensions.height10),
        padding: EdgeInsets.all(Dimensions.width15),
        decoration: BoxDecoration(
          color: context.colors.card,
          borderRadius: BorderRadius.circular(Dimensions.radius15),
          border: Border.all(color: context.colors.border),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: Dimensions.height45 * 0.78,
              height: Dimensions.height45 * 0.78,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(Dimensions.radius15 - 4),
              ),
              child: Icon(
                Icons.receipt_long_outlined,
                color: AppColors.primary,
                size: Dimensions.iconSize24 - 4,
              ),
            ),
            SizedBox(width: Dimensions.width15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    expense.category,
                    style: TextStyle(
                      fontSize: Dimensions.font16 * 0.95,
                      fontWeight: FontWeight.w700,
                      color: context.colors.textPrimary,
                    ),
                  ),
                  SizedBox(height: Dimensions.height10 / 2),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_rounded,
                        size: Dimensions.iconSize16 - 2,
                        color: context.colors.textTertiary,
                      ),
                      SizedBox(width: Dimensions.width10 / 2),
                      Text(
                        formatDate(expense.expenseDate),
                        style: TextStyle(
                          fontSize: Dimensions.font16 * 0.7,
                          color: context.colors.textSecondary,
                        ),
                      ),
                      Text(
                        '  •  ',
                        style: TextStyle(
                          fontSize: Dimensions.font16 * 0.7,
                          color: context.colors.textTertiary,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          expense.vendorName,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: Dimensions.font16 * 0.7,
                            color: context.colors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Dimensions.height10 / 2),
                  StatusChip(
                    color: expense.status.color,
                    label: expense.status.label,
                  ),
                ],
              ),
            ),
            SizedBox(width: Dimensions.width10),
            Text(
              '₹${expense.amount.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.9,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
