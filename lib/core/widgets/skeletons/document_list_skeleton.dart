import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/widgets/shimmer_effect.dart';
import 'package:custom_books/core/widgets/skeletons/skeleton_box.dart';
import 'package:flutter/material.dart';

/// Skeleton placeholder that mirrors [DocumentListTile]'s layout:
/// leading icon box, a stacked column of text lines + a status chip, and a
/// trailing amount. Used by every document-style list page while loading.
class DocumentListTileSkeleton extends StatelessWidget {
  const DocumentListTileSkeleton({super.key, this.showSubDate = false});

  /// Whether to render the extra sub-date row (invoices/bills show a due date).
  final bool showSubDate;

  @override
  Widget build(BuildContext context) {
    final double iconBox = Dimensions.height45 * 0.78;

    return Container(
      margin: EdgeInsets.only(bottom: Dimensions.height10),
      padding: EdgeInsets.all(Dimensions.width15),
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: BorderRadius.circular(Dimensions.radius15),
        border: Border.all(color: context.colors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Leading icon box
          SkeletonBox(
            width: iconBox,
            height: iconBox,
            borderRadius: BorderRadius.circular(Dimensions.radius15 - 4),
          ),
          SizedBox(width: Dimensions.width15),

          // Middle column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Primary text (name)
                SkeletonLine(
                  width: Dimensions.width30 * 4.2,
                  height: Dimensions.font16 * 0.95,
                ),
                SizedBox(height: Dimensions.height10 * 0.9),

                // Date + document number row
                SkeletonLine(
                  width: Dimensions.width30 * 3.4,
                  height: Dimensions.font16 * 0.7,
                ),

                if (showSubDate) ...[
                  SizedBox(height: Dimensions.height10 * 0.7),
                  SkeletonLine(
                    width: Dimensions.width30 * 2.8,
                    height: Dimensions.font16 * 0.7,
                  ),
                ],

                SizedBox(height: Dimensions.height10 * 0.9),

                // Status chip
                SkeletonBox(
                  width: Dimensions.width30 * 2.2,
                  height: Dimensions.font16 * 1.2,
                  borderRadius: BorderRadius.circular(Dimensions.radius15),
                ),
              ],
            ),
          ),
          SizedBox(width: Dimensions.width10),

          // Trailing amount
          SkeletonLine(
            width: Dimensions.width30 * 1.9,
            height: Dimensions.font16 * 0.9,
          ),
        ],
      ),
    );
  }
}

/// A full-list shimmer skeleton: a scrollable column of
/// [DocumentListTileSkeleton] rows wrapped once in a single [ShimmerEffect].
///
/// Drop this into the same slot where the real `ListView.builder` renders.
class DocumentListSkeleton extends StatelessWidget {
  const DocumentListSkeleton({
    super.key,
    this.itemCount = 7,
    this.showSubDate = false,
    this.padding,
  });

  final int itemCount;
  final bool showSubDate;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      child: ListView.builder(
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
        itemBuilder: (context, index) =>
            DocumentListTileSkeleton(showSubDate: showSubDate),
      ),
    );
  }
}
