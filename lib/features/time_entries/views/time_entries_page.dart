import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/core/widgets/custom_add_button.dart';
import 'package:custom_books/core/widgets/custom_search_field.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/features/drawer/views/custom_drawer.dart';
import 'package:custom_books/features/time_entries/models/time_entry_model.dart';
import 'package:custom_books/features/time_entries/views/add_time_entry_page.dart';
import 'package:custom_books/features/time_entries/views/time_entry_details_page.dart';
import 'package:custom_books/features/time_entries/widgets/time_entry_filter_sheet.dart';
import 'package:custom_books/features/time_entries/widgets/time_entry_sort_sheet.dart';
import 'package:custom_books/features/time_entries/widgets/time_entry_page_widgets.dart';
import 'package:flutter/material.dart';
import 'package:custom_books/core/enums/sort_direction.dart';

class TimeEntriesPage extends StatefulWidget {
  const TimeEntriesPage({super.key});

  @override
  State<TimeEntriesPage> createState() => _TimeEntriesPageState();
}

class _TimeEntriesPageState extends State<TimeEntriesPage> {
  final TextEditingController _searchController = TextEditingController();

  int _selectedTab = 0; // 0: All, 1: Billable, 2: Non-billable
  bool _searchOpen = false;
  bool? _billableFilter;
  TimeEntrySortField _sortField = TimeEntrySortField.createdTime;
  SortDirection _sortDirection = SortDirection.descending;

  late List<TimeEntryModel> _entries;

