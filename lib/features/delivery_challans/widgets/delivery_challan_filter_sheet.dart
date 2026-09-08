import 'package:custom_books/core/widgets/filter_sheet.dart';
import 'package:custom_books/features/delivery_challans/models/delivery_challan_model.dart';
import 'package:flutter/material.dart';

class DeliveryChallanFilterSheet extends StatelessWidget {
  final DeliveryChallanStatus? selectedStatus;

  const DeliveryChallanFilterSheet({
    super.key,
    required this.selectedStatus,
  });

  @override
  Widget build(BuildContext context) {
    return FilterSheet<DeliveryChallanStatus>(
      title: 'Filter',
      options: const [null, ...DeliveryChallanStatus.values],
      selectedValue: selectedStatus,
      labelBuilder: (status) => status?.label ?? 'All Statuses',
      onSelected: (status) => Navigator.pop(context, status),
      onClose: () => Navigator.pop(context),
    );
  }
}