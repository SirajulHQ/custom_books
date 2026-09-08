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
            ListControlBar(
              tabs: const ['All', 'Draft', 'Published'],
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
            Expanded(
              child: visibleList.isEmpty
                  ? const EmptyStateWidget(
                      icon: Icons.menu_book_rounded,
                      title: 'No manual journals found',
                      subtitle: 'Tap the + button to create a new journal.',
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

}
