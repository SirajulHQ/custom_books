import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/date_formatter.dart';
import 'package:custom_books/core/widgets/document_list_tile.dart';
import 'package:custom_books/core/widgets/status_chip.dart';
import 'package:custom_books/features/payments_received/models/payment_received_model.dart';
import 'package:flutter/material.dart';

class PaymentReceivedTile extends StatelessWidget {
  final PaymentReceivedModel payment;
  final VoidCallback onTap;

  const PaymentReceivedTile({
    super.key,
    required this.payment,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return DocumentListTile(
      leadingIcon: Icons.payments_outlined,
      leadingColor: AppColors.success,
      primaryText: payment.customerName,
      date: formatDate(payment.paymentDate),
      documentNumber: payment.paymentNumber,
      statusWidget: StatusChip(
        color: AppColors.primaryLight,
        label: payment.mode.label,
      ),
      amount: '₹${payment.amount.toStringAsFixed(2)}',
      amountColor: AppColors.success,
      onTap: onTap,
    );
  }
}
