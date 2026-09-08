import 'package:custom_books/core/enums/sort_direction.dart';
import 'package:custom_books/core/widgets/generic_sort_sheet.dart';
import 'package:custom_books/features/time_entries/models/time_entry_model.dart';
import 'package:flutter/material.dart';

/// Thin wrapper kept for call-site compatibility.
class TimeEntrySortSheet extends StatelessWidget {
  final TimeEntrySortField selectedField;
  final SortDirection selectedDirection;
  final void Function(TimeEntrySortField field, SortDirection direction)
  onApply;

  const TimeEntrySortSheet({
    super.key,
    required this.selectedField,
    required this.selectedDirection,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    return GenericSortSheet<TimeEntrySortField>(
      fields: TimeEntrySortField.values,
      initialField: selectedField,
      initialDirection: selectedDirection,
      labelBuilder: (f) => f.label,
      onApply: onApply,
      compact: true,
      buttonLabel: 'Apply',
    );
  }
}
