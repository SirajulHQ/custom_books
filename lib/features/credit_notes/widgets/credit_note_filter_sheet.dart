import 'package:custom_books/core/widgets/filter_sheet.dart';
import 'package:flutter/material.dart';

class CreditNoteFilterSheet<T> extends StatelessWidget {
  final String title;
  final List<T?> options;
  final T? selectedValue;
  final String Function(T?) labelBuilder;
  final ValueChanged<T?> onSelected;

  const CreditNoteFilterSheet({
    super.key,
    required this.title,
    required this.options,
    required this.selectedValue,
    required this.labelBuilder,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterSheet<T>(
      title: title,
      options: options,
      selectedValue: selectedValue,
      labelBuilder: labelBuilder,
      onSelected: onSelected,
    );
  }
}
