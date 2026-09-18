import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/widgets/active_filter_banner.dart';
import 'package:custom_books/core/widgets/custom_add_button.dart';
import 'package:custom_books/core/widgets/custom_search_field.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/core/widgets/empty_state_widget.dart';
import 'package:custom_books/core/widgets/list_control_bar.dart';
import 'package:custom_books/core/widgets/skeletons/skeletons.dart';
import 'package:custom_books/features/drawer/views/custom_drawer.dart';
import 'package:custom_books/features/invoices/models/invoice_model.dart';
import 'package:custom_books/features/invoices/views/new_invoice_page.dart';
import 'package:custom_books/features/invoices/widgets/invoices_page_widgets/invoice_filter_sheet.dart';
import 'package:custom_books/features/invoices/widgets/invoices_page_widgets/invoice_list_item.dart';
import 'package:custom_books/features/invoices/widgets/invoices_page_widgets/invoice_sort_sheet.dart';
import 'package:custom_books/core/widgets/more_options_sheet.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:flutter/material.dart';
import 'package:custom_books/core/enums/sort_direction.dart';

class InvoicesPage extends StatefulWidget {
  final int initialTab;

  const InvoicesPage({super.key, this.initialTab = 0});

  @override
  State<InvoicesPage> createState() => _InvoicesPageState();
}

class _InvoicesPageState extends State<InvoicesPage> {
  final TextEditingController _searchController = TextEditingController();

  late int _selectedTab;
  bool _searchOpen = false;
  bool _isLoading = true;
  InvoiceStatus? _statusFilter;
  InvoiceSortField _sortField = InvoiceSortField.createdTime;
  SortDirection _sortDirection = SortDirection.descending;

  late List<InvoiceModel> _invoices;

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.initialTab;
    _loadInvoices();
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

  /// Simulates fetching invoices so the shimmer skeleton is shown briefly.
  Future<void> _loadInvoices() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _isLoading = false);
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
        case InvoiceSortField.createdTime:
          result = a.createdAt.compareTo(b.createdAt);
        case InvoiceSortField.date:
          result = a.invoiceDate.compareTo(b.invoiceDate);
        case InvoiceSortField.invoiceNumber:
          result = a.invoiceNumber.compareTo(b.invoiceNumber);
        case InvoiceSortField.customerName:
          result = a.customerName.toLowerCase().compareTo(
            b.customerName.toLowerCase(),
          );
        case InvoiceSortField.amount:
          result = a.total.compareTo(b.total);
      }
      return _sortDirection == SortDirection.ascending ? result : -result;
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

  void _showMoreOptions() {
    MoreOptionsSheet.show(
      context,
      sectionLabel: 'INVOICE ACTIONS',
      items: [
        MoreOptionsItem(
          icon: Icons.file_download_outlined,
          title: 'Export Invoices',
          subtitle: 'Export the current invoice list',
          onTap: () =>
              ToastificationHelper.showSuccess(context, 'Invoices exported'),
        ),
        MoreOptionsItem(
          icon: Icons.notifications_outlined,
          title: 'Send Payment Reminders',
          subtitle: 'Send reminders for overdue invoices',
          onTap: () => ToastificationHelper.showInfo(
            context,
            'Payment reminders is coming soon.',
          ),
        ),
        MoreOptionsItem(
          icon: Icons.refresh_rounded,
          title: 'Refresh',
          subtitle: 'Reload the latest invoices',
          onTap: () => setState(() {}),
        ),
      ],
    );
  }

  void _openFilterSheet() {
    InvoiceFilterSheet.show(
      context,
      selectedStatus: _statusFilter,
      onSelected: (status) => setState(() => _statusFilter = status),
    );
  }

  void _openSortSheet() {
    InvoiceSortSheet.show(
      context,
      initialField: _sortField,
      initialDirection: _sortDirection,
      onApply: (field, direction) {
        setState(() {
          _sortField = field;
          _sortDirection = direction;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
                hintText: 'Search by customer or invoice number',
                onChanged: (_) => setState(() {}),
              ),
            ListControlBar(
              tabs: const ['All', 'Draft', 'Overdue', 'Paid'],
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
              child: _isLoading
                  ? const DocumentListSkeleton(showSubDate: true)
                  : visibleList.isEmpty
                  ? const EmptyStateWidget(
                      icon: Icons.description_outlined,
                      title: 'No invoices found',
                      subtitle: 'Tap the + button to create a new invoice.',
                    )
                  : RefreshIndicator(
                      onRefresh: _loadInvoices,
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
                        itemBuilder: (context, index) {
                          final invoice = visibleList[index];
                          return InvoiceListItem(invoice: invoice);
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
