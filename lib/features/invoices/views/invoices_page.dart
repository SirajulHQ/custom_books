import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/widgets/custom_add_button.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/features/drawer/views/custom_drawer.dart';
import 'package:custom_books/features/invoices/models/invoice_model.dart';
import 'package:custom_books/features/invoices/views/invoice_details_page.dart';
import 'package:custom_books/features/invoices/views/new_invoice_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum _InvoiceSortField {
  createdTime,
  date,
  invoiceNumber,
  customerName,
  amount,
}

extension _InvoiceSortFieldLabel on _InvoiceSortField {
  String get label => switch (this) {
    _InvoiceSortField.createdTime => 'Created Time',
    _InvoiceSortField.date => 'Date',
    _InvoiceSortField.invoiceNumber => 'Invoice#',
    _InvoiceSortField.customerName => 'Customer Name',
    _InvoiceSortField.amount => 'Amount',
  };
}

extension _InvoiceStatusLabel on InvoiceStatus {
  String get label => switch (this) {
    InvoiceStatus.draft => 'DRAFT',
    InvoiceStatus.sent => 'SENT',
    InvoiceStatus.paid => 'PAID',
    InvoiceStatus.partiallyPaid => 'PARTIALLY PAID',
    InvoiceStatus.overdue => 'OVERDUE',
    InvoiceStatus.cancelled => 'CANCELLED',
  };
}

enum _SortDirection { ascending, descending }

class InvoicesPage extends StatefulWidget {
  final int initialTab;

  const InvoicesPage({super.key, this.initialTab = 0});

  @override
  State<InvoicesPage> createState() => _InvoicesPageState();
}

class _InvoicesPageState extends State<InvoicesPage> {
  final TextEditingController _searchController = TextEditingController();

  late int _selectedTab; // 0: All, 1: Draft, 2: Overdue, 3: Paid
  bool _searchOpen = false;
  InvoiceStatus? _statusFilter;
  _InvoiceSortField _sortField = _InvoiceSortField.createdTime;
  _SortDirection _sortDirection = _SortDirection.descending;

