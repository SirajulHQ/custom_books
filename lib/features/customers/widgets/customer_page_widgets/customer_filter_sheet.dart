import 'package:custom_books/core/widgets/filter_sheet.dart';
import 'package:flutter/material.dart';

class CustomerFilterSheet extends StatelessWidget {
  final String selectedFilter;
  final List<String> filterOptions;
  final ValueChanged<String> onSelected;

  const CustomerFilterSheet({
    super.key,
    required this.selectedFilter,
    required this.filterOptions,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterSheet<String>(
      title: 'Filter',
      showHeaderBorder: true,
      sectionLabel: 'DEFAULT FILTERS',
      options: filterOptions,
      selectedValue: selectedFilter,
      labelBuilder: (filter) => filter ?? '',
      onSelected: (filter) {
        if (filter != null) onSelected(filter);
      },
    );
  }
}
