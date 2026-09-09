import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/enums/sort_direction.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/core/utils/date_formatter.dart';
import 'package:custom_books/core/widgets/active_filter_banner.dart';
import 'package:custom_books/core/widgets/custom_add_button.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/core/widgets/empty_state_widget.dart';
import 'package:custom_books/core/widgets/generic_sort_sheet.dart';
import 'package:custom_books/core/widgets/list_control_bar.dart';
import 'package:custom_books/core/widgets/status_chip.dart';
import 'package:custom_books/core/widgets/custom_search_field.dart';
import 'package:custom_books/features/drawer/views/custom_drawer.dart';
import 'package:custom_books/features/quotes/models/quote_model.dart';
import 'package:custom_books/features/quotes/views/add_quote_page.dart';
import 'package:custom_books/core/widgets/more_options_sheet.dart';
import 'package:custom_books/features/quotes/widgets/quote_filter_sheet.dart';
import 'package:flutter/material.dart';

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
    MoreOptionsSheet.show(
      context,
      sectionLabel: 'QUOTE ACTIONS',
      items: [
        MoreOptionsItem(
          icon: Icons.file_download_outlined,
          title: 'Export Quotes',
          subtitle: 'Export the current quote list',
          onTap: () =>
              ToastificationHelper.showSuccess(context, 'Quotes exported'),
        ),
        MoreOptionsItem(
          icon: Icons.refresh_rounded,
          title: 'Refresh',
          subtitle: 'Reload the latest quotes',
          onTap: () => setState(() {}),
        ),
      ],
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
    GenericSortSheet.show<QuoteSort>(
      context,
      fields: QuoteSort.values,
      initialField: _sort,
      initialDirection: _ascending
          ? SortDirection.ascending
          : SortDirection.descending,
      labelBuilder: (f) => f.label,
      onApply: (field, direction) {
        setState(() {
          _sort = field;
          _ascending = direction == SortDirection.ascending;
        });
      },
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
            ListControlBar(
              tabs: const ['All', 'Draft', 'Sent'],
              selectedTab: _tab,
              onTabSelected: (i) => setState(() {
                _tab = i;
                _statusFilter = null;
              }),
              filterActive: _statusFilter != null,
              onFilterTap: _showFilterSheet,
              onSortTap: _showSortSheet,
            ),
            if (_statusFilter != null)
              ActiveFilterBanner(
                label: 'Status: ${_statusFilter!.label}',
                onClear: () => setState(() => _statusFilter = null),
              ),
            Expanded(
              child: quotes.isEmpty
                  ? const EmptyStateWidget(
                      icon: Icons.request_quote_rounded,
                      title: 'No quotes found',
                      subtitle: 'Tap the + button to create a new quote.',
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
