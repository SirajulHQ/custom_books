import 'package:custom_books/core/widgets/filter_sheet.dart';
import 'package:custom_books/features/documents/models/document_model.dart';
import 'package:flutter/material.dart';

class DocumentFilterSheet extends StatelessWidget {
  final DocumentType? selectedType;
  final ValueChanged<DocumentType?> onSelected;

  const DocumentFilterSheet({
    super.key,
    required this.selectedType,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterSheet<DocumentType>(
      title: 'Filter by Type',
      compact: true,
      style: FilterOptionStyle.radio,
      options: const [null, ...DocumentType.values],
      selectedValue: selectedType,
      labelBuilder: (type) => type == null ? 'All Types' : type.label,
      iconBuilder: (type) => type == null ? Icons.apps_rounded : type.iconData,
      onSelected: onSelected,
    );
  }
}
