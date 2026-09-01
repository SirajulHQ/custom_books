import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/core/widgets/custom_add_button.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/features/drawer/views/custom_drawer.dart';
import 'package:custom_books/features/payments_made/models/payment_made_model.dart';
import 'package:custom_books/features/payments_made/views/add_payment_made_page.dart';
import 'package:custom_books/features/payments_made/views/payment_made_details_page.dart';
import 'package:custom_books/features/payments_made/widgets/payment_made_filter_sheet.dart';
import 'package:custom_books/features/payments_made/widgets/payment_made_sort_sheet.dart';
import 'package:custom_books/features/payments_made/widgets/payment_made_page_widgets.dart';
import 'package:flutter/material.dart';
import 'package:custom_books/core/enums/sort_direction.dart';

class PaymentsMadePage extends StatefulWidget {
  const PaymentsMadePage({super.key});

  @override
  State<PaymentsMadePage> createState() => _PaymentsMadePageState();
}

class _PaymentsMadePageState extends State<PaymentsMadePage> {
  final TextEditingController _searchController = TextEditingController();

  int _selectedTab = 0; // 0: All, 1: This Month
  bool _searchOpen = false;
  PaymentMode? _modeFilter;
  PaymentMadeSortField _sortField = PaymentMadeSortField.createdTime;
  SortDirection _sortDirection = SortDirection.descending;

  late List<PaymentMadeModel> _payments;

  @override
  void initState() {
    super.initState();
    _payments = [
      PaymentMadeModel(
        id: '1',
        paymentNumber: 'PAY-00035',
        vendorName: 'Al Futtaim Trading',
        billNumbers: const ['BILL-00021'],
        paymentDate: DateTime(2026, 7, 3),
        mode: PaymentMode.bankTransfer,
        referenceNumber: 'TXN-778812',
        amount: 15230.75,
        createdAt: DateTime(2026, 7, 3, 10, 0),
        updatedAt: DateTime(2026, 7, 3, 10, 0),
      ),
      PaymentMadeModel(
        id: '2',
        paymentNumber: 'PAY-00034',
        vendorName: 'Gulf Office Supplies',
        billNumbers: const ['BILL-00020'],
        paymentDate: DateTime(2026, 7, 2),
        mode: PaymentMode.card,
        referenceNumber: 'TXN-778799',
        amount: 3420.00,
        createdAt: DateTime(2026, 7, 2, 9, 30),
        updatedAt: DateTime(2026, 7, 2, 9, 30),
      ),
      PaymentMadeModel(
        id: '3',
        paymentNumber: 'PAY-00033',
        vendorName: 'Desert Tech Solutions',
        billNumbers: const ['BILL-00019', 'BILL-00017'],
        paymentDate: DateTime(2026, 6, 28),
        mode: PaymentMode.cheque,
        referenceNumber: 'CHQ-004521',
        amount: 8975.50,
        createdAt: DateTime(2026, 6, 28, 14, 0),
        updatedAt: DateTime(2026, 6, 28, 14, 0),
      ),
      PaymentMadeModel(
        id: '4',
        paymentNumber: 'PAY-00032',
        vendorName: 'Emirates Logistics',
        billNumbers: const ['BILL-00018'],
        paymentDate: DateTime(2026, 6, 25),
        mode: PaymentMode.cash,
        referenceNumber: '',
        amount: 3100.00,
        createdAt: DateTime(2026, 6, 25, 11, 15),
        updatedAt: DateTime(2026, 6, 25, 11, 15),
      ),
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool _isThisMonth(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month;
  }

  List<PaymentMadeModel> get _visiblePayments {
    final query = _searchController.text.trim().toLowerCase();
    final list = _payments.where((payment) {
      if (_selectedTab == 1 && !_isThisMonth(payment.paymentDate)) {
        return false;
      }
      if (_modeFilter != null && payment.mode != _modeFilter) {
        return false;
      }
      return query.isEmpty ||
          payment.vendorName.toLowerCase().contains(query) ||
          payment.paymentNumber.toLowerCase().contains(query) ||
          payment.referenceNumber.toLowerCase().contains(query);
    }).toList();

    list.sort((a, b) {
      int result;
      switch (_sortField) {
        case PaymentMadeSortField.createdTime:
          result = a.createdAt.compareTo(b.createdAt);
        case PaymentMadeSortField.date:
          result = a.paymentDate.compareTo(b.paymentDate);
        case PaymentMadeSortField.paymentNumber:
          result = a.paymentNumber.compareTo(b.paymentNumber);
        case PaymentMadeSortField.vendorName:
          result = a.vendorName.toLowerCase().compareTo(
            b.vendorName.toLowerCase(),
          );
        case PaymentMadeSortField.amount:
          result = a.amount.compareTo(b.amount);
      }
      return _sortDirection == SortDirection.ascending ? result : -result;
    });

    return list;
  }

  Future<void> _addNewPayment() async {
    final result = await Navigator.push<PaymentMadeModel>(
      context,
      MaterialPageRoute(builder: (_) => const AddPaymentMadePage()),
    );
    if (result != null && mounted) {
      setState(() => _payments.insert(0, result));
      ToastificationHelper.showSuccess(context, 'Payment created successfully');
    }
  }

  void _openFilterSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PaymentMadeFilterSheet(
        selectedMode: _modeFilter,
        onSelected: (mode) => setState(() => _modeFilter = mode),
      ),
    );
  }

