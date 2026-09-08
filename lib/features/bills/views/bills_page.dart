import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/core/widgets/active_filter_banner.dart';
import 'package:custom_books/core/widgets/custom_search_field.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/core/widgets/list_control_bar.dart';
import 'package:custom_books/features/drawer/views/custom_drawer.dart';
import 'package:custom_books/features/bills/models/bill_model.dart';
import 'package:custom_books/features/bills/views/add_bill_page.dart';
import 'package:custom_books/features/bills/widgets/bill_filter_sheet.dart';
import 'package:custom_books/features/bills/widgets/bill_sort_sheet.dart';
import 'package:custom_books/features/bills/widgets/bills_list_body.dart';
import 'package:flutter/material.dart';
import 'package:custom_books/core/enums/sort_direction.dart';

class BillsPage extends StatefulWidget {
  final int initialTab;

  const BillsPage({super.key, this.initialTab = 0});

  @override
  State<BillsPage> createState() => _BillsPageState();
}

class _BillsPageState extends State<BillsPage> {
  final TextEditingController _searchController = TextEditingController();

  late int _selectedTab; // 0: All, 1: Open, 2: Overdue, 3: Paid
  bool _searchOpen = false;
  BillStatus? _statusFilter;
  BillSortField _sortField = BillSortField.createdTime;
  SortDirection _sortDirection = SortDirection.descending;

  late List<BillModel> _bills;

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.initialTab;
    _bills = [
      BillModel(
        id: '1',
        billNumber: 'BILL-00021',
        vendorName: 'Al Futtaim Trading',
        billDate: DateTime(2026, 7, 3),
        dueDate: DateTime(2026, 7, 18),
        status: BillStatus.open,
        total: 15230.75,
        balanceDue: 15230.75,
        createdAt: DateTime(2026, 7, 3, 10, 0),
        updatedAt: DateTime(2026, 7, 3, 10, 0),
      ),
      BillModel(
        id: '2',
        billNumber: 'BILL-00020',
        vendorName: 'Gulf Office Supplies',
        billDate: DateTime(2026, 6, 15),
        dueDate: DateTime(2026, 6, 30),
        status: BillStatus.overdue,
        total: 3420.00,
        balanceDue: 3420.00,
        createdAt: DateTime(2026, 6, 15, 9, 30),
        updatedAt: DateTime(2026, 6, 15, 9, 30),
      ),
      BillModel(
        id: '3',
        billNumber: 'BILL-00019',
        vendorName: 'Desert Tech Solutions',
        billDate: DateTime(2026, 6, 10),
        dueDate: DateTime(2026, 6, 25),
        status: BillStatus.paid,
        total: 8975.50,
        balanceDue: 0,
        createdAt: DateTime(2026, 6, 10, 14, 0),
        updatedAt: DateTime(2026, 6, 10, 14, 0),
      ),
      BillModel(
        id: '4',
        billNumber: 'BILL-00018',
        vendorName: 'Emirates Logistics',
        billDate: DateTime(2026, 6, 5),
        dueDate: DateTime(2026, 6, 20),
        status: BillStatus.partiallyPaid,
        total: 5200.00,
        balanceDue: 2100.00,
        createdAt: DateTime(2026, 6, 5, 11, 15),
        updatedAt: DateTime(2026, 6, 5, 11, 15),
      ),
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<BillModel> get _visibleBills {
    final query = _searchController.text.trim().toLowerCase();
    final list = _bills.where((bill) {
      if (_selectedTab == 1 && bill.status != BillStatus.open) {
        return false;
      }
      if (_selectedTab == 2 && bill.status != BillStatus.overdue) {
        return false;
      }
      if (_selectedTab == 3 && bill.status != BillStatus.paid) {
        return false;
      }
      if (_statusFilter != null && bill.status != _statusFilter) {
        return false;
      }
      return query.isEmpty ||
          bill.vendorName.toLowerCase().contains(query) ||
          bill.billNumber.toLowerCase().contains(query);
    }).toList();

    list.sort((a, b) {
      int result;
      switch (_sortField) {
        case BillSortField.createdTime:
          result = a.createdAt.compareTo(b.createdAt);
        case BillSortField.date:
          result = a.billDate.compareTo(b.billDate);
        case BillSortField.billNumber:
          result = a.billNumber.compareTo(b.billNumber);
        case BillSortField.vendorName:
          result = a.vendorName.toLowerCase().compareTo(
            b.vendorName.toLowerCase(),
          );
        case BillSortField.amount:
          result = a.total.compareTo(b.total);
      }
      return _sortDirection == SortDirection.ascending ? result : -result;
    });

    return list;
  }

  Future<void> _addNewBill() async {
    final result = await Navigator.push<BillModel>(
      context,
      MaterialPageRoute(builder: (_) => const AddBillPage()),
    );
    if (result != null && mounted) {
      setState(() => _bills.insert(0, result));
      ToastificationHelper.showSuccess(context, 'Bill created successfully');
    }
  }

  void _openFilterSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BillFilterSheet(
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
      builder: (_) => BillSortSheet(
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
    final visibleList = _visibleBills;

    return Scaffold(
      backgroundColor: context.colors.background,
      drawer: const DrawerView(currentRoute: 'bills'),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radius15),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.35),
              blurRadius: Dimensions.radius15 * 1.07,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: _addNewBill,
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.radius15),
          ),
          child: const Icon(Icons.add_rounded),
        ),
      ),
      body: NestedScrollView(
        physics: const BouncingScrollPhysics(),
        headerSliverBuilder: (context, _) => [
          CustomSliverAppBar(
            title: 'Bills',
            subtitle: '${_bills.length} bill${_bills.length == 1 ? '' : 's'}',
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
                onPressed: _openFilterSheet,
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
                hintText: 'Search by vendor or bill number',
                onChanged: (_) => setState(() {}),
              ),
            ListControlBar(
              tabs: const ['All', 'Open', 'Overdue', 'Paid'],
              selectedTab: _selectedTab,
              onTabSelected: (index) => setState(() {
                _selectedTab = index;
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
              child: BillsListBody(
                bills: visibleList,
                onRefresh: () => setState(() {}),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
