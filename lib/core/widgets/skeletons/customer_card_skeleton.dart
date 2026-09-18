import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/widgets/shimmer_effect.dart';
import 'package:custom_books/core/widgets/skeletons/skeleton_box.dart';
import 'package:flutter/material.dart';

/// Skeleton that mirrors `CustomerCardWidget`: a circular avatar, a name +
/// email column, and a two-metric row (receivables / unused credits).
class CustomerCardSkeleton extends StatelessWidget {
  const CustomerCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final double avatar = Dimensions.height45 * 1.1;

    return Container(
      padding: EdgeInsets.all(Dimensions.width20),
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: BorderRadius.circular(Dimensions.radius15),
        border: Border.all(color: context.colors.border),
      ),
      child: Row(
        children: [
          SkeletonBox(width: avatar, height: avatar, shape: BoxShape.circle),
          SizedBox(width: Dimensions.width15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonLine(
                  width: Dimensions.width30 * 3.5,
                  height: Dimensions.font16 * 0.95,
                ),
                SizedBox(height: Dimensions.height10),
                SkeletonLine(
                  width: Dimensions.width30 * 5,
                  height: Dimensions.font16 * 0.75,
                ),
                SizedBox(height: Dimensions.height15),
                Row(
                  children: [
                    Expanded(child: _metric()),
                    Expanded(child: _metric()),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _metric() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SkeletonLine(
          width: Dimensions.width30 * 2,
          height: Dimensions.font16 * 0.7,
        ),
        SizedBox(height: Dimensions.height10 * 0.7),
        SkeletonLine(
          width: Dimensions.width30 * 2.4,
          height: Dimensions.font16 * 0.85,
        ),
      ],
    );
  }
}

/// A full list of [CustomerCardSkeleton] rows wrapped in one [ShimmerEffect].
class CustomerListSkeleton extends StatelessWidget {
  const CustomerListSkeleton({super.key, this.itemCount = 6, this.padding});

  final int itemCount;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      child: ListView.separated(
        padding:
            padding ??
            EdgeInsets.fromLTRB(
              Dimensions.width20,
              Dimensions.height15,
              Dimensions.width20,
              Dimensions.listBottomSpace,
            ),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: itemCount,
        separatorBuilder: (_, _) => SizedBox(height: Dimensions.height15),
        itemBuilder: (context, index) => const CustomerCardSkeleton(),
      ),
    );
  }
}
