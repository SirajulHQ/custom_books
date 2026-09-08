import 'package:custom_books/core/enums/sort_direction.dart';
import 'package:custom_books/core/widgets/generic_sort_sheet.dart';
import 'package:custom_books/features/purchase_orders/models/purchase_order_model.dart';
import 'package:flutter/material.dart';

/// Thin wrapper kept for call-site compatibility.
class PurchaseOrderSortSheet extends StatelessWidget {
  final PurchaseOrderSortField selectedField;
  final SortDirection selectedDirection;
  final void Function(PurchaseOrderSortField field, SortDirection direction)
  onApply;

  const PurchaseOrderSortSheet({
    super.key,
    required this.selectedField,
    required this.selectedDirection,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    return GenericSortSheet<PurchaseOrderSortField>(
      fields: PurchaseOrderSortField.values,
      initialField: selectedField,
      initialDirection: selectedDirection,
      labelBuilder: (f) => f.label,
      onApply: onApply,
      compact: true,
      buttonLabel: 'Apply',
    );
  }
}
