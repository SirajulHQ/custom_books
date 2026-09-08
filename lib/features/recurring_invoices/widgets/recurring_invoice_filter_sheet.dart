import 'package:custom_books/core/widgets/filter_sheet.dart';
import 'package:custom_books/features/recurring_invoices/models/recurring_invoice_model.dart';
import 'package:flutter/material.dart';

class RecurringInvoiceFilterSheet extends StatelessWidget {
  final RecurringInvoiceStatus? selectedStatus;
  final ValueChanged<RecurringInvoiceStatus?> onSelected;

  const RecurringInvoiceFilterSheet({
    super.key,
    required this.selectedStatus,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterSheet<RecurringInvoiceStatus>(
      title: 'Filter',
      options: const [null, ...RecurringInvoiceStatus.values],
      selectedValue: selectedStatus,
      labelBuilder: (status) => status?.label ?? 'All Statuses',
      onSelected: onSelected,
    );
  }
}
