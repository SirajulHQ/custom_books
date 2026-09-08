import 'package:custom_books/core/widgets/filter_sheet.dart';
import 'package:custom_books/features/quotes/models/quote_model.dart';
import 'package:flutter/material.dart';

class QuoteFilterSheet extends StatelessWidget {
  final QuoteStatus? selectedStatus;
  final ValueChanged<QuoteStatus?> onSelected;
  final VoidCallback onClose;

  const QuoteFilterSheet({
    super.key,
    required this.selectedStatus,
    required this.onSelected,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return FilterSheet<QuoteStatus>(
      title: 'Filter',
      showHeaderBorder: true,
      sectionLabel: 'DEFAULT FILTERS',
      options: const [null, ...QuoteStatus.values],
      selectedValue: selectedStatus,
      labelBuilder: (status) => status?.label ?? 'All Statuses',
      onSelected: onSelected,
      onClose: onClose,
    );
  }
}
