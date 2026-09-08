import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/core/widgets/custom_search_field.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/features/delivery_challans/models/delivery_challan_model.dart';
import 'package:custom_books/features/delivery_challans/views/add_delivery_challan_page.dart';
import 'package:custom_books/features/delivery_challans/widgets/delivery_challan_card.dart';
import 'package:custom_books/features/delivery_challans/views/delivery_challan_details_page.dart';
import 'package:custom_books/features/delivery_challans/widgets/delivery_challan_filter_sheet.dart';
import 'package:custom_books/features/delivery_challans/widgets/delivery_challan_sort_sheet.dart';
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
  DeliveryChallanStatus? _statusFilter;
  DeliveryChallanSortField _sortField = DeliveryChallanSortField.createdTime;
  SortDirection _sortDirection = SortDirection.descending;

  late List<DeliveryChallanModel> _challans;

  @override
  void initState() {
    super.initState();
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

  void _openFilterSheet() async {
    final result = await showModalBottomSheet<DeliveryChallanStatus?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DeliveryChallanFilterSheet(selectedStatus: _statusFilter),
    );

    if (result != null || _statusFilter != null) {
      setState(() {
        _statusFilter = result;
      });
    }
  }

  void _openSortSheet() async {
    final result = await showModalBottomSheet<SortSheetResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DeliveryChallanSortSheet(
        selectedField: _sortField,
        selectedDirection: _sortDirection,
      ),
    );

    if (result != null && mounted) {
      setState(() {
        _sortField = result.field;
        _sortDirection = result.direction;
      });
    }
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
                onPressed: _openFilterSheet,
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
                          _tabButton('Delivered', 2),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: Dimensions.width10),
                  InkWell(
                    borderRadius: BorderRadius.circular(Dimensions.radius15),
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
                    borderRadius: BorderRadius.circular(Dimensions.radius15),
                    onTap: _openSortSheet,
                    child: _controlBadge(Icons.swap_vert_rounded),
                  ),
                ],
              ),
            ),
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
                  color: AppColors.primary.withValues(alpha: 0.07),
                  borderRadius: BorderRadius.circular(Dimensions.radius15),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.filter_alt_rounded,
                      size: Dimensions.iconSize16,
                      color: AppColors.primary,
                    ),
                    SizedBox(width: Dimensions.width10 / 2),
                    Text(
                      'Status: ${_statusFilter!.label}',
                      style: TextStyle(
                        fontSize: Dimensions.font16 * 0.72,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () => setState(() => _statusFilter = null),
                      child: Icon(
                        Icons.close_rounded,
                        size: Dimensions.iconSize16,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
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
                                color: AppColors.primary.withValues(
                                  alpha: 0.08,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.local_shipping_outlined,
                                size: Dimensions.iconSize24 * 1.3,
                                color: AppColors.primary,
                              ),
                            ),
                            SizedBox(height: Dimensions.height15),
                            Text(
                              'No delivery challans found',
                              style: TextStyle(
                                fontSize: Dimensions.font16,
                                fontWeight: FontWeight.w700,
                                color: context.colors.textPrimary,
                              ),
                            ),
                            SizedBox(height: Dimensions.height10 / 2),
                            Text(
                              'Tap the + button to create a new delivery challan.',
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
                    color: AppColors.primary.withValues(alpha: 0.3),
                    width: 1.5,
                  )
                : null,
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.08),
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
                  ? AppColors.primary
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
        color: (active ? AppColors.accent : AppColors.primary).withValues(
          alpha: 0.1,
        ),
        borderRadius: BorderRadius.circular(Dimensions.radius15),
      ),
      child: Icon(
        icon,
        size: Dimensions.iconSize24 - 4,
        color: active ? AppColors.accent : AppColors.primary,
      ),
    );
  }
}
