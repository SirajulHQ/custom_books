import 'package:custom_books/core/widgets/filter_sheet.dart';
import 'package:custom_books/features/payments_received/models/payment_received_model.dart';
import 'package:flutter/material.dart';

class PaymentReceivedFilterSheet extends StatelessWidget {
  final PaymentMode? selectedMode;
  final ValueChanged<PaymentMode?> onSelected;

  const PaymentReceivedFilterSheet({
    super.key,
    required this.selectedMode,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterSheet<PaymentMode>(
      title: 'Filter by mode',
      options: const [null, ...PaymentMode.values],
      selectedValue: selectedMode,
      labelBuilder: (mode) => mode?.label ?? 'All Modes',
      onSelected: onSelected,
    );
  }
}
