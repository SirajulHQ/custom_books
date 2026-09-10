import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/date_formatter.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/core/widgets/active_filter_banner.dart';
import 'package:custom_books/core/widgets/custom_add_button.dart';
import 'package:custom_books/core/widgets/custom_search_field.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/core/widgets/document_list_tile.dart';
import 'package:custom_books/core/widgets/empty_state_widget.dart';
import 'package:custom_books/core/widgets/filter_sheet.dart';
import 'package:custom_books/core/widgets/generic_sort_sheet.dart';
import 'package:custom_books/core/widgets/list_control_bar.dart';
import 'package:custom_books/core/widgets/status_chip.dart';
import 'package:custom_books/features/drawer/views/custom_drawer.dart';
import 'package:custom_books/features/sales_orders/models/sales_order_model.dart';
import 'package:custom_books/features/sales_orders/views/add_sales_order_page.dart';
import 'package:custom_books/features/sales_orders/views/sales_order_details_page.dart';
import 'package:custom_books/features/sales_orders/widgets/sales_order_actions_sheet.dart';
import 'package:custom_books/core/widgets/more_options_sheet.dart';
import 'package:flutter/material.dart';
import 'package:custom_books/core/enums/sort_direction.dart';

class SalesOrdersPage extends StatefulWidget {
  const SalesOrdersPage({super.key});

  @override
  State<SalesOrdersPage> createState() => _SalesOrdersPageState();
}

class _SalesOrdersPageState extends State<SalesOrdersPage> {
  final TextEditingController _searchController = TextEditingController();

  int _selectedTab = 0; // 0: All, 1: Draft, 2: Confirmed
  bool _searchOpen = false;
  SalesOrderStatus? _statusFilter;
  SalesOrderSortField _sortField = SalesOrderSortField.createdTime;
  SortDirection _sortDirection = SortDirection.descending;

  // Mock sales order list matching Image 1
  late List<SalesOrderModel> _orders;

