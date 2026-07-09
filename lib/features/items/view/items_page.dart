import 'dart:developer' as developer;
import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/features/drawer/view/custom_drawer.dart';
import 'package:custom_books/features/items/models/item_model.dart';
import 'package:custom_books/features/items/widgets/item_card_widget.dart';
import 'package:custom_books/features/items/view/add_item_page.dart';
import 'package:flutter/material.dart';

class ItemsPage extends StatefulWidget {
  const ItemsPage({super.key});

  @override
  State<ItemsPage> createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {
  String _selectedFilter = 'Active Items';

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
    developer.log('🎯 ItemsPage initialized', name: 'ItemsPage');
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
    if (_selectedFilter == 'All Items') return _items;
    if (_selectedFilter == 'Active Items') {
      return _items.where((item) => item.isActive).toList();
    } else if (_selectedFilter == 'Inactive Items') {
      return _items.where((item) => !item.isActive).toList();
    }
    // For other filters, show all items for now
    return _items;
  }

  void _showFilterBottomSheet() {
    developer.log('📋 Opening filter bottom sheet', name: 'ItemsPage');
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(Dimensions.radius20),
              topRight: Radius.circular(Dimensions.radius20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.width20,
                  vertical: Dimensions.height15,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Appcolors.border, width: 1),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filter',
                      style: TextStyle(
                        fontSize: Dimensions.font20,
                        fontWeight: FontWeight.bold,
                        color: Appcolors.textPrimary,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        developer.log(
                          '❌ Filter sheet closed',
                          name: 'ItemsPage',
                        );
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.close_rounded,
                        size: Dimensions.iconSize24,
                        color: Appcolors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              // Default Filters Label
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(
                  Dimensions.width20,
                  Dimensions.height20,
                  Dimensions.width20,
                  Dimensions.height10,
                ),
                child: Text(
                  'DEFAULT FILTERS',
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.7,
                    fontWeight: FontWeight.w600,
                    color: Appcolors.textTertiary,
                    letterSpacing: 0.5,
                  ),
                ),
              ),

              // Filter options
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.width20,
                  vertical: Dimensions.height10,
                ),
                itemCount: _allFilterOptions.length,
                itemBuilder: (context, index) {
                  final filter = _allFilterOptions[index];
                  final isSelected = filter == _selectedFilter;

                  return GestureDetector(
                    onTap: () {
                      developer.log(
                        '✅ Filter selected: $filter',
                        name: 'ItemsPage',
                      );
                      setState(() {
                        _selectedFilter = filter;
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: Dimensions.height10),
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.width15,
                        vertical: Dimensions.height15,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Appcolors.primary.withValues(alpha: 0.05)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(
                          Dimensions.radius15,
                        ),
                        border: Border.all(
                          color: isSelected
                              ? Appcolors.primary
                              : Appcolors.border,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            filter,
                            style: TextStyle(
                              fontSize: Dimensions.font16,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                              color: isSelected
                                  ? Appcolors.primary
                                  : Appcolors.textPrimary,
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              Icons.check_circle,
                              color: Appcolors.primary,
                              size: Dimensions.iconSize24,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              SizedBox(height: Dimensions.height20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    developer.log('🏗️ Building ItemsPage', name: 'ItemsPage');
    Dimensions.init(context);

    return Scaffold(
      backgroundColor: Appcolors.background,
      drawer: const DrawerView(currentRoute: 'items'),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // App Bar
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
                  onPressed: () {
                    developer.log(
                      '📂 Drawer menu button tapped',
                      name: 'ItemsPage',
                    );
                    Scaffold.of(context).openDrawer();
                  },
                ),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Items',
                    style: TextStyle(
                      fontSize: Dimensions.font26 * 0.85,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  Text(
                    '${_filteredItems.length} items found',
                    style: TextStyle(
                      fontSize: Dimensions.font16 * 0.7,
                      color: Colors.black45,
                    ),
                  ),
                ],
              ),
              actions: [
                _buildIconButton(
                  Icons.search_rounded,
                  Appcolors.primary,
                  onTap: () {
                    developer.log('🔍 Search tapped', name: 'ItemsPage');
                  },
                ),
                SizedBox(width: Dimensions.width10),
                _buildIconButton(
                  Icons.qr_code_scanner_rounded,
                  Appcolors.accent,
                  onTap: () {
                    developer.log('📷 QR Scanner tapped', name: 'ItemsPage');
                  },
                ),
                SizedBox(width: Dimensions.width20),
              ],
            ),

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
          developer.log('➕ Add Item FAB tapped', name: 'ItemsPage');
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

  Widget _buildIconButton(IconData icon, Color color, {VoidCallback? onTap}) {
    return GestureDetector(
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
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Dimensions.radius15),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          children: [
            // Filter dropdown button
            Expanded(
              child: GestureDetector(
                onTap: () {
                  developer.log('🔽 Filter dropdown tapped', name: 'ItemsPage');
                  _showFilterBottomSheet();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: Dimensions.height10),
                  decoration: BoxDecoration(
                    color: Appcolors.primary,
                    borderRadius: BorderRadius.circular(
                      Dimensions.radius15 - 5,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.filter_list_rounded,
                        size: Dimensions.iconSize16,
                        color: Colors.white,
                      ),
                      SizedBox(width: Dimensions.width10 / 2),
                      Text(
                        displayText,
                        style: TextStyle(
                          fontSize: Dimensions.font16 * 0.8,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: Dimensions.width10 / 3),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: Dimensions.iconSize16,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(width: 8),

            // Sort button
            GestureDetector(
              onTap: () {
                developer.log('🔀 Sort button tapped', name: 'ItemsPage');
                // TODO: Implement sort functionality
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.width15,
                  vertical: Dimensions.height10,
                ),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(Dimensions.radius15 - 5),
                ),
                child: Icon(
                  Icons.sort_rounded,
                  size: Dimensions.iconSize24 - 4,
                  color: Appcolors.textSecondary,
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
                color: Appcolors.textPrimary,
              ),
            ),
            SizedBox(height: Dimensions.height10),
            Text(
              'Tap the + button to add your first item',
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.85,
                color: Appcolors.textTertiary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
