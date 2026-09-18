import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/widgets/shimmer_effect.dart';
import 'package:custom_books/core/widgets/skeletons/skeleton_box.dart';
import 'package:flutter/material.dart';

/// A skeleton for add / edit form pages: grouped cards each containing a
/// section title and a set of labelled input-field placeholders.
/// Wrapped in a single [ShimmerEffect].
class FormPageSkeleton extends StatelessWidget {
  const FormPageSkeleton({
    super.key,
    this.sectionFieldCounts = const [3, 4, 2],
    this.showSaveBar = true,
  });

  /// Number of field placeholders per grouped card section.
  final List<int> sectionFieldCounts;
  final bool showSaveBar;

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.fromLTRB(
                Dimensions.width20,
                Dimensions.height15,
                Dimensions.width20,
                Dimensions.height20,
              ),
              children: [
                for (final count in sectionFieldCounts) ...[
                  _buildSectionCard(context, count),
                  SizedBox(height: Dimensions.height20),
                ],
              ],
            ),
          ),
          if (showSaveBar)
            Container(
              padding: EdgeInsets.fromLTRB(
                Dimensions.width20,
                Dimensions.height15,
                Dimensions.width20,
                Dimensions.bottomSafeSpace,
              ),
              decoration: BoxDecoration(
                color: context.colors.card,
                border: Border(
                  top: BorderSide(color: context.colors.border),
                ),
              ),
              child: SkeletonBox(
                height: Dimensions.height52,
                borderRadius: BorderRadius.circular(Dimensions.radius15),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(BuildContext context, int fieldCount) {
    return Container(
      padding: EdgeInsets.all(Dimensions.width20),
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: BorderRadius.circular(Dimensions.radius20),
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          SkeletonLine(
            width: Dimensions.width30 * 3.5,
            height: Dimensions.font16,
          ),
          SizedBox(height: Dimensions.height20),
          for (int i = 0; i < fieldCount; i++) ...[
            // Field label
            SkeletonLine(
              width: Dimensions.width30 * (2 + (i % 2)),
              height: Dimensions.font16 * 0.75,
            ),
            SizedBox(height: Dimensions.height10),
            // Field input box
            SkeletonBox(
              height: Dimensions.height45,
              borderRadius: BorderRadius.circular(Dimensions.radius15 * 0.7),
            ),
            if (i != fieldCount - 1) SizedBox(height: Dimensions.height20),
          ],
        ],
      ),
    );
  }
}
