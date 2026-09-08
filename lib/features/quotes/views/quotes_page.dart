import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/core/widgets/custom_add_button.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/core/widgets/status_chip.dart';
import 'package:custom_books/core/widgets/custom_search_field.dart';
import 'package:custom_books/features/drawer/views/custom_drawer.dart';
import 'package:custom_books/features/quotes/models/quote_model.dart';
import 'package:custom_books/features/quotes/views/add_quote_page.dart';
import 'package:custom_books/features/quotes/widgets/quote_actions_sheet.dart';
import 'package:custom_books/features/quotes/widgets/quote_filter_sheet.dart';
import 'package:flutter/material.dart';
import 'package:custom_books/core/utils/date_formatter.dart';

enum QuoteSort {
  createdTime,
  lastModifiedTime,
  date,
  quoteNumber,
  customerName,
}

extension QuoteSortLabel on QuoteSort {
  String get label => switch (this) {
    QuoteSort.createdTime => 'Created Time',
    QuoteSort.lastModifiedTime => 'Last Modified Time',
    QuoteSort.date => 'Date',
    QuoteSort.quoteNumber => 'Quote Number',
    QuoteSort.customerName => 'Customer Name',
  };
}

class QuotesPage extends StatefulWidget {
  const QuotesPage({super.key});

  @override
  State<QuotesPage> createState() => _QuotesPageState();
}

class _QuotesPageState extends State<QuotesPage> {
  final _searchController = TextEditingController();
  final List<QuoteModel> _quotes = [
    QuoteModel(
      id: '1',
      quoteNumber: 'QT-000001',
      customerName: 'nabeel',
      quoteDate: DateTime(2026, 7, 2),
      lineItems: const [
        QuoteLineItem(
          id: '1',
          itemName: 'Sample item',
          quantity: 1,
          rate: 20,
          taxRate: 5,
        ),
      ],
      status: QuoteStatus.sent,
      createdAt: DateTime(2026, 7, 2),
      updatedAt: DateTime(2026, 7, 2),
    ),
  ];
  int _tab = 0;
  bool _searchOpen = false;
  QuoteStatus? _statusFilter;
  QuoteSort _sort = QuoteSort.createdTime;
  bool _ascending = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<QuoteModel> get _visibleQuotes {
    final query = _searchController.text.trim().toLowerCase();
    final list = _quotes.where((quote) {
      if (_tab == 1 && quote.status != QuoteStatus.draft) return false;
      if (_tab == 2 && quote.status != QuoteStatus.sent) return false;
      if (_statusFilter != null && quote.status != _statusFilter) return false;
      return query.isEmpty ||
          quote.customerName.toLowerCase().contains(query) ||
          quote.quoteNumber.toLowerCase().contains(query) ||
          quote.referenceNumber.toLowerCase().contains(query);
    }).toList();
    list.sort((a, b) {
      int result;
      switch (_sort) {
        case QuoteSort.createdTime:
          result = a.createdAt.compareTo(b.createdAt);
        case QuoteSort.lastModifiedTime:
          result = a.updatedAt.compareTo(b.updatedAt);
        case QuoteSort.date:
          result = a.quoteDate.compareTo(b.quoteDate);
        case QuoteSort.quoteNumber:
          result = a.quoteNumber.compareTo(b.quoteNumber);
        case QuoteSort.customerName:
          result = a.customerName.toLowerCase().compareTo(
            b.customerName.toLowerCase(),
          );
      }
      return _ascending ? result : -result;
    });
    return list;
  }