  @override
  void initState() {
    super.initState();
    _entries = [
      TimeEntryModel(
        id: '1',
        projectName: 'Website Redesign',
        taskName: 'Homepage layout',
        userName: 'Nandhu',
        logDate: DateTime(2026, 7, 3),
        durationMinutes: 150,
        isBillable: true,
        notes: 'Wireframes and hero section',
        createdAt: DateTime(2026, 7, 3, 10, 0),
        updatedAt: DateTime(2026, 7, 3, 10, 0),
      ),
      TimeEntryModel(
        id: '2',
        projectName: 'Mobile App Development',
        taskName: 'API integration',
        userName: 'Parthiv Ajith',
        logDate: DateTime(2026, 7, 2),
        durationMinutes: 320,
        isBillable: true,
        notes: 'Auth endpoints',
        createdAt: DateTime(2026, 7, 2, 9, 30),
        updatedAt: DateTime(2026, 7, 2, 9, 30),
      ),
      TimeEntryModel(
        id: '3',
        projectName: 'Brand Identity',
        taskName: 'Internal review',
        userName: 'Nandhu',
        logDate: DateTime(2026, 6, 30),
        durationMinutes: 45,
        isBillable: false,
        notes: 'Team sync',
        createdAt: DateTime(2026, 6, 30, 14, 0),
        updatedAt: DateTime(2026, 6, 30, 14, 0),
      ),
      TimeEntryModel(
        id: '4',
        projectName: 'SEO Audit',
        taskName: 'Keyword research',
        userName: 'Aravind',
        logDate: DateTime(2026, 6, 28),
        durationMinutes: 90,
        isBillable: false,
        notes: '',
        createdAt: DateTime(2026, 6, 28, 11, 15),
        updatedAt: DateTime(2026, 6, 28, 11, 15),
      ),
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<TimeEntryModel> get _visibleEntries {
    final query = _searchController.text.trim().toLowerCase();
    final list = _entries.where((entry) {
      if (_selectedTab == 1 && !entry.isBillable) return false;
      if (_selectedTab == 2 && entry.isBillable) return false;
      if (_billableFilter != null && entry.isBillable != _billableFilter) {
        return false;
      }
      return query.isEmpty ||
          entry.taskName.toLowerCase().contains(query) ||
          entry.projectName.toLowerCase().contains(query) ||
          entry.userName.toLowerCase().contains(query);
    }).toList();

    list.sort((a, b) {
      int result;
      switch (_sortField) {
        case TimeEntrySortField.createdTime:
          result = a.createdAt.compareTo(b.createdAt);
        case TimeEntrySortField.date:
          result = a.logDate.compareTo(b.logDate);
        case TimeEntrySortField.projectName:
          result = a.projectName.toLowerCase().compareTo(
            b.projectName.toLowerCase(),
          );
        case TimeEntrySortField.duration:
          result = a.durationMinutes.compareTo(b.durationMinutes);
      }
      return _sortDirection == SortDirection.ascending ? result : -result;
    });

    return list;
  }

  Future<void> _addNewEntry() async {
    final result = await Navigator.push<TimeEntryModel>(
      context,
      MaterialPageRoute(builder: (_) => const AddTimeEntryPage()),
    );
    if (result != null && mounted) {
      setState(() => _entries.insert(0, result));
      ToastificationHelper.showSuccess(
        context,
        'Time entry created successfully',
      );
    }
  }

  void _openFilterSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.colors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Dimensions.radius20),
        ),
      ),
      builder: (_) => TimeEntryFilterSheet(
        selectedBillable: _billableFilter,
        onSelected: (value) => setState(() => _billableFilter = value),
      ),
    );
  }

  void _openSortSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.colors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Dimensions.radius20),
        ),
      ),
      builder: (_) => TimeEntrySortSheet(
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
    final visibleList = _visibleEntries;

    return Scaffold(
      backgroundColor: context.colors.background,
      drawer: const DrawerView(currentRoute: 'time_entries'),
      floatingActionButton: CustomAddButton(onPressed: _addNewEntry),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // App Bar
            CustomSliverAppBar(
              title: 'Time Entries',
              subtitle:
                  '${visibleList.length} entr${visibleList.length == 1 ? 'y' : 'ies'}',
              leadingType: AppBarLeadingType.menu,
              actions: [
                AppBarIconButton(
                  icon: _searchOpen
                      ? Icons.close_rounded
                      : Icons.search_rounded,
                  color: AppColors.primary,
                  onPressed: () {
                    setState(() {
                      _searchOpen = !_searchOpen;
                      if (!_searchOpen) _searchController.clear();
                    });
                  },
                ),
                SizedBox(width: Dimensions.width20),
              ],
            ),

            // Search Field
            if (_searchOpen)
              SliverToBoxAdapter(
                child: ListSearchField(
                  controller: _searchController,
                  hintText: 'Search by task, project or user',
                  onChanged: (_) => setState(() {}),
                  topPadding: 0,
                ),
              ),

            // Filter / Sort bar
            SliverToBoxAdapter(
              child: Padding(
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
                            _tabButton('Billable', 1),
                            _tabButton('Non-billable', 2),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: Dimensions.width10),
                    InkWell(
                      borderRadius: BorderRadius.circular(Dimensions.radius15),
                      onTap: _openFilterSheet,
                      child: _controlBadge(
                        _billableFilter == null
                            ? Icons.filter_list_rounded
                            : Icons.filter_alt_rounded,
                        active: _billableFilter != null,
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
            ),

            // List or empty state
            if (visibleList.isEmpty)
              SliverFillRemaining(child: _emptyState())
            else
              SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  Dimensions.width20,
                  0,
                  Dimensions.width20,
                  Dimensions.listBottomSpace,
                ),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => TimeEntryTile(
                      entry: visibleList[index],
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TimeEntryDetailsPage(entry: visibleList[index]),
                        ),
                      ),
                    ),
                    childCount: visibleList.length,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
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
                Icons.access_time_rounded,
                size: Dimensions.iconSize24 * 1.3,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: Dimensions.height15),
            Text(
              'No time entries found',
              style: TextStyle(
                fontSize: Dimensions.font16,
                fontWeight: FontWeight.w700,
                color: context.colors.textPrimary,
              ),
            ),
            SizedBox(height: Dimensions.height10 / 2),
            Text(
              'Tap the + button to log time.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.75,
                color: context.colors.textSecondary,
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
          _billableFilter = null;
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
              fontSize: Dimensions.font16 * 0.68,
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
