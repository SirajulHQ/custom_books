import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/features/reports/models/report_type.dart';
import 'package:custom_books/features/reports/widgets/report_filter_sheet.dart';
import 'package:custom_books/features/reports/widgets/report_export_dialog.dart';
import 'package:flutter/material.dart';
import 'package:custom_books/core/utils/date_formatter.dart';

class ReportDetailPage extends StatefulWidget {
  final ReportType reportType;

  const ReportDetailPage({super.key, required this.reportType});

  @override
  State<ReportDetailPage> createState() => _ReportDetailPageState();
}

class _ReportDetailPageState extends State<ReportDetailPage> {
  late DateTime _startDate;
  late DateTime _endDate;
  late DateTime _asOfDate;
  String _reportBasis = 'Cash';
  String _filterAccounts = 'Accounts Without Zero Balance';
  String _compareWith = 'None';

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _startDate = DateTime(now.year, now.month, 1);
    _endDate = DateTime(now.year, now.month + 1, 0);
    _asOfDate = now;
    appLog(
      '📊 ReportDetailPage initialized: ${widget.reportType.title}',
      name: 'ReportDetail',
    );
  }

  void _openFilterSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ReportFilterSheet(
        reportType: widget.reportType,
        startDate: _startDate,
        endDate: _endDate,
        asOfDate: _asOfDate,
        reportBasis: _reportBasis,
        filterAccounts: _filterAccounts,
        compareWith: _compareWith,
        onApply: (start, end, asOf, basis, filter, compare) {
          setState(() {
            _startDate = start;
            _endDate = end;
            _asOfDate = asOf;
            _reportBasis = basis;
            _filterAccounts = filter;
            _compareWith = compare;
          });
        },
      ),
    );
  }

  void _openExportDialog() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ReportExportDialog(
        reportType: widget.reportType,
        reportBasis: _reportBasis,
      ),
    );
  }

  String get _dateSubtitle {
    if (widget.reportType.dateMode == ReportDateMode.asOf) {
      return 'As of ${formatDate(_asOfDate)}';
    }
    return 'From ${formatDate(_startDate)} To ${formatDate(_endDate)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            CustomSliverAppBar(
              title: '',
              leadingType: AppBarLeadingType.back,
              actions: [
                AppBarIconButton(
                  icon: Icons.filter_list_rounded,
                  onPressed: _openFilterSheet,
                ),
                SizedBox(width: Dimensions.width10),
                AppBarElevatedButton(
                  label: 'Export',
                  onPressed: _openExportDialog,
                ),
                SizedBox(width: Dimensions.width20),
              ],
            ),
            // Report Header
            SliverToBoxAdapter(child: _buildReportHeader()),
            // Report Table Header
            SliverToBoxAdapter(child: _buildTableHeader()),
            // Report Content
            SliverToBoxAdapter(child: _buildReportContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildReportHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.width20,
        vertical: Dimensions.height15,
      ),
      decoration: BoxDecoration(
        color: context.colors.card,
        border: Border(bottom: BorderSide(color: context.colors.border)),
      ),
      child: Column(
        children: [
          Text(
            'Own Store',
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.85,
              color: context.colors.textSecondary,
            ),
          ),
          SizedBox(height: Dimensions.height10 / 2),
          Text(
            widget.reportType.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: Dimensions.font20,
              fontWeight: FontWeight.w800,
              color: context.colors.textPrimary,
            ),
          ),
          SizedBox(height: Dimensions.height10 / 3),
          if (widget.reportType.category == ReportCategory.financial)
            Text(
              'Basis : $_reportBasis',
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.8,
                color: context.colors.textSecondary,
              ),
            ),
          SizedBox(height: Dimensions.height10 / 3),
          Text(
            _dateSubtitle,
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.8,
              color: context.colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    final columns = widget.reportType.columns;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.width20,
        vertical: Dimensions.height10,
      ),
      decoration: BoxDecoration(
        color: context.colors.surfaceLight,
        border: Border(bottom: BorderSide(color: context.colors.border)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: columns.map((col) {
            final isFirst = col == columns.first;
            return Container(
              width: _columnWidth(col),
              padding: EdgeInsets.only(right: Dimensions.width15),
              child: Text(
                col,
                style: TextStyle(
                  fontSize: Dimensions.font16 * 0.7,
                  fontWeight: FontWeight.w700,
                  color: context.colors.textSecondary,
                  letterSpacing: 0.5,
                ),
                textAlign: isFirst ? TextAlign.left : TextAlign.right,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  double _columnWidth(String col) {
    if (col.length > 15) return Dimensions.width20 * 8;
    if (col.length > 10) return Dimensions.width20 * 6.5;
    return Dimensions.width20 * 5.5;
  }

  Widget _buildReportContent() {
    switch (widget.reportType) {
      case ReportType.balanceSheet:
        return _buildBalanceSheetContent();
      case ReportType.profitAndLoss:
        return _buildProfitAndLossContent();
      case ReportType.cashFlowStatement:
        return _buildCashFlowContent();
      case ReportType.salesByCustomer:
        return _buildSalesByCustomerContent();
      case ReportType.salesByItem:
        return _buildSalesByItemContent();
      case ReportType.salesBySalesPerson:
        return _buildSalesBySalesPersonContent();
      case ReportType.customerBalanceSummary:
        return _buildCustomerBalanceSummaryContent();
      case ReportType.arAgingSummary:
        return _buildArAgingSummaryContent();
      case ReportType.arAgingDetails:
        return _buildArAgingDetailsContent();
      case ReportType.paymentsReceived:
        return _buildPaymentsReceivedContent();
      case ReportType.expensesByCategory:
        return _buildExpensesByCategoryContent();
      case ReportType.paymentsMade:
        return _buildPaymentsMadeContent();
      case ReportType.vendorBalanceSummary:
        return _buildVendorBalanceSummaryContent();
    }
  }

  Widget _buildEmptyState(String message) {
    return Padding(
      padding: EdgeInsets.all(Dimensions.width20 * 2),
      child: Center(
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: Dimensions.font16 * 0.9,
            color: context.colors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceSheetContent() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Assets'),
          _subSectionTitle('Current Assets'),
          _subSubSectionTitle('Cash and Cash Equivalents'),
          _accountCategory('Cash'),
          _accountRow('Petty Cash', '1,528.00', isLink: true),
          _accountRow('Undeposited Funds', '4,607.00', isLink: true),
          _totalRow('Total for Cash', '6,135.00'),
          _accountCategory('Bank'),
          _accountRow('ADBC', '306.73', isLink: true),
          _totalRow('Total for Bank', '306.73'),
          _totalRow(
            'Total for Cash and Cash Equivalents',
            '6,441.73',
            isBold: true,
          ),
          _divider(),
          _subSubSectionTitle('Accounts Receivable'),
          _totalRow('Total for Accounts Receivable', '0.00'),
          _divider(),
          _subSubSectionTitle('Other current assets'),
          _accountRow('Inventory Asset', '-150.00', isLink: true),
          _accountRow('Sales to Customers (Cash)', '300.00', isLink: true),
          _totalRow('Total for Other current assets', '150.00'),
          _totalRow('Total for Current Assets', '6,591.73', isBold: true),
          _divider(),
          _subSectionTitle('Non Current Assets'),
          _totalRow('Total for Non Current Assets', '0.00'),
          _divider(),
          _subSectionTitle('Fixed Assets'),
          _totalRow('Total for Fixed Assets', '0.00'),
          _totalRow('Total for Assets', '6,591.73', isBold: true),
          SizedBox(height: Dimensions.height20),
          _buildCurrencyNote(),
          SizedBox(height: Dimensions.height30),
        ],
      ),
    );
  }

  Widget _buildProfitAndLossContent() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Operating Income'),
          _totalRow('Total for Operating Income', '0.00'),
          _divider(),
          _sectionTitle('Cost of Goods Sold'),
          _totalRow('Total for Cost of Goods Sold', '0.00'),
          _totalRow('Gross Profit', '0.00', isBold: true),
          _divider(),
          _sectionTitle('Operating Expense'),
          _totalRow('Total for Operating Expense', '0.00'),
          _totalRow('Operating Profit', '0.00', isBold: true),
          _divider(),
          _sectionTitle('Non Operating Income'),
          _totalRow('Total for Non Operating Income', '0.00'),
          _divider(),
          _sectionTitle('Non Operating Expense'),
          _totalRow('Total for Non Operating Expense', '0.00'),
          _totalRow('Net Profit/Loss', '0.00', isBold: true),
          SizedBox(height: Dimensions.height20),
          _buildCurrencyNote(),
          SizedBox(height: Dimensions.height30),
        ],
      ),
    );
  }

  Widget _buildCashFlowContent() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _totalRow('Beginning Cash Balance', '6,441.73', isBold: true),
          _divider(),
          _sectionTitle('Cash Flow from Operating Activities'),
          _accountRow('Net Income', '0.00', isLink: true),
          _subSubSectionTitle('Non-cash adjustments'),
          _totalRow('Non-cash adjustments Total', '0.00'),
          _totalRow('Net cash provided by Operating Activities', '0.00'),
          _divider(),
          _sectionTitle('Cash Flow from Investing Activities'),
          _totalRow('Net cash provided by Investing Activities', '0.00'),
          _divider(),
          _sectionTitle('Cash Flow from Financing Activities'),
          _totalRow('Net cash provided by Financing Activities', '0.00'),
          _divider(),
          _totalRow('Net Change in cash', '0.00', isBold: true),
          _totalRow('Ending Cash Balance', '6,441.73', isBold: true),
          SizedBox(height: Dimensions.height20),
          _buildCurrencyNote(),
          SizedBox(height: Dimensions.height30),
        ],
      ),
    );
  }

  // ── Sales by Customer ──────────────────────────────────────────────────
  Widget _buildSalesByCustomerContent() {
    return _buildHorizontalTableReport(
      columns: ['NAME', 'INVOICE COUNT', 'SALES', 'SALES WITH TAX'],
      rows: [],
      emptyMessage: 'There were no sales during the selected date range.',
    );
  }

  // ── Sales by Item ──────────────────────────────────────────────────────
  Widget _buildSalesByItemContent() {
    return _buildHorizontalTableReport(
      columns: ['ITEM NAME', 'SKU', 'QUANTITY SOLD', 'AMOUNT', 'AVERAGE PRICE'],
      rows: [],
      emptyMessage: 'There were no sales during the selected date range.',
    );
  }

  // ── Sales by Sales Person ──────────────────────────────────────────────
  Widget _buildSalesBySalesPersonContent() {
    return _buildHorizontalTableReport(
      columns: [
        'NAME',
        'INVOICE COUNT',
        'INVOICE SALES',
        'INVOICE SALES WITH TAX',
        'CREDIT NOTE COUNT',
        'CREDIT NOTE SALES',
        'CREDIT NOTE SALES WITH TAX',
        'TOTAL SALES',
        'TOTAL SALES WITH TAX',
      ],
      rows: [],
      emptyMessage: 'There were no sales during the selected date range.',
    );
  }

  // ── Customer Balance Summary ───────────────────────────────────────────
  Widget _buildCustomerBalanceSummaryContent() {
    final rows = [
      ['Amal', '₹0.00', '₹0.00', '₹315.00 Dr'],
      ['Nandhu', '₹0.00', '₹0.00', '₹2,212.00 Dr'],
      ['Parthiv Ajith', '₹0.00', '₹0.00', '₹1,000.00 Cr'],
      ['Sirajul Haq', '₹0.00', '₹0.00', '₹833.00 Cr'],
      ['Trial Register', '₹0.00', '₹0.00', '₹31.00 Dr'],
      ['trialuser', '₹0.00', '₹0.00', '₹2,110.00 Dr'],
      ['YASMIN', '₹0.00', '₹0.00', '₹105.00 Cr'],
      ['YASMIN P', '₹0.00', '₹0.00', '₹315.00 Cr'],
    ];
    return _buildHorizontalTableReport(
      columns: [
        'CUSTOMER NAME',
        'INVOICED AMOUNT',
        'AMOUNT RECEIVED',
        'CLOSING BALANCE',
      ],
      rows: rows,
      emptyMessage: 'No data available.',
      linkColumn: 0,
      totalRow: ['Total', '₹0.00', '₹0.00', '₹2,415.00 Dr'],
    );
  }

  // ── AR Aging Summary ───────────────────────────────────────────────────
  Widget _buildArAgingSummaryContent() {
    final rows = [
      ['Amal', '₹0.00'],
      ['Nandhu', '₹0.00'],
      ['Trial Register', '₹0.00'],
      ['trialuser', '₹0.00'],
    ];
    return _buildHorizontalTableReport(
      columns: ['CUSTOMER NAME', 'CURRENT'],
      rows: rows,
      emptyMessage: 'No aging data available.',
      linkColumn: 0,
      totalRow: ['Total', '₹0.00'],
    );
  }

  // ── AR Aging Details ───────────────────────────────────────────────────
  Widget _buildArAgingDetailsContent() {
    final rows = [
      [
        '29 Jun 2026',
        '29 Jun 2026',
        'INV-000019',
        'Invoice',
        'Overdue',
        'Trial Register',
        '39 Days',
        '₹31.00',
        '₹31.00',
      ],
      [
        '30 Jun 2026',
        '30 Jun 2026',
        'INV-000022',
        'Invoice',
        'Overdue',
        'trialuser',
        '38 Days',
        '₹2,110.00',
        '₹2,110.00',
      ],
      [
        '30 Jun 2026',
        '30 Jun 2026',
        'INV-000023',
        'Invoice',
        'Overdue',
        'Nandhu',
        '38 Days',
        '₹1,081.00',
        '₹1,081.00',
      ],
      [
        '30 Jun 2026',
        '30 Jun 2026',
        'INV-000024',
        'Invoice',
        'Overdue',
        'Nandhu',
        '38 Days',
        '₹1,081.00',
        '₹1,081.00',
      ],
      [
        '30 Jun 2026',
        '30 Jun 2026',
        'INV-000025',
        'Invoice',
        'Overdue',
        'Nandhu',
        '38 Days',
        '₹187.00',
        '₹187.00',
      ],
      [
        '01 Jul 2026',
        '01 Jul 2026',
        'INV-000032',
        'Invoice',
        'Overdue',
        'Nandhu',
        '37 Days',
        '₹1,081.00',
        '₹1,081.00',
      ],
      [
        '03 Jul 2026',
        '03 Jul 2026',
        'INV-000035',
        'Invoice',
        'Overdue',
        'Amal',
        '35 Days',
        '₹157.50',
        '₹157.50',
      ],
      [
        '03 Jul 2026',
        '03 Jul 2026',
        'INV-000036',
        'Invoice',
        'Overdue',
        'Amal',
        '35 Days',
        '₹157.50',
        '₹157.50',
      ],
    ];
    return _buildHorizontalTableReport(
      columns: [
        'DATE',
        'DUE DATE',
        'TRANSACTION#',
        'TYPE',
        'STATUS',
        'CUSTOMER NAME',
        'AGE',
        'AMOUNT',
        'BALANCE DUE',
      ],
      rows: rows,
      emptyMessage: 'No aging details available.',
      linkColumn: 2,
      statusColumn: 4,
      totalRow: ['Total', '', '', '', '', '', '', '₹5,886.00', '₹5,886.00'],
      sectionHeaders: {'0': '31 - 45 Days'},
    );
  }

  // ── Payments Received ──────────────────────────────────────────────────
  Widget _buildPaymentsReceivedContent() {
    return _buildHorizontalTableReport(
      columns: [
        'PAYMENT NUMBER',
        'DATE',
        'STATUS',
        'REFERENCE NUMBER',
        'CUSTOMER NAME',
        'PAYMENT MODE',
        'NOTES',
        'INVOICE#',
        'DEPOSIT TO',
        'AMOUNT (BCY)',
        'UNUSED AMOUNT (BCY)',
        'UNUSED AMOUNT (FCY)',
        'AMOUNT (FCY)',
      ],
      rows: [],
      emptyMessage: 'There are no transactions during the selected date range.',
    );
  }

  // ── Expenses by Category ───────────────────────────────────────────────
  Widget _buildExpensesByCategoryContent() {
    return _buildHorizontalTableReport(
      columns: ['CATEGORY', 'AMOUNT'],
      rows: [],
      emptyMessage: 'No expenses during the selected date range.',
    );
  }

  // ── Payments Made ──────────────────────────────────────────────────────
  Widget _buildPaymentsMadeContent() {
    return _buildHorizontalTableReport(
      columns: ['PAYMENT NUMBER', 'DATE', 'VENDOR', 'AMOUNT'],
      rows: [],
      emptyMessage: 'There are no transactions during the selected date range.',
    );
  }

  // ── Vendor Balance Summary ─────────────────────────────────────────────
  Widget _buildVendorBalanceSummaryContent() {
    return _buildHorizontalTableReport(
      columns: [
        'VENDOR NAME',
        'BILLED AMOUNT',
        'AMOUNT PAID',
        'CLOSING BALANCE',
      ],
      rows: [],
      emptyMessage: 'No vendor data during the selected date range.',
    );
  }

  // ── Reusable horizontal scrollable table builder ───────────────────────
  Widget _buildHorizontalTableReport({
    required List<String> columns,
    required List<List<String>> rows,
    required String emptyMessage,
    int? linkColumn,
    int? statusColumn,
    List<String>? totalRow,
    Map<String, String>? sectionHeaders,
  }) {
    if (rows.isEmpty) {
      return _buildEmptyState(emptyMessage);
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < rows.length; i++) ...[
            if (sectionHeaders != null && sectionHeaders.containsKey('$i'))
              Padding(
                padding: EdgeInsets.only(
                  top: Dimensions.height15,
                  bottom: Dimensions.height10,
                ),
                child: Text(
                  sectionHeaders['$i']!,
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.9,
                    fontWeight: FontWeight.w700,
                    color: context.colors.textPrimary,
                  ),
                ),
              ),
            _buildTableRow(
              rows[i],
              columns,
              linkColumn: linkColumn,
              statusColumn: statusColumn,
            ),
            Divider(color: context.colors.border, height: 1),
          ],
          if (totalRow != null) ...[
            Container(
              padding: EdgeInsets.symmetric(vertical: Dimensions.height10),
              decoration: BoxDecoration(color: context.colors.surfaceLight),
              child: _buildTableRow(totalRow, columns, isBold: true),
            ),
          ],
          SizedBox(height: Dimensions.height30),
        ],
      ),
    );
  }

  Widget _buildTableRow(
    List<String> values,
    List<String> columns, {
    int? linkColumn,
    int? statusColumn,
    bool isBold = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Dimensions.height10 / 1.5),
      child: Row(
        children: List.generate(values.length, (i) {
          final isLink = linkColumn == i && values[i].isNotEmpty;
          final isStatus = statusColumn == i;
          Color textColor = context.colors.textPrimary;

          if (isLink) {
            textColor = AppColors.primary;
          } else if (isStatus && values[i] == 'Overdue') {
            textColor = AppColors.warn;
          }

          return Container(
            width: _columnWidth(columns.length > i ? columns[i] : ''),
            padding: EdgeInsets.only(right: Dimensions.width15),
            child: Text(
              values[i],
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.8,
                fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
                color: textColor,
              ),
              textAlign: i == 0 ? TextAlign.left : TextAlign.right,
            ),
          );
        }),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: EdgeInsets.only(
        top: Dimensions.height15,
        bottom: Dimensions.height10,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: Dimensions.font16,
          fontWeight: FontWeight.w700,
          color: context.colors.textPrimary,
        ),
      ),
    );
  }

  Widget _subSectionTitle(String text) {
    return Padding(
      padding: EdgeInsets.only(
        left: Dimensions.width10,
        top: Dimensions.height10,
        bottom: Dimensions.height10 / 2,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: Dimensions.font16 * 0.9,
          fontWeight: FontWeight.w700,
          color: context.colors.textPrimary,
        ),
      ),
    );
  }

  Widget _subSubSectionTitle(String text) {
    return Padding(
      padding: EdgeInsets.only(
        left: Dimensions.width20,
        top: Dimensions.height10,
        bottom: Dimensions.height10 / 2,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: Dimensions.font16 * 0.85,
          fontWeight: FontWeight.w600,
          color: context.colors.textPrimary,
        ),
      ),
    );
  }

  Widget _accountCategory(String text) {
    return Padding(
      padding: EdgeInsets.only(
        left: Dimensions.width30,
        top: Dimensions.height10 / 2,
        bottom: Dimensions.height10 / 2,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: Dimensions.font16 * 0.85,
          fontWeight: FontWeight.w600,
          color: context.colors.textPrimary,
        ),
      ),
    );
  }

  Widget _accountRow(String name, String amount, {bool isLink = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.width30 + Dimensions.width10,
        vertical: Dimensions.height10 / 2,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.85,
                fontWeight: FontWeight.w500,
                color: isLink ? AppColors.primary : context.colors.textPrimary,
              ),
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.85,
              fontWeight: FontWeight.w500,
              color: isLink ? AppColors.primary : context.colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _totalRow(String label, String amount, {bool isBold = false}) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.width20,
        vertical: Dimensions.height10,
      ),
      decoration: isBold
          ? BoxDecoration(
              border: Border(top: BorderSide(color: context.colors.border)),
            )
          : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.85,
                fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
                color: context.colors.textPrimary,
              ),
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.85,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
              color: context.colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Divider(height: Dimensions.height10, color: context.colors.border);
  }

  Widget _buildCurrencyNote() {
    return Row(
      children: [
        Text(
          '**Amount is displayed in your base currency ',
          style: TextStyle(
            fontSize: Dimensions.font16 * 0.75,
            color: context.colors.textSecondary,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.width10 / 2,
            vertical: Dimensions.height10 * 0.2,
          ),
          decoration: BoxDecoration(
            color: AppColors.ok,
            borderRadius: BorderRadius.circular(Dimensions.radius15 * 0.27),
          ),
          child: Text(
            '₹',
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.7,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
