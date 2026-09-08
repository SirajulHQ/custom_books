import 'package:custom_books/core/widgets/filter_sheet.dart';
import 'package:custom_books/features/vendors/models/vendor_model.dart';
import 'package:flutter/material.dart';

class VendorFilterSheet extends StatelessWidget {
  final VendorStatus? selectedStatus;
  final ValueChanged<VendorStatus?> onSelected;

  const VendorFilterSheet({
    super.key,
    required this.selectedStatus,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterSheet<VendorStatus>(
      title: 'Filter by Status',
      compact: true,
      style: FilterOptionStyle.card,
      options: const [null, ...VendorStatus.values],
      selectedValue: selectedStatus,
      labelBuilder: (status) => status == null ? 'All Vendors' : status.label,
      onSelected: onSelected,
    );
  }
}
