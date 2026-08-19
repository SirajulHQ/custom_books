import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/core/widgets/custom_add_button.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/core/widgets/status_chip.dart';
import 'package:custom_books/features/drawer/views/custom_drawer.dart';
import 'package:custom_books/features/manual_journals/models/manual_journal_model.dart';
import 'package:custom_books/features/manual_journals/views/add_manual_journal_page.dart';
import 'package:custom_books/features/manual_journals/views/manual_journal_details_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.all(Dimensions.width20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Filter by Status',
                  style: TextStyle(
                    fontSize: Dimensions.font20 * 0.85,
                    fontWeight: FontWeight.w800,
                    color: context.colors.textPrimary,
                  ),
                ),
                SizedBox(height: Dimensions.height15),
                _filterOption('All Statuses', null),
                ...ManualJournalStatus.values.map(
                  (s) => _filterOption(s.label, s),
                ),
                SizedBox(height: Dimensions.height10),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _filterOption(String label, ManualJournalStatus? status) {
    final selected = _statusFilter == status;
    return InkWell(
      borderRadius: BorderRadius.circular(Dimensions.radius15),
      onTap: () {
        setState(() => _statusFilter = status);
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
                    ...ManualJournalSortField.values.map((field) {
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
                    hintText: 'Search by journal, reference or notes',
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
                        padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.width20,
                        ),
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        itemCount: visibleList.length,
                        itemBuilder: (context, index) =>
                            _journalTile(visibleList[index]),
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

  Widget _journalTile(ManualJournalModel journal) {
    return InkWell(
      borderRadius: BorderRadius.circular(Dimensions.radius15),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ManualJournalDetailsPage(journal: journal),
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
                Icons.menu_book_rounded,
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
                    journal.journalNumber,
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
                        Icons.calendar_today_rounded,
                        size: Dimensions.iconSize16 - 2,
                        color: context.colors.textTertiary,
                      ),
                      SizedBox(width: Dimensions.width10 / 2),
                      Text(
                        DateFormat('dd MMM yyyy').format(journal.journalDate),
                        style: TextStyle(
                          fontSize: Dimensions.font16 * 0.7,
                          color: context.colors.textSecondary,
                        ),
                      ),
                      if (journal.referenceNumber.isNotEmpty) ...[
                        Text(
                          '  •  ',
                          style: TextStyle(
                            fontSize: Dimensions.font16 * 0.7,
                            color: context.colors.textTertiary,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            journal.referenceNumber,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: Dimensions.font16 * 0.7,
                              color: context.colors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: Dimensions.height10 / 2),
                  StatusChip(
                    color: journal.status.color,
                    label: journal.status.label,
                  ),
                ],
              ),
            ),
            SizedBox(width: Dimensions.width10),
            Text(
              '₹${journal.amount.toStringAsFixed(2)}',
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
}
