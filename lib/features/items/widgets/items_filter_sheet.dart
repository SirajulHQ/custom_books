import 'package:custom_books/core/widgets/filter_sheet.dart';
import 'package:flutter/material.dart';

class ItemsFilterSheet extends StatelessWidget {
  final List<String> options;
  final String selectedFilter;
  final ValueChanged<String> onSelected;
  final VoidCallback onClose;

  const ItemsFilterSheet({
    super.key,
    required this.options,
    required this.selectedFilter,
    required this.onSelected,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return FilterSheet<String>(
      title: 'Filter',
      showHeaderBorder: true,
      sectionLabel: 'DEFAULT FILTERS',
      options: options,
      selectedValue: selectedFilter,
      labelBuilder: (filter) => filter ?? '',
      onSelected: (filter) {
        if (filter != null) onSelected(filter);
      },
      onClose: onClose,
    );
  }
}
