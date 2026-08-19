import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/features/banking/widgets/banking_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BankingSummaryCard extends StatefulWidget {
  final List<FlSpot> chartData;
  final double cashInHand;
  final double bankBalance;

  const BankingSummaryCard({
    super.key,
    required this.chartData,
    required this.cashInHand,
    required this.bankBalance,
  });

  @override
  State<BankingSummaryCard> createState() => _BankingSummaryCardState();
}

class _BankingSummaryCardState extends State<BankingSummaryCard> {
  bool _isChartVisible = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: Dimensions.width20),
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: BorderRadius.circular(Dimensions.radius15),
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        children: [
          // Header with Hide/Show button
          Padding(
            padding: EdgeInsets.all(Dimensions.width20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Banking Summary',
                  style: TextStyle(
                    fontSize: Dimensions.font20 * 0.95,
                    color: context.colors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isChartVisible = !_isChartVisible;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.width15 * 0.8,
                      vertical: Dimensions.height10 / 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(Dimensions.radius20),
                    ),
                    child: Row(
                      children: [
                        Text(
                          _isChartVisible ? 'Hide' : 'Show',
                          style: TextStyle(
                            fontSize: Dimensions.font16 * 0.8,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: Dimensions.width10 / 3),
                        Icon(
                          _isChartVisible
                              ? Icons.keyboard_arrow_up_rounded
                              : Icons.keyboard_arrow_down_rounded,
                          color: AppColors.primary,
                          size: Dimensions.iconSize16,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Chart (conditionally shown)
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: _isChartVisible
                ? BankingChart(
                    dataPoints: widget.chartData,
                    cashInHand: widget.cashInHand,
                    bankBalance: widget.bankBalance,
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
