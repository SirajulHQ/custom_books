import 'package:custom_books/core/widgets/filter_sheet.dart';
import 'package:custom_books/features/vendor_credits/models/vendor_credit_model.dart';
import 'package:flutter/material.dart';

class VendorCreditFilterSheet extends StatelessWidget {
  final VendorCreditStatus? selectedStatus;
  final ValueChanged<VendorCreditStatus?> onSelected;

  const VendorCreditFilterSheet({
    super.key,
    required this.selectedStatus,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterSheet<VendorCreditStatus>(
      title: 'Filter by Status',
      compact: true,
      style: FilterOptionStyle.radio,
      options: const [null, ...VendorCreditStatus.values],
      selectedValue: selectedStatus,
      labelBuilder: (status) => status?.label ?? 'All Statuses',
      onSelected: onSelected,
    );
  }
}
