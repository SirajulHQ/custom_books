import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/date_formatter.dart';
import 'package:custom_books/core/widgets/document_list_tile.dart';
import 'package:custom_books/core/widgets/status_chip.dart';
import 'package:custom_books/features/purchase_orders/models/purchase_order_model.dart';
import 'package:flutter/material.dart';

class PurchaseOrderTile extends StatelessWidget {
  final PurchaseOrderModel order;
  final VoidCallback onTap;

  const PurchaseOrderTile({
    super.key,
    required this.order,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return DocumentListTile(
      leadingIcon: Icons.assignment_outlined,
      leadingColor: AppColors.primary,
      primaryText: order.vendorName,
      date: formatDate(order.orderDate),
      documentNumber: order.purchaseOrderNumber,
      statusWidget: StatusChip(
        color: order.status.color,
        label: order.status.label,
      ),
      amount: '₹${order.total.toStringAsFixed(2)}',
      onTap: onTap,
    );
  }
}
