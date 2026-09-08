import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/core/widgets/custom_add_button.dart';
import 'package:custom_books/core/widgets/custom_search_field.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/features/drawer/views/custom_drawer.dart';
import 'package:custom_books/features/recurring_invoices/models/recurring_invoice_model.dart';
import 'package:custom_books/features/recurring_invoices/views/add_recurring_invoice_page.dart';
import 'package:custom_books/features/recurring_invoices/views/recurring_invoice_details_page.dart';
import 'package:custom_books/features/recurring_invoices/widgets/recurring_invoice_filter_sheet.dart';
import 'package:custom_books/features/recurring_invoices/widgets/recurring_invoice_sort_sheet.dart';
import 'package:custom_books/features/recurring_invoices/widgets/recurring_invoice_page_widgets.dart';
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

  void _openFilterSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => RecurringInvoiceFilterSheet(
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
      builder: (_) => RecurringInvoiceSortSheet(
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
                    hintText: 'Search by profile or customer',
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
                              _tabButton('Active', 1),
                              _tabButton('Stopped', 2),
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
                              Icons.autorenew_rounded,
                              size: Dimensions.iconSize24 * 1.3,
                              color: AppColors.primary,
                            ),
                          ),
                          SizedBox(height: Dimensions.height15),
                          Text(
                            'No recurring invoices found',
                            style: TextStyle(
                              fontSize: Dimensions.font16,
                              fontWeight: FontWeight.w700,
                              color: context.colors.textPrimary,
                            ),
                          ),
                          SizedBox(height: Dimensions.height10 / 2),
                          Text(
                            'Tap the + button to create a new profile.',
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
