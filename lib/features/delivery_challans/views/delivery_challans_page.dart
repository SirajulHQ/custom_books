import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/core/widgets/active_filter_banner.dart';
import 'package:custom_books/core/widgets/custom_search_field.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/core/widgets/empty_state_widget.dart';
import 'package:custom_books/core/widgets/filter_sheet.dart';
import 'package:custom_books/core/widgets/list_control_bar.dart';
import 'package:custom_books/core/widgets/skeletons/skeletons.dart';
import 'package:custom_books/features/delivery_challans/models/delivery_challan_model.dart';
import 'package:custom_books/features/delivery_challans/views/add_delivery_challan_page.dart';
import 'package:custom_books/features/delivery_challans/widgets/delivery_challan_card.dart';
import 'package:custom_books/features/delivery_challans/views/delivery_challan_details_page.dart';
import 'package:custom_books/features/delivery_challans/widgets/delivery_challan_sort_sheet.dart';
import 'package:custom_books/core/widgets/more_options_sheet.dart';
import 'package:custom_books/features/drawer/views/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:custom_books/core/enums/sort_direction.dart';

class DeliveryChallansPage extends StatefulWidget {
  const DeliveryChallansPage({super.key});

  @override
  State<DeliveryChallansPage> createState() => _DeliveryChallansPageState();
}

class _DeliveryChallansPageState extends State<DeliveryChallansPage> {
  final TextEditingController _searchController = TextEditingController();

  int _selectedTab = 0; // 0: All, 1: Draft, 2: Delivered
  bool _searchOpen = false;
  bool _isLoading = true;
  DeliveryChallanStatus? _statusFilter;
  DeliveryChallanSortField _sortField = DeliveryChallanSortField.createdTime;
  SortDirection _sortDirection = SortDirection.descending;

  late List<DeliveryChallanModel> _challans;

  @override
  void initState() {
    super.initState();
    _loadChallans();
    _challans = [
      DeliveryChallanModel(
        id: '1',
        challanNumber: 'DC-00042',
        customerName: 'Nandhu',
        referenceNumber: 'REF-812',
        challanDate: DateTime(2026, 7, 3),
        type: 'Job Work',
        status: DeliveryChallanStatus.draft,
        total: 1240.00,
        createdAt: DateTime(2026, 7, 3, 10, 0),
        updatedAt: DateTime(2026, 7, 3, 10, 0),
      ),
      DeliveryChallanModel(
        id: '2',
        challanNumber: 'DC-00041',
        customerName: 'Parthiv Ajith',
        referenceNumber: 'REF-806',
        challanDate: DateTime(2026, 7, 2),
        type: 'Supply on Approval',
        status: DeliveryChallanStatus.delivered,
        total: 3560.50,
        createdAt: DateTime(2026, 7, 2, 14, 30),
        updatedAt: DateTime(2026, 7, 2, 14, 30),
      ),
      DeliveryChallanModel(
        id: '3',
        challanNumber: 'DC-00040',
        customerName: 'Aisha Traders',
        referenceNumber: 'REF-799',
        challanDate: DateTime(2026, 7, 1),
        type: 'Job Work',
        status: DeliveryChallanStatus.returned,
        total: 875.00,
        createdAt: DateTime(2026, 7, 1, 9, 15),
        updatedAt: DateTime(2026, 7, 1, 9, 15),
      ),
      DeliveryChallanModel(
        id: '4',
        challanNumber: 'DC-00039',
        customerName: 'Gulf Retail LLC',
        referenceNumber: 'REF-790',
        challanDate: DateTime(2026, 6, 29),
        type: 'Supply on Approval',
        status: DeliveryChallanStatus.delivered,
        total: 5210.75,
        createdAt: DateTime(2026, 6, 29, 16, 45),
        updatedAt: DateTime(2026, 6, 29, 16, 45),
      ),
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Simulates fetching delivery challans so the shimmer skeleton is shown briefly.
  Future<void> _loadChallans() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _isLoading = false);
  }

