import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/core/widgets/active_filter_banner.dart';
import 'package:custom_books/core/widgets/custom_add_button.dart';
import 'package:custom_books/core/widgets/custom_search_field.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/core/widgets/empty_state_widget.dart';
import 'package:custom_books/core/widgets/list_control_bar.dart';
import 'package:custom_books/features/drawer/views/custom_drawer.dart';
import 'package:custom_books/features/vendor_credits/models/vendor_credit_model.dart';
import 'package:custom_books/features/vendor_credits/views/add_vendor_credit_page.dart';
import 'package:custom_books/features/vendor_credits/views/vendor_credit_details_page.dart';
import 'package:custom_books/features/vendor_credits/widgets/vendor_credit_filter_sheet.dart';
import 'package:custom_books/features/vendor_credits/widgets/vendor_credit_sort_sheet.dart';
import 'package:custom_books/features/vendor_credits/widgets/vendor_credit_page_widgets.dart';
import 'package:custom_books/core/widgets/more_options_sheet.dart';
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

  void _showMoreOptions() {
    MoreOptionsSheet.show(
      context,
      sectionLabel: 'VENDOR CREDIT ACTIONS',
      items: [
        MoreOptionsItem(
          icon: Icons.file_download_outlined,
          title: 'Export Vendor Credits',
          subtitle: 'Export the current vendor credit list',
          onTap: () => ToastificationHelper.showSuccess(
            context,
            'Vendor credits exported',
          ),
        ),
        MoreOptionsItem(
          icon: Icons.refresh_rounded,
          title: 'Refresh',
          subtitle: 'Reload the latest vendor credits',
          onTap: () => setState(() {}),
        ),
      ],
    );
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
                onPressed: _showMoreOptions,
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
                    hintText: 'Search by vendor, credit note or reference',
                    onChanged: (_) => setState(() {}),
                  ),
                ListControlBar(
                  tabs: const ['All', 'Open', 'Closed'],
                  selectedTab: _selectedTab,
                  onTabSelected: (i) => setState(() {
                    _selectedTab = i;
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
              ],
            ),
          ),
          SliverFillRemaining(
            child: visibleList.isEmpty
                ? const EmptyStateWidget(
                    icon: Icons.assignment_return_outlined,
                    title: 'No vendor credits found',
                    subtitle: 'Tap the + button to create a new vendor credit.',
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
}
