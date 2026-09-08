import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/date_formatter.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/widgets/document_list_tile.dart';
import 'package:custom_books/core/widgets/status_chip.dart';
import 'package:custom_books/features/sales_orders/models/sales_order_model.dart';
import 'package:flutter/material.dart';

class SalesOrderTile extends StatelessWidget {
  const SalesOrderTile({
    super.key,
    required this.order,
    required this.onTap,
    this.onLongPress,
  });

  final SalesOrderModel order;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    return DocumentListTile(
      leadingIcon: Icons.shopping_bag_outlined,
      leadingColor: AppColors.primary,
      primaryText: order.customerName,
      date: formatDate(order.salesOrderDate),
      documentNumber: order.salesOrderNumber,
      statusWidget: StatusChip(
        color: order.status.color,
        label: order.status.label,
      ),
      trailingBadge: _InvoicedBadge(isInvoiced: order.isInvoiced),
      amount: '₹${order.total.toStringAsFixed(2)}',
      onTap: onTap,
      onLongPress: onLongPress,
    );
  }
}

class _InvoicedBadge extends StatelessWidget {
  final bool isInvoiced;

  const _InvoicedBadge({required this.isInvoiced});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.width10 * 0.7,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: context.colors.surfaceLight,
        borderRadius: BorderRadius.circular(Dimensions.radius30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: Dimensions.width10 * 0.6,
            height: Dimensions.height10 * 0.6,
            decoration: BoxDecoration(
              color: isInvoiced
                  ? AppColors.success
                  : context.colors.textTertiary,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: Dimensions.width10 / 3),
          Text(
            isInvoiced ? 'Invoiced' : 'Not Invoiced',
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.6,
              color: context.colors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
