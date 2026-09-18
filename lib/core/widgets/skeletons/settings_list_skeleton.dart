import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/widgets/shimmer_effect.dart';
import 'package:custom_books/core/widgets/skeletons/skeleton_box.dart';
import 'package:flutter/material.dart';

/// Skeleton row matching [SettingsTile]: leading icon, a label line and an
/// optional trailing chevron/toggle placeholder.
class SettingsTileSkeleton extends StatelessWidget {
  const SettingsTileSkeleton({super.key, this.labelWidth});

  final double? labelWidth;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: Dimensions.height20,
        horizontal: Dimensions.width10,
      ),
      child: Row(
        children: [
          SkeletonBox(
            width: Dimensions.iconSize24,
            height: Dimensions.iconSize24,
            borderRadius: BorderRadius.circular(Dimensions.radius15 * 0.4),
          ),
          SizedBox(width: Dimensions.width20),
          SkeletonLine(
            width: labelWidth ?? Dimensions.width30 * 4.5,
            height: Dimensions.font16 * 0.9,
          ),
          const Spacer(),
          SkeletonBox(
            width: Dimensions.iconSize20,
            height: Dimensions.iconSize20,
            borderRadius: BorderRadius.circular(Dimensions.radius15 * 0.4),
          ),
        ],
      ),
    );
  }
}

/// A full settings list skeleton: grouped card sections of settings rows,
/// wrapped in one [ShimmerEffect].
class SettingsListSkeleton extends StatelessWidget {
  const SettingsListSkeleton({
    super.key,
    this.sectionCounts = const [1, 4, 3, 2],
    this.padding,
  });

  /// Number of rows per grouped card section.
  final List<int> sectionCounts;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      child: ListView(
        padding:
            padding ??
            EdgeInsets.fromLTRB(
              Dimensions.width20,
              Dimensions.height15,
              Dimensions.width20,
              Dimensions.bottomSafeSpace,
            ),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          for (final count in sectionCounts) ...[
            Container(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.width10),
              decoration: BoxDecoration(
                color: context.colors.card,
                borderRadius: BorderRadius.circular(Dimensions.radius15),
                border: Border.all(color: context.colors.border),
              ),
              child: Column(
                children: [
                  for (int i = 0; i < count; i++)
                    SettingsTileSkeleton(
                      labelWidth: Dimensions.width30 * (3.2 + (i % 3)),
                    ),
                ],
              ),
            ),
            SizedBox(height: Dimensions.height15),
          ],
        ],
      ),
    );
  }
}
