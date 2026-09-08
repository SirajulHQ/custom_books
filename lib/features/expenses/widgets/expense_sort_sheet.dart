import 'package:custom_books/core/enums/sort_direction.dart';
import 'package:custom_books/core/widgets/generic_sort_sheet.dart';
import 'package:custom_books/features/expenses/models/expense_model.dart';
import 'package:flutter/material.dart';

/// Thin wrapper kept for call-site compatibility.
class ExpenseSortSheet extends StatelessWidget {
  final ExpenseSortField selectedField;
  final SortDirection selectedDirection;
  final void Function(ExpenseSortField field, SortDirection direction) onApply;

  const ExpenseSortSheet({
    super.key,
    required this.selectedField,
    required this.selectedDirection,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    return GenericSortSheet<ExpenseSortField>(
      fields: ExpenseSortField.values,
      initialField: selectedField,
      initialDirection: selectedDirection,
      labelBuilder: (f) => f.label,
      onApply: onApply,
      compact: true,
      buttonLabel: 'Apply',
    );
  }
}
