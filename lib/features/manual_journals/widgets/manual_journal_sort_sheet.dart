import 'package:custom_books/core/enums/sort_direction.dart';
import 'package:custom_books/core/widgets/generic_sort_sheet.dart';
import 'package:custom_books/features/manual_journals/models/manual_journal_model.dart';
import 'package:flutter/material.dart';

/// Thin wrapper kept for call-site compatibility.
class ManualJournalSortSheet extends StatelessWidget {
  final ManualJournalSortField selectedField;
  final SortDirection selectedDirection;
  final void Function(ManualJournalSortField field, SortDirection direction)
  onApply;

  const ManualJournalSortSheet({
    super.key,
    required this.selectedField,
    required this.selectedDirection,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    return GenericSortSheet<ManualJournalSortField>(
      fields: ManualJournalSortField.values,
      initialField: selectedField,
      initialDirection: selectedDirection,
      labelBuilder: (f) => f.label,
      onApply: onApply,
      compact: true,
      buttonLabel: 'Apply',
    );
  }
}
