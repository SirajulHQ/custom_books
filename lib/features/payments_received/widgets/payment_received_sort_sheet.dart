import 'package:custom_books/core/enums/sort_direction.dart';
import 'package:custom_books/core/widgets/generic_sort_sheet.dart';
import 'package:custom_books/features/payments_received/models/payment_received_model.dart';
import 'package:flutter/material.dart';

/// Thin wrapper kept for call-site compatibility.
class PaymentReceivedSortSheet extends StatelessWidget {
  final PaymentReceivedSortField selectedField;
  final SortDirection selectedDirection;
  final void Function(PaymentReceivedSortField field, SortDirection direction)
  onApply;

  const PaymentReceivedSortSheet({
    super.key,
    required this.selectedField,
    required this.selectedDirection,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    return GenericSortSheet<PaymentReceivedSortField>(
      fields: PaymentReceivedSortField.values,
      initialField: selectedField,
      initialDirection: selectedDirection,
      labelBuilder: (f) => f.label,
      onApply: onApply,
    );
  }
}
