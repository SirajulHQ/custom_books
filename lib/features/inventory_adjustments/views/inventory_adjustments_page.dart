import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/features/drawer/views/custom_drawer.dart';
import 'package:custom_books/features/inventory_adjustments/models/inventory_adjustments_model.dart';
import 'package:custom_books/features/inventory_adjustments/views/add_adjustment_page.dart';
import 'package:custom_books/features/inventory_adjustments/views/adjustment_details_page.dart';
import 'package:custom_books/features/inventory_adjustments/widgets/inventory_adjustments_card_widgets.dart';
import 'package:custom_books/features/inventory_adjustments/widgets/inventory_adjustments_page_widgets.dart';
import 'package:flutter/material.dart';

class InventoryAdjustmentsPage extends StatefulWidget {
  const InventoryAdjustmentsPage({super.key});

  @override
  State<InventoryAdjustmentsPage> createState() =>
      _InventoryAdjustmentsPageState();
}

class _InventoryAdjustmentsPageState extends State<InventoryAdjustmentsPage> {
  int _selectedTab = 0; // 0 All, 1 By Quantity, 2 By Value
  bool _searchOpen = false;
  final _searchController = TextEditingController();

  AdjustmentSortField _sortField = AdjustmentSortField.createdTime;
  SortDirection _sortDirection = SortDirection.descending;

