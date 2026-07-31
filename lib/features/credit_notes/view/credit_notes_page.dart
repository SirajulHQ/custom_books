import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/features/credit_notes/models/credit_note_model.dart';
import 'package:custom_books/features/credit_notes/view/add_credit_note_page.dart';
import 'package:custom_books/features/credit_notes/view/credit_note_details_page.dart';
import 'package:custom_books/features/drawer/view/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CreditNotesPage extends StatefulWidget {
  const CreditNotesPage({super.key});

  @override
  State<CreditNotesPage> createState() => _CreditNotesPageState();
}

class _CreditNotesPageState extends State<CreditNotesPage> {
  final TextEditingController _searchController = TextEditingController();

  int _selectedTab = 0; // 0: All, 1: Open, 2: Closed
  bool _searchOpen = false;
  CreditNoteStatus? _statusFilter;
  CreditNoteSortField _sortField = CreditNoteSortField.createdTime;
  SortDirection _sortDirection = SortDirection.descending;

  late List<CreditNoteModel> _notes;

  @override
  void initState() {
    super.initState();
    _notes = [
      CreditNoteModel(
        id: '1',
        creditNoteNumber: 'CN-00015',
        customerName: 'Nandhu',
        referenceNumber: 'INV-000039',
        creditNoteDate: DateTime(2026, 7, 3),
        status: CreditNoteStatus.open,
        total: 240.00,
        createdAt: DateTime(2026, 7, 3, 10, 0),
        updatedAt: DateTime(2026, 7, 3, 10, 0),
      ),
      CreditNoteModel(
        id: '2',
        creditNoteNumber: 'CN-00014',
        customerName: 'Parthiv Ajith',
        referenceNumber: 'INV-000036',
        creditNoteDate: DateTime(2026, 7, 1),
        status: CreditNoteStatus.closed,
        total: 560.50,
        createdAt: DateTime(2026, 7, 1, 14, 0),
        updatedAt: DateTime(2026, 7, 1, 14, 0),
      ),
      CreditNoteModel(
        id: '3',
        creditNoteNumber: 'CN-00013',
        customerName: 'Aisha Traders',
        referenceNumber: '',
        creditNoteDate: DateTime(2026, 6, 28),
        status: CreditNoteStatus.draft,
        total: 120.00,
        createdAt: DateTime(2026, 6, 28, 9, 30),
        updatedAt: DateTime(2026, 6, 28, 9, 30),
      ),
      CreditNoteModel(
        id: '4',
        creditNoteNumber: 'CN-00012',
        customerName: 'Gulf Retail LLC',
        referenceNumber: 'INV-000031',
        creditNoteDate: DateTime(2026, 6, 25),
        status: CreditNoteStatus.void_,
        total: 980.75,
        createdAt: DateTime(2026, 6, 25, 16, 0),
        updatedAt: DateTime(2026, 6, 25, 16, 0),
      ),
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<CreditNoteModel> get _visibleNotes {
    final query = _searchController.text.trim().toLowerCase();
    final list = _notes.where((note) {
      if (_selectedTab == 1 && note.status != CreditNoteStatus.open) {
        return false;
      }
      if (_selectedTab == 2 && note.status != CreditNoteStatus.closed) {
        return false;
      }
      if (_statusFilter != null && note.status != _statusFilter) {
        return false;
      }
      return query.isEmpty ||
          note.customerName.toLowerCase().contains(query) ||
          note.creditNoteNumber.toLowerCase().contains(query) ||
          note.referenceNumber.toLowerCase().contains(query);
    }).toList();

    list.sort((a, b) {
      int result;
      switch (_sortField) {
        case CreditNoteSortField.createdTime:
          result = a.createdAt.compareTo(b.createdAt);
        case CreditNoteSortField.date:
          result = a.creditNoteDate.compareTo(b.creditNoteDate);
        case CreditNoteSortField.creditNoteNumber:
          result = a.creditNoteNumber.compareTo(b.creditNoteNumber);
        case CreditNoteSortField.customerName:
          result = a.customerName.toLowerCase().compareTo(
            b.customerName.toLowerCase(),
          );
        case CreditNoteSortField.amount:
          result = a.total.compareTo(b.total);
      }
      return _sortDirection == SortDirection.ascending ? result : -result;
    });

    return list;
  }

  Future<void> _addNewNote() async {
    final result = await Navigator.push<CreditNoteModel>(
      context,
      MaterialPageRoute(builder: (_) => const AddCreditNotePage()),
    );
    if (result != null && mounted) {
      setState(() => _notes.insert(0, result));
      ToastificationHelper.showSuccess(
        context,
        '${result.creditNoteNumber} created successfully',
      );
    }
  }

  void _openFilterSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final options = <CreditNoteStatus?>[null, ...CreditNoteStatus.values];
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
                      children: CreditNoteSortField.values.map((f) {
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
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _sortField = field;
                            _sortDirection = direction;
                          });
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Appcolors.primary,
                          foregroundColor: Colors.white,
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
    final visibleList = _visibleNotes;

    return Scaffold(
      backgroundColor: context.colors.background,
      drawer: const DrawerView(currentRoute: 'credit_notes'),
      appBar: AppBar(
        backgroundColor: context.colors.background,
        surfaceTintColor: context.colors.background,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Container(
              width: Dimensions.height45 * 0.9,
              height: Dimensions.height45 * 0.9,
              decoration: BoxDecoration(
                color: Appcolors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(Dimensions.radius15),
              ),
              child: Icon(
                Icons.menu_rounded,
                size: Dimensions.iconSize24 - 4,
                color: Appcolors.primary,
              ),
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Credit Notes',
              style: TextStyle(
                fontSize: Dimensions.font26 * 0.85,
                fontWeight: FontWeight.w800,
                color: context.colors.textPrimary,
              ),
            ),
            Text(
              '${_notes.length} credit note${_notes.length == 1 ? '' : 's'}',
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.7,
                color: context.colors.textSecondary,
              ),
            ),
          ],
        ),
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
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radius15),
          boxShadow: [
            BoxShadow(
              color: Appcolors.primary.withValues(alpha: 0.35),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: _addNewNote,
          backgroundColor: Appcolors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.radius15),
          ),
          child: const Icon(Icons.add_rounded),
        ),
      ),
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
                  hintText: 'Search by customer, credit note or reference',
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
                      borderRadius: BorderRadius.circular(Dimensions.radius30),
                    ),
                    child: Row(
                      children: [
                        _tabButton('All', 0),
                        _tabButton('Open', 1),
                        _tabButton('Closed', 2),
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
          Expanded(
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
                              Icons.receipt_long_outlined,
                              size: Dimensions.iconSize24 * 1.3,
                              color: Appcolors.primary,
                            ),
                          ),
                          SizedBox(height: Dimensions.height15),
                          Text(
                            'No credit notes found',
                            style: TextStyle(
                              fontSize: Dimensions.font16,
                              fontWeight: FontWeight.w700,
                              color: context.colors.textPrimary,
                            ),
                          ),
                          SizedBox(height: Dimensions.height10 / 2),
                          Text(
                            'Tap the + button to create a new credit note.',
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
                          _noteTile(visibleList[index]),
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

  Widget _noteTile(CreditNoteModel note) {
    return InkWell(
      borderRadius: BorderRadius.circular(Dimensions.radius15),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CreditNoteDetailsPage(note: note),
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
                Icons.receipt_long_outlined,
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
                    note.customerName,
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
                        DateFormat('dd MMM yyyy').format(note.creditNoteDate),
                        style: TextStyle(
                          fontSize: Dimensions.font16 * 0.7,
                          color: context.colors.textSecondary,
                        ),
                      ),
                      Text(
                        '  •  ',
                        style: TextStyle(
                          fontSize: Dimensions.font16 * 0.7,
                          color: context.colors.textTertiary,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          note.creditNoteNumber,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: Dimensions.font16 * 0.7,
                            color: context.colors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Dimensions.height10 / 2),
                  _statusChip(note.status),
                ],
              ),
            ),
            SizedBox(width: Dimensions.width10),
            Text(
              'AED ${note.total.toStringAsFixed(2)}',
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

  Widget _statusChip(CreditNoteStatus status) {
    final color = switch (status) {
      CreditNoteStatus.draft => Colors.grey,
      CreditNoteStatus.open => Appcolors.primaryLight,
      CreditNoteStatus.closed => Appcolors.success,
      CreditNoteStatus.void_ => Appcolors.error,
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
