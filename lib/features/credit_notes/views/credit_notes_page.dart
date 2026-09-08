import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/core/widgets/custom_search_field.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/features/credit_notes/models/credit_note_model.dart';
import 'package:custom_books/features/credit_notes/views/add_credit_note_page.dart';
import 'package:custom_books/features/credit_notes/views/credit_note_details_page.dart';
import 'package:custom_books/features/credit_notes/widgets/credit_note_card.dart';
import 'package:custom_books/features/credit_notes/widgets/credit_note_filter_sheet.dart';
import 'package:custom_books/features/credit_notes/widgets/credit_note_sort_sheet.dart';
import 'package:custom_books/features/drawer/views/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:custom_books/core/enums/sort_direction.dart';

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
  final SortDirection _sortDirection = SortDirection.descending;

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

  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return CreditNoteFilterSheet<CreditNoteStatus>(
          title: "Filter",

          options: [null, ...CreditNoteStatus.values],

          selectedValue: _statusFilter,

          labelBuilder: (status) {
            return status?.label ?? "All Statuses";
          },

          onSelected: (status) {
            setState(() {
              _statusFilter = status;
            });
          },
        );
      },
    );
  }

  void _openSortSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return CreditNoteSortSheet<CreditNoteSortField>(
          title: "Sort by",
          items: CreditNoteSortField.values,
          selectedItem: _sortField,
          direction: _sortDirection,
          labelBuilder: (item) => item.label,

          onItemChanged: (field) {
            setState(() {
              _sortField = field;
            });
          },

          onApply: () {
            setState(() {});
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final visibleList = _visibleNotes;

    return Scaffold(
      backgroundColor: context.colors.background,
      drawer: const DrawerView(currentRoute: 'credit_notes'),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radius15),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.35),
              blurRadius: Dimensions.radius15 * 1.07,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () async {
            final result = await Navigator.push<CreditNoteModel>(
              context,
              MaterialPageRoute(builder: (_) => const AddCreditNotePage()),
            );
            if (result != null && mounted) {
              setState(() => _notes.insert(0, result));
              ToastificationHelper.showSuccess(
                context, // ignore: use_build_context_synchronously
                '${result.creditNoteNumber} created successfully',
              );
            }
          },
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.radius15),
          ),
          child: const Icon(Icons.add_rounded),
        ),
      ),
      body: NestedScrollView(
        physics: const BouncingScrollPhysics(),
        headerSliverBuilder: (context, _) => [
          CustomSliverAppBar(
            title: 'Credit Notes',
            subtitle:
                '${_notes.length} credit note${_notes.length == 1 ? '' : 's'}',
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
                hintText: 'Search by customer, credit note or reference',
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
                                color: AppColors.primary.withValues(
                                  alpha: 0.08,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.receipt_long_outlined,
                                size: Dimensions.iconSize24 * 1.3,
                                color: AppColors.primary,
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
                        itemBuilder: (context, index) {
                          final note = visibleList[index];
                          final status = note.status;
                          return InkWell(
                            borderRadius: BorderRadius.circular(
                              Dimensions.radius15,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      CreditNoteDetailsPage(note: note),
                                ),
                              );
                            },
                            child: CreditNoteCard(
                              note: note,
                              statusColor: status.color,
                            ),
                          );
                        },
                      ),
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
