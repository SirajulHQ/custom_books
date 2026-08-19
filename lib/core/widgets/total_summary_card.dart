import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/widgets/form_widgets.dart';
import 'package:flutter/material.dart';

class TotalSummaryCard extends StatelessWidget {
  final double subTotal;
  final double taxAmount;
  final double total;
  final String currencySymbol;

  const TotalSummaryCard({
    super.key,
    required this.subTotal,
    required this.taxAmount,
    required this.total,
    this.currencySymbol = '₹',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Dimensions.width15),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(Dimensions.radius15),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.18),
        ),
      ),
      child: Column(
        children: [
          _buildRow(context, 'Sub Total', subTotal),
          _buildRow(context, 'Tax', taxAmount),
          const FormDivider(),
          _buildRow(context, 'Total', total, bold: true),
        ],
      ),
    );
  }

  Widget _buildRow(
    BuildContext context,
    String label,
    double value, {
    bool bold = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Dimensions.height10 / 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.82,
              fontWeight: bold ? FontWeight.w800 : FontWeight.w500,
              color: bold
                  ? context.colors.textPrimary
                  : context.colors.textSecondary,
            ),
          ),
          Text(
            '$currencySymbol${value.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: Dimensions.font16 * (bold ? 0.95 : 0.82),
              fontWeight: FontWeight.w700,
              color: bold ? AppColors.primary : context.colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
