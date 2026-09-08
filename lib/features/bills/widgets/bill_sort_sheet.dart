import 'package:custom_books/core/enums/sort_direction.dart';
import 'package:custom_books/core/widgets/generic_sort_sheet.dart';
import 'package:custom_books/features/bills/models/bill_model.dart';
import 'package:flutter/material.dart';

/// Thin wrapper kept for call-site compatibility.
class BillSortSheet extends StatelessWidget {
  final BillSortField selectedField;
  final SortDirection selectedDirection;
  final void Function(BillSortField field, SortDirection direction) onApply;

  const BillSortSheet({
    super.key,
    required this.selectedField,
    required this.selectedDirection,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    return GenericSortSheet<BillSortField>(
      fields: BillSortField.values,
      initialField: selectedField,
      initialDirection: selectedDirection,
      labelBuilder: (f) => f.label,
      onApply: onApply,
      compact: true,
      buttonLabel: 'Apply',
    );
  }
}