  Future<void> _addQuote() async {
    final result = await Navigator.push<QuoteModel>(
      context,
      MaterialPageRoute(
        builder: (_) => AddQuotePage(quoteSequence: _quotes.length + 2),
      ),
    );
    if (result != null && mounted) {
      setState(() {
        _quotes.add(result);
        _tab = 0;
        _statusFilter = null;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${result.quoteNumber} created')));
    }
  }

  void _showQuote(QuoteModel quote) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            Dimensions.width20 * 1.2,
            Dimensions.height10 * 0.4,
            Dimensions.width20 * 1.2,
            Dimensions.width20 * 1.2,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    quote.quoteNumber,
                    style: TextStyle(
                      fontSize: Dimensions.font20 * 1.1,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  StatusChip(
                    color: quote.status.color,
                    label: quote.status.label,
                  ),
                ],
              ),
              SizedBox(height: Dimensions.height15 * 1.2),
              Text(
                quote.customerName,
                style: TextStyle(
                  fontSize: Dimensions.font16 * 1.125,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(formatDate(quote.quoteDate)),
              if (quote.subject.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(top: Dimensions.height10),
                  child: Text(quote.subject),
                ),
              Divider(height: Dimensions.height30),
              ...quote.lineItems.map(
                (item) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(item.itemName),
                  subtitle: Text(
                    '${item.quantity.toStringAsFixed(2)} × ₹${item.rate.toStringAsFixed(2)}',
                  ),
                  trailing: Text('₹${item.net.toStringAsFixed(2)}'),
                ),
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(
                      fontSize: Dimensions.font16 * 1.125,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    '₹${quote.total.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: Dimensions.font16 * 1.125,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              SizedBox(height: Dimensions.height15 * 1.2),
              if (quote.status == QuoteStatus.draft)
                OutlinedButton.icon(
                  onPressed: () {
                    final index = _quotes.indexWhere(
                      (item) => item.id == quote.id,
                    );
                    setState(
                      () => _quotes[index] = quote.copyWith(
                        status: QuoteStatus.sent,
                      ),
                    );
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.send_outlined),
                  label: const Text('Mark as Sent'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(
                      color: AppColors.primary,
                      width: 1.5,
                    ),
                    backgroundColor: Colors.transparent,
                    minimumSize: Size(
                      double.infinity,
                      Dimensions.height45 * 1.11,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showActionsSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) => QuoteActionsSheet(
        onClose: () => Navigator.pop(sheetContext),
        onExport: () {
          Navigator.pop(sheetContext);
          ToastificationHelper.showSuccess(context, 'Quotes exported');
        },
        onRefresh: () {
          Navigator.pop(sheetContext);
          setState(() {});
        },
      ),
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) => QuoteFilterSheet(
        selectedStatus: _statusFilter,
        onClose: () => Navigator.pop(sheetContext),
        onSelected: (status) {
          setState(() {
            _statusFilter = status;
            _tab = 0;
          });
          Navigator.pop(sheetContext);
        },
      ),
    );
  }

  void _showSortSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _QuoteSortSheet(
        initialField: _sort,
        initialAscending: _ascending,
        onApply: (field, ascending) {
          setState(() {
            _sort = field;
            _ascending = ascending;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final quotes = _visibleQuotes;
    return Scaffold(
      backgroundColor: context.colors.background,
      drawer: const DrawerView(currentRoute: 'quotes'),

      floatingActionButton: CustomAddButton(onPressed: _addQuote),
      body: NestedScrollView(
        physics: const BouncingScrollPhysics(),
        headerSliverBuilder: (context, _) => [
          CustomSliverAppBar(
            title: 'Quotes',
            subtitle: '${quotes.length} quote${quotes.length == 1 ? '' : 's'}',
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
                onPressed: _showActionsSheet,
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
                hintText: 'Search by customer, quote or reference',
                onChanged: (_) => setState(() {}),
              ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                Dimensions.width20,
                0,
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
                          _tabButton('Draft', 1),
                          _tabButton('Sent', 2),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: Dimensions.width10),
                  InkWell(
                    borderRadius: BorderRadius.circular(Dimensions.radius15),
                    onTap: _showFilterSheet,
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
                    onTap: _showSortSheet,
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
              child: quotes.isEmpty
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
                                Icons.request_quote_rounded,
                                size: Dimensions.iconSize24 * 1.3,
                                color: AppColors.primary,
                              ),
                            ),
                            SizedBox(height: Dimensions.height15),
                            Text(
                              'No quotes found',
                              style: TextStyle(
                                fontSize: Dimensions.font16,
                                fontWeight: FontWeight.w700,
                                color: context.colors.textPrimary,
                              ),
                            ),
                            SizedBox(height: Dimensions.height10 / 2),
                            Text(
                              'Tap the + button to create a new quote.',
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
                        itemCount: quotes.length,
                        itemBuilder: (context, index) =>
                            _quoteTile(quotes[index]),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabButton(String label, int index) {
    final selected = _tab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() {
          _tab = index;
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

  Widget _controlBadge(IconData icon, {bool active = false}) => Container(
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

  Widget _quoteTile(QuoteModel quote) => InkWell(
    borderRadius: BorderRadius.circular(Dimensions.radius15),
    onTap: () => _showQuote(quote),
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
              Icons.request_quote_outlined,
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
                  quote.customerName,
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
                      formatDate(quote.quoteDate),
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
                        quote.quoteNumber,
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
                StatusChip(
                  color: quote.status.color,
                  label: quote.status.label,
                ),
              ],
            ),
          ),
          SizedBox(width: Dimensions.width10),
          Text(
            '₹${quote.total.toStringAsFixed(2)}',
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

class _QuoteSortSheet extends StatefulWidget {
  final QuoteSort initialField;
  final bool initialAscending;
  final void Function(QuoteSort field, bool ascending) onApply;

  const _QuoteSortSheet({
    required this.initialField,
    required this.initialAscending,
    required this.onApply,
  });

  @override
  State<_QuoteSortSheet> createState() => _QuoteSortSheetState();
}

class _QuoteSortSheetState extends State<_QuoteSortSheet> {
  late QuoteSort _field;
  late bool _ascending;

  @override
  void initState() {
    super.initState();
    _field = widget.initialField;
    _ascending = widget.initialAscending;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.9,
        ),
        decoration: BoxDecoration(
          color: context.colors.card,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(Dimensions.radius20 * 1.2),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: Dimensions.width20 * 2,
              height: Dimensions.height10 * 0.4,
              margin: EdgeInsets.symmetric(vertical: Dimensions.height10),
              decoration: BoxDecoration(
                color: context.colors.border,
                borderRadius: BorderRadius.circular(Dimensions.radius30),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
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
                    borderRadius: BorderRadius.circular(Dimensions.radius15),
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: EdgeInsets.all(Dimensions.width10 * 0.6),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(
                          Dimensions.radius15,
                        ),
                      ),
                      child: Icon(
                        Icons.close_rounded,
                        size: Dimensions.iconSize16,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: Dimensions.height15),
            Flexible(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
                child: Column(
                  children: [
                    ...QuoteSort.values.map(_sortOption),
                    Container(
                      padding: EdgeInsets.all(Dimensions.width15 * 0.8),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(
                          Dimensions.radius15,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            size: Dimensions.iconSize16,
                            color: AppColors.accent,
                          ),
                          SizedBox(width: Dimensions.width10),
                          Expanded(
                            child: Text(
                              'Tap a selection again to switch between ascending and descending order.',
                              style: TextStyle(
                                fontSize: Dimensions.font16 * 0.7,
                                color: context.colors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: Dimensions.height15),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(
                Dimensions.width20,
                Dimensions.height15,
                Dimensions.width20,
                Dimensions.height20,
              ),
              decoration: BoxDecoration(
                color: context.colors.card,
                border: Border(top: BorderSide(color: context.colors.border)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'SORT SELECTED',
                          style: TextStyle(
                            fontSize: Dimensions.font16 * 0.6,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(height: Dimensions.height10 * 0.2),
                        Text(
                          '${_field.label} (${_ascending ? 'Ascending' : 'Descending'})',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: Dimensions.font16 * 0.85,
                            fontWeight: FontWeight.w700,
                            color: context.colors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: Dimensions.width15),
                  OutlinedButton(
                    onPressed: () {
                      widget.onApply(_field, _ascending);
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(
                        color: AppColors.primary,
                        width: 1.5,
                      ),
                      backgroundColor: Colors.transparent,
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.width20 * 1.2,
                        vertical: Dimensions.height15 * 0.8,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sortOption(QuoteSort field) {
    final selected = field == _field;
    return Padding(
      padding: EdgeInsets.only(bottom: Dimensions.height10),
      child: InkWell(
        borderRadius: BorderRadius.circular(Dimensions.radius15),
        onTap: () {
          setState(() {
            if (_field == field) {
              _ascending = !_ascending;
            } else {
              _field = field;
              _ascending = false;
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
                ? AppColors.primary.withValues(alpha: 0.06)
                : context.colors.card,
            borderRadius: BorderRadius.circular(Dimensions.radius15),
            border: Border.all(
              color: selected ? AppColors.primary : context.colors.border,
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
                    ? AppColors.primary
                    : context.colors.textTertiary,
              ),
              SizedBox(width: Dimensions.width10),
              Expanded(
                child: Text(
                  field.label,
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.9,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    color: context.colors.textPrimary,
                  ),
                ),
              ),
              if (selected) ...[
                Text(
                  _ascending ? 'Ascending' : 'Descending',
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.75,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(width: Dimensions.width10 / 2),
                Icon(
                  _ascending
                      ? Icons.arrow_upward_rounded
                      : Icons.arrow_downward_rounded,
                  size: Dimensions.iconSize16,
                  color: AppColors.primary,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
