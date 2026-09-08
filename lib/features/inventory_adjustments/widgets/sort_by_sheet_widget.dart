import 'package:custom_books/core/enums/sort_direction.dart';
import 'package:custom_books/core/widgets/generic_sort_sheet.dart';
import 'package:custom_books/features/inventory_adjustments/models/inventory_adjustments_model.dart';
import 'package:flutter/material.dart';

Future<void> showSortBySheet(
  BuildContext context, {
  required AdjustmentSortField selectedField,
  required SortDirection selectedDirection,
  required void Function(AdjustmentSortField field, SortDirection direction)
  onApply,
}) {
  return GenericSortSheet.show<AdjustmentSortField>(
    context,
    fields: AdjustmentSortField.values,
    initialField: selectedField,
    initialDirection: selectedDirection,
    labelBuilder: (field) => field.label,
    onApply: onApply,
  );
}
