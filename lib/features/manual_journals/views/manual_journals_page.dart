import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/core/widgets/custom_add_button.dart';
import 'package:custom_books/core/widgets/custom_search_field.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/features/drawer/views/custom_drawer.dart';
import 'package:custom_books/features/manual_journals/models/manual_journal_model.dart';
import 'package:custom_books/features/manual_journals/views/add_manual_journal_page.dart';
import 'package:custom_books/features/manual_journals/views/manual_journal_details_page.dart';
import 'package:custom_books/features/manual_journals/widgets/manual_journal_filter_sheet.dart';
import 'package:custom_books/features/manual_journals/widgets/manual_journal_sort_sheet.dart';
import 'package:custom_books/features/manual_journals/widgets/manual_journal_page_widgets.dart';
import 'package:flutter/material.dart';
import 'package:custom_books/core/enums/sort_direction.dart';

class ManualJournalsPage extends StatefulWidget {
  const ManualJournalsPage({super.key});

  @override
  State<ManualJournalsPage> createState() => _ManualJournalsPageState();
}

class _ManualJournalsPageState extends State<ManualJournalsPage> {
  final TextEditingController _searchController = TextEditingController();

  int _selectedTab = 0; // 0: All, 1: Draft, 2: Published
  bool _searchOpen = false;
  ManualJournalStatus? _statusFilter;
  ManualJournalSortField _sortField = ManualJournalSortField.createdTime;
  SortDirection _sortDirection = SortDirection.descending;

  late List<ManualJournalModel> _journals;

  @override
  void initState() {
    super.initState();
    _journals = [
      ManualJournalModel(
        id: '1',
        journalNumber: 'MJ-00012',
        referenceNumber: 'REF-101',
        journalDate: DateTime(2026, 7, 3),
        notes: 'Depreciation entry',
        status: ManualJournalStatus.published,
        amount: 4500,
        createdAt: DateTime(2026, 7, 3, 10, 0),
        updatedAt: DateTime(2026, 7, 3, 10, 0),
      ),
      ManualJournalModel(
        id: '2',
        journalNumber: 'MJ-00011',
        referenceNumber: 'REF-098',
        journalDate: DateTime(2026, 7, 2),
        notes: 'Accrued expenses',
        status: ManualJournalStatus.draft,
        amount: 1250,
        createdAt: DateTime(2026, 7, 2, 9, 30),
        updatedAt: DateTime(2026, 7, 2, 9, 30),
      ),
      ManualJournalModel(
        id: '3',
        journalNumber: 'MJ-00010',
        referenceNumber: 'REF-090',
        journalDate: DateTime(2026, 6, 30),
        notes: 'Prepaid insurance adjustment',
        status: ManualJournalStatus.published,
        amount: 3200,
        createdAt: DateTime(2026, 6, 30, 14, 0),
        updatedAt: DateTime(2026, 6, 30, 14, 0),
      ),
      ManualJournalModel(
        id: '4',
        journalNumber: 'MJ-00009',
        referenceNumber: '',
        journalDate: DateTime(2026, 6, 28),
        notes: 'Bank charges',
        status: ManualJournalStatus.draft,
        amount: 75,
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

  List<ManualJournalModel> get _visibleJournals {
    final query = _searchController.text.trim().toLowerCase();
    final list = _journals.where((journal) {
      if (_selectedTab == 1 && journal.status != ManualJournalStatus.draft) {
        return false;
      }
      if (_selectedTab == 2 &&
          journal.status != ManualJournalStatus.published) {
        return false;
      }
      if (_statusFilter != null && journal.status != _statusFilter) {
        return false;
      }
      return query.isEmpty ||
          journal.journalNumber.toLowerCase().contains(query) ||
          journal.referenceNumber.toLowerCase().contains(query) ||
          journal.notes.toLowerCase().contains(query);
    }).toList();

    list.sort((a, b) {
      int result;
      switch (_sortField) {
        case ManualJournalSortField.createdTime:
          result = a.createdAt.compareTo(b.createdAt);
        case ManualJournalSortField.date:
          result = a.journalDate.compareTo(b.journalDate);
        case ManualJournalSortField.journalNumber:
          result = a.journalNumber.compareTo(b.journalNumber);
        case ManualJournalSortField.amount:
          result = a.amount.compareTo(b.amount);
      }
      return _sortDirection == SortDirection.ascending ? result : -result;
    });

    return list;
  }

  Future<void> _addNewJournal() async {
    final result = await Navigator.push<ManualJournalModel>(
      context,
      MaterialPageRoute(builder: (_) => const AddManualJournalPage()),
    );
    if (result != null && mounted) {
      setState(() => _journals.insert(0, result));
      ToastificationHelper.showSuccess(context, 'Journal created successfully');
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
      builder: (_) => ManualJournalFilterSheet(
        selectedStatus: _statusFilter,
        onSelected: (status) => setState(() => _statusFilter = status),
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
      builder: (_) => ManualJournalSortSheet(
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
    final visibleList = _visibleJournals;

    return Scaffold(
      backgroundColor: context.colors.background,
      drawer: const DrawerView(currentRoute: 'manual_journals'),
      floatingActionButton: CustomAddButton(onPressed: _addNewJournal),
      body: NestedScrollView(
        physics: const BouncingScrollPhysics(),
        headerSliverBuilder: (context, _) => [
          CustomSliverAppBar(
            title: 'Manual Journals',
            subtitle:
                '${_journals.length} journal${_journals.length == 1 ? '' : 's'}',
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
                hintText: 'Search by journal, reference or notes',
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
                          _tabButton('Draft', 1),
                          _tabButton('Published', 2),
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
                  ? _emptyState()
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
                        itemBuilder: (context, index) => ManualJournalTile(
                          journal: visibleList[index],
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ManualJournalDetailsPage(
                                journal: visibleList[index],
                              ),
                            ),
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
                Icons.menu_book_rounded,
                size: Dimensions.iconSize24 * 1.3,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: Dimensions.height15),
            Text(
              'No manual journals found',
              style: TextStyle(
                fontSize: Dimensions.font16,
                fontWeight: FontWeight.w700,
                color: context.colors.textPrimary,
              ),
            ),
            SizedBox(height: Dimensions.height10 / 2),
            Text(
              'Tap the + button to create a new journal.',
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