  void _openSortSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PaymentMadeSortSheet(
        selectedField: _sortField,
        selectedDirection: _sortDirection,
        onApply: (field, direction) => setState(() {
          _sortField = field;
          _sortDirection = direction;
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final visibleList = _visiblePayments;

    return Scaffold(
      backgroundColor: context.colors.background,
      drawer: const DrawerView(currentRoute: 'payments_made'),
      floatingActionButton: CustomAddButton(onPressed: _addNewPayment),
      body: NestedScrollView(
        physics: const BouncingScrollPhysics(),
        headerSliverBuilder: (context, _) => [
          CustomSliverAppBar(
            title: 'Payments Made',
            subtitle:
                '${_payments.length} payment${_payments.length == 1 ? '' : 's'}',
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
                    hintText: 'Search by vendor, payment or reference',
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
                        color: AppColors.primary,
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
                      padding: EdgeInsets.all(Dimensions.height10 * 0.4),
                      decoration: BoxDecoration(
                        color: context.colors.surfaceLight,
                        borderRadius: BorderRadius.circular(
                          Dimensions.radius30,
                        ),
                      ),
                      child: Row(
                        children: [
                          _tabButton('All', 0),
                          _tabButton('This Month', 1),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: Dimensions.width10),
                  InkWell(
                    borderRadius: BorderRadius.circular(Dimensions.radius15),
                    onTap: _openFilterSheet,
                    child: _controlBadge(
                      _modeFilter == null
                          ? Icons.filter_list_rounded
                          : Icons.filter_alt_rounded,
                      active: _modeFilter != null,
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
            if (_modeFilter != null)
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
                  color: AppColors.primary.withValues(alpha: 0.07),
                  borderRadius: BorderRadius.circular(Dimensions.radius15),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.filter_alt_rounded,
                      size: Dimensions.iconSize16,
                      color: AppColors.primary,
                    ),
                    SizedBox(width: Dimensions.width10 / 2),
                    Text(
                      'Mode: ${_modeFilter!.label}',
                      style: TextStyle(
                        fontSize: Dimensions.font16 * 0.72,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () => setState(() => _modeFilter = null),
                      child: Icon(
                        Icons.close_rounded,
                        size: Dimensions.iconSize16,
                        color: AppColors.primary,
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
                                color: AppColors.primary.withValues(
                                  alpha: 0.08,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.payments_outlined,
                                size: Dimensions.iconSize24 * 1.3,
                                color: AppColors.primary,
                              ),
                            ),
                            SizedBox(height: Dimensions.height15),
                            Text(
                              'No payments found',
                              style: TextStyle(
                                fontSize: Dimensions.font16,
                                fontWeight: FontWeight.w700,
                                color: context.colors.textPrimary,
                              ),
                            ),
                            SizedBox(height: Dimensions.height10 / 2),
                            Text(
                              'Tap the + button to record a payment made.',
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
                        itemBuilder: (context, index) => PaymentMadeTile(
                          payment: visibleList[index],
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PaymentMadeDetailsPage(
                                payment: visibleList[index],
                              ),
                            ),
                          ),
                        ),
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
          _modeFilter = null;
        }),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: EdgeInsets.symmetric(vertical: Dimensions.height10),
          decoration: BoxDecoration(
            color: selected ? context.colors.card : Colors.transparent,
            borderRadius: BorderRadius.circular(Dimensions.radius30),
            border: selected
                ? Border.all(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    width: 1.5,
                  )
                : null,
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      blurRadius: Dimensions.radius15 * 0.53,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.72,
              fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
              color: selected
                  ? AppColors.primary
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
        color: (active ? AppColors.accent : AppColors.primary).withValues(
          alpha: 0.1,
        ),
        borderRadius: BorderRadius.circular(Dimensions.radius15),
      ),
      child: Icon(
        icon,
        size: Dimensions.iconSize24 - 4,
        color: active ? AppColors.accent : AppColors.primary,
      ),
    );
  }
}