  // TODO: replace with real data from your inventory/bloc/repository layer.
  final List<InventoryAdjustment> _adjustments = [
    InventoryAdjustment(
      id: '1',
      reason: 'Damaged goods',
      date: DateTime(2026, 7, 21),
      createdBy: 'Parthiv P',
      quantityChange: -5,
      value: -1250,
      status: AdjustmentStatus.draft,
      createdAt: DateTime(2026, 7, 21, 10, 53),
      lastModifiedAt: DateTime(2026, 7, 21, 10, 53),
    ),
    InventoryAdjustment(
      id: '2',
      reason: 'Stock count correction',
      date: DateTime(2026, 7, 18),
      createdBy: 'Aarav Menon',
      quantityChange: 12,
      value: 3600,
      status: AdjustmentStatus.completed,
      createdAt: DateTime(2026, 7, 18, 9, 10),
      lastModifiedAt: DateTime(2026, 7, 19, 14, 30),
    ),
    InventoryAdjustment(
      id: '3',
      reason: 'Warehouse transfer shortfall',
      date: DateTime(2026, 7, 12),
      createdBy: 'Own Store',
      quantityChange: -2,
      value: -480,
      status: AdjustmentStatus.completed,
      createdAt: DateTime(2026, 7, 12, 16, 45),
      lastModifiedAt: DateTime(2026, 7, 12, 16, 45),
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<InventoryAdjustment> get _filteredAdjustments {
    var list = _adjustments.where((a) {
      final q = _searchController.text.trim().toLowerCase();
      if (q.isEmpty) return true;
      return a.reason.toLowerCase().contains(q) ||
          a.createdBy.toLowerCase().contains(q);
    }).toList();

    list.sort((a, b) {
      int cmp;
      switch (_sortField) {
        case AdjustmentSortField.date:
          cmp = a.date.compareTo(b.date);
          break;
        case AdjustmentSortField.reason:
          cmp = a.reason.toLowerCase().compareTo(b.reason.toLowerCase());
          break;
        case AdjustmentSortField.createdTime:
          cmp = a.createdAt.compareTo(b.createdAt);
          break;
        case AdjustmentSortField.lastModifiedTime:
          cmp = a.lastModifiedAt.compareTo(b.lastModifiedAt);
          break;
      }
      return _sortDirection == SortDirection.ascending ? cmp : -cmp;
    });

    if (_selectedTab == 1) {
      list.sort(
        (a, b) => b.quantityChange.abs().compareTo(a.quantityChange.abs()),
      );
    } else if (_selectedTab == 2) {
      list.sort((a, b) => b.value.abs().compareTo(a.value.abs()));
    }

    return list;
  }

  AdjustmentListMode get _listMode {
    switch (_selectedTab) {
      case 1:
        return AdjustmentListMode.byQuantity;
      case 2:
        return AdjustmentListMode.byValue;
      default:
        return AdjustmentListMode.all;
    }
  }

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);
    final items = _filteredAdjustments;

    return Scaffold(
      backgroundColor: context.colors.background,
      drawer: const DrawerView(currentRoute: 'inventory_adjustments'),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radius15),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.35),
              blurRadius: Dimensions.radius15 * 1.07,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: FloatingActionButton(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.radius15),
          ),
          onPressed: () async {
            final result = await Navigator.push<InventoryAdjustment>(
              context,
              MaterialPageRoute(
                builder: (context) => const NewAdjustmentPage(),
              ),
            );
            if (result != null) {
              setState(() {
                _adjustments.add(result);
              });
              if (context.mounted) {
                ToastificationHelper.showSuccess(
                  context,
                  'Adjustment "${result.reason}" created',
                );
              }
            }
          },
          child: const Icon(Icons.add_rounded, color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            CustomSliverAppBar(
              title: 'Inventory Adjustments',
              subtitle:
                  '${items.length} adjustment${items.length == 1 ? '' : 's'}',
              leadingType: AppBarLeadingType.menu,
              actions: [
                AppBarIconButton(
                  icon: _searchOpen
                      ? Icons.close_rounded
                      : Icons.search_rounded,
                  color: AppColors.primary,
                  onPressed: () => setState(() {
                    _searchOpen = !_searchOpen;
                    if (!_searchOpen) _searchController.clear();
                  }),
                ),
                SizedBox(width: Dimensions.width10),
                PopupMenuButton<String>(
                  icon: Container(
                    width: Dimensions.height45 * 0.9,
                    height: Dimensions.height45 * 0.9,
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(Dimensions.radius15),
                    ),
                    child: Icon(
                      Icons.more_vert_rounded,
                      size: Dimensions.iconSize24 - 4,
                      color: AppColors.accent,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Dimensions.radius15),
                  ),
                  onSelected: (value) {
                    switch (value) {
                      case 'export':
                        ToastificationHelper.showInfo(
                          context,
                          'Exporting adjustments is coming soon.',
                        );
                        break;
                      case 'print':
                        ToastificationHelper.showInfo(
                          context,
                          'Printing adjustments is coming soon.',
                        );
                        break;
                      case 'refresh':
                        setState(() {});
                        ToastificationHelper.showSuccess(
                          context,
                          'Adjustments refreshed.',
                        );
                        break;
                    }
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(value: 'export', child: Text('Export')),
                    PopupMenuItem(value: 'print', child: Text('Print')),
                    PopupMenuItem(value: 'refresh', child: Text('Refresh')),
                  ],
                ),
                SizedBox(width: Dimensions.width20),
              ],
            ),
            if (_searchOpen)
              SliverToBoxAdapter(
                child: AdjustmentsSearchField(
                  controller: _searchController,
                  onChanged: () => setState(() {}),
                ),
              ),
            SliverToBoxAdapter(
              child: AdjustmentsTabsAndSort(
                selectedTab: _selectedTab,
                onTabChanged: (index) => setState(() => _selectedTab = index),
                sortField: _sortField,
                sortDirection: _sortDirection,
                onSortChanged: (field, direction) {
                  setState(() {
                    _sortField = field;
                    _sortDirection = direction;
                  });
                },
              ),
            ),
            if (items.isEmpty)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: AdjustmentsEmptyState(),
              )
            else
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => InventoryAdjustmentCardWidget(
                      adjustment: items[index],
                      mode: _listMode,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AdjustmentDetailsPage(adjustment: items[index]),
                          ),
                        );
                      },
                    ),
                    childCount: items.length,
                  ),
                ),
              ),
            SliverToBoxAdapter(child: SizedBox(height: Dimensions.height30)),
          ],
        ),
      ),
    );
  }
}
