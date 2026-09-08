import 'package:custom_books/core/widgets/filter_sheet.dart';
import 'package:custom_books/features/invoices/models/invoice_model.dart';
import 'package:flutter/material.dart';

class InvoiceFilterSheet extends StatelessWidget {
  final InvoiceStatus? selectedStatus;
  final ValueChanged<InvoiceStatus?> onSelected;

  const InvoiceFilterSheet({
    super.key,
    required this.selectedStatus,
    required this.onSelected,
  });

  /// Opens the sheet and wires the selection callback for you.
  static Future<void> show(
    BuildContext context, {
    required InvoiceStatus? selectedStatus,
    required ValueChanged<InvoiceStatus?> onSelected,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => InvoiceFilterSheet(
        selectedStatus: selectedStatus,
        onSelected: onSelected,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FilterSheet<InvoiceStatus>(
      title: 'Filter',
      options: const [null, ...InvoiceStatus.values],
      selectedValue: selectedStatus,
      labelBuilder: (status) => status?.label ?? 'All Statuses',
      onSelected: onSelected,
    );
  }
}
