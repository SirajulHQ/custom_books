import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/core/widgets/bottom_sheet_drag_handle.dart';
import 'package:custom_books/core/widgets/custom_add_button.dart';
import 'package:custom_books/core/widgets/custom_search_field.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/core/widgets/empty_state_widget.dart';
import 'package:custom_books/core/widgets/filter_sheet.dart';
import 'package:custom_books/features/drawer/views/custom_drawer.dart';
import 'package:custom_books/features/items/models/item_model.dart';
import 'package:custom_books/features/items/widgets/item_card_widget.dart';
import 'package:custom_books/features/items/views/add_item_page.dart';
import 'package:custom_books/features/items/views/item_details_page.dart';
import 'package:flutter/material.dart';

class ItemsPage extends StatefulWidget {
  const ItemsPage({super.key});

  @override
  State<ItemsPage> createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {
  String _selectedFilter = 'Active Items';
  bool _searchOpen = false;
  final _searchController = TextEditingController();

  String _sortField = 'Name';
  bool _sortAsc = true;

  final List<String> _allFilterOptions = [
    'All Items',
    'Active Items',
    'Inactive Items',
    'Sales',
    'Purchases',
    'Services',
    'Zoho CRM',
    'Inventory Items',
    'Non-inventory Items',
  ];

  @override
  void initState() {
    super.initState();
    appLog('🎯 ItemsPage initialized', name: 'ItemsPage');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Dummy data based on the image
  final List<ItemModel> _items = [
    ItemModel(
      id: '1',
      name: 'Mouse',
      salesPrice: 15.00,
      purchasePrice: 10.00,
      isActive: true,
    ),
    ItemModel(
      id: '2',
      name: 'Pen',
      sku: 'PEN-01',
      salesPrice: 20.00,
      purchasePrice: 10.00,
      isActive: true,
    ),
    ItemModel(
      id: '3',
      name: 'Pencil',
      salesPrice: 20.00,
      purchasePrice: 0.00,
      isActive: true,
    ),
  ];

  List<ItemModel> get _filteredItems {
    var list = _items;

    // Apply filter
    if (_selectedFilter == 'Active Items') {
      list = list.where((item) => item.isActive).toList();
    } else if (_selectedFilter == 'Inactive Items') {
      list = list.where((item) => !item.isActive).toList();
    }
    // For 'All Items' and other filters, show all items for now

    // Apply search
    final query = _searchController.text.trim().toLowerCase();
    if (query.isNotEmpty) {
      list = list.where((item) {
        return item.name.toLowerCase().contains(query) ||
            (item.sku?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    // Apply sort
    list = [...list];
    list.sort((a, b) {
      int cmp;
      switch (_sortField) {
        case 'Sales Price':
          cmp = a.salesPrice.compareTo(b.salesPrice);
          break;
        case 'Purchase Price':
          cmp = a.purchasePrice.compareTo(b.purchasePrice);
          break;
        case 'Name':
        default:
          cmp = a.name.toLowerCase().compareTo(b.name.toLowerCase());
      }
      return _sortAsc ? cmp : -cmp;
    });

    return list;
  }

  void _showSortSheet() {
    appLog('🔀 Opening sort sheet', name: 'ItemsPage');
    const fields = ['Name', 'Sales Price', 'Purchase Price'];
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: BoxDecoration(
            color: context.colors.card,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(Dimensions.radius20 * 1.2),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const BottomSheetDragHandle(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Sort by',
                    style: TextStyle(
                      fontSize: Dimensions.font20,
                      fontWeight: FontWeight.w800,
                      color: context.colors.textPrimary,
                    ),
                  ),
                ),
              ),
              SizedBox(height: Dimensions.height10),
              ...fields.map((f) {
                final selected = f == _sortField;
                return ListTile(
                  leading: Icon(
                    selected
                        ? Icons.radio_button_checked_rounded
                        : Icons.radio_button_off_rounded,
                    color: selected
                        ? AppColors.primary
                        : context.colors.textSecondary,
                  ),
                  title: Text(
                    f,
                    style: TextStyle(
                      fontSize: Dimensions.font16 * 0.9,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                      color: context.colors.textPrimary,
                    ),
                  ),
                  trailing: selected
                      ? Icon(
                          _sortAsc
                              ? Icons.arrow_upward_rounded
                              : Icons.arrow_downward_rounded,
                          color: AppColors.primary,
                          size: Dimensions.iconSize16,
                        )
                      : null,
                  onTap: () {
                    setState(() {
                      if (_sortField == f) {
                        _sortAsc = !_sortAsc;
                      } else {
                        _sortField = f;
                        _sortAsc = true;
                      }
                    });
                    Navigator.pop(ctx);
                  },
                );
              }),
              SizedBox(height: Dimensions.height20),
            ],
          ),
        );
      },
    );
  }

