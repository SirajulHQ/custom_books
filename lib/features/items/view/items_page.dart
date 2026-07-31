import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/features/drawer/view/custom_drawer.dart';
import 'package:custom_books/features/items/models/item_model.dart';
import 'package:custom_books/features/items/widgets/item_card_widget.dart';
import 'package:custom_books/features/items/widgets/items_filter_sheet.dart';
import 'package:custom_books/features/items/view/add_item_page.dart';
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
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
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
                        ? Appcolors.primary
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
                          color: Appcolors.primary,
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
      builder: (sheetContext) => ItemsFilterSheet(
        options: _allFilterOptions,
        selectedFilter: _selectedFilter,
        onClose: () {
          appLog('❌ Filter sheet closed', name: 'ItemsPage');
          Navigator.pop(sheetContext);
        },
        onSelected: (filter) {
          appLog('✅ Filter selected: $filter', name: 'ItemsPage');
          setState(() => _selectedFilter = filter);
          Navigator.pop(sheetContext);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    appLog('🏗️ Building ItemsPage', name: 'ItemsPage');
    Dimensions.init(context);

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
                  color: Appcolors.primary,
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
                  color: Appcolors.accent,
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
                  ? SliverToBoxAdapter(child: _buildEmptyState())
                  : SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: Dimensions.height15),
                          child: ItemCardWidget(item: _filteredItems[index]),
                        );
                      }, childCount: _filteredItems.length),
                    ),
            ),

            SliverToBoxAdapter(child: SizedBox(height: Dimensions.height30)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          appLog('➕ Add Item FAB tapped', name: 'ItemsPage');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddItemPage()),
          );
        },
        backgroundColor: Appcolors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radius20),
        ),
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: Dimensions.iconSize24 * 1.2,
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
          hintText: 'Search by name or SKU',
          hintStyle: TextStyle(color: context.colors.textTertiary),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: context.colors.textTertiary,
          ),
          filled: true,
          fillColor: context.colors.card,
          contentPadding: EdgeInsets.symmetric(vertical: Dimensions.height10),
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
            borderSide: BorderSide(color: Appcolors.primary, width: 1.5),
          ),
        ),
      ),
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
                      color: Appcolors.primary.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Appcolors.primary.withValues(alpha: 0.08),
                        blurRadius: 8,
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
                        color: Appcolors.primary,
                      ),
                      SizedBox(width: Dimensions.width10 / 2),
                      Text(
                        displayText,
                        style: TextStyle(
                          fontSize: Dimensions.font16 * 0.8,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.3,
                          color: Appcolors.primary,
                        ),
                      ),
                      SizedBox(width: Dimensions.width10 / 3),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: Dimensions.iconSize16,
                        color: Appcolors.primary,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(width: 8),

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

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(Dimensions.width30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(Dimensions.width30),
              decoration: BoxDecoration(
                color: Appcolors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.inventory_2_outlined,
                size: Dimensions.height45 * 1.5,
                color: Appcolors.primary,
              ),
            ),
            SizedBox(height: Dimensions.height20),
            Text(
              'No items found',
              style: TextStyle(
                fontSize: Dimensions.font20,
                fontWeight: FontWeight.w700,
                color: context.colors.textPrimary,
              ),
            ),
            SizedBox(height: Dimensions.height10),
            Text(
              'Tap the + button to add your first item',
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.85,
                color: context.colors.textTertiary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
