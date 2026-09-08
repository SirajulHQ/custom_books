import 'package:custom_books/core/enums/sort_direction.dart';
import 'package:custom_books/core/widgets/generic_sort_sheet.dart';
import 'package:flutter/material.dart';

enum InvoiceSortField { createdTime, date, invoiceNumber, customerName, amount }

extension InvoiceSortFieldLabel on InvoiceSortField {
  String get label => switch (this) {
    InvoiceSortField.createdTime => 'Created Time',
    InvoiceSortField.date => 'Date',
    InvoiceSortField.invoiceNumber => 'Invoice#',
    InvoiceSortField.customerName => 'Customer Name',
    InvoiceSortField.amount => 'Amount',
  };
}

/// Thin wrapper kept for call-site compatibility.
class InvoiceSortSheet extends StatelessWidget {
  final InvoiceSortField initialField;
  final SortDirection initialDirection;
  final void Function(InvoiceSortField field, SortDirection direction) onApply;

  const InvoiceSortSheet({
    super.key,
    required this.initialField,
    required this.initialDirection,
    required this.onApply,
  });

  /// Opens the sheet and wires the apply callback for you.
  static Future<void> show(
    BuildContext context, {
    required InvoiceSortField initialField,
    required SortDirection initialDirection,
    required void Function(InvoiceSortField field, SortDirection direction)
    onApply,
  }) {
    return GenericSortSheet.show<InvoiceSortField>(
      context,
      fields: InvoiceSortField.values,
      initialField: initialField,
      initialDirection: initialDirection,
      labelBuilder: (f) => f.label,
      onApply: onApply,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GenericSortSheet<InvoiceSortField>(
      fields: InvoiceSortField.values,
      initialField: initialField,
      initialDirection: initialDirection,
      labelBuilder: (f) => f.label,
      onApply: onApply,
    );
  }
}
