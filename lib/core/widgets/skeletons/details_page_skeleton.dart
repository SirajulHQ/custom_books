import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/widgets/shimmer_effect.dart';
import 'package:custom_books/core/widgets/skeletons/skeleton_box.dart';
import 'package:flutter/material.dart';

/// Header layout variants so the skeleton matches the real details header.
enum DetailsHeaderStyle {
  /// Full-bleed card: date label + status pill row, big date line, name line,
  /// document-number line. Matches invoice / bill / expense / credit-note /
  /// payment / order / journal / adjustment / challan / recurring details.
  document,

  /// Full-bleed card: two side-by-side metric columns split by a divider.
  /// Matches customer / vendor details (Receivables | Unused Credits).
  twoMetric,

  /// Full-bleed card: a square thumbnail with a name + chips column beside it.
  /// Matches item details.
  avatar,

  /// A large full-width preview box (rounded, centered thumbnail), then an
  /// info card and two action buttons. Matches the document/file details page.
  preview,
}

/// Tab-bar visual style so the skeleton matches the real details tab bar.
enum DetailsTabStyle {
  /// A rounded pill segmented control inside a [surfaceLight] track.
  pill,

  /// A plain full-width underline tab bar on a card background.
  underline,
}

/// A skeleton that mirrors the common document *details* layout:
/// a full-bleed header summary, an optional tab bar, then a body of detail
/// rows and an optional totals card. Wrapped in a single [ShimmerEffect].
class DetailsPageSkeleton extends StatelessWidget {
  const DetailsPageSkeleton({
    super.key,
    this.headerStyle = DetailsHeaderStyle.document,
    this.showTabs = true,
    this.tabStyle = DetailsTabStyle.pill,
    this.tabCount = 2,
    this.detailRows = 6,
    this.showLineItems = false,
    this.lineItemCount = 3,
    this.showTotalsCard = true,
  });

  final DetailsHeaderStyle headerStyle;
  final bool showTabs;
  final DetailsTabStyle tabStyle;
  final int tabCount;
  final int detailRows;

  /// Whether to render a line-items card (section title + item rows) between
  /// the detail card and the totals card. Matches order-style detail pages.
  final bool showLineItems;
  final int lineItemCount;
  final bool showTotalsCard;

