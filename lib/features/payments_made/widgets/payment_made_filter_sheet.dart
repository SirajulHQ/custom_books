import 'package:custom_books/core/widgets/filter_sheet.dart';
import 'package:custom_books/features/payments_made/models/payment_made_model.dart';
import 'package:flutter/material.dart';

class PaymentMadeFilterSheet extends StatelessWidget {
  final PaymentMode? selectedMode;
  final ValueChanged<PaymentMode?> onSelected;

  const PaymentMadeFilterSheet({
    super.key,
    required this.selectedMode,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterSheet<PaymentMode>(
      title: 'Filter by Payment Mode',
      compact: true,
      style: FilterOptionStyle.card,
      options: const [null, ...PaymentMode.values],
      selectedValue: selectedMode,
      labelBuilder: (mode) => mode == null ? 'All Modes' : mode.label,
      onSelected: onSelected,
    );
  }
}
