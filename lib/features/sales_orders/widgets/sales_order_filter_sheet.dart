import 'package:custom_books/core/widgets/filter_sheet.dart';
import 'package:custom_books/features/sales_orders/models/sales_order_model.dart';
import 'package:flutter/material.dart';

class SalesOrderFilterSheet extends StatelessWidget {
  final SalesOrderStatus? selectedStatus;
  final ValueChanged<SalesOrderStatus?> onSelected;
  final VoidCallback onClose;

  const SalesOrderFilterSheet({
    super.key,
    required this.selectedStatus,
    required this.onSelected,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return FilterSheet<SalesOrderStatus>(
      title: 'Filter',
      showHeaderBorder: true,
      sectionLabel: 'DEFAULT FILTERS',
      options: const [null, ...SalesOrderStatus.values],
      selectedValue: selectedStatus,
      labelBuilder: (status) => status?.label ?? 'All Statuses',
      onSelected: onSelected,
      onClose: onClose,
    );
  }
}
