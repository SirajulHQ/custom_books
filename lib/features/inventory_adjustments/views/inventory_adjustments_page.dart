import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/core/widgets/skeletons/skeletons.dart';
import 'package:custom_books/features/drawer/views/custom_drawer.dart';
import 'package:custom_books/features/inventory_adjustments/controllers/inventory_adjustments_list_controller.dart';
import 'package:custom_books/features/inventory_adjustments/models/inventory_adjustments_model.dart';
import 'package:custom_books/features/inventory_adjustments/views/add_adjustment_page.dart';
import 'package:custom_books/features/inventory_adjustments/views/adjustment_details_page.dart';
import 'package:custom_books/features/inventory_adjustments/widgets/inventory_adjustments_card_widgets.dart';
import 'package:custom_books/core/widgets/more_options_sheet.dart';
import 'package:custom_books/features/inventory_adjustments/widgets/inventory_adjustments_page_widgets.dart';
import 'package:flutter/material.dart';
import 'package:custom_books/core/enums/sort_direction.dart';

class InventoryAdjustmentsPage extends StatefulWidget {
  const InventoryAdjustmentsPage({super.key});

  @override
  State<InventoryAdjustmentsPage> createState() =>
      _InventoryAdjustmentsPageState();
}

class _InventoryAdjustmentsPageState extends State<InventoryAdjustmentsPage> {
  final InventoryAdjustmentsListController _controller =
      InventoryAdjustmentsListController();

  int _selectedTab = 0; // 0 All, 1 By Quantity, 2 By Value
  bool _searchOpen = false;
  final _searchController = TextEditingController();

  AdjustmentSortField _sortField = AdjustmentSortField.createdTime;
  SortDirection _sortDirection = SortDirection.descending;

  /// Maps the sort enum to the API's `sort_by` query values.
  static const Map<AdjustmentSortField, String> _sortApiValues = {
    AdjustmentSortField.date: 'date',
    AdjustmentSortField.reason: 'reason',
    AdjustmentSortField.createdTime: 'created_time',
    AdjustmentSortField.lastModifiedTime: 'last_modified_time',
  };

  /// Maps the selected tab to the API's `filter` query value.
  static const List<String> _filterApiValues = [
    'all',
    'by_quantity',
    'by_value',
  ];

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onControllerChanged);
    _loadAdjustments();
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

  bool get _isLoading => _controller.isLoading;

  Future<void> _loadAdjustments() async {
    await _controller.load(
      filter: _filterApiValues[_selectedTab],
      sortBy: _sortApiValues[_sortField],
      sortOrder: _sortDirection == SortDirection.ascending ? 'asc' : 'desc',
    );
    if (!mounted) return;
    if (_controller.errorMessage != null) {
      ToastificationHelper.showError(context, _controller.errorMessage!);
    }
  }

  List<InventoryAdjustment> get _filteredAdjustments {
    return _controller.adjustments.where((a) {
      final q = _searchController.text.trim().toLowerCase();
      if (q.isEmpty) return true;
      return a.reason.toLowerCase().contains(q) ||
          a.createdBy.toLowerCase().contains(q);
    }).toList();
  }

  void _showMoreOptions() {
    MoreOptionsSheet.show(
      context,
      sectionLabel: 'ADJUSTMENT ACTIONS',
      items: [
        MoreOptionsItem(
          icon: Icons.file_download_outlined,
          title: 'Export Adjustments',
          subtitle: 'Export the current adjustment list',
          onTap: () => ToastificationHelper.showInfo(
            context,
            'Exporting adjustments is coming soon.',
          ),
        ),
        MoreOptionsItem(
          icon: Icons.print_outlined,
          title: 'Print',
          subtitle: 'Print inventory adjustment documents',
          onTap: () => ToastificationHelper.showInfo(
            context,
            'Printing adjustments is coming soon.',
          ),
        ),
        MoreOptionsItem(
          icon: Icons.refresh_rounded,
          title: 'Refresh',
          subtitle: 'Reload the latest adjustments',
          onTap: () {
            _loadAdjustments();
            ToastificationHelper.showSuccess(context, 'Adjustments refreshed.');
          },
        ),
      ],
    );
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
              await _loadAdjustments();
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
        child: RefreshIndicator(
          color: AppColors.primary,
          backgroundColor: context.colors.card,
          strokeWidth: 2.5,
          onRefresh: _loadAdjustments,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
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
                  AppBarIconButton(
                    icon: Icons.more_vert_rounded,
                    color: AppColors.accent,
                    onPressed: _showMoreOptions,
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
                  onTabChanged: (index) {
                    setState(() => _selectedTab = index);
                    _loadAdjustments();
                  },
                  sortField: _sortField,
                  sortDirection: _sortDirection,
                  onSortChanged: (field, direction) {
                    setState(() {
                      _sortField = field;
                      _sortDirection = direction;
                    });
                    _loadAdjustments();
                  },
                ),
              ),
              if (_isLoading && _controller.adjustments.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: true,
                  child: DocumentListSkeleton(),
                )
              else if (items.isEmpty)
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
                              builder: (context) => AdjustmentDetailsPage(
                                adjustment: items[index],
                              ),
                            ),
                          );
                        },
                      ),
                      childCount: items.length,
                    ),
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
    );
  }
}
