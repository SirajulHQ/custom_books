import 'package:custom_books/core/widgets/filter_sheet.dart';
import 'package:custom_books/features/bills/models/bill_model.dart';
import 'package:flutter/material.dart';

class BillFilterSheet extends StatelessWidget {
  final BillStatus? selectedStatus;
  final ValueChanged<BillStatus?> onSelected;

  const BillFilterSheet({
    super.key,
    required this.selectedStatus,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterSheet<BillStatus>(
      title: 'Filter by Status',
      compact: true,
      style: FilterOptionStyle.card,
      options: const [null, ...BillStatus.values],
      selectedValue: selectedStatus,
      labelBuilder: (status) => status == null ? 'All Bills' : status.label,
      onSelected: onSelected,
    );
  }
}