  void _showFilterBottomSheet() {
    appLog('📋 Opening filter bottom sheet', name: 'ItemsPage');
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) => FilterSheet<String>(
        title: 'Filter',
        showHeaderBorder: true,
        sectionLabel: 'DEFAULT FILTERS',
        options: _allFilterOptions,
        selectedValue: _selectedFilter,
        labelBuilder: (filter) => filter ?? '',
        onSelected: (filter) {
          if (filter != null) {
            appLog('✅ Filter selected: $filter', name: 'ItemsPage');
            setState(() => _selectedFilter = filter);
            Navigator.pop(sheetContext);
          }
          ;
        },
        onClose: () {
          appLog('❌ Filter sheet closed', name: 'ItemsPage');
          Navigator.pop(sheetContext);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    appLog('🏗️ Building ItemsPage', name: 'ItemsPage');
    return Scaffold(
      backgroundColor: context.colors.background,
      drawer: const DrawerView(currentRoute: 'items'),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // App Bar
            CustomSliverAppBar(
              title: 'Items',
              subtitle: '${_filteredItems.length} items found',
              leadingType: AppBarLeadingType.menu,
              actions: [
                AppBarIconButton(
                  icon: _searchOpen
                      ? Icons.close_rounded
                      : Icons.search_rounded,
                  color: AppColors.primary,
                  onPressed: () {
                    appLog('🔍 Search tapped', name: 'ItemsPage');
                    setState(() {
                      _searchOpen = !_searchOpen;
                      if (!_searchOpen) _searchController.clear();
                    });
                  },
                ),
                SizedBox(width: Dimensions.width10),
                AppBarIconButton(
                  icon: Icons.qr_code_scanner_rounded,
                  color: AppColors.accent,
                  onPressed: () {
                    appLog('📷 QR Scanner tapped', name: 'ItemsPage');
                    ToastificationHelper.showInfo(
                      context,
                      'Barcode scanning is coming soon.',
                    );
                  },
                ),
                SizedBox(width: Dimensions.width20),
              ],
            ),

            // Search Field
            if (_searchOpen) SliverToBoxAdapter(child: _buildSearchField()),

            // Filter Segment Control
            SliverToBoxAdapter(child: _buildFilterSegment()),

            // Items List
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
              sliver: _filteredItems.isEmpty
                  ? const SliverToBoxAdapter(
                      child: EmptyStateWidget(
                        icon: Icons.inventory_2_outlined,
                        title: 'No items found',
                        subtitle: 'Tap the + button to add your first item',
                      ),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final item = _filteredItems[index];
                        return Padding(
                          padding: EdgeInsets.only(bottom: Dimensions.height15),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(
                              Dimensions.radius20,
                            ),
                            onTap: () {
                              appLog(
                                '👁️ Item tapped: ${item.name}',
                                name: 'ItemsPage',
                              );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ItemDetailsPage(item: item),
                                ),
                              );
                            },
                            child: ItemCardWidget(item: item),
                          ),
                        );
                      }, childCount: _filteredItems.length),
                    ),
            ),

            SliverToBoxAdapter(
              child: SizedBox(
                height: Dimensions.height30 + Dimensions.listBottomSpace,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: CustomAddButton(
        onPressed: () {
          appLog('➕ Add Item FAB tapped', name: 'ItemsPage');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddItemPage()),
          );
        },
      ),
    );
  }

  Widget _buildSearchField() {
    return ListSearchField(
      controller: _searchController,
      hintText: 'Search by name or SKU',
      onChanged: (_) => setState(() {}),
    );
  }

  Widget _buildFilterSegment() {
    // Extract display text from selected filter
    String displayText = _selectedFilter.replaceAll(' Items', '');

    return Padding(
      padding: EdgeInsets.fromLTRB(
        Dimensions.width20,
        0,
        Dimensions.width20,
        Dimensions.height15,
      ),
      child: Container(
        padding: EdgeInsets.all(Dimensions.width10 / 2),
        decoration: BoxDecoration(
          color: context.colors.surfaceLight,
          borderRadius: BorderRadius.circular(Dimensions.radius30),
        ),
        child: Row(
          children: [
            // Filter dropdown button
            Expanded(
              child: GestureDetector(
                onTap: () {
                  appLog('🔽 Filter dropdown tapped', name: 'ItemsPage');
                  _showFilterBottomSheet();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: Dimensions.height10),
                  decoration: BoxDecoration(
                    color: context.colors.card,
                    borderRadius: BorderRadius.circular(Dimensions.radius30),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        blurRadius: Dimensions.radius15 * 0.53,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.filter_list_rounded,
                        size: Dimensions.iconSize16,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: Dimensions.width10 / 2),
                      Text(
                        displayText,
                        style: TextStyle(
                          fontSize: Dimensions.font16 * 0.8,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.3,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(width: Dimensions.width10 / 3),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: Dimensions.iconSize16,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(width: Dimensions.width10 * 0.8),

            // Sort button
            GestureDetector(
              onTap: _showSortSheet,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.width15,
                  vertical: Dimensions.height10,
                ),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(Dimensions.radius30),
                ),
                child: Icon(
                  Icons.sort_rounded,
                  size: Dimensions.iconSize24 - 4,
                  color: context.colors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
