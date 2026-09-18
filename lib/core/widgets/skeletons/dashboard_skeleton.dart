import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/widgets/shimmer_effect.dart';
import 'package:custom_books/core/widgets/skeletons/skeleton_box.dart';
import 'package:flutter/material.dart';

/// Skeleton for the home dashboard overview content: a balances grid, a
/// quick-actions grid and a set of stacked summary cards. Mirrors the
/// widgets rendered by the home overview. Wrapped in one [ShimmerEffect].
class DashboardSkeleton extends StatelessWidget {
  const DashboardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: Dimensions.height15),

          // Balances grid (2 x 2)
          _grid(context, rows: 2, cols: 2, tileHeight: Dimensions.height80),
          SizedBox(height: Dimensions.height20),

          // Quick actions grid (2 rows of 4 small tiles)
          _grid(context, rows: 2, cols: 4, tileHeight: Dimensions.height80 * 0.9),
          SizedBox(height: Dimensions.height20),

          // Banking strip
          _card(context, height: Dimensions.height80),
          SizedBox(height: Dimensions.height20),

          // Chart-style cards
          _card(context, height: Dimensions.height90 * 2.2),
          SizedBox(height: Dimensions.height20),
          _card(context, height: Dimensions.height90 * 2),
          SizedBox(height: Dimensions.height20),
          _card(context, height: Dimensions.height90 * 1.6),
          SizedBox(height: Dimensions.height30),
        ],
      ),
    );
  }

  Widget _card(BuildContext context, {required double height}) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: BorderRadius.circular(Dimensions.radius20),
        border: Border.all(color: context.colors.border),
      ),
      padding: EdgeInsets.all(Dimensions.width20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonLine(width: Dimensions.width30 * 4, height: Dimensions.font16),
          SizedBox(height: Dimensions.height15),
          Expanded(
            child: SkeletonBox(
              width: double.infinity,
              borderRadius: BorderRadius.circular(Dimensions.radius15),
            ),
          ),
        ],
      ),
    );
  }

  Widget _grid(
    BuildContext context, {
    required int rows,
    required int cols,
    required double tileHeight,
  }) {
    return Column(
      children: [
        for (int r = 0; r < rows; r++) ...[
          Row(
            children: [
              for (int c = 0; c < cols; c++) ...[
                Expanded(
                  child: Container(
                    height: tileHeight,
                    decoration: BoxDecoration(
                      color: context.colors.card,
                      borderRadius:
                          BorderRadius.circular(Dimensions.radius15),
                      border: Border.all(color: context.colors.border),
                    ),
                  ),
                ),
                if (c != cols - 1) SizedBox(width: Dimensions.width15),
              ],
            ],
          ),
          if (r != rows - 1) SizedBox(height: Dimensions.height15),
        ],
      ],
    );
  }
}
