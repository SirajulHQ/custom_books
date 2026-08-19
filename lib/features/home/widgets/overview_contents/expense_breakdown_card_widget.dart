import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/dummy_data/dummy_data_list.dart';
import 'package:custom_books/features/home/widgets/card_tile_widget.dart';
import 'package:flutter/material.dart';

class ExpenseBreakdownCardWidget extends StatelessWidget {
  const ExpenseBreakdownCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final total = topExpenses.fold<double>(0, (p, e) => p + e.amount);
    return Container(
      padding: EdgeInsets.all(Dimensions.width15),
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: BorderRadius.circular(Dimensions.radius20),
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CardTitle(
                title: 'Expense Breakdown',
                icon: Icons.donut_small_rounded,
              ),
              Text(
                '₹${total.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: Dimensions.font16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
          SizedBox(height: Dimensions.height20),
          ...topExpenses.map((e) {
            final ratio = total == 0 ? 0.0 : (e.amount / total).clamp(0.0, 1.0);
            return Padding(
              padding: EdgeInsets.symmetric(
                vertical: Dimensions.height10 / 1.5,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        e.label,
                        style: TextStyle(
                          fontSize: Dimensions.font16 * 0.85,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '₹${e.amount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: Dimensions.font16 * 0.85,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Dimensions.height10 / 2),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                      Dimensions.radius15 * 0.67,
                    ),
                    child: LinearProgressIndicator(
                      value: ratio,
                      minHeight: Dimensions.height10 * 0.6,
                      backgroundColor: context.colors.border,
                      valueColor: AlwaysStoppedAnimation(e.color),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
