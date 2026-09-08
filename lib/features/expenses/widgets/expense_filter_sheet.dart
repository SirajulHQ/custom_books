import 'package:custom_books/core/widgets/filter_sheet.dart';
import 'package:custom_books/features/expenses/models/expense_model.dart';
import 'package:flutter/material.dart';

class ExpenseFilterSheet extends StatelessWidget {
  final ExpenseStatus? selectedStatus;
  final ValueChanged<ExpenseStatus?> onSelected;

  const ExpenseFilterSheet({
    super.key,
    required this.selectedStatus,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterSheet<ExpenseStatus>(
      title: 'Filter by Status',
      compact: true,
      style: FilterOptionStyle.card,
      options: const [null, ...ExpenseStatus.values],
      selectedValue: selectedStatus,
      labelBuilder: (status) => status == null ? 'All Expenses' : status.label,
      onSelected: onSelected,
    );
  }
}
