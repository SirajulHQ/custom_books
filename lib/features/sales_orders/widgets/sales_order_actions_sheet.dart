import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/features/sales_orders/models/sales_order_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SalesOrderActionsSheet extends StatelessWidget {
  final SalesOrderModel order;
  final ValueChanged<SalesOrderStatus> onStatusChanged;
  final VoidCallback onDelete;

  const SalesOrderActionsSheet({
    super.key,
    required this.order,
    required this.onStatusChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);
    final currencyFormat = NumberFormat.currency(symbol: '₹', decimalDigits: 2);
    final dateFormat = DateFormat('dd MMM yyyy');

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          Dimensions.width20,
          Dimensions.height10,
          Dimensions.width20,
          Dimensions.height20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order.salesOrderNumber,
                  style: TextStyle(
                    fontSize: Dimensions.font20,
                    fontWeight: FontWeight.w800,
                    color: context.colors.textPrimary,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.width10,
                    vertical: Dimensions.height10 / 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(Dimensions.radius15),
                  ),
                  child: Text(
                    order.status.label,
                    style: TextStyle(
                      fontSize: Dimensions.font16 * 0.75,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: Dimensions.height10),
            Text(
              order.customerName,
              style: TextStyle(
                fontSize: Dimensions.font16,
                fontWeight: FontWeight.w600,
                color: context.colors.textPrimary,
              ),
            ),
            SizedBox(height: Dimensions.height10 / 2),
            Text(
              'Date: ${dateFormat.format(order.salesOrderDate)} | Total: ${currencyFormat.format(order.total)}',
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.8,
                color: context.colors.textSecondary,
              ),
            ),
            Divider(height: Dimensions.height20 * 1.5, color: context.colors.border),
            if (order.status == SalesOrderStatus.draft)
              ListTile(
                leading: const Icon(Icons.check_circle_outline_rounded, color: Colors.green),
                title: const Text('Mark as Confirmed'),
                onTap: () {
                  Navigator.pop(context);
                  onStatusChanged(SalesOrderStatus.confirmed);
                },
              ),
            if (order.status == SalesOrderStatus.confirmed)
              ListTile(
                leading: const Icon(Icons.receipt_long_rounded, color: AppColors.primary),
                title: const Text('Convert to Invoice'),
                onTap: () {
                  Navigator.pop(context);
                  onStatusChanged(SalesOrderStatus.invoiced);
                },
              ),
            ListTile(
              leading: const Icon(Icons.delete_outline_rounded, color: Colors.red),
              title: const Text('Delete Sales Order', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                onDelete();
              },
            ),
          ],
        ),
      ),
    );
  }
}
