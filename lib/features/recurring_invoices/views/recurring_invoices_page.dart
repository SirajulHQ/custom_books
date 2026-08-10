import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/core/widgets/custom_add_button.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/features/drawer/views/custom_drawer.dart';
import 'package:custom_books/features/recurring_invoices/models/recurring_invoice_model.dart';
import 'package:custom_books/features/recurring_invoices/views/add_recurring_invoice_page.dart';
import 'package:custom_books/features/recurring_invoices/views/recurring_invoice_details_page.dart';
import 'package:flutter/material.dart';

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
      builder: (context) {
        final options = <RecurringInvoiceStatus?>[
          null,
          ...RecurringInvoiceStatus.values,
        ];
        return SafeArea(
          top: false,
          child: Container(
            decoration: BoxDecoration(
              color: context.colors.card,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(Dimensions.radius20),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: EdgeInsets.symmetric(vertical: Dimensions.height10),
                  decoration: BoxDecoration(
                    color: context.colors.border,
                    borderRadius: BorderRadius.circular(Dimensions.radius30),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.width20,
                    vertical: Dimensions.height10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Filter',
                        style: TextStyle(
                          fontSize: Dimensions.font20,
                          fontWeight: FontWeight.bold,
                          color: context.colors.textPrimary,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(
                          Icons.close_rounded,
                          size: Dimensions.iconSize24,
                          color: context.colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(
                      Dimensions.width20,
                      Dimensions.height10,
                      Dimensions.width20,
                      Dimensions.height20,
                    ),
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      final status = options[index];
                      final selected = status == _statusFilter;
                      return GestureDetector(
                        onTap: () {
                          setState(() => _statusFilter = status);
                          Navigator.pop(context);
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: Dimensions.height10),
                          padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.width15,
                            vertical: Dimensions.height15,
                          ),
                          decoration: BoxDecoration(
                            color: selected
                                ? Appcolors.primary.withValues(alpha: 0.05)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(
                              Dimensions.radius15,
                            ),
                            border: Border.all(
                              color: selected
                                  ? Appcolors.primary
                                  : context.colors.border,
                              width: selected ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                status?.label ?? 'All Statuses',
                                style: TextStyle(
                                  fontSize: Dimensions.font16,
                                  fontWeight: selected
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                                  color: selected
                                      ? Appcolors.primary
                                      : context.colors.textPrimary,
                                ),
                              ),
                              if (selected)
                                Icon(
                                  Icons.check_circle_rounded,
                                  color: Appcolors.primary,
                                  size: Dimensions.iconSize24,
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openSortSheet() {
    var field = _sortField;
    var direction = _sortDirection;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              decoration: BoxDecoration(
                color: context.colors.card,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    margin: EdgeInsets.symmetric(vertical: Dimensions.height10),
                    decoration: BoxDecoration(
                      color: context.colors.border,
                      borderRadius: BorderRadius.circular(Dimensions.radius30),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.width20,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Sort by',
                          style: TextStyle(
                            fontSize: Dimensions.font20,
                            fontWeight: FontWeight.w800,
                            color: context.colors.textPrimary,
                          ),
                        ),
                        InkWell(
                          borderRadius: BorderRadius.circular(
                            Dimensions.radius15,
                          ),
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: EdgeInsets.all(Dimensions.width10 * 0.6),
                            decoration: BoxDecoration(
                              color: Appcolors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(
                                Dimensions.radius15,
                              ),
                            ),
                            child: Icon(
                              Icons.close_rounded,
                              size: Dimensions.iconSize16,
                              color: Appcolors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: Dimensions.height15),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.width20,
                    ),
                    child: Column(
                      children: RecurringInvoiceSortField.values.map((f) {
                        final selected = f == field;
                        return Padding(
                          padding: EdgeInsets.only(bottom: Dimensions.height10),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(
                              Dimensions.radius15,
                            ),
                            onTap: () {
                              setSheetState(() {
                                if (field == f) {
                                  direction =
                                      direction == SortDirection.ascending
                                      ? SortDirection.descending
                                      : SortDirection.ascending;
                                } else {
                                  field = f;
                                  direction = SortDirection.descending;
                                }
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: Dimensions.width15,
                                vertical: Dimensions.height15 * 0.75,
                              ),
                              decoration: BoxDecoration(
                                color: selected
                                    ? Appcolors.primary.withValues(alpha: 0.06)
                                    : context.colors.card,
                                borderRadius: BorderRadius.circular(
                                  Dimensions.radius15,
                                ),
                                border: Border.all(
                                  color: selected
                                      ? Appcolors.primary
                                      : context.colors.border,
                                  width: selected ? 1.5 : 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    selected
                                        ? Icons.radio_button_checked_rounded
                                        : Icons.radio_button_off_rounded,
                                    size: Dimensions.iconSize24 - 4,
                                    color: selected
                                        ? Appcolors.primary
                                        : context.colors.textTertiary,
                                  ),
                                  SizedBox(width: Dimensions.width10),
                                  Expanded(
                                    child: Text(
                                      f.label,
                                      style: TextStyle(
                                        fontSize: Dimensions.font16 * 0.9,
                                        fontWeight: selected
                                            ? FontWeight.w700
                                            : FontWeight.w500,
                                        color: context.colors.textPrimary,
                                      ),
                                    ),
                                  ),
                                  if (selected)
                                    Icon(
                                      direction == SortDirection.ascending
                                          ? Icons.arrow_upward_rounded
                                          : Icons.arrow_downward_rounded,
                                      size: Dimensions.iconSize16,
                                      color: Appcolors.primary,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: Dimensions.height15),
                  Container(
                    padding: EdgeInsets.fromLTRB(
                      Dimensions.width20,
                      Dimensions.height15,
                      Dimensions.width20,
                      Dimensions.height20,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: context.colors.border),
                      ),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _sortField = field;
                            _sortDirection = direction;
                          });
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Appcolors.primary,
                          side: const BorderSide(
                            color: Appcolors.primary,
                            width: 1.5,
                          ),
                          backgroundColor: Colors.transparent,
                          padding: EdgeInsets.symmetric(
                            vertical: Dimensions.height15 * 0.9,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              Dimensions.radius15,
                            ),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Sort',
                          style: TextStyle(
                            fontSize: Dimensions.font16 * 0.9,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);
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
                color: Appcolors.accent,
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
                        hintText: 'Search by profile or customer',
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
                            color: Appcolors.primary,
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
                          padding: const EdgeInsets.all(4),
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
                      color: Appcolors.primary.withValues(alpha: 0.07),
                      borderRadius: BorderRadius.circular(Dimensions.radius15),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.filter_alt_rounded,
                          size: Dimensions.iconSize16,
                          color: Appcolors.primary,
                        ),
                        SizedBox(width: Dimensions.width10 / 2),
                        Text(
                          'Status: ${_statusFilter!.label}',
                          style: TextStyle(
                            fontSize: Dimensions.font16 * 0.72,
                            fontWeight: FontWeight.w600,
                            color: Appcolors.primary,
                          ),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () => setState(() => _statusFilter = null),
                          child: Icon(
                            Icons.close_rounded,
                            size: Dimensions.iconSize16,
                            color: Appcolors.primary,
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
                              color: Appcolors.primary.withValues(alpha: 0.08),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.autorenew_rounded,
                              size: Dimensions.iconSize24 * 1.3,
                              color: Appcolors.primary,
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
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.width20,
                      ),
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      itemCount: visibleList.length,
                      itemBuilder: (context, index) =>
                          _profileTile(visibleList[index]),
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
                    color: Appcolors.primary.withValues(alpha: 0.3),
                    width: 1.5,
                  )
                : null,
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: Appcolors.primary.withValues(alpha: 0.08),
                      blurRadius: 8,
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
                  ? Appcolors.primary
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
        color: (active ? Appcolors.accent : Appcolors.primary).withValues(
          alpha: 0.1,
        ),
        borderRadius: BorderRadius.circular(Dimensions.radius15),
      ),
      child: Icon(
        icon,
        size: Dimensions.iconSize24 - 4,
        color: active ? Appcolors.accent : Appcolors.primary,
      ),
    );
  }

  Widget _profileTile(RecurringInvoiceModel profile) {
    return InkWell(
      borderRadius: BorderRadius.circular(Dimensions.radius15),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RecurringInvoiceDetailsPage(profile: profile),
        ),
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
              decoration: BoxDecoration(
                color: Appcolors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(Dimensions.radius15 - 4),
              ),
              child: Icon(
                Icons.autorenew_rounded,
                color: Appcolors.primary,
                size: Dimensions.iconSize24 - 4,
              ),
            ),
            SizedBox(width: Dimensions.width15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile.profileName,
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
                        Icons.person_outline_rounded,
                        size: Dimensions.iconSize16 - 2,
                        color: context.colors.textTertiary,
                      ),
                      SizedBox(width: Dimensions.width10 / 2),
                      Flexible(
                        child: Text(
                          profile.customerName,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: Dimensions.font16 * 0.7,
                            color: context.colors.textSecondary,
                          ),
                        ),
                      ),
                      Text(
                        '  •  ',
                        style: TextStyle(
                          fontSize: Dimensions.font16 * 0.7,
                          color: context.colors.textTertiary,
                        ),
                      ),
                      Text(
                        profile.frequency.label,
                        style: TextStyle(
                          fontSize: Dimensions.font16 * 0.7,
                          color: context.colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Dimensions.height10 / 2),
                  _statusChip(profile.status),
                ],
              ),
            ),
            SizedBox(width: Dimensions.width10),
            Text(
              '₹${profile.amount.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.9,
                fontWeight: FontWeight.w800,
                color: Appcolors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusChip(RecurringInvoiceStatus status) {
    final color = switch (status) {
      RecurringInvoiceStatus.active => Appcolors.success,
      RecurringInvoiceStatus.stopped => Appcolors.error,
      RecurringInvoiceStatus.expired => Appcolors.warning,
      RecurringInvoiceStatus.draft => Colors.grey,
    };
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.width10,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(Dimensions.radius30),
      ),
      child: Text(
        status.label.toUpperCase(),
        style: TextStyle(
          fontSize: Dimensions.font16 * 0.6,
          color: color,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
