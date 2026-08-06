import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/features/drawer/views/custom_drawer.dart';
import 'package:custom_books/features/payments_received/models/payment_received_model.dart';
import 'package:custom_books/features/payments_received/views/add_payment_received_page.dart';
import 'package:custom_books/features/payments_received/views/payment_received_details_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
      builder: (context) {
        final options = <PaymentMode?>[null, ...PaymentMode.values];
        return SafeArea(
          top: false,
          child: Container(
            decoration: BoxDecoration(
              color: context.colors.card,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(Dimensions.radius20),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: EdgeInsets.symmetric(vertical: Dimensions.height10),
                  decoration: BoxDecoration(
                    color: context.colors.border,
                    borderRadius: BorderRadius.circular(Dimensions.radius30),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.width20,
                    vertical: Dimensions.height10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Filter by mode',
                        style: TextStyle(
                          fontSize: Dimensions.font20,
                          fontWeight: FontWeight.bold,
                          color: context.colors.textPrimary,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(
                          Icons.close_rounded,
                          size: Dimensions.iconSize24,
                          color: context.colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(
                      Dimensions.width20,
                      Dimensions.height10,
                      Dimensions.width20,
                      Dimensions.height20,
                    ),
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      final mode = options[index];
                      final selected = mode == _modeFilter;
                      return GestureDetector(
                        onTap: () {
                          setState(() => _modeFilter = mode);
                          Navigator.pop(context);
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: Dimensions.height10),
                          padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.width15,
                            vertical: Dimensions.height15,
                          ),
                          decoration: BoxDecoration(
                            color: selected
                                ? Appcolors.primary.withValues(alpha: 0.05)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(
                              Dimensions.radius15,
                            ),
                            border: Border.all(
                              color: selected
                                  ? Appcolors.primary
                                  : context.colors.border,
                              width: selected ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                mode?.label ?? 'All Modes',
                                style: TextStyle(
                                  fontSize: Dimensions.font16,
                                  fontWeight: selected
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                                  color: selected
                                      ? Appcolors.primary
                                      : context.colors.textPrimary,
                                ),
                              ),
                              if (selected)
                                Icon(
                                  Icons.check_circle_rounded,
                                  color: Appcolors.primary,
                                  size: Dimensions.iconSize24,
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openSortSheet() {
    var field = _sortField;
    var direction = _sortDirection;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              decoration: BoxDecoration(
                color: context.colors.card,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    margin: EdgeInsets.symmetric(vertical: Dimensions.height10),
                    decoration: BoxDecoration(
                      color: context.colors.border,
                      borderRadius: BorderRadius.circular(Dimensions.radius30),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.width20,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Sort by',
                          style: TextStyle(
                            fontSize: Dimensions.font20,
                            fontWeight: FontWeight.w800,
                            color: context.colors.textPrimary,
                          ),
                        ),
                        InkWell(
                          borderRadius: BorderRadius.circular(
                            Dimensions.radius15,
                          ),
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: EdgeInsets.all(Dimensions.width10 * 0.6),
                            decoration: BoxDecoration(
                              color: Appcolors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(
                                Dimensions.radius15,
                              ),
                            ),
                            child: Icon(
                              Icons.close_rounded,
                              size: Dimensions.iconSize16,
                              color: Appcolors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: Dimensions.height15),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.width20,
                    ),
                    child: Column(
                      children: PaymentReceivedSortField.values.map((f) {
                        final selected = f == field;
                        return Padding(
                          padding: EdgeInsets.only(bottom: Dimensions.height10),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(
                              Dimensions.radius15,
                            ),
                            onTap: () {
                              setSheetState(() {
                                if (field == f) {
                                  direction =
                                      direction == SortDirection.ascending
                                      ? SortDirection.descending
                                      : SortDirection.ascending;
                                } else {
                                  field = f;
                                  direction = SortDirection.descending;
                                }
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: Dimensions.width15,
                                vertical: Dimensions.height15 * 0.75,
                              ),
                              decoration: BoxDecoration(
                                color: selected
                                    ? Appcolors.primary.withValues(alpha: 0.06)
                                    : context.colors.card,
                                borderRadius: BorderRadius.circular(
                                  Dimensions.radius15,
                                ),
                                border: Border.all(
                                  color: selected
                                      ? Appcolors.primary
                                      : context.colors.border,
                                  width: selected ? 1.5 : 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    selected
                                        ? Icons.radio_button_checked_rounded
                                        : Icons.radio_button_off_rounded,
                                    size: Dimensions.iconSize24 - 4,
                                    color: selected
                                        ? Appcolors.primary
                                        : context.colors.textTertiary,
                                  ),
                                  SizedBox(width: Dimensions.width10),
                                  Expanded(
                                    child: Text(
                                      f.label,
                                      style: TextStyle(
                                        fontSize: Dimensions.font16 * 0.9,
                                        fontWeight: selected
                                            ? FontWeight.w700
                                            : FontWeight.w500,
                                        color: context.colors.textPrimary,
                                      ),
                                    ),
                                  ),
                                  if (selected)
                                    Icon(
                                      direction == SortDirection.ascending
                                          ? Icons.arrow_upward_rounded
                                          : Icons.arrow_downward_rounded,
                                      size: Dimensions.iconSize16,
                                      color: Appcolors.primary,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: Dimensions.height15),
                  Container(
                    padding: EdgeInsets.fromLTRB(
                      Dimensions.width20,
                      Dimensions.height15,
                      Dimensions.width20,
                      Dimensions.height20,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: context.colors.border),
                      ),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _sortField = field;
                            _sortDirection = direction;
                          });
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Appcolors.primary,
                          side: const BorderSide(color: Appcolors.primary, width: 1.5),
                          backgroundColor: Colors.transparent,
                          padding: EdgeInsets.symmetric(
                            vertical: Dimensions.height15 * 0.9,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              Dimensions.radius15,
                            ),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Sort',
                          style: TextStyle(
                            fontSize: Dimensions.font16 * 0.9,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);
    final visibleList = _visiblePayments;

    return Scaffold(
      backgroundColor: context.colors.background,
      drawer: const DrawerView(currentRoute: 'payments_received'),
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
          onPressed: _addNewPayment,
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
            title: 'Payments Received',
            subtitle: '${_payments.length} payment${_payments.length == 1 ? '' : 's'}',
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
                  hintText: 'Search by customer, payment or reference',
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
                    'Mode: ${_modeFilter!.label}',
                    style: TextStyle(
                      fontSize: Dimensions.font16 * 0.72,
                      fontWeight: FontWeight.w600,
                      color: Appcolors.primary,
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () => setState(() => _modeFilter = null),
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
                              Icons.payments_outlined,
                              size: Dimensions.iconSize24 * 1.3,
                              color: Appcolors.primary,
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
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.width20,
                      ),
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      itemCount: visibleList.length,
                      itemBuilder: (context, index) =>
                          _paymentTile(visibleList[index]),
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
              fontSize: Dimensions.font16 * 0.72,
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

  Widget _paymentTile(PaymentReceivedModel payment) {
    return InkWell(
      borderRadius: BorderRadius.circular(Dimensions.radius15),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentReceivedDetailsPage(payment: payment),
        ),
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
                color: Appcolors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(Dimensions.radius15 - 4),
              ),
              child: Icon(
                Icons.payments_outlined,
                color: Appcolors.success,
                size: Dimensions.iconSize24 - 4,
              ),
            ),
            SizedBox(width: Dimensions.width15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    payment.customerName,
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
                        DateFormat('dd MMM yyyy').format(payment.paymentDate),
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
                          payment.paymentNumber,
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
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.width10,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Appcolors.primaryLight.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(Dimensions.radius30),
                    ),
                    child: Text(
                      payment.mode.label,
                      style: TextStyle(
                        fontSize: Dimensions.font16 * 0.6,
                        color: Appcolors.primaryLight,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: Dimensions.width10),
            Text(
              'AED ${payment.amount.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.9,
                fontWeight: FontWeight.w800,
                color: Appcolors.success,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
