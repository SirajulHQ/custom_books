import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/features/drawer/view/custom_drawer.dart';
import 'package:custom_books/features/inventory_adjustments/model/inventory_adjustments_model.dart';
import 'package:custom_books/features/inventory_adjustments/view/add_adjustment_page.dart';
import 'package:custom_books/features/inventory_adjustments/widgets/inventory_adjustments_card_widgets.dart';
import 'package:custom_books/features/inventory_adjustments/widgets/sort_by_sheet_widget.dart';
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
      backgroundColor: Appcolors.background,
      drawer: const DrawerView(currentRoute: 'inventory_adjustments'),
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
          backgroundColor: Appcolors.primary,
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
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Adjustment "${result.reason}" created'),
                    backgroundColor: Colors.green.shade600,
                  ),
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
            SliverAppBar(
              pinned: true,
              backgroundColor: Appcolors.background,
              surfaceTintColor: Appcolors.background,
              elevation: 0,
              toolbarHeight: Dimensions.height45 * 1.6,
              titleSpacing: Dimensions.width20,
              leading: Builder(
                builder: (context) => IconButton(
                  icon: Container(
                    width: Dimensions.height45 * 0.9,
                    height: Dimensions.height45 * 0.9,
                    decoration: BoxDecoration(
                      color: Appcolors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(Dimensions.radius15),
                    ),
                    child: Icon(
                      Icons.menu_rounded,
                      size: Dimensions.iconSize24 - 4,
                      color: Appcolors.primary,
                    ),
                  ),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Inventory Adjustments',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: Dimensions.font26 * 0.7,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  Text(
                    '${items.length} adjustment${items.length == 1 ? '' : 's'}',
                    style: TextStyle(
                      fontSize: Dimensions.font16 * 0.7,
                      color: Colors.black45,
                    ),
                  ),
                ],
              ),
              actions: [
                _iconBadge(
                  _searchOpen ? Icons.close_rounded : Icons.search_rounded,
                  Appcolors.primary,
                  onTap: () => setState(() {
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
                      color: Appcolors.accent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(Dimensions.radius15),
                    ),
                    child: Icon(
                      Icons.more_vert_rounded,
                      size: Dimensions.iconSize24 - 4,
                      color: Appcolors.accent,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Dimensions.radius15),
                  ),
                  onSelected: (_) {},
                  itemBuilder: (context) => const [
                    PopupMenuItem(value: 'export', child: Text('Export')),
                    PopupMenuItem(value: 'print', child: Text('Print')),
                    PopupMenuItem(value: 'refresh', child: Text('Refresh')),
                  ],
                ),
                SizedBox(width: Dimensions.width20),
              ],
            ),
            if (_searchOpen) SliverToBoxAdapter(child: _buildSearchField()),
            SliverToBoxAdapter(child: _buildTabsAndSort()),
            if (items.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: _buildEmptyState(),
              )
            else
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => InventoryAdjustmentCardWidget(
                      adjustment: items[index],
                      mode: _listMode,
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

  Widget _buildSearchField() {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        Dimensions.width20,
        0,
        Dimensions.width20,
        Dimensions.height15,
      ),
      child: TextField(
        controller: _searchController,
        autofocus: true,
        onChanged: (_) => setState(() {}),
        style: TextStyle(fontSize: Dimensions.font16 * 0.85),
        decoration: InputDecoration(
          hintText: 'Search by reason or person',
          hintStyle: const TextStyle(color: Colors.black26),
          prefixIcon: const Icon(Icons.search_rounded, color: Colors.black38),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(vertical: Dimensions.height10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Dimensions.radius15),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Dimensions.radius15),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Dimensions.radius15),
            borderSide: BorderSide(color: Appcolors.primary, width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _buildTabsAndSort() {
    final segments = ['All', 'By Quantity', 'By Value'];
    return Padding(
      padding: EdgeInsets.fromLTRB(
        Dimensions.width20,
        0,
        Dimensions.width20,
        Dimensions.height15,
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(Dimensions.radius15),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: List.generate(segments.length, (i) {
                  final selected = i == _selectedTab;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedTab = i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: EdgeInsets.symmetric(
                          vertical: Dimensions.height10,
                        ),
                        decoration: BoxDecoration(
                          color: selected
                              ? Appcolors.primary
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(
                            Dimensions.radius15 - 5,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          segments[i],
                          style: TextStyle(
                            fontSize: Dimensions.font16 * 0.72,
                            fontWeight: selected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: selected ? Colors.white : Colors.black54,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          SizedBox(width: Dimensions.width10),
          _iconBadge(
            Icons.swap_vert_rounded,
            Appcolors.primary,
            onTap: () {
              showSortBySheet(
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
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
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
                Icons.inventory_2_rounded,
                size: Dimensions.iconSize24 * 1.3,
                color: Appcolors.primary,
              ),
            ),
            SizedBox(height: Dimensions.height15),
            Text(
              'No adjustments found',
              style: TextStyle(
                fontSize: Dimensions.font16,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0F172A),
              ),
            ),
            SizedBox(height: Dimensions.height10 / 2),
            Text(
              'Tap the + button to record a stock adjustment.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.75,
                color: Colors.black45,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconBadge(IconData icon, Color color, {VoidCallback? onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(Dimensions.radius15),
      onTap: onTap,
      child: Container(
        width: Dimensions.height45 * 0.9,
        height: Dimensions.height45 * 0.9,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(Dimensions.radius15),
        ),
        child: Icon(icon, size: Dimensions.iconSize24 - 4, color: color),
      ),
    );
  }
}