  @override
  Widget build(BuildContext context) {
    if (headerStyle == DetailsHeaderStyle.preview) {
      return ShimmerEffect(child: _previewLayout(context));
    }
    return ShimmerEffect(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(context),

            if (showTabs) ...[
              SizedBox(height: Dimensions.height15),
              _buildTabBar(context),
            ],

            SizedBox(height: Dimensions.height20),

            _buildDetailCard(context),

            if (showLineItems) ...[
              SizedBox(height: Dimensions.height20),
              _buildLineItemsCard(context),
            ],

            if (showTotalsCard) ...[
              SizedBox(height: Dimensions.height20),
              _buildTotalsCard(context),
            ],

            SizedBox(height: Dimensions.height30),
          ],
        ),
      ),
    );
  }

  /// A card with a section title and a set of line-item rows
  /// (description + qty/rate/amount), matching order detail line-item cards.
  Widget _buildLineItemsCard(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: Dimensions.width20),
      padding: EdgeInsets.all(Dimensions.width20),
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: BorderRadius.circular(Dimensions.radius15),
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title ("ITEMS")
          SkeletonLine(
            width: Dimensions.width30 * 2,
            height: Dimensions.font16 * 0.75,
          ),
          SizedBox(height: Dimensions.height15),
          for (int i = 0; i < lineItemCount; i++) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonLine(
                        width: Dimensions.width30 * (3 + (i % 2)),
                        height: Dimensions.font16 * 0.85,
                      ),
                      SizedBox(height: Dimensions.height10 * 0.6),
                      SkeletonLine(
                        width: Dimensions.width30 * 2.4,
                        height: Dimensions.font16 * 0.7,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: Dimensions.width10),
                SkeletonLine(
                  width: Dimensions.width30 * 1.8,
                  height: Dimensions.font16 * 0.85,
                ),
              ],
            ),
            if (i != lineItemCount - 1) SizedBox(height: Dimensions.height15),
          ],
        ],
      ),
    );
  }

  /// Layout for the file/document details page: a tall preview box, an info
  /// card of rows, then two action buttons.
  Widget _previewLayout(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(Dimensions.width20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Preview box with centered thumbnail
          Container(
            height: Dimensions.height45 * 5,
            decoration: BoxDecoration(
              color: context.colors.surfaceLight,
              borderRadius: BorderRadius.circular(Dimensions.radius20),
              border: Border.all(color: context.colors.border),
            ),
            child: Center(
              child: SkeletonBox(
                width: Dimensions.height45 * 1.6,
                height: Dimensions.height45 * 1.6,
                borderRadius: BorderRadius.circular(Dimensions.radius20),
              ),
            ),
          ),
          SizedBox(height: Dimensions.height20),

          // Info card
          _buildDetailCard(context),
          SizedBox(height: Dimensions.height20),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: SkeletonBox(
                  height: Dimensions.height45,
                  borderRadius: BorderRadius.circular(Dimensions.radius15),
                ),
              ),
              SizedBox(width: Dimensions.width15),
              Expanded(
                child: SkeletonBox(
                  height: Dimensions.height45,
                  borderRadius: BorderRadius.circular(Dimensions.radius15),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    // All real detail headers are full-bleed cards (no radius, bottom border).
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Dimensions.width20),
      decoration: BoxDecoration(
        color: context.colors.card,
        border: Border(bottom: BorderSide(color: context.colors.border)),
      ),
      child: switch (headerStyle) {
        DetailsHeaderStyle.document => _documentHeader(),
        DetailsHeaderStyle.twoMetric => _twoMetricHeader(context),
        DetailsHeaderStyle.avatar => _avatarHeader(context),
        // Preview is handled by [_previewLayout]; never reached here.
        DetailsHeaderStyle.preview => const SizedBox.shrink(),
      },
    );
  }

  Widget _documentHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date label + status pill
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SkeletonLine(
              width: Dimensions.width30 * 1.6,
              height: Dimensions.font16 * 0.7,
            ),
            SkeletonBox(
              width: Dimensions.width30 * 2.4,
              height: Dimensions.font16 * 1.4,
              borderRadius: BorderRadius.circular(Dimensions.radius30),
            ),
          ],
        ),
        SizedBox(height: Dimensions.height10 * 0.6),
        // Big date
        SkeletonLine(
          width: Dimensions.width30 * 3.6,
          height: Dimensions.font20 * 0.95,
        ),
        SizedBox(height: Dimensions.height20),
        // Name
        SkeletonLine(
          width: Dimensions.width30 * 4.5,
          height: Dimensions.font20 * 0.95,
        ),
        SizedBox(height: Dimensions.height10 * 0.6),
        // Document number
        SkeletonLine(
          width: Dimensions.width30 * 3,
          height: Dimensions.font16 * 0.85,
        ),
      ],
    );
  }

  Widget _twoMetricHeader(BuildContext context) {
    Widget metric() => Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonLine(
            width: Dimensions.width30 * 2.4,
            height: Dimensions.font16 * 0.75,
          ),
          SizedBox(height: Dimensions.height10 * 0.8),
          SkeletonLine(
            width: Dimensions.width30 * 3,
            height: Dimensions.font26,
          ),
        ],
      ),
    );

    return Row(
      children: [
        metric(),
        Container(
          height: Dimensions.height45,
          width: 1,
          color: context.colors.border,
        ),
        SizedBox(width: Dimensions.width20),
        metric(),
      ],
    );
  }

  Widget _avatarHeader(BuildContext context) {
    final double thumb = Dimensions.height45 * 1.8;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SkeletonBox(
          width: thumb,
          height: thumb,
          borderRadius: BorderRadius.circular(Dimensions.radius15),
        ),
        SizedBox(width: Dimensions.width15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonLine(
                width: Dimensions.width30 * 4,
                height: Dimensions.font20,
              ),
              SizedBox(height: Dimensions.height10),
              // SKU chip
              SkeletonBox(
                width: Dimensions.width30 * 2.6,
                height: Dimensions.font16 * 1.2,
                borderRadius: BorderRadius.circular(Dimensions.radius15 / 2),
              ),
              SizedBox(height: Dimensions.height10),
              // Status pill
              SkeletonBox(
                width: Dimensions.width30 * 2,
                height: Dimensions.font16 * 1.4,
                borderRadius: BorderRadius.circular(Dimensions.radius30),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Tab bar ───────────────────────────────────────────────────────────
  Widget _buildTabBar(BuildContext context) {
    if (tabStyle == DetailsTabStyle.underline) {
      // Plain full-width underline tab bar sitting on a card.
      return Container(
        color: context.colors.card,
        padding: EdgeInsets.symmetric(vertical: Dimensions.height15),
        child: Row(
          children: [
            for (int i = 0; i < tabCount; i++)
              Expanded(
                child: Center(
                  child: SkeletonLine(
                    width: Dimensions.width30 * 2.2,
                    height: Dimensions.font16 * 0.8,
                  ),
                ),
              ),
          ],
        ),
      );
    }

    // Pill segmented control inside a surfaceLight track.
    return Container(
      margin: EdgeInsets.symmetric(horizontal: Dimensions.width20),
      padding: EdgeInsets.all(Dimensions.width10 / 2),
      decoration: BoxDecoration(
        color: context.colors.surfaceLight,
        borderRadius: BorderRadius.circular(Dimensions.radius30),
      ),
      child: Row(
        children: [
          for (int i = 0; i < tabCount; i++) ...[
            Expanded(
              child: SkeletonBox(
                height: Dimensions.height30,
                borderRadius: BorderRadius.circular(Dimensions.radius30),
              ),
            ),
            if (i != tabCount - 1) SizedBox(width: Dimensions.width10),
          ],
        ],
      ),
    );
  }

  // ── Detail rows card ────────────────────────────────────────────────────
  Widget _buildDetailCard(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: Dimensions.width20),
      padding: EdgeInsets.all(Dimensions.width20),
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: BorderRadius.circular(Dimensions.radius15),
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        children: [
          for (int i = 0; i < detailRows; i++) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SkeletonLine(
                  width: Dimensions.width30 * (2.5 + (i % 2)),
                  height: Dimensions.font16 * 0.8,
                ),
                SkeletonLine(
                  width: Dimensions.width30 * (2 + (i % 3) * 0.6),
                  height: Dimensions.font16 * 0.8,
                ),
              ],
            ),
            if (i != detailRows - 1) SizedBox(height: Dimensions.height20),
          ],
        ],
      ),
    );
  }

  Widget _buildTotalsCard(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: Dimensions.width20),
      padding: EdgeInsets.all(Dimensions.width20),
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: BorderRadius.circular(Dimensions.radius15),
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        children: [
          for (int i = 0; i < 3; i++) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SkeletonLine(width: Dimensions.width30 * 2.5),
                SkeletonLine(width: Dimensions.width30 * 2),
              ],
            ),
            SizedBox(height: Dimensions.height15),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SkeletonLine(
                width: Dimensions.width30 * 2.2,
                height: Dimensions.font16,
              ),
              SkeletonLine(
                width: Dimensions.width30 * 2.6,
                height: Dimensions.font16,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
