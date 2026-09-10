import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/core/widgets/active_filter_banner.dart';
import 'package:custom_books/core/widgets/custom_add_button.dart';
import 'package:custom_books/core/widgets/custom_search_field.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/core/widgets/empty_state_widget.dart';
import 'package:custom_books/core/widgets/filter_sheet.dart';
import 'package:custom_books/core/widgets/generic_sort_sheet.dart';
import 'package:custom_books/core/widgets/list_control_bar.dart';
import 'package:custom_books/features/drawer/views/custom_drawer.dart';
import 'package:custom_books/features/recurring_invoices/models/recurring_invoice_model.dart';
import 'package:custom_books/features/recurring_invoices/views/add_recurring_invoice_page.dart';
import 'package:custom_books/features/recurring_invoices/views/recurring_invoice_details_page.dart';
import 'package:custom_books/features/recurring_invoices/widgets/recurring_invoice_page_widgets.dart';
import 'package:custom_books/core/widgets/more_options_sheet.dart';
import 'package:flutter/material.dart';
import 'package:custom_books/core/enums/sort_direction.dart';

class RecurringInvoicesPage extends StatefulWidget {
  const RecurringInvoicesPage({super.key});

  @override
  State<RecurringInvoicesPage> createState() => _RecurringInvoicesPageState();
}

class _RecurringInvoicesPageState extends State<RecurringInvoicesPage> {
  final TextEditingController _searchController = TextEditingController();

  int _selectedTab = 0; // 0: All, 1: Active, 2: Stopped
  bool _searchOpen = false;
  RecurringInvoiceStatus? _statusFilter;
  RecurringInvoiceSortField _sortField = RecurringInvoiceSortField.createdTime;
  SortDirection _sortDirection = SortDirection.descending;

  late List<RecurringInvoiceModel> _profiles;

