import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/core/widgets/custom_add_button.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/core/widgets/status_chip.dart';
import 'package:custom_books/features/drawer/views/custom_drawer.dart';
import 'package:custom_books/features/sales_orders/models/sales_order_model.dart';
import 'package:custom_books/features/sales_orders/views/add_sales_order_page.dart';
import 'package:custom_books/features/sales_orders/widgets/sales_order_actions_sheet.dart';
import 'package:custom_books/features/sales_orders/widgets/sales_order_filter_sheet.dart';
import 'package:custom_books/features/sales_orders/widgets/sales_order_sort_sheet.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  void _openFilterSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SalesOrderFilterSheet(
        selectedStatus: _statusFilter,
        onSelected: (status) {
          setState(() => _statusFilter = status);
          Navigator.pop(context);
        },
        onClose: () => Navigator.pop(context),
      ),
    );
  }

  void _openSortSheet() {
    showSalesOrderSortSheet(
      context,
      selectedField: _sortField,
      selectedDirection: _sortDirection,
      onApply: (field, direction) {
        setState(() {
          _sortField = field;
          _sortDirection = direction;
        });
      },
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
        onDelete: () {
          setState(() {
            _orders.removeWhere((o) => o.id == order.id);
          });
          ToastificationHelper.showSuccess(context, 'Sales Order deleted');
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);
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
                color: Appcolors.accent,
                onPressed: _openFilterSheet,
              ),
              SizedBox(width: Dimensions.width20),
            ],
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                // Search Field Bar
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
                        hintText:
                            'Search by customer, sales order or reference',
                        hintStyle: TextStyle(
                          color: context.colors.textTertiary,
                        ),
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
                          borderRadius: BorderRadius.circular(
                            Dimensions.radius15,
                          ),
                          borderSide: BorderSide(color: context.colors.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            Dimensions.radius15,
                          ),
                          borderSide: BorderSide(color: context.colors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            Dimensions.radius15,
                          ),
                          borderSide: const BorderSide(
                            color: Appcolors.primary,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),

                // Filter Segment Control Bar (matching app design)
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
                              _tabButton('Confirmed', 2),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: Dimensions.width10),
                      InkWell(
                        borderRadius: BorderRadius.circular(
                          Dimensions.radius15,
                        ),
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
                        borderRadius: BorderRadius.circular(
                          Dimensions.radius15,
                        ),
                        onTap: _openSortSheet,
                        child: _controlBadge(Icons.swap_vert_rounded),
                      ),
                    ],
                  ),
                ),

                // Active Status Filter Banner
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

                // Sales Orders List
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
                                    Icons.shopping_bag_outlined,
                                    size: Dimensions.iconSize24 * 1.3,
                                    color: Appcolors.primary,
                                  ),
                                ),
                                SizedBox(height: Dimensions.height15),
                                Text(
                                  'No sales orders found',
                                  style: TextStyle(
                                    fontSize: Dimensions.font16,
                                    fontWeight: FontWeight.w700,
                                    color: context.colors.textPrimary,
                                  ),
                                ),
                                SizedBox(height: Dimensions.height10 / 2),
                                Text(
                                  'Tap the + button to create a new sales order.',
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
                                _salesOrderTile(visibleList[index]),
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

  Widget _salesOrderTile(SalesOrderModel order) {
    return InkWell(
      borderRadius: BorderRadius.circular(Dimensions.radius15),
      onTap: () => _openOrderActions(order),
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
                Icons.shopping_bag_outlined,
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
                    order.customerName,
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
                        DateFormat('dd MMM yyyy').format(order.salesOrderDate),
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
                          order.salesOrderNumber,
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
                      StatusChip(
                        color: order.status.color,
                        label: order.status.label,
                      ),
                      SizedBox(width: Dimensions.width10 / 2),
                      Container(
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
                                color: order.isInvoiced
                                    ? Appcolors.success
                                    : context.colors.textTertiary,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: Dimensions.width10 / 3),
                            Text(
                              order.isInvoiced ? 'Invoiced' : 'Invoiced',
                              style: TextStyle(
                                fontSize: Dimensions.font16 * 0.6,
                                color: context.colors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: Dimensions.width10),
            Text(
              '₹${order.total.toStringAsFixed(2)}',
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
}
