import 'package:custom_books/core/enums/sort_direction.dart';
import 'package:custom_books/core/widgets/generic_sort_sheet.dart';
import 'package:custom_books/features/sales_orders/models/sales_order_model.dart';
import 'package:flutter/material.dart';

Future<void> showSalesOrderSortSheet(
  BuildContext context, {
  required SalesOrderSortField selectedField,
  required SortDirection selectedDirection,
  required void Function(SalesOrderSortField field, SortDirection direction)
  onApply,
}) {
  return GenericSortSheet.show<SalesOrderSortField>(
    context,
    fields: SalesOrderSortField.values,
    initialField: selectedField,
    initialDirection: selectedDirection,
    labelBuilder: (f) => f.label,
    onApply: onApply,
    showInfoBanner: true,
  );
}

/// Thin wrapper kept for call-site compatibility.
class SalesOrderSortSheet extends StatelessWidget {
  final SalesOrderSortField initialField;
  final SortDirection initialDirection;
  final void Function(SalesOrderSortField, SortDirection) onApply;

  const SalesOrderSortSheet({
    super.key,
    required this.initialField,
    required this.initialDirection,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    return GenericSortSheet<SalesOrderSortField>(
      fields: SalesOrderSortField.values,
      initialField: initialField,
      initialDirection: initialDirection,
      labelBuilder: (f) => f.label,
      onApply: onApply,
      showInfoBanner: true,
    );
  }
}
