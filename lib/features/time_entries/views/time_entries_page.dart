import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/core/widgets/custom_add_button.dart';
import 'package:custom_books/features/drawer/views/custom_drawer.dart';
import 'package:custom_books/features/time_entries/models/time_entry_model.dart';
import 'package:custom_books/features/time_entries/views/add_time_entry_page.dart';
import 'package:custom_books/features/time_entries/views/time_entry_details_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeEntriesPage extends StatefulWidget {
  const TimeEntriesPage({super.key});

  @override
  State<TimeEntriesPage> createState() => _TimeEntriesPageState();
}

class _TimeEntriesPageState extends State<TimeEntriesPage> {
  final TextEditingController _searchController = TextEditingController();

  int _selectedTab = 0; // 0: All, 1: Billable, 2: Non-billable
  final bool _searchOpen = false;
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
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.all(Dimensions.width20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Filter by Type',
                  style: TextStyle(
                    fontSize: Dimensions.font20 * 0.85,
                    fontWeight: FontWeight.w800,
                    color: context.colors.textPrimary,
                  ),
                ),
                SizedBox(height: Dimensions.height15),
                _filterOption('All Types', null),
                _filterOption('Billable', true),
                _filterOption('Non-billable', false),
                SizedBox(height: Dimensions.height10),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _filterOption(String label, bool? value) {
    final selected = _billableFilter == value;
    return InkWell(
      borderRadius: BorderRadius.circular(Dimensions.radius15),
      onTap: () {
        setState(() => _billableFilter = value);
        Navigator.pop(context);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: Dimensions.height10 / 2),
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.width15,
          vertical: Dimensions.height10,
        ),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withValues(alpha: 0.08)
              : context.colors.surfaceLight,
          borderRadius: BorderRadius.circular(Dimensions.radius15),
          border: Border.all(
            color: selected ? AppColors.primary : context.colors.border,
          ),
        ),
        child: Row(
          children: [
            Icon(
              selected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_off_rounded,
              size: Dimensions.iconSize16 + 2,
              color: selected ? AppColors.primary : context.colors.textTertiary,
            ),
            SizedBox(width: Dimensions.width10),
            Text(
              label,
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.8,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: context.colors.textPrimary,
              ),
            ),
          ],
        ),
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
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheet) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.all(Dimensions.width20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sort By',
                      style: TextStyle(
                        fontSize: Dimensions.font20 * 0.85,
                        fontWeight: FontWeight.w800,
                        color: context.colors.textPrimary,
                      ),
                    ),
                    SizedBox(height: Dimensions.height15),
                    ...TimeEntrySortField.values.map((field) {
                      final selected = _sortField == field;
                      return InkWell(
                        borderRadius: BorderRadius.circular(
                          Dimensions.radius15,
                        ),
                        onTap: () {
                          setState(() => _sortField = field);
                          setSheet(() {});
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                            bottom: Dimensions.height10 / 2,
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.width15,
                            vertical: Dimensions.height10,
                          ),
                          decoration: BoxDecoration(
                            color: selected
                                ? AppColors.primary.withValues(alpha: 0.08)
                                : context.colors.surfaceLight,
                            borderRadius: BorderRadius.circular(
                              Dimensions.radius15,
                            ),
                            border: Border.all(
                              color: selected
                                  ? AppColors.primary
                                  : context.colors.border,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                selected
                                    ? Icons.radio_button_checked_rounded
                                    : Icons.radio_button_off_rounded,
                                size: Dimensions.iconSize16 + 2,
                                color: selected
                                    ? AppColors.primary
                                    : context.colors.textTertiary,
                              ),
                              SizedBox(width: Dimensions.width10),
                              Text(
                                field.label,
                                style: TextStyle(
                                  fontSize: Dimensions.font16 * 0.8,
                                  fontWeight: selected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  color: context.colors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                    SizedBox(height: Dimensions.height10),
                    Row(
                      children: [
                        Expanded(
                          child: _directionButton(
                            'Ascending',
                            Icons.arrow_upward_rounded,
                            SortDirection.ascending,
                            setSheet,
                          ),
                        ),
                        SizedBox(width: Dimensions.width10),
                        Expanded(
                          child: _directionButton(
                            'Descending',
                            Icons.arrow_downward_rounded,
                            SortDirection.descending,
                            setSheet,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Dimensions.height10),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _directionButton(
    String label,
    IconData icon,
    SortDirection direction,
    StateSetter setSheet,
  ) {
    final selected = _sortDirection == direction;
    return InkWell(
      borderRadius: BorderRadius.circular(Dimensions.radius15),
      onTap: () {
        setState(() => _sortDirection = direction);
        setSheet(() {});
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: Dimensions.height10),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withValues(alpha: 0.08)
              : context.colors.surfaceLight,
          borderRadius: BorderRadius.circular(Dimensions.radius15),
          border: Border.all(
            color: selected ? AppColors.primary : context.colors.border,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: Dimensions.iconSize16 + 2,
              color: selected ? AppColors.primary : context.colors.textTertiary,
            ),
            SizedBox(width: Dimensions.width10 / 2),
            Text(
              label,
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.75,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected
                    ? AppColors.primary
                    : context.colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);
    final visibleList = _visibleEntries;

    return Scaffold(
      backgroundColor: context.colors.background,
      drawer: const DrawerView(currentRoute: 'time_entries'),
      floatingActionButton: CustomAddButton(onPressed: _addNewEntry),
      body: Column(
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
                  hintText: 'Search by task, project or user',
                  hintStyle: TextStyle(color: context.colors.textTertiary),
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
                    borderRadius: BorderRadius.circular(Dimensions.radius15),
                    borderSide: BorderSide(color: context.colors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Dimensions.radius15),
                    borderSide: BorderSide(color: context.colors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Dimensions.radius15),
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
                    padding: EdgeInsets.all(Dimensions.height10 * 0.4),
                    decoration: BoxDecoration(
                      color: context.colors.surfaceLight,
                      borderRadius: BorderRadius.circular(Dimensions.radius30),
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
          Expanded(
            child: visibleList.isEmpty
                ? _emptyState()
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
                          _entryTile(visibleList[index]),
                    ),
                  ),
          ),
        ],
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

  Widget _entryTile(TimeEntryModel entry) {
    return InkWell(
      borderRadius: BorderRadius.circular(Dimensions.radius15),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TimeEntryDetailsPage(entry: entry),
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
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(Dimensions.radius15 - 4),
              ),
              child: Icon(
                Icons.access_time_rounded,
                color: AppColors.primary,
                size: Dimensions.iconSize24 - 4,
              ),
            ),
            SizedBox(width: Dimensions.width15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.taskName,
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
                        Icons.folder_open_rounded,
                        size: Dimensions.iconSize16 - 2,
                        color: context.colors.textTertiary,
                      ),
                      SizedBox(width: Dimensions.width10 / 2),
                      Flexible(
                        child: Text(
                          entry.projectName,
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
                        DateFormat('dd MMM yyyy').format(entry.logDate),
                        style: TextStyle(
                          fontSize: Dimensions.font16 * 0.7,
                          color: context.colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Dimensions.height10 / 2),
                  _billableChip(entry.isBillable),
                ],
              ),
            ),
            SizedBox(width: Dimensions.width10),
            Text(
              entry.durationLabel,
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.9,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _billableChip(bool isBillable) {
    final color = isBillable ? AppColors.success : context.colors.textTertiary;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.width10,
        vertical: Dimensions.height10 * 0.2,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(Dimensions.radius30),
      ),
      child: Text(
        isBillable ? 'BILLABLE' : 'NON-BILLABLE',
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
