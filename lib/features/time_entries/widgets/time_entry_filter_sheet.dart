import 'package:custom_books/core/widgets/filter_sheet.dart';
import 'package:flutter/material.dart';

class TimeEntryFilterSheet extends StatelessWidget {
  final bool? selectedBillable;
  final ValueChanged<bool?> onSelected;

  const TimeEntryFilterSheet({
    super.key,
    required this.selectedBillable,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterSheet<bool>(
      title: 'Filter by Type',
      compact: true,
      style: FilterOptionStyle.radio,
      options: const [null, true, false],
      selectedValue: selectedBillable,
      labelBuilder: (b) => b == null
          ? 'All Entries'
          : (b ? 'BILLABLE' : 'NON-BILLABLE'),
      onSelected: onSelected,
    );
  }
}
