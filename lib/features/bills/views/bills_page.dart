import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/features/drawer/views/custom_drawer.dart';
import 'package:custom_books/features/bills/models/bill_model.dart';
import 'package:custom_books/features/bills/views/add_bill_page.dart';
import 'package:custom_books/features/bills/views/bill_details_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
      builder: (context) => Container(
        margin: EdgeInsets.all(Dimensions.width15),
        padding: EdgeInsets.all(Dimensions.width20),
        decoration: BoxDecoration(
          color: context.colors.card,
          borderRadius: BorderRadius.circular(Dimensions.radius20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filter by Status',
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.95,
                fontWeight: FontWeight.w800,
                color: context.colors.textPrimary,
              ),
            ),
            SizedBox(height: Dimensions.height15),
            _filterOption('All Bills', null),
            for (final status in BillStatus.values)
              _filterOption(status.label, status),
            SizedBox(height: Dimensions.height10),
          ],
        ),
      ),
    );
  }

  Widget _filterOption(String label, BillStatus? status) {
    final selected = _statusFilter == status;
    return InkWell(
      borderRadius: BorderRadius.circular(Dimensions.radius15),
      onTap: () {
        setState(() => _statusFilter = status);
        Navigator.pop(context);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: Dimensions.height10 / 2),
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.width15,
          vertical: Dimensions.height10,
        ),
        decoration: BoxDecoration(
          color: selected
              ? Appcolors.primary.withValues(alpha: 0.08)
              : context.colors.surfaceLight,
          borderRadius: BorderRadius.circular(Dimensions.radius15),
          border: selected
              ? Border.all(color: Appcolors.primary.withValues(alpha: 0.4))
              : null,
        ),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.8,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected
                    ? Appcolors.primary
                    : context.colors.textPrimary,
              ),
            ),
            const Spacer(),
            if (selected)
              Icon(
                Icons.check_rounded,
                size: Dimensions.iconSize16,
                color: Appcolors.primary,
              ),
          ],
        ),
      ),
    );
  }

  void _openSortSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) {
          return Container(
            margin: EdgeInsets.all(Dimensions.width15),
            padding: EdgeInsets.all(Dimensions.width20),
            decoration: BoxDecoration(
              color: context.colors.card,
              borderRadius: BorderRadius.circular(Dimensions.radius20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sort By',
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.95,
                    fontWeight: FontWeight.w800,
                    color: context.colors.textPrimary,
                  ),
                ),
                SizedBox(height: Dimensions.height15),
                for (final field in BillSortField.values)
                  InkWell(
                    borderRadius: BorderRadius.circular(Dimensions.radius15),
                    onTap: () => setSheetState(() => _sortField = field),
                    child: Container(
                      margin: EdgeInsets.only(bottom: Dimensions.height10 / 2),
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.width15,
                        vertical: Dimensions.height10,
                      ),
                      decoration: BoxDecoration(
                        color: _sortField == field
                            ? Appcolors.primary.withValues(alpha: 0.08)
                            : context.colors.surfaceLight,
                        borderRadius: BorderRadius.circular(
                          Dimensions.radius15,
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            field.label,
                            style: TextStyle(
                              fontSize: Dimensions.font16 * 0.8,
                              fontWeight: _sortField == field
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: _sortField == field
                                  ? Appcolors.primary
                                  : context.colors.textPrimary,
                            ),
                          ),
                          const Spacer(),
                          if (_sortField == field)
                            Icon(
                              Icons.check_rounded,
                              size: Dimensions.iconSize16,
                              color: Appcolors.primary,
                            ),
                        ],
                      ),
                    ),
                  ),
                SizedBox(height: Dimensions.height10),
                Row(
                  children: [
                    Expanded(
                      child: _directionButton(
                        'Ascending',
                        Icons.arrow_upward_rounded,
                        SortDirection.ascending,
                        setSheetState,
                      ),
                    ),
                    SizedBox(width: Dimensions.width10),
                    Expanded(
                      child: _directionButton(
                        'Descending',
                        Icons.arrow_downward_rounded,
                        SortDirection.descending,
                        setSheetState,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Dimensions.height15),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {});
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Appcolors.primary,
                      side: const BorderSide(color: Appcolors.primary, width: 1.5),
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(
                        vertical: Dimensions.height15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          Dimensions.radius15,
                        ),
                      ),
                    ),
                    child: const Text('Apply'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _directionButton(
    String label,
    IconData icon,
    SortDirection direction,
    void Function(void Function()) setSheetState,
  ) {
    final selected = _sortDirection == direction;
    return InkWell(
      borderRadius: BorderRadius.circular(Dimensions.radius15),
      onTap: () => setSheetState(() => _sortDirection = direction),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: Dimensions.height10),
        decoration: BoxDecoration(
          color: selected
              ? Appcolors.primary.withValues(alpha: 0.08)
              : context.colors.surfaceLight,
          borderRadius: BorderRadius.circular(Dimensions.radius15),
          border: selected
              ? Border.all(color: Appcolors.primary.withValues(alpha: 0.4))
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: Dimensions.iconSize16,
              color: selected
                  ? Appcolors.primary
                  : context.colors.textSecondary,
            ),
            SizedBox(width: Dimensions.width10 / 2),
            Text(
              label,
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.75,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected
                    ? Appcolors.primary
                    : context.colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);
    final visibleList = _visibleBills;

    return Scaffold(
      backgroundColor: context.colors.background,
      drawer: const DrawerView(currentRoute: 'bills'),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radius15),
          boxShadow: [
            BoxShadow(
              color: Appcolors.primary.withValues(alpha: 0.35),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: _addNewBill,
          backgroundColor: Appcolors.primary,
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
                color: Appcolors.accent,
                onPressed: _openFilterSheet,
              ),
              SizedBox(width: Dimensions.width20),
            ],
          ),
        ],
        body: Column(
          children: [
          if (_searchOpen)
            Padding(
              padding: EdgeInsets.fromLTRB(
                Dimensions.width20,
                Dimensions.height10,
                Dimensions.width20,
                Dimensions.height15,
              ),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                onChanged: (_) => setState(() {}),
                style: TextStyle(fontSize: Dimensions.font16 * 0.85),
                decoration: InputDecoration(
                  hintText: 'Search by vendor or bill number',
                  hintStyle: TextStyle(color: context.colors.textTertiary),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: context.colors.textTertiary,
                  ),
                  filled: true,
                  fillColor: context.colors.card,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: Dimensions.height10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Dimensions.radius15),
                    borderSide: BorderSide(color: context.colors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Dimensions.radius15),
                    borderSide: BorderSide(color: context.colors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Dimensions.radius15),
                    borderSide: const BorderSide(
                      color: Appcolors.primary,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              Dimensions.width20,
              Dimensions.height10 / 2,
              Dimensions.width20,
              Dimensions.height15,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: context.colors.surfaceLight,
                      borderRadius: BorderRadius.circular(Dimensions.radius30),
                    ),
                    child: Row(
                      children: [
                        _tabButton('All', 0),
                        _tabButton('Open', 1),
                        _tabButton('Overdue', 2),
                        _tabButton('Paid', 3),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: Dimensions.width10),
                InkWell(
                  borderRadius: BorderRadius.circular(Dimensions.radius15),
                  onTap: _openFilterSheet,
                  child: _controlBadge(
                    _statusFilter == null
                        ? Icons.filter_list_rounded
                        : Icons.filter_alt_rounded,
                    active: _statusFilter != null,
                  ),
                ),
                SizedBox(width: Dimensions.width10 / 2),
                InkWell(
                  borderRadius: BorderRadius.circular(Dimensions.radius15),
                  onTap: _openSortSheet,
                  child: _controlBadge(Icons.swap_vert_rounded),
                ),
              ],
            ),
          ),
          if (_statusFilter != null)
            Container(
              margin: EdgeInsets.fromLTRB(
                Dimensions.width20,
                0,
                Dimensions.width20,
                Dimensions.height10,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.width15,
                vertical: Dimensions.height10 / 2,
              ),
              decoration: BoxDecoration(
                color: Appcolors.primary.withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(Dimensions.radius15),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.filter_alt_rounded,
                    size: Dimensions.iconSize16,
                    color: Appcolors.primary,
                  ),
                  SizedBox(width: Dimensions.width10 / 2),
                  Text(
                    'Status: ${_statusFilter!.label}',
                    style: TextStyle(
                      fontSize: Dimensions.font16 * 0.72,
                      fontWeight: FontWeight.w600,
                      color: Appcolors.primary,
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () => setState(() => _statusFilter = null),
                    child: Icon(
                      Icons.close_rounded,
                      size: Dimensions.iconSize16,
                      color: Appcolors.primary,
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: visibleList.isEmpty
                ? Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.width20,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: Dimensions.height45 * 1.6,
                            height: Dimensions.height45 * 1.6,
                            decoration: BoxDecoration(
                              color: Appcolors.primary.withValues(alpha: 0.08),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.description_outlined,
                              size: Dimensions.iconSize24 * 1.3,
                              color: Appcolors.primary,
                            ),
                          ),
                          SizedBox(height: Dimensions.height15),
                          Text(
                            'No bills found',
                            style: TextStyle(
                              fontSize: Dimensions.font16,
                              fontWeight: FontWeight.w700,
                              color: context.colors.textPrimary,
                            ),
                          ),
                          SizedBox(height: Dimensions.height10 / 2),
                          Text(
                            'Tap the + button to record a new bill.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: Dimensions.font16 * 0.75,
                              color: context.colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: () async => setState(() {}),
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.width20,
                      ),
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      itemCount: visibleList.length,
                      itemBuilder: (context, index) =>
                          _billTile(visibleList[index]),
                    ),
                  ),
          ),
        ],
        ),
      ),
    );
  }

  Widget _tabButton(String label, int index) {
    final selected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() {
          _selectedTab = index;
          _statusFilter = null;
        }),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: EdgeInsets.symmetric(vertical: Dimensions.height10),
          decoration: BoxDecoration(
            color: selected ? context.colors.card : Colors.transparent,
            borderRadius: BorderRadius.circular(Dimensions.radius30),
            border: selected
                ? Border.all(
                    color: Appcolors.primary.withValues(alpha: 0.3),
                    width: 1.5,
                  )
                : null,
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: Appcolors.primary.withValues(alpha: 0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.68,
              fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
              color: selected
                  ? Appcolors.primary
                  : context.colors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _controlBadge(IconData icon, {bool active = false}) {
    return Container(
      width: Dimensions.height45 * 0.9,
      height: Dimensions.height45 * 0.9,
      decoration: BoxDecoration(
        color: (active ? Appcolors.accent : Appcolors.primary).withValues(
          alpha: 0.1,
        ),
        borderRadius: BorderRadius.circular(Dimensions.radius15),
      ),
      child: Icon(
        icon,
        size: Dimensions.iconSize24 - 4,
        color: active ? Appcolors.accent : Appcolors.primary,
      ),
    );
  }

  Widget _billTile(BillModel bill) {
    return InkWell(
      borderRadius: BorderRadius.circular(Dimensions.radius15),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => BillDetailsPage(bill: bill)),
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
                color: Appcolors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(Dimensions.radius15 - 4),
              ),
              child: Icon(
                Icons.description_outlined,
                color: Appcolors.primary,
                size: Dimensions.iconSize24 - 4,
              ),
            ),
            SizedBox(width: Dimensions.width15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bill.vendorName,
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
                        DateFormat('dd MMM yyyy').format(bill.billDate),
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
                          bill.billNumber,
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
                  Row(
                    children: [
                      Icon(
                        Icons.event_busy_rounded,
                        size: Dimensions.iconSize16 - 2,
                        color: context.colors.textTertiary,
                      ),
                      SizedBox(width: Dimensions.width10 / 2),
                      Text(
                        'Due ${DateFormat('dd MMM yyyy').format(bill.dueDate)}',
                        style: TextStyle(
                          fontSize: Dimensions.font16 * 0.7,
                          color: context.colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Dimensions.height10 / 2),
                  _statusChip(bill.status),
                ],
              ),
            ),
            SizedBox(width: Dimensions.width10),
            Text(
              '₹${bill.total.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.9,
                fontWeight: FontWeight.w800,
                color: Appcolors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusChip(BillStatus status) {
    final color = switch (status) {
      BillStatus.draft => Colors.grey,
      BillStatus.open => Appcolors.primaryLight,
      BillStatus.overdue => Appcolors.error,
      BillStatus.paid => Appcolors.success,
      BillStatus.partiallyPaid => Appcolors.warning,
    };
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.width10,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(Dimensions.radius30),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          fontSize: Dimensions.font16 * 0.6,
          color: color,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
