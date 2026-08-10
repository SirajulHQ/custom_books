/// Defines all available report types with their metadata.
enum ReportType {
  // Financial Reports
  balanceSheet(
    title: 'Balance Sheet',
    category: ReportCategory.financial,
    dateMode: ReportDateMode.asOf,
    columns: ['ACCOUNT', 'TOTAL'],
  ),
  profitAndLoss(
    title: 'Profit and Loss',
    category: ReportCategory.financial,
    dateMode: ReportDateMode.dateRange,
    columns: ['ACCOUNT', 'TOTAL'],
  ),
  cashFlowStatement(
    title: 'Cash Flow Statement',
    category: ReportCategory.financial,
    dateMode: ReportDateMode.dateRange,
    columns: ['ACCOUNT', 'TOTAL'],
  ),

  // Sales
  salesByCustomer(
    title: 'Sales by Customer',
    category: ReportCategory.sales,
    dateMode: ReportDateMode.dateRange,
    columns: ['NAME', 'INVOICE COUNT', 'SALES', 'SALES WITH TAX'],
  ),
  salesByItem(
    title: 'Sales by Item',
    category: ReportCategory.sales,
    dateMode: ReportDateMode.dateRange,
    columns: ['ITEM NAME', 'SKU', 'QUANTITY SOLD', 'AMOUNT', 'AVERAGE PRICE'],
  ),
  salesBySalesPerson(
    title: 'Sales by Sales Person',
    category: ReportCategory.sales,
    dateMode: ReportDateMode.dateRange,
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
  ),

  // Receivables
  customerBalanceSummary(
    title: 'Customer Balance Summary',
    category: ReportCategory.receivables,
    dateMode: ReportDateMode.dateRange,
    columns: [
      'CUSTOMER NAME',
      'INVOICED AMOUNT',
      'AMOUNT RECEIVED',
      'CLOSING BALANCE',
    ],
  ),
  arAgingSummary(
    title: 'AR Aging Summary',
    category: ReportCategory.receivables,
    dateMode: ReportDateMode.asOf,
    columns: ['CUSTOMER NAME', 'CURRENT'],
  ),
  arAgingDetails(
    title: 'AR Aging Details',
    category: ReportCategory.receivables,
    dateMode: ReportDateMode.asOf,
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
  ),
  paymentsReceived(
    title: 'Payments Received',
    category: ReportCategory.receivables,
    dateMode: ReportDateMode.dateRange,
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
  ),

  // Expenses
  expensesByCategory(
    title: 'Expenses by Category',
    category: ReportCategory.expenses,
    dateMode: ReportDateMode.dateRange,
    columns: ['CATEGORY', 'AMOUNT'],
  ),

  // Payables
  paymentsMade(
    title: 'Payments Made',
    category: ReportCategory.payables,
    dateMode: ReportDateMode.dateRange,
    columns: ['PAYMENT NUMBER', 'DATE', 'VENDOR', 'AMOUNT'],
  ),
  vendorBalanceSummary(
    title: 'Vendor Balance Summary',
    category: ReportCategory.payables,
    dateMode: ReportDateMode.dateRange,
    columns: ['VENDOR NAME', 'BILLED AMOUNT', 'AMOUNT PAID', 'CLOSING BALANCE'],
  );

  const ReportType({
    required this.title,
    required this.category,
    required this.dateMode,
    required this.columns,
  });

  final String title;
  final ReportCategory category;
  final ReportDateMode dateMode;
  final List<String> columns;
}

enum ReportCategory {
  financial('Financial Reports'),
  sales('Sales'),
  receivables('Receivables'),
  expenses('Expenses'),
  payables('Payables');

  const ReportCategory(this.label);
  final String label;
}

enum ReportDateMode { asOf, dateRange }
