import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/core/widgets/custom_add_button.dart';
import 'package:custom_books/core/widgets/custom_search_field.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/features/drawer/views/custom_drawer.dart';
import 'package:custom_books/features/payments_received/models/payment_received_model.dart';
import 'package:custom_books/features/payments_received/views/add_payment_received_page.dart';
import 'package:custom_books/features/payments_received/views/payment_received_details_page.dart';
import 'package:custom_books/features/payments_received/widgets/payment_received_filter_sheet.dart';
import 'package:custom_books/features/payments_received/widgets/payment_received_sort_sheet.dart';
import 'package:custom_books/features/payments_received/widgets/payment_received_page_widgets.dart';
import 'package:flutter/material.dart';
import 'package:custom_books/core/enums/sort_direction.dart';

class PaymentsReceivedPage extends StatefulWidget {
  const PaymentsReceivedPage({super.key});

  @override
  State<PaymentsReceivedPage> createState() => _PaymentsReceivedPageState();
}

class _PaymentsReceivedPageState extends State<PaymentsReceivedPage> {
  final TextEditingController _searchController = TextEditingController();

  int _selectedTab = 0; // 0: All, 1: This Month, 2: Unapplied
  bool _searchOpen = false;
  PaymentMode? _modeFilter;
  PaymentReceivedSortField _sortField = PaymentReceivedSortField.createdTime;
  SortDirection _sortDirection = SortDirection.descending;

  late List<PaymentReceivedModel> _payments;

  @override
  void initState() {
    super.initState();
    _payments = [
      PaymentReceivedModel(
        id: '1',
        paymentNumber: 'PR-00021',
        customerName: 'Nandhu',
        invoiceNumbers: const ['INV-000039'],
        paymentDate: DateTime.now(),
        mode: PaymentMode.bankTransfer,
        referenceNumber: 'TXN-9931',
        amount: 1240.00,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      PaymentReceivedModel(
        id: '2',
        paymentNumber: 'PR-00020',
        customerName: 'Parthiv Ajith',
        invoiceNumbers: const ['INV-000036', 'INV-000037'],
        paymentDate: DateTime.now().subtract(const Duration(days: 4)),
        mode: PaymentMode.card,
        referenceNumber: 'CARD-4412',
        amount: 3560.50,
        createdAt: DateTime.now().subtract(const Duration(days: 4)),
        updatedAt: DateTime.now().subtract(const Duration(days: 4)),
      ),
      PaymentReceivedModel(
        id: '3',
        paymentNumber: 'PR-00019',
        customerName: 'Aisha Traders',
        invoiceNumbers: const [],
        paymentDate: DateTime.now().subtract(const Duration(days: 40)),
        mode: PaymentMode.cheque,
        referenceNumber: 'CHQ-0087',
        amount: 875.00,
        createdAt: DateTime.now().subtract(const Duration(days: 40)),
        updatedAt: DateTime.now().subtract(const Duration(days: 40)),
      ),
      PaymentReceivedModel(
        id: '4',
        paymentNumber: 'PR-00018',
        customerName: 'Gulf Retail LLC',
        invoiceNumbers: const ['INV-000031'],
        paymentDate: DateTime.now().subtract(const Duration(days: 2)),
        mode: PaymentMode.cash,
        referenceNumber: '',
        amount: 5210.75,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        updatedAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<PaymentReceivedModel> get _visiblePayments {
    final now = DateTime.now();
    final query = _searchController.text.trim().toLowerCase();
    final list = _payments.where((payment) {
      // This Month
      if (_selectedTab == 1 &&
          !(payment.paymentDate.year == now.year &&
              payment.paymentDate.month == now.month)) {
        return false;
      }
      // Unapplied (no invoices linked)
      if (_selectedTab == 2 && payment.invoiceNumbers.isNotEmpty) {
        return false;
      }
      if (_modeFilter != null && payment.mode != _modeFilter) {
        return false;
      }
      return query.isEmpty ||
          payment.customerName.toLowerCase().contains(query) ||
          payment.paymentNumber.toLowerCase().contains(query) ||
          payment.referenceNumber.toLowerCase().contains(query);
    }).toList();

    list.sort((a, b) {
      int result;
      switch (_sortField) {
        case PaymentReceivedSortField.createdTime:
          result = a.createdAt.compareTo(b.createdAt);
        case PaymentReceivedSortField.date:
          result = a.paymentDate.compareTo(b.paymentDate);
        case PaymentReceivedSortField.paymentNumber:
          result = a.paymentNumber.compareTo(b.paymentNumber);
        case PaymentReceivedSortField.customerName:
          result = a.customerName.toLowerCase().compareTo(
            b.customerName.toLowerCase(),
          );
        case PaymentReceivedSortField.amount:
          result = a.amount.compareTo(b.amount);
      }
      return _sortDirection == SortDirection.ascending ? result : -result;
    });

    return list;
  }

  Future<void> _addNewPayment() async {
    final result = await Navigator.push<PaymentReceivedModel>(
      context,
      MaterialPageRoute(builder: (_) => const AddPaymentReceivedPage()),
    );
    if (result != null && mounted) {
      setState(() => _payments.insert(0, result));
      ToastificationHelper.showSuccess(
        context,
        '${result.paymentNumber} created successfully',
      );
    }
  }

  void _openFilterSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PaymentReceivedFilterSheet(
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
      builder: (_) => PaymentReceivedSortSheet(
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
      drawer: const DrawerView(currentRoute: 'payments_received'),
      floatingActionButton: CustomAddButton(onPressed: _addNewPayment),
      body: NestedScrollView(
        physics: const BouncingScrollPhysics(),
        headerSliverBuilder: (context, _) => [
          CustomSliverAppBar(
            title: 'Payments Received',
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
              ListSearchField(
                controller: _searchController,
                hintText: 'Search by customer, payment or reference',
                onChanged: (_) => setState(() {}),
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
                          _tabButton('Unapplied', 2),
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
                              'Tap the + button to record a new payment.',
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
                        itemBuilder: (context, index) => PaymentReceivedTile(
                          payment: visibleList[index],
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PaymentReceivedDetailsPage(
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
