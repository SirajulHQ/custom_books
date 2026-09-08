import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/core/widgets/custom_add_button.dart';
import 'package:custom_books/core/widgets/custom_search_field.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/features/drawer/views/custom_drawer.dart';
import 'package:custom_books/features/vendors/models/vendor_model.dart';
import 'package:custom_books/features/vendors/views/add_vendor_page.dart';
import 'package:custom_books/features/vendors/views/vendor_details_page.dart';
import 'package:custom_books/features/vendors/widgets/vendor_filter_sheet.dart';
import 'package:custom_books/features/vendors/widgets/vendor_sort_sheet.dart';
import 'package:flutter/material.dart';
import 'package:custom_books/core/enums/sort_direction.dart';

class VendorsPage extends StatefulWidget {
  const VendorsPage({super.key});

  @override
  State<VendorsPage> createState() => _VendorsPageState();
}

class _VendorsPageState extends State<VendorsPage> {
  final TextEditingController _searchController = TextEditingController();

  int _selectedTab = 0; // 0: All, 1: Active, 2: Inactive
  bool _searchOpen = false;
  VendorStatus? _statusFilter;
  VendorsSortField _sortField = VendorsSortField.createdTime;
  SortDirection _sortDirection = SortDirection.descending;

  late List<VendorModel> _vendors;

  @override
  void initState() {
    super.initState();
    _vendors = [
      VendorModel(
        id: '1',
        displayName: 'Al Futtaim Trading',
        companyName: 'Al Futtaim Trading LLC',
        email: 'accounts@alfuttaim.ae',
        phone: '+971 50 123 4567',
        payables: 15230.75,
        unusedCredits: 500,
        status: VendorStatus.active,
        createdAt: DateTime(2026, 6, 28, 10, 0),
        updatedAt: DateTime(2026, 6, 28, 10, 0),
      ),
      VendorModel(
        id: '2',
        displayName: 'Gulf Office Supplies',
        companyName: 'Gulf Office Supplies FZE',
        email: 'sales@gulfoffice.ae',
        phone: '+971 4 556 8899',
        payables: 3420.00,
        unusedCredits: 0,
        status: VendorStatus.active,
        createdAt: DateTime(2026, 6, 25, 9, 30),
        updatedAt: DateTime(2026, 6, 25, 9, 30),
      ),
      VendorModel(
        id: '3',
        displayName: 'Emirates Logistics',
        companyName: 'Emirates Logistics Co.',
        email: 'billing@emirateslog.ae',
        phone: '+971 2 445 1122',
        payables: 0,
        unusedCredits: 1200,
        status: VendorStatus.inactive,
        createdAt: DateTime(2026, 6, 20, 14, 0),
        updatedAt: DateTime(2026, 6, 20, 14, 0),
      ),
      VendorModel(
        id: '4',
        displayName: 'Desert Tech Solutions',
        companyName: 'Desert Tech Solutions LLC',
        email: 'finance@deserttech.ae',
        phone: '+971 55 998 7766',
        payables: 8975.50,
        unusedCredits: 0,
        status: VendorStatus.active,
        createdAt: DateTime(2026, 6, 18, 11, 15),
        updatedAt: DateTime(2026, 6, 18, 11, 15),
      ),
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<VendorModel> get _visibleVendors {
    final query = _searchController.text.trim().toLowerCase();
    final list = _vendors.where((vendor) {
      if (_selectedTab == 1 && vendor.status != VendorStatus.active) {
        return false;
      }
      if (_selectedTab == 2 && vendor.status != VendorStatus.inactive) {
        return false;
      }
      if (_statusFilter != null && vendor.status != _statusFilter) {
        return false;
      }
      return query.isEmpty ||
          vendor.displayName.toLowerCase().contains(query) ||
          vendor.companyName.toLowerCase().contains(query) ||
          vendor.email.toLowerCase().contains(query);
    }).toList();

    list.sort((a, b) {
      int result;
      switch (_sortField) {
        case VendorsSortField.createdTime:
          result = a.createdAt.compareTo(b.createdAt);
        case VendorsSortField.name:
          result = a.displayName.toLowerCase().compareTo(
            b.displayName.toLowerCase(),
          );
        case VendorsSortField.companyName:
          result = a.companyName.toLowerCase().compareTo(
            b.companyName.toLowerCase(),
          );
        case VendorsSortField.payables:
          result = a.payables.compareTo(b.payables);
      }
      return _sortDirection == SortDirection.ascending ? result : -result;
    });

    return list;
  }

  Future<void> _addNewVendor() async {
    final result = await Navigator.push<VendorModel>(
      context,
      MaterialPageRoute(builder: (_) => const AddVendorPage()),
    );
    if (result != null && mounted) {
      setState(() => _vendors.insert(0, result));
      ToastificationHelper.showSuccess(context, 'Vendor created successfully');
    }
  }

  void _openFilterSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => VendorFilterSheet(
        selectedStatus: _statusFilter,
        onSelected: (status) => setState(() => _statusFilter = status),
      ),
    );
  }

