import 'package:custom_books/core/enums/sort_direction.dart';
import 'package:custom_books/core/widgets/generic_sort_sheet.dart';
import 'package:custom_books/features/payments_made/models/payment_made_model.dart';
import 'package:flutter/material.dart';

/// Thin wrapper kept for call-site compatibility.
class PaymentMadeSortSheet extends StatelessWidget {
  final PaymentMadeSortField selectedField;
  final SortDirection selectedDirection;
  final void Function(PaymentMadeSortField field, SortDirection direction)
  onApply;

  const PaymentMadeSortSheet({
    super.key,
    required this.selectedField,
    required this.selectedDirection,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    return GenericSortSheet<PaymentMadeSortField>(
      fields: PaymentMadeSortField.values,
      initialField: selectedField,
      initialDirection: selectedDirection,
      labelBuilder: (f) => f.label,
      onApply: onApply,
      compact: true,
      buttonLabel: 'Apply',
    );
  }
}
