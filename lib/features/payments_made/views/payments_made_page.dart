import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/core/widgets/active_filter_banner.dart';
import 'package:custom_books/core/widgets/custom_add_button.dart';
import 'package:custom_books/core/widgets/custom_search_field.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/core/widgets/empty_state_widget.dart';
import 'package:custom_books/core/widgets/list_control_bar.dart';
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
              ListSearchField(
                controller: _searchController,
                hintText: 'Search by vendor, payment or reference',
                onChanged: (_) => setState(() {}),
              ),
            ListControlBar(
              tabs: const ['All', 'This Month'],
              selectedTab: _selectedTab,
              onTabSelected: (i) => setState(() {
                _selectedTab = i;
                _modeFilter = null;
              }),
              filterActive: _modeFilter != null,
              onFilterTap: _openFilterSheet,
              onSortTap: _openSortSheet,
            ),
            if (_modeFilter != null)
              ActiveFilterBanner(
                label: 'Mode: ${_modeFilter!.label}',
                onClear: () => setState(() => _modeFilter = null),
              ),
            Expanded(
              child: visibleList.isEmpty
                  ? const EmptyStateWidget(
                      icon: Icons.payments_outlined,
                      title: 'No payments found',
                      subtitle: 'Tap the + button to record a payment made.',
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

}