  void _openSortSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => VendorSortSheet(
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
    final visibleList = _visibleVendors;

    return Scaffold(
      backgroundColor: context.colors.background,
      drawer: const DrawerView(currentRoute: 'vendors'),
      floatingActionButton: CustomAddButton(onPressed: _addNewVendor),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          CustomSliverAppBar(
            title: 'Vendors',
            subtitle:
                '${_vendors.length} vendor${_vendors.length == 1 ? '' : 's'}',
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
          SliverToBoxAdapter(
            child: Column(
              children: [
                if (_searchOpen)
                  ListSearchField(
                    controller: _searchController,
                    hintText: 'Search by name, company or email',
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
                          padding: EdgeInsets.all(Dimensions.width10 * 0.4),
                          decoration: BoxDecoration(
                            color: context.colors.surfaceLight,
                            borderRadius: BorderRadius.circular(
                              Dimensions.radius30,
                            ),
                          ),
                          child: Row(
                            children: [
                              _tabButton('All', 0),
                              _tabButton('Active', 1),
                              _tabButton('Inactive', 2),
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
                                    Icons.store_outlined,
                                    size: Dimensions.iconSize24 * 1.3,
                                    color: AppColors.primary,
                                  ),
                                ),
                                SizedBox(height: Dimensions.height15),
                                Text(
                                  'No vendors found',
                                  style: TextStyle(
                                    fontSize: Dimensions.font16,
                                    fontWeight: FontWeight.w700,
                                    color: context.colors.textPrimary,
                                  ),
                                ),
                                SizedBox(height: Dimensions.height10 / 2),
                                Text(
                                  'Tap the + button to add a new vendor.',
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
                            itemBuilder: (context, index) =>
                                _vendorTile(visibleList[index]),
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
        size: Dimensions.iconSize20,
        color: active ? AppColors.accent : AppColors.primary,
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return (parts.first.substring(0, 1) + parts[1].substring(0, 1))
        .toUpperCase();
  }

  Widget _vendorTile(VendorModel vendor) {
    return InkWell(
      borderRadius: BorderRadius.circular(Dimensions.radius15),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => VendorDetailsPage(vendor: vendor)),
      ),
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
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Text(
                _initials(vendor.displayName),
                style: TextStyle(
                  fontSize: Dimensions.font16 * 0.85,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            ),
            SizedBox(width: Dimensions.width15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vendor.displayName,
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
                        Icons.business_rounded,
                        size: Dimensions.iconSize16 * 0.875,
                        color: context.colors.textTertiary,
                      ),
                      SizedBox(width: Dimensions.width10 / 2),
                      Flexible(
                        child: Text(
                          vendor.companyName.isEmpty
                              ? vendor.email
                              : vendor.companyName,
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
                      Icon(
                        Icons.phone_outlined,
                        size: Dimensions.iconSize16 * 0.875,
                        color: context.colors.textTertiary,
                      ),
                      SizedBox(width: Dimensions.width10 / 2),
                      Flexible(
                        child: Text(
                          vendor.phone.isEmpty ? vendor.email : vendor.phone,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: Dimensions.font16 * 0.7,
                            color: context.colors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: Dimensions.width10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Payables',
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.6,
                    color: context.colors.textTertiary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: Dimensions.height10 / 3),
                Text(
                  '₹${vendor.payables.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.9,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
