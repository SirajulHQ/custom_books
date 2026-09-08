import 'package:custom_books/core/widgets/filter_sheet.dart';
import 'package:custom_books/features/manual_journals/models/manual_journal_model.dart';
import 'package:flutter/material.dart';

class ManualJournalFilterSheet extends StatelessWidget {
  final ManualJournalStatus? selectedStatus;
  final ValueChanged<ManualJournalStatus?> onSelected;

  const ManualJournalFilterSheet({
    super.key,
    required this.selectedStatus,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterSheet<ManualJournalStatus>(
      title: 'Filter by Status',
      compact: true,
      style: FilterOptionStyle.radio,
      options: const [null, ...ManualJournalStatus.values],
      selectedValue: selectedStatus,
      labelBuilder: (status) => status?.label ?? 'All Statuses',
      onSelected: onSelected,
    );
  }
}
