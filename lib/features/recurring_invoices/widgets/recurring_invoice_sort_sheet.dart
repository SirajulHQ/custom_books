import 'package:custom_books/core/enums/sort_direction.dart';
import 'package:custom_books/core/widgets/generic_sort_sheet.dart';
import 'package:custom_books/features/recurring_invoices/models/recurring_invoice_model.dart';
import 'package:flutter/material.dart';

/// Thin wrapper kept for call-site compatibility.
class RecurringInvoiceSortSheet extends StatelessWidget {
  final RecurringInvoiceSortField selectedField;
  final SortDirection selectedDirection;
  final void Function(RecurringInvoiceSortField field, SortDirection direction)
  onApply;

  const RecurringInvoiceSortSheet({
    super.key,
    required this.selectedField,
    required this.selectedDirection,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    return GenericSortSheet<RecurringInvoiceSortField>(
      fields: RecurringInvoiceSortField.values,
      initialField: selectedField,
      initialDirection: selectedDirection,
      labelBuilder: (f) => f.label,
      onApply: onApply,
    );
  }
}