  @override
  void initState() {
    super.initState();
    _profiles = [
      RecurringInvoiceModel(
        id: '1',
        profileName: 'Monthly Retainer - Nandhu',
        customerName: 'Nandhu',
        frequency: RecurringFrequency.monthly,
        startDate: DateTime(2026, 1, 1),
        status: RecurringInvoiceStatus.active,
        amount: 1500.00,
        createdAt: DateTime(2026, 1, 1, 9, 0),
        updatedAt: DateTime(2026, 1, 1, 9, 0),
      ),
      RecurringInvoiceModel(
        id: '2',
        profileName: 'Quarterly Support - Parthiv',
        customerName: 'Parthiv Ajith',
        frequency: RecurringFrequency.quarterly,
        startDate: DateTime(2026, 2, 15),
        status: RecurringInvoiceStatus.stopped,
        amount: 4200.00,
        createdAt: DateTime(2026, 2, 15, 11, 30),
        updatedAt: DateTime(2026, 2, 15, 11, 30),
      ),
      RecurringInvoiceModel(
        id: '3',
        profileName: 'Weekly Cleaning - Aisha',
        customerName: 'Aisha Traders',
        frequency: RecurringFrequency.weekly,
        startDate: DateTime(2026, 3, 3),
        status: RecurringInvoiceStatus.active,
        amount: 350.00,
        createdAt: DateTime(2026, 3, 3, 8, 0),
        updatedAt: DateTime(2026, 3, 3, 8, 0),
      ),
      RecurringInvoiceModel(
        id: '4',
        profileName: 'Annual License - Gulf Retail',
        customerName: 'Gulf Retail LLC',
        frequency: RecurringFrequency.yearly,
        startDate: DateTime(2025, 12, 1),
        status: RecurringInvoiceStatus.expired,
        amount: 12000.00,
        createdAt: DateTime(2025, 12, 1, 15, 0),
        updatedAt: DateTime(2025, 12, 1, 15, 0),
      ),
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<RecurringInvoiceModel> get _visibleProfiles {
    final query = _searchController.text.trim().toLowerCase();
    final list = _profiles.where((profile) {
      if (_selectedTab == 1 &&
          profile.status != RecurringInvoiceStatus.active) {
        return false;
      }
      if (_selectedTab == 2 &&
          profile.status != RecurringInvoiceStatus.stopped) {
        return false;
      }
      if (_statusFilter != null && profile.status != _statusFilter) {
        return false;
      }
      return query.isEmpty ||
          profile.customerName.toLowerCase().contains(query) ||
          profile.profileName.toLowerCase().contains(query);
    }).toList();

    list.sort((a, b) {
      int result;
      switch (_sortField) {
        case RecurringInvoiceSortField.createdTime:
          result = a.createdAt.compareTo(b.createdAt);
        case RecurringInvoiceSortField.profileName:
          result = a.profileName.toLowerCase().compareTo(
            b.profileName.toLowerCase(),
          );
        case RecurringInvoiceSortField.customerName:
          result = a.customerName.toLowerCase().compareTo(
            b.customerName.toLowerCase(),
          );
        case RecurringInvoiceSortField.amount:
          result = a.amount.compareTo(b.amount);
      }
      return _sortDirection == SortDirection.ascending ? result : -result;
    });

    return list;
  }

  Future<void> _addNewProfile() async {
    final result = await Navigator.push<RecurringInvoiceModel>(
      context,
      MaterialPageRoute(builder: (_) => const AddRecurringInvoicePage()),
    );
    if (result != null && mounted) {
      setState(() => _profiles.insert(0, result));
      ToastificationHelper.showSuccess(
        context,
        '${result.profileName} created successfully',
      );
    }
  }

  void _showMoreOptions() {
    MoreOptionsSheet.show(
      context,
      sectionLabel: 'RECURRING INVOICE ACTIONS',
      items: [
        MoreOptionsItem(
          icon: Icons.file_download_outlined,
          title: 'Export Profiles',
          subtitle: 'Export the current recurring invoice profiles',
          onTap: () => ToastificationHelper.showSuccess(
            context,
            'Recurring invoice profiles exported',
          ),
        ),
        MoreOptionsItem(
          icon: Icons.refresh_rounded,
          title: 'Refresh',
          subtitle: 'Reload the latest recurring invoice profiles',
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
      builder: (_) => FilterSheet<RecurringInvoiceStatus>(
        title: 'Filter',
        options: const [null, ...RecurringInvoiceStatus.values],
        selectedValue: _statusFilter,
        labelBuilder: (status) => status?.label ?? 'All Statuses',
        onSelected: (status) => setState(() => _statusFilter = status),
      ),
    );
  }

  void _openSortSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => GenericSortSheet<RecurringInvoiceSortField>(
        fields: RecurringInvoiceSortField.values,
        initialField: _sortField,
        initialDirection: _sortDirection,
        labelBuilder: (f) => f.label,
        onApply: (field, direction) => setState(() {
          _sortField = field;
          _sortDirection = direction;
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final visibleList = _visibleProfiles;

    return Scaffold(
      backgroundColor: context.colors.background,
      drawer: const DrawerView(currentRoute: 'recurring_invoices'),
      floatingActionButton: CustomAddButton(onPressed: _addNewProfile),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          CustomSliverAppBar(
            title: 'Recurring Invoices',
            subtitle:
                '${_profiles.length} profile${_profiles.length == 1 ? '' : 's'}',
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
                    hintText: 'Search by profile or customer',
                    onChanged: (_) => setState(() {}),
                  ),
                ListControlBar(
                  tabs: const ['All', 'Active', 'Stopped'],
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
                    icon: Icons.autorenew_rounded,
                    title: 'No recurring invoices found',
                    subtitle: 'Tap the + button to create a new profile.',
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
                      itemBuilder: (context, index) => RecurringInvoiceTile(
                        profile: visibleList[index],
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecurringInvoiceDetailsPage(
                              profile: visibleList[index],
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
