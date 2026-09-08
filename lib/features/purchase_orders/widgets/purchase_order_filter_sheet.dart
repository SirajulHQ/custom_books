import 'package:custom_books/core/widgets/filter_sheet.dart';
import 'package:custom_books/features/purchase_orders/models/purchase_order_model.dart';
import 'package:flutter/material.dart';

class PurchaseOrderFilterSheet extends StatelessWidget {
  final PurchaseOrderStatus? selectedStatus;
  final ValueChanged<PurchaseOrderStatus?> onSelected;

  const PurchaseOrderFilterSheet({
    super.key,
    required this.selectedStatus,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterSheet<PurchaseOrderStatus>(
      title: 'Filter by Status',
      compact: true,
      style: FilterOptionStyle.radio,
      options: const [null, ...PurchaseOrderStatus.values],
      selectedValue: selectedStatus,
      labelBuilder: (status) => status?.label ?? 'All Statuses',
      onSelected: onSelected,
    );
  }
}
