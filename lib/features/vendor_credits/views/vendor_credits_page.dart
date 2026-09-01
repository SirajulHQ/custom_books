import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/core/widgets/custom_add_button.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/features/drawer/views/custom_drawer.dart';
import 'package:custom_books/features/vendor_credits/models/vendor_credit_model.dart';
import 'package:custom_books/features/vendor_credits/views/add_vendor_credit_page.dart';
import 'package:custom_books/features/vendor_credits/views/vendor_credit_details_page.dart';
import 'package:custom_books/features/vendor_credits/widgets/vendor_credit_filter_sheet.dart';
import 'package:custom_books/features/vendor_credits/widgets/vendor_credit_sort_sheet.dart';
import 'package:custom_books/features/vendor_credits/widgets/vendor_credit_page_widgets.dart';
import 'package:flutter/material.dart';
import 'package:custom_books/core/enums/sort_direction.dart';

class VendorCreditsPage extends StatefulWidget {
  const VendorCreditsPage({super.key});

  @override
  State<VendorCreditsPage> createState() => _VendorCreditsPageState();
}

class _VendorCreditsPageState extends State<VendorCreditsPage> {
  final TextEditingController _searchController = TextEditingController();

  int _selectedTab = 0; // 0: All, 1: Open, 2: Closed
  bool _searchOpen = false;
  VendorCreditStatus? _statusFilter;
  VendorCreditSortField _sortField = VendorCreditSortField.createdTime;
  SortDirection _sortDirection = SortDirection.descending;

  late List<VendorCreditModel> _credits;

  @override
  void initState() {
    super.initState();
    _credits = [
      VendorCreditModel(
        id: '1',
        creditNoteNumber: 'VC-00014',
        vendorName: 'Al Futtaim Trading',
        referenceNumber: 'REF-5501',
        creditDate: DateTime(2026, 7, 3),
        status: VendorCreditStatus.open,
        total: 1250.00,
        createdAt: DateTime(2026, 7, 3, 10, 0),
        updatedAt: DateTime(2026, 7, 3, 10, 0),
      ),
      VendorCreditModel(
        id: '2',
        creditNoteNumber: 'VC-00013',
        vendorName: 'Gulf Office Supplies',
        referenceNumber: 'REF-5490',
        creditDate: DateTime(2026, 6, 28),
        status: VendorCreditStatus.closed,
        total: 480.00,
        createdAt: DateTime(2026, 6, 28, 9, 30),
        updatedAt: DateTime(2026, 6, 28, 9, 30),
      ),
      VendorCreditModel(
        id: '3',
        creditNoteNumber: 'VC-00012',
        vendorName: 'Desert Tech Solutions',
        creditDate: DateTime(2026, 6, 20),
        status: VendorCreditStatus.draft,
        total: 3200.50,
        createdAt: DateTime(2026, 6, 20, 14, 0),
        updatedAt: DateTime(2026, 6, 20, 14, 0),
      ),
      VendorCreditModel(
        id: '4',
        creditNoteNumber: 'VC-00011',
        vendorName: 'Emirates Logistics',
        creditDate: DateTime(2026, 6, 12),
        status: VendorCreditStatus.void_,
        total: 900.00,
        createdAt: DateTime(2026, 6, 12, 11, 15),
        updatedAt: DateTime(2026, 6, 12, 11, 15),
      ),
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<VendorCreditModel> get _visibleCredits {
    final query = _searchController.text.trim().toLowerCase();
    final list = _credits.where((credit) {
      if (_selectedTab == 1 && credit.status != VendorCreditStatus.open) {
        return false;
      }
      if (_selectedTab == 2 && credit.status != VendorCreditStatus.closed) {
        return false;
      }
      if (_statusFilter != null && credit.status != _statusFilter) {
        return false;
      }
      return query.isEmpty ||
          credit.vendorName.toLowerCase().contains(query) ||
          credit.creditNoteNumber.toLowerCase().contains(query) ||
          credit.referenceNumber.toLowerCase().contains(query);
    }).toList();

    list.sort((a, b) {
      int result;
      switch (_sortField) {
        case VendorCreditSortField.createdTime:
          result = a.createdAt.compareTo(b.createdAt);
        case VendorCreditSortField.date:
          result = a.creditDate.compareTo(b.creditDate);
        case VendorCreditSortField.creditNoteNumber:
          result = a.creditNoteNumber.compareTo(b.creditNoteNumber);
        case VendorCreditSortField.vendorName:
          result = a.vendorName.toLowerCase().compareTo(
            b.vendorName.toLowerCase(),
          );
        case VendorCreditSortField.amount:
          result = a.total.compareTo(b.total);
      }
      return _sortDirection == SortDirection.ascending ? result : -result;
    });

    return list;
  }

  Future<void> _addNewCredit() async {
    final result = await Navigator.push<VendorCreditModel>(
      context,
      MaterialPageRoute(builder: (_) => const AddVendorCreditPage()),
    );
    if (result != null && mounted) {
      setState(() => _credits.insert(0, result));
      ToastificationHelper.showSuccess(
        context,
        'Vendor credit created successfully',
      );
    }
  }

  void _openFilterSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => VendorCreditFilterSheet(
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
      builder: (_) => VendorCreditSortSheet(
        selectedField: _sortField,
        selectedDirection: _sortDirection,
        onApply: (field, direction) => setState(() {
          _sortField = field;
          _sortDirection = direction;
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final visibleList = _visibleCredits;

    return Scaffold(
      backgroundColor: context.colors.background,
      drawer: const DrawerView(currentRoute: 'vendor_credits'),
      floatingActionButton: CustomAddButton(onPressed: _addNewCredit),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          CustomSliverAppBar(
            title: 'Vendor Credits',
            subtitle:
                '${_credits.length} vendor credit${_credits.length == 1 ? '' : 's'}',
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
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      Dimensions.width20,
                      Dimensions.height10,
                      Dimensions.width20,
                      Dimensions.height15,
                    ),
                    child: TextField(
                      controller: _searchController,
                      autofocus: true,
                      onChanged: (_) => setState(() {}),
                      style: TextStyle(fontSize: Dimensions.font16 * 0.85),
                      decoration: InputDecoration(
                        hintText: 'Search by vendor, credit note or reference',
                        hintStyle: TextStyle(
                          color: context.colors.textTertiary,
                        ),
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: context.colors.textTertiary,
                        ),
                        filled: true,
                        fillColor: context.colors.card,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: Dimensions.height10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            Dimensions.radius15,
                          ),
                          borderSide: BorderSide(color: context.colors.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            Dimensions.radius15,
                          ),
                          borderSide: BorderSide(color: context.colors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            Dimensions.radius15,
                          ),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
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
                              _tabButton('Open', 1),
                              _tabButton('Closed', 2),
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
              ],
            ),
          ),
          SliverFillRemaining(
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
                              color: AppColors.primary.withValues(alpha: 0.08),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.assignment_return_outlined,
                              size: Dimensions.iconSize24 * 1.3,
                              color: AppColors.primary,
                            ),
                          ),
                          SizedBox(height: Dimensions.height15),
                          Text(
                            'No vendor credits found',
                            style: TextStyle(
                              fontSize: Dimensions.font16,
                              fontWeight: FontWeight.w700,
                              color: context.colors.textPrimary,
                            ),
                          ),
                          SizedBox(height: Dimensions.height10 / 2),
                          Text(
                            'Tap the + button to create a new vendor credit.',
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
                      itemBuilder: (context, index) => VendorCreditTile(
                        credit: visibleList[index],
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => VendorCreditDetailsPage(
                              credit: visibleList[index],
                            ),
                          ),
                        ),
                      ),
                    ),
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
        size: Dimensions.iconSize24 - 4,
        color: active ? AppColors.accent : AppColors.primary,
      ),
    );
  }
}
