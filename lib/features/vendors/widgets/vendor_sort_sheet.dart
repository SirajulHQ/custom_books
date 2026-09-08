import 'package:custom_books/core/enums/sort_direction.dart';
import 'package:custom_books/core/widgets/generic_sort_sheet.dart';
import 'package:custom_books/features/vendors/models/vendor_model.dart';
import 'package:flutter/material.dart';

/// Thin wrapper kept for call-site compatibility.
class VendorSortSheet extends StatelessWidget {
  final VendorsSortField selectedField;
  final SortDirection selectedDirection;
  final void Function(VendorsSortField field, SortDirection direction) onApply;

  const VendorSortSheet({
    super.key,
    required this.selectedField,
    required this.selectedDirection,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    return GenericSortSheet<VendorsSortField>(
      fields: VendorsSortField.values,
      initialField: selectedField,
      initialDirection: selectedDirection,
      labelBuilder: (f) => f.label,
      onApply: onApply,
      compact: true,
      buttonLabel: 'Apply',
    );
  }
}