  List<DeliveryChallanModel> get _visibleChallans {
    final query = _searchController.text.trim().toLowerCase();
    final list = _challans.where((challan) {
      if (_selectedTab == 1 && challan.status != DeliveryChallanStatus.draft) {
        return false;
      }
      if (_selectedTab == 2 &&
          challan.status != DeliveryChallanStatus.delivered) {
        return false;
      }
      if (_statusFilter != null && challan.status != _statusFilter) {
        return false;
      }
      return query.isEmpty ||
          challan.customerName.toLowerCase().contains(query) ||
          challan.challanNumber.toLowerCase().contains(query) ||
          challan.referenceNumber.toLowerCase().contains(query);
    }).toList();

    list.sort((a, b) {
      int result;
      switch (_sortField) {
        case DeliveryChallanSortField.createdTime:
          result = a.createdAt.compareTo(b.createdAt);
        case DeliveryChallanSortField.date:
          result = a.challanDate.compareTo(b.challanDate);
        case DeliveryChallanSortField.challanNumber:
          result = a.challanNumber.compareTo(b.challanNumber);
        case DeliveryChallanSortField.customerName:
          result = a.customerName.toLowerCase().compareTo(
            b.customerName.toLowerCase(),
          );
        case DeliveryChallanSortField.amount:
          result = a.total.compareTo(b.total);
      }
      return _sortDirection == SortDirection.ascending ? result : -result;
    });

    return list;
  }

  Future<void> _addNewChallan() async {
    final result = await Navigator.push<DeliveryChallanModel>(
      context,
      MaterialPageRoute(builder: (_) => const AddDeliveryChallanPage()),
    );
    if (result != null && mounted) {
      setState(() => _challans.insert(0, result));
      ToastificationHelper.showSuccess(
        context,
        '${result.challanNumber} created successfully',
      );
    }
  }

  void _showMoreOptions() {
    MoreOptionsSheet.show(
      context,
      sectionLabel: 'DELIVERY CHALLAN ACTIONS',
      items: [
        MoreOptionsItem(
          icon: Icons.file_download_outlined,
          title: 'Export Delivery Challans',
          subtitle: 'Export the current delivery challan list',
          onTap: () => ToastificationHelper.showSuccess(
            context,
            'Delivery challans exported',
          ),
        ),
        MoreOptionsItem(
          icon: Icons.print_outlined,
          title: 'Print',
          subtitle: 'Print delivery challan documents',
          onTap: () => ToastificationHelper.showInfo(
            context,
            'Printing delivery challans is coming soon.',
          ),
        ),
        MoreOptionsItem(
          icon: Icons.refresh_rounded,
          title: 'Refresh',
          subtitle: 'Reload the latest delivery challans',
          onTap: () => setState(() {}),
        ),
      ],
    );
  }

  void _openFilterSheet() async {
    final result = await showModalBottomSheet<DeliveryChallanStatus?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FilterSheet<DeliveryChallanStatus>(
        title: 'Filter',
        options: const [null, ...DeliveryChallanStatus.values],
        selectedValue: _statusFilter,
        labelBuilder: (status) => status?.label ?? 'All Statuses',
        onSelected: (status) => Navigator.pop(context, status),
        onClose: () => Navigator.pop(context),
      ),
    );

    if (result != null || _statusFilter != null) {
      setState(() {
        _statusFilter = result;
      });
    }
  }

  void _openSortSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DeliveryChallanSortSheet(
        selectedField: _sortField,
        selectedDirection: _sortDirection,
        onApply: (field, direction) {
          setState(() {
            _sortField = field;
            _sortDirection = direction;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final visibleList = _visibleChallans;

    return Scaffold(
      backgroundColor: context.colors.background,
      drawer: const DrawerView(currentRoute: 'delivery_challans'),
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
          onPressed: _addNewChallan,
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.radius15),
          ),
          child: const Icon(Icons.add_rounded),
        ),
      ),
      body: NestedScrollView(
        physics: const BouncingScrollPhysics(),
        headerSliverBuilder: (context, _) => [
          CustomSliverAppBar(
            title: 'Delivery Challans',
            subtitle:
                '${_challans.length} delivery challan${_challans.length == 1 ? '' : 's'}',
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
                hintText: 'Search by customer, challan or reference',
                onChanged: (_) => setState(() {}),
              ),
            ListControlBar(
              tabs: const ['All', 'Draft', 'Delivered'],
              selectedTab: _selectedTab,
              onTabSelected: (index) => setState(() {
                _selectedTab = index;
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
              child: _isLoading
                  ? const DocumentListSkeleton()
                  : visibleList.isEmpty
                  ? const EmptyStateWidget(
                      icon: Icons.local_shipping_outlined,
                      title: 'No delivery challans found',
                      subtitle:
                          'Tap the + button to create a new delivery challan.',
                    )
                  : RefreshIndicator(
                      onRefresh: _loadChallans,
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
                        itemBuilder: (context, index) => InkWell(
                          borderRadius: BorderRadius.circular(
                            Dimensions.radius15,
                          ),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DeliveryChallanDetailsPage(
                                challan: visibleList[index],
                              ),
                            ),
                          ),
                          child: DeliveryChallanCard(
                            challan: visibleList[index],
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
