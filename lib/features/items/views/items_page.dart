import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/enums/sort_direction.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/core/widgets/custom_add_button.dart';
import 'package:custom_books/core/widgets/custom_search_field.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/core/widgets/empty_state_widget.dart';
import 'package:custom_books/core/widgets/filter_sheet.dart';
import 'package:custom_books/core/widgets/generic_sort_sheet.dart';
import 'package:custom_books/core/widgets/skeletons/skeletons.dart';
import 'package:custom_books/features/drawer/views/custom_drawer.dart';
import 'package:custom_books/features/items/controllers/items_list_controller.dart';
import 'package:custom_books/features/items/models/item_model.dart';
import 'package:custom_books/features/items/widgets/item_card_widget.dart';
import 'package:custom_books/features/items/views/add_edit_item_page.dart';
import 'package:custom_books/features/items/views/item_details_page.dart';
import 'package:flutter/material.dart';

class ItemsPage extends StatefulWidget {
  const ItemsPage({super.key});

  @override
  State<ItemsPage> createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {
  final ItemsListController _controller = ItemsListController();

  String _selectedFilter = 'All Items';
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

  /// Maps the UI sort-field label to the API's `sort_by` query value.
  static const Map<String, String> _sortApiValues = {
    'Name': 'name',
    'Sales Price': 'sales_price',
    'Purchase Price': 'purchase_price',
  };

  /// Maps the UI filter label to the API's `filter` query value.
  static const Map<String, String> _filterApiValues = {
    'All Items': 'all_items',
    'Active Items': 'active_items',
    'Inactive Items': 'inactive_items',
    'Sales': 'sales',
    'Purchases': 'purchases',
    'Services': 'services',
    'Zoho CRM': 'zoho_crm',
    'Inventory Items': 'inventory_items',
    'Non-inventory Items': 'non_inventory_items',
  };

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onControllerChanged);
    _loadItems();
    appLog('🎯 ItemsPage initialized', name: 'ItemsPage');
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    _controller.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    if (mounted) setState(() {});
  }

  /// Fetches items from the API for the current filter and sort selection.
  Future<void> _loadItems() async {
    await _controller.load(
      filter: _filterApiValues[_selectedFilter],
      sortBy: _sortApiValues[_sortField],
      sortOrder: _sortAsc ? 'asc' : 'desc',
    );
    if (!mounted) return;
    if (_controller.errorMessage != null) {
      ToastificationHelper.showError(context, _controller.errorMessage!);
    }
  }

  bool get _isLoading => _controller.isLoading;

  List<ItemModel> get _filteredItems {
    // Filtering and sorting are done server-side via query params; only the
    // search box is applied client-side over the returned list.
    var list = _controller.items;

    final query = _searchController.text.trim().toLowerCase();
    if (query.isNotEmpty) {
      list = list.where((item) {
        return item.name.toLowerCase().contains(query) ||
            (item.sku?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    return list;
  }

  void _showSortSheet() {
    appLog('🔀 Opening sort sheet', name: 'ItemsPage');
    const fields = ['Name', 'Sales Price', 'Purchase Price'];
    GenericSortSheet.show<String>(
      context,
      fields: fields,
      initialField: _sortField,
      initialDirection: _sortAsc
          ? SortDirection.ascending
          : SortDirection.descending,
      labelBuilder: (f) => f,
      showInfoBanner: true,
      onApply: (field, direction) {
        setState(() {
          _sortField = field;
          _sortAsc = direction == SortDirection.ascending;
        });
        // Re-fetch from the API with the new sort.
        _loadItems();
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
          if (filter != null && filter != _selectedFilter) {
            appLog('✅ Filter selected: $filter', name: 'ItemsPage');
            setState(() => _selectedFilter = filter);
            // Re-fetch from the API for the newly selected filter.
            _loadItems();
          }
          Navigator.pop(sheetContext);
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
        child: RefreshIndicator(
          color: AppColors.primary,
          backgroundColor: context.colors.card,
          strokeWidth: 2.5,
          onRefresh: _loadItems,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
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
              if (_isLoading && _controller.items.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: true,
                  child: DocumentListSkeleton(),
                )
              else
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
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final item = _filteredItems[index];
                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: Dimensions.height15,
                              ),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(
                                  Dimensions.radius20,
                                ),
                                onTap: () async {
                                  appLog(
                                    '👁️ Item tapped: ${item.name}',
                                    name: 'ItemsPage',
                                  );
                                  final changed = await Navigator.push<bool>(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          ItemDetailsPage(item: item),
                                    ),
                                  );
                                  // Reload if the item was edited from details.
                                  if (changed == true) _loadItems();
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
      ),
      floatingActionButton: CustomAddButton(
        onPressed: () async {
          appLog('➕ Add Item FAB tapped', name: 'ItemsPage');
          final created = await Navigator.push<bool>(
            context,
            MaterialPageRoute(builder: (context) => const AddEditItemPage()),
          );
          // Reload the list when a new item was created.
          if (created == true) _loadItems();
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
