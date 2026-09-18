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
import 'package:custom_books/core/widgets/skeletons/skeletons.dart';
import 'package:custom_books/features/drawer/views/custom_drawer.dart';
import 'package:custom_books/features/time_entries/models/time_entry_model.dart';
import 'package:custom_books/features/time_entries/views/add_time_entry_page.dart';
import 'package:custom_books/features/time_entries/views/time_entry_details_page.dart';
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
  bool _isLoading = true;
  bool? _billableFilter;
  TimeEntrySortField _sortField = TimeEntrySortField.createdTime;
  SortDirection _sortDirection = SortDirection.descending;

  late List<TimeEntryModel> _entries;

  @override
  void initState() {
    super.initState();
    _loadEntries();
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

  /// Simulates fetching data so the shimmer skeleton is shown briefly.
  Future<void> _loadEntries() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _isLoading = false);
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
      builder: (_) => FilterSheet<bool>(
        title: 'Filter by Type',
        compact: true,
        style: FilterOptionStyle.radio,
        options: const [null, true, false],
        selectedValue: _billableFilter,
        labelBuilder: (b) =>
            b == null ? 'All Entries' : (b ? 'BILLABLE' : 'NON-BILLABLE'),
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
      builder: (_) => GenericSortSheet<TimeEntrySortField>(
        fields: TimeEntrySortField.values,
        initialField: _sortField,
        initialDirection: _sortDirection,
        labelBuilder: (f) => f.label,
        onApply: (field, direction) => setState(() {
          _sortField = field;
          _sortDirection = direction;
        }),
        compact: true,
        buttonLabel: 'Apply',
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
              child: ListControlBar(
                tabs: const ['All', 'Billable', 'Non-billable'],
                selectedTab: _selectedTab,
                onTabSelected: (index) => setState(() {
                  _selectedTab = index;
                  _billableFilter = null;
                }),
                filterActive: _billableFilter != null,
                onFilterTap: _openFilterSheet,
                onSortTap: _openSortSheet,
              ),
            ),

            // Active billable filter banner
            if (_billableFilter != null)
              SliverToBoxAdapter(
                child: ActiveFilterBanner(
                  label: _billableFilter! ? 'Billable: Yes' : 'Billable: No',
                  onClear: () => setState(() => _billableFilter = null),
                ),
              ),

            // List or empty state
            if (_isLoading)
              const SliverFillRemaining(
                hasScrollBody: true,
                child: DocumentListSkeleton(),
              )
            else if (visibleList.isEmpty)
              const SliverFillRemaining(
                child: EmptyStateWidget(
                  icon: Icons.access_time_rounded,
                  title: 'No time entries found',
                  subtitle: 'Tap the + button to log time.',
                ),
              )
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
}
