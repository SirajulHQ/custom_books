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
import 'package:custom_books/features/purchase_orders/models/purchase_order_model.dart';
import 'package:custom_books/features/purchase_orders/views/add_purchase_order_page.dart';
import 'package:custom_books/features/purchase_orders/views/purchase_order_details_page.dart';
import 'package:custom_books/features/purchase_orders/widgets/purchase_order_filter_sheet.dart';
import 'package:custom_books/features/purchase_orders/widgets/purchase_order_sort_sheet.dart';
import 'package:custom_books/features/purchase_orders/widgets/purchase_order_page_widgets.dart';
import 'package:custom_books/core/widgets/more_options_sheet.dart';
import 'package:flutter/material.dart';
import 'package:custom_books/core/enums/sort_direction.dart';

class PurchaseOrdersPage extends StatefulWidget {
  const PurchaseOrdersPage({super.key});

  @override
  State<PurchaseOrdersPage> createState() => _PurchaseOrdersPageState();
}

class _PurchaseOrdersPageState extends State<PurchaseOrdersPage> {
  final TextEditingController _searchController = TextEditingController();

  int _selectedTab = 0; // 0: All, 1: Draft, 2: Issued
  bool _searchOpen = false;
  PurchaseOrderStatus? _statusFilter;
  PurchaseOrderSortField _sortField = PurchaseOrderSortField.createdTime;
  SortDirection _sortDirection = SortDirection.descending;

  late List<PurchaseOrderModel> _orders;

  @override
  void initState() {
    super.initState();
    _orders = [
      PurchaseOrderModel(
        id: '1',
        purchaseOrderNumber: 'PO-00042',
        vendorName: 'Al Futtaim Trading',
        referenceNumber: 'REF-9001',
        orderDate: DateTime(2026, 7, 3),
        expectedDeliveryDate: DateTime(2026, 7, 10),
        status: PurchaseOrderStatus.draft,
        total: 15230.75,
        createdAt: DateTime(2026, 7, 3, 10, 0),
        updatedAt: DateTime(2026, 7, 3, 10, 0),
      ),
      PurchaseOrderModel(
        id: '2',
        purchaseOrderNumber: 'PO-00041',
        vendorName: 'Gulf Office Supplies',
        referenceNumber: 'REF-9000',
        orderDate: DateTime(2026, 7, 2),
        expectedDeliveryDate: DateTime(2026, 7, 6),
        status: PurchaseOrderStatus.issued,
        total: 3420.00,
        createdAt: DateTime(2026, 7, 2, 9, 30),
        updatedAt: DateTime(2026, 7, 2, 9, 30),
      ),
      PurchaseOrderModel(
        id: '3',
        purchaseOrderNumber: 'PO-00040',
        vendorName: 'Desert Tech Solutions',
        orderDate: DateTime(2026, 7, 1),
        expectedDeliveryDate: DateTime(2026, 7, 8),
        status: PurchaseOrderStatus.billed,
        total: 8975.50,
        createdAt: DateTime(2026, 7, 1, 14, 0),
        updatedAt: DateTime(2026, 7, 1, 14, 0),
      ),
      PurchaseOrderModel(
        id: '4',
        purchaseOrderNumber: 'PO-00039',
        vendorName: 'Emirates Logistics',
        orderDate: DateTime(2026, 6, 28),
        status: PurchaseOrderStatus.cancelled,
        total: 1200.00,
        createdAt: DateTime(2026, 6, 28, 11, 15),
        updatedAt: DateTime(2026, 6, 28, 11, 15),
      ),
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<PurchaseOrderModel> get _visibleOrders {
    final query = _searchController.text.trim().toLowerCase();
    final list = _orders.where((order) {
      if (_selectedTab == 1 && order.status != PurchaseOrderStatus.draft) {
        return false;
      }
      if (_selectedTab == 2 && order.status != PurchaseOrderStatus.issued) {
        return false;
      }
      if (_statusFilter != null && order.status != _statusFilter) {
        return false;
      }
      return query.isEmpty ||
          order.vendorName.toLowerCase().contains(query) ||
          order.purchaseOrderNumber.toLowerCase().contains(query) ||
          order.referenceNumber.toLowerCase().contains(query);
    }).toList();

    list.sort((a, b) {
      int result;
      switch (_sortField) {
        case PurchaseOrderSortField.createdTime:
          result = a.createdAt.compareTo(b.createdAt);
        case PurchaseOrderSortField.date:
          result = a.orderDate.compareTo(b.orderDate);
        case PurchaseOrderSortField.purchaseOrderNumber:
          result = a.purchaseOrderNumber.compareTo(b.purchaseOrderNumber);
        case PurchaseOrderSortField.vendorName:
          result = a.vendorName.toLowerCase().compareTo(
            b.vendorName.toLowerCase(),
          );
        case PurchaseOrderSortField.amount:
          result = a.total.compareTo(b.total);
      }
      return _sortDirection == SortDirection.ascending ? result : -result;
    });

    return list;
  }

  Future<void> _addNewPurchaseOrder() async {
    final result = await Navigator.push<PurchaseOrderModel>(
      context,
      MaterialPageRoute(builder: (_) => const AddPurchaseOrderPage()),
    );
    if (result != null && mounted) {
      setState(() => _orders.insert(0, result));
      ToastificationHelper.showSuccess(
        context,
        'Purchase order created successfully',
      );
    }
  }

  void _showMoreOptions() {
    MoreOptionsSheet.show(
      context,
      sectionLabel: 'PURCHASE ORDER ACTIONS',
      items: [
        MoreOptionsItem(
          icon: Icons.file_download_outlined,
          title: 'Export Purchase Orders',
          subtitle: 'Export the current purchase order list',
          onTap: () => ToastificationHelper.showSuccess(
            context,
            'Purchase orders exported',
          ),
        ),
        MoreOptionsItem(
          icon: Icons.refresh_rounded,
          title: 'Refresh',
          subtitle: 'Reload the latest purchase orders',
          onTap: () => setState(() {}),
        ),
      ],
    );
  }

  void _openFilterSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PurchaseOrderFilterSheet(
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
      builder: (_) => PurchaseOrderSortSheet(
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
    final visibleList = _visibleOrders;

    return Scaffold(
      backgroundColor: context.colors.background,
      drawer: const DrawerView(currentRoute: 'purchase_orders'),
      floatingActionButton: CustomAddButton(onPressed: _addNewPurchaseOrder),
      body: NestedScrollView(
        physics: const BouncingScrollPhysics(),
        headerSliverBuilder: (context, _) => [
          CustomSliverAppBar(
            title: 'Purchase Orders',
            subtitle:
                '${_orders.length} purchase order${_orders.length == 1 ? '' : 's'}',
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
                hintText: 'Search by vendor, PO or reference',
                onChanged: (_) => setState(() {}),
              ),
            ListControlBar(
              tabs: const ['All', 'Draft', 'Issued'],
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
                      icon: Icons.assignment_outlined,
                      title: 'No purchase orders found',
                      subtitle:
                          'Tap the + button to create a new purchase order.',
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
                        itemBuilder: (context, index) => PurchaseOrderTile(
                          order: visibleList[index],
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PurchaseOrderDetailsPage(
                                order: visibleList[index],
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