  late List<InvoiceModel> _invoices;

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.initialTab;
    _invoices = [
      InvoiceModel(
        id: '1',
        invoiceNumber: 'INV-000039',
        customerId: 'c1',
        customerName: 'Nandhu',
        invoiceDate: DateTime(2026, 7, 3),
        dueDate: DateTime(2026, 7, 3),
        terms: 'Due on Receipt',
        placeOfSupply: 'Dubai',
        subTotal: 1180.00,
        taxAmount: 60.00,
        total: 1240.00,
        status: InvoiceStatus.sent,
        createdAt: DateTime(2026, 7, 3, 10, 0),
      ),
      InvoiceModel(
        id: '2',
        invoiceNumber: 'INV-000038',
        customerId: 'c2',
        customerName: 'Parthiv Ajith',
        invoiceDate: DateTime(2026, 6, 20),
        dueDate: DateTime(2026, 6, 27),
        terms: 'Net 7',
        placeOfSupply: 'Dubai',
        subTotal: 3390.00,
        taxAmount: 170.50,
        total: 3560.50,
        status: InvoiceStatus.overdue,
        createdAt: DateTime(2026, 6, 20, 14, 0),
      ),
      InvoiceModel(
        id: '3',
        invoiceNumber: 'INV-000037',
        customerId: 'c3',
        customerName: 'Aisha Traders',
        invoiceDate: DateTime(2026, 6, 15),
        dueDate: DateTime(2026, 6, 30),
        terms: 'Net 15',
        placeOfSupply: 'Abu Dhabi',
        subTotal: 832.00,
        taxAmount: 43.00,
        total: 875.00,
        status: InvoiceStatus.paid,
        createdAt: DateTime(2026, 6, 15, 9, 30),
      ),
      InvoiceModel(
        id: '4',
        invoiceNumber: 'INV-000036',
        customerId: 'c4',
        customerName: 'Gulf Retail LLC',
        invoiceDate: DateTime(2026, 6, 10),
        dueDate: DateTime(2026, 6, 25),
        terms: 'Net 15',
        placeOfSupply: 'Sharjah',
        subTotal: 4960.00,
        taxAmount: 250.75,
        total: 5210.75,
        status: InvoiceStatus.draft,
        createdAt: DateTime(2026, 6, 10, 16, 45),
      ),
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<InvoiceModel> get _visibleInvoices {
    final query = _searchController.text.trim().toLowerCase();
    final list = _invoices.where((invoice) {
      if (_selectedTab == 1 && invoice.status != InvoiceStatus.draft) {
        return false;
      }
      if (_selectedTab == 2 && invoice.status != InvoiceStatus.overdue) {
        return false;
      }
      if (_selectedTab == 3 && invoice.status != InvoiceStatus.paid) {
        return false;
      }
      if (_statusFilter != null && invoice.status != _statusFilter) {
        return false;
      }
      return query.isEmpty ||
          invoice.customerName.toLowerCase().contains(query) ||
          invoice.invoiceNumber.toLowerCase().contains(query);
    }).toList();

    list.sort((a, b) {
      int result;
      switch (_sortField) {
        case _InvoiceSortField.createdTime:
          result = a.createdAt.compareTo(b.createdAt);
        case _InvoiceSortField.date:
          result = a.invoiceDate.compareTo(b.invoiceDate);
        case _InvoiceSortField.invoiceNumber:
          result = a.invoiceNumber.compareTo(b.invoiceNumber);
        case _InvoiceSortField.customerName:
          result = a.customerName.toLowerCase().compareTo(
            b.customerName.toLowerCase(),
          );
        case _InvoiceSortField.amount:
          result = a.total.compareTo(b.total);
      }
      return _sortDirection == _SortDirection.ascending ? result : -result;
    });

    return list;
  }

  Future<void> _addNewInvoice() async {
    await Navigator.push<void>(
      context,
      MaterialPageRoute(builder: (_) => const NewInvoicePage()),
    );
    if (mounted) setState(() {});
  }

  void _openFilterSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final options = <InvoiceStatus?>[null, ...InvoiceStatus.values];
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
                  width: Dimensions.width20 * 2,
                  height: Dimensions.height10 * 0.4,
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
                        'Filter',
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
                      final status = options[index];
                      final selected = status == _statusFilter;
                      return GestureDetector(
                        onTap: () {
                          setState(() => _statusFilter = status);
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
                                status?.label ?? 'All Statuses',
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
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(Dimensions.radius20 * 1.2),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: Dimensions.width20 * 2,
                    height: Dimensions.height10 * 0.4,
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
                      children: _InvoiceSortField.values.map((f) {
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
                                      direction == _SortDirection.ascending
                                      ? _SortDirection.descending
                                      : _SortDirection.ascending;
                                } else {
                                  field = f;
                                  direction = _SortDirection.descending;
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
                                      direction == _SortDirection.ascending
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
                          side: const BorderSide(
                            color: Appcolors.primary,
                            width: 1.5,
                          ),
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
    final visibleList = _visibleInvoices;

    return Scaffold(
      backgroundColor: context.colors.background,
      drawer: const DrawerView(currentRoute: 'invoices'),

      floatingActionButton: CustomAddButton(onPressed: _addNewInvoice),
      body: NestedScrollView(
        physics: const BouncingScrollPhysics(),
        headerSliverBuilder: (context, _) => [
          CustomSliverAppBar(
            title: 'Invoices',
            subtitle:
                '${_invoices.length} invoice${_invoices.length == 1 ? '' : 's'}',
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
                    hintText: 'Search by customer or invoice number',
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
                          _tabButton('Draft', 1),
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
                                color: Appcolors.primary.withValues(
                                  alpha: 0.08,
                                ),
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
                              'No invoices found',
                              style: TextStyle(
                                fontSize: Dimensions.font16,
                                fontWeight: FontWeight.w700,
                                color: context.colors.textPrimary,
                              ),
                            ),
                            SizedBox(height: Dimensions.height10 / 2),
                            Text(
                              'Tap the + button to create a new invoice.',
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
                            _invoiceTile(visibleList[index]),
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

  Widget _invoiceTile(InvoiceModel invoice) {
    return InkWell(
      borderRadius: BorderRadius.circular(Dimensions.radius15),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => InvoiceDetailsPage(invoice: invoice),
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
                    invoice.customerName,
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
                        DateFormat('dd MMM yyyy').format(invoice.invoiceDate),
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
                          invoice.invoiceNumber,
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
                        'Due ${DateFormat('dd MMM yyyy').format(invoice.dueDate)}',
                        style: TextStyle(
                          fontSize: Dimensions.font16 * 0.68,
                          color: context.colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Dimensions.height10 / 2),
                  _statusChip(invoice.status),
                ],
              ),
            ),
            SizedBox(width: Dimensions.width10),
            Text(
              '₹${invoice.total.toStringAsFixed(2)}',
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

  Widget _statusChip(InvoiceStatus status) {
    final color = switch (status) {
      InvoiceStatus.draft => Colors.grey,
      InvoiceStatus.sent => Appcolors.primaryLight,
      InvoiceStatus.paid => Appcolors.success,
      InvoiceStatus.partiallyPaid => Appcolors.warning,
      InvoiceStatus.overdue => Appcolors.error,
      InvoiceStatus.cancelled => context.colors.textTertiary,
    };
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.width10,
        vertical: Dimensions.height10 * 0.2,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(Dimensions.radius30),
      ),
      child: Text(
        status.label.toUpperCase(),
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