  @override
  void initState() {
    super.initState();
    _orders = [
      SalesOrderModel(
        id: '1',
        salesOrderNumber: 'SO-00309',
        customerName: 'Nandhu',
        salesOrderDate: DateTime(2026, 7, 3),
        lineItems: const [
          SalesOrderLineItem(
            id: 'l1',
            itemName: 'Item 1',
            quantity: 1,
            rate: 124,
          ),
        ],
        status: SalesOrderStatus.draft,
        isInvoiced: false,
        createdAt: DateTime(2026, 7, 3, 10, 0),
        updatedAt: DateTime(2026, 7, 3, 10, 0),
      ),
      SalesOrderModel(
        id: '2',
        salesOrderNumber: 'SO-00303',
        customerName: 'Nandhu',
        salesOrderDate: DateTime(2026, 7, 3),
        lineItems: const [
          SalesOrderLineItem(
            id: 'l2',
            itemName: 'Item 2',
            quantity: 1,
            rate: 103,
          ),
        ],
        status: SalesOrderStatus.draft,
        isInvoiced: false,
        createdAt: DateTime(2026, 7, 3, 9, 30),
        updatedAt: DateTime(2026, 7, 3, 9, 30),
      ),
      SalesOrderModel(
        id: '3',
        salesOrderNumber: 'SO-00301',
        customerName: 'Parthiv Ajith',
        salesOrderDate: DateTime(2026, 7, 2),
        lineItems: const [
          SalesOrderLineItem(
            id: 'l3',
            itemName: 'Item 3',
            quantity: 1,
            rate: 1071,
          ),
        ],
        status: SalesOrderStatus.draft,
        isInvoiced: false,
        createdAt: DateTime(2026, 7, 2, 14, 0),
        updatedAt: DateTime(2026, 7, 2, 14, 0),
      ),
      SalesOrderModel(
        id: '4',
        salesOrderNumber: 'SO-00287',
        customerName: 'Nandhu',
        salesOrderDate: DateTime(2026, 7, 1),
        lineItems: const [
          SalesOrderLineItem(
            id: 'l4',
            itemName: 'Item 4',
            quantity: 1,
            rate: 166,
          ),
        ],
        status: SalesOrderStatus.draft,
        isInvoiced: false,
        createdAt: DateTime(2026, 7, 1, 11, 15),
        updatedAt: DateTime(2026, 7, 1, 11, 15),
      ),
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<SalesOrderModel> get _visibleOrders {
    final query = _searchController.text.trim().toLowerCase();
    final list = _orders.where((order) {
      if (_selectedTab == 1 && order.status != SalesOrderStatus.draft) {
        return false;
      }
      if (_selectedTab == 2 && order.status != SalesOrderStatus.confirmed) {
        return false;
      }
      if (_statusFilter != null && order.status != _statusFilter) {
        return false;
      }
      return query.isEmpty ||
          order.customerName.toLowerCase().contains(query) ||
          order.salesOrderNumber.toLowerCase().contains(query) ||
          order.referenceNumber.toLowerCase().contains(query);
    }).toList();

    list.sort((a, b) {
      int result;
      switch (_sortField) {
        case SalesOrderSortField.createdTime:
          result = a.createdAt.compareTo(b.createdAt);
        case SalesOrderSortField.date:
          result = a.salesOrderDate.compareTo(b.salesOrderDate);
        case SalesOrderSortField.salesOrderNumber:
          result = a.salesOrderNumber.compareTo(b.salesOrderNumber);
        case SalesOrderSortField.referenceNumber:
          result = a.referenceNumber.compareTo(b.referenceNumber);
        case SalesOrderSortField.customerName:
          result = a.customerName.toLowerCase().compareTo(
            b.customerName.toLowerCase(),
          );
        case SalesOrderSortField.amount:
          result = a.total.compareTo(b.total);
      }
      return _sortDirection == SortDirection.ascending ? result : -result;
    });

    return list;
  }

  Future<void> _addNewSalesOrder() async {
    final newOrder = await Navigator.push<SalesOrderModel>(
      context,
      MaterialPageRoute(
        builder: (_) => AddSalesOrderPage(orderSequence: _orders.length + 310),
      ),
    );

    if (newOrder != null && mounted) {
      setState(() {
        _orders.insert(0, newOrder);
        if (newOrder.status == SalesOrderStatus.draft) {
          _selectedTab = 1;
        } else if (newOrder.status == SalesOrderStatus.confirmed) {
          _selectedTab = 2;
        } else {
          _selectedTab = 0;
        }
      });
      ToastificationHelper.showSuccess(
        context,
        '${newOrder.salesOrderNumber} created successfully',
      );
    }
  }

  void _showMoreOptions() {
    MoreOptionsSheet.show(
      context,
      sectionLabel: 'SALES ORDER ACTIONS',
      items: [
        MoreOptionsItem(
          icon: Icons.file_download_outlined,
          title: 'Export Sales Orders',
          subtitle: 'Export the current sales order list',
          onTap: () => ToastificationHelper.showSuccess(
            context,
            'Sales orders exported',
          ),
        ),
        MoreOptionsItem(
          icon: Icons.refresh_rounded,
          title: 'Refresh',
          subtitle: 'Reload the latest sales orders',
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
      builder: (context) => FilterSheet<SalesOrderStatus>(
        title: 'Filter',
        showHeaderBorder: true,
        sectionLabel: 'DEFAULT FILTERS',
        options: const [null, ...SalesOrderStatus.values],
        selectedValue: _statusFilter,
        labelBuilder: (status) => status?.label ?? 'All Statuses',
        onSelected: (status) {
          setState(() => _statusFilter = status);
          Navigator.pop(context);
        },
        onClose: () => Navigator.pop(context),
      ),
    );
  }

  void _openSortSheet() {
    GenericSortSheet.show<SalesOrderSortField>(
      context,
      fields: SalesOrderSortField.values,
      initialField: _sortField,
      initialDirection: _sortDirection,
      labelBuilder: (f) => f.label,
      onApply: (field, direction) {
        setState(() {
          _sortField = field;
          _sortDirection = direction;
        });
      },
      showInfoBanner: true,
    );
  }

  void _openOrderActions(SalesOrderModel order) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.colors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Dimensions.radius20),
        ),
      ),
      builder: (context) => SalesOrderActionsSheet(
        order: order,
        onStatusChanged: (newStatus) {
          setState(() {
            final idx = _orders.indexWhere((o) => o.id == order.id);
            if (idx != -1) {
              _orders[idx] = _orders[idx].copyWith(
                status: newStatus,
                isInvoiced: newStatus == SalesOrderStatus.invoiced,
              );
            }
          });
          ToastificationHelper.showSuccess(
            context,
            'Status updated to ${newStatus.label}',
          );
        },
        onDelete: () => _deleteOrder(order),
      ),
    );
  }

  void _changeOrderStatus(SalesOrderModel order, SalesOrderStatus newStatus) {
    setState(() {
      final idx = _orders.indexWhere((o) => o.id == order.id);
      if (idx != -1) {
        _orders[idx] = _orders[idx].copyWith(
          status: newStatus,
          isInvoiced: newStatus == SalesOrderStatus.invoiced,
        );
      }
    });
    ToastificationHelper.showSuccess(
      context,
      'Status updated to ${newStatus.label}',
    );
  }

  void _deleteOrder(SalesOrderModel order) {
    setState(() {
      _orders.removeWhere((o) => o.id == order.id);
    });
    ToastificationHelper.showSuccess(context, 'Sales Order deleted');
  }

  void _openOrderDetails(SalesOrderModel order) {
    Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => SalesOrderDetailsPage(
          order: order,
          onStatusChanged: (newStatus) => _changeOrderStatus(order, newStatus),
          onDelete: () => _deleteOrder(order),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final visibleList = _visibleOrders;

    return Scaffold(
      backgroundColor: context.colors.background,
      drawer: const DrawerView(currentRoute: 'sales_orders'),
      floatingActionButton: CustomAddButton(onPressed: _addNewSalesOrder),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          CustomSliverAppBar(
            title: 'Sales Orders',
            subtitle:
                '${_orders.length} sales order${_orders.length == 1 ? '' : 's'}',
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
          SliverToBoxAdapter(
            child: Column(
              children: [
                // Search Field Bar
                if (_searchOpen)
                  ListSearchField(
                    controller: _searchController,
                    hintText: 'Search by customer, sales order or reference',
                    onChanged: (_) => setState(() {}),
                  ),

                // Filter Segment Control Bar (matching app design)
                ListControlBar(
                  tabs: const ['All', 'Draft', 'Confirmed'],
                  selectedTab: _selectedTab,
                  onTabSelected: (index) => setState(() {
                    _selectedTab = index;
                    _statusFilter = null;
                  }),
                  filterActive: _statusFilter != null,
                  onFilterTap: _openFilterSheet,
                  onSortTap: _openSortSheet,
                ),

                // Active Status Filter Banner
                if (_statusFilter != null)
                  ActiveFilterBanner(
                    label: 'Status: ${_statusFilter!.label}',
                    onClear: () => setState(() => _statusFilter = null),
                  ),

                // Sales Orders List
                Expanded(
                  child: visibleList.isEmpty
                      ? const EmptyStateWidget(
                          icon: Icons.shopping_bag_outlined,
                          title: 'No sales orders found',
                          subtitle:
                              'Tap the + button to create a new sales order.',
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
                            itemBuilder: (context, index) => DocumentListTile(
                              leadingIcon: Icons.shopping_bag_outlined,
                              leadingColor: AppColors.primary,
                              primaryText: visibleList[index].customerName,
                              date: formatDate(
                                visibleList[index].salesOrderDate,
                              ),
                              documentNumber:
                                  visibleList[index].salesOrderNumber,
                              statusWidget: StatusChip(
                                color: visibleList[index].status.color,
                                label: visibleList[index].status.label,
                              ),
                              trailingBadge: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: Dimensions.width10 * 0.7,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: context.colors.surfaceLight,
                                  borderRadius: BorderRadius.circular(
                                    Dimensions.radius30,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: Dimensions.width10 * 0.6,
                                      height: Dimensions.height10 * 0.6,
                                      decoration: BoxDecoration(
                                        color: visibleList[index].isInvoiced
                                            ? AppColors.success
                                            : context.colors.textTertiary,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    SizedBox(width: Dimensions.width10 / 3),
                                    Text(
                                      visibleList[index].isInvoiced
                                          ? 'Invoiced'
                                          : 'Not Invoiced',
                                      style: TextStyle(
                                        fontSize: Dimensions.font16 * 0.6,
                                        color: context.colors.textSecondary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              amount:
                                  '₹${visibleList[index].total.toStringAsFixed(2)}',
                              onTap: () =>
                                  _openOrderDetails(visibleList[index]),
                              onLongPress: () =>
                                  _openOrderActions(visibleList[index]),
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
