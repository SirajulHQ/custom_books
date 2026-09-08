import 'package:custom_books/core/enums/sort_direction.dart';
import 'package:custom_books/core/widgets/generic_sort_sheet.dart';
import 'package:custom_books/features/documents/models/document_model.dart';
import 'package:flutter/material.dart';

/// Thin wrapper kept for call-site compatibility.
class DocumentSortSheet extends StatelessWidget {
  final DocumentSortField selectedField;
  final SortDirection selectedDirection;
  final void Function(DocumentSortField field, SortDirection direction) onApply;

  const DocumentSortSheet({
    super.key,
    required this.selectedField,
    required this.selectedDirection,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    return GenericSortSheet<DocumentSortField>(
      fields: DocumentSortField.values,
      initialField: selectedField,
      initialDirection: selectedDirection,
      labelBuilder: (f) => f.label,
      onApply: onApply,
      compact: true,
      buttonLabel: 'Apply',
    );
  }
}
