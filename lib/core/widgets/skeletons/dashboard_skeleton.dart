import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/widgets/shimmer_effect.dart';
import 'package:custom_books/core/widgets/skeletons/skeleton_box.dart';
import 'package:flutter/material.dart';

/// Shimmer skeleton for the home dashboard overview tab.
/// Mirrors the exact widget order and approximate heights of the real content:
///   1. BalancesGridWidget   — 2×2 grid, childAspectRatio 1.5, radius20 tiles
///   2. QuickActionsGridWidget — one card, single row of 4 action items
///   3. BankingStripWidget   — height45*2.3 horizontal row of 2 gradient cards
///   4. CashFlowCardWidget   — large chart card (screenHeight / 3.5 chart area)
///   5. IncomeExpenseCardWidget — large chart card (screenHeight / 3.2 chart area)
///   6. ProjectTimerCardWidget — timer display + 2 stat chips
///   7. ExpenseBreakdownCardWidget — chart card with progress bars
class DashboardSkeleton extends StatelessWidget {
  const DashboardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: Dimensions.height15),

          // ── 1. Balances grid (2×2, aspect-ratio 1.5, radius20) ──────────
          _BalancesGridSkeleton(),
          SizedBox(height: Dimensions.height20),

          // ── 2. Quick actions — one card, 1 row of 4 items ───────────────
          _quickActionsSkeleton(context),
          SizedBox(height: Dimensions.height20),

          // ── 3. Banking strip — height45*2.3, two side-by-side cards ─────
          _bankingStripSkeleton(context),
          SizedBox(height: Dimensions.height20),

          // ── 4. Cash Flow chart card ──────────────────────────────────────
          _chartCard(
            context,
            chartHeight: Dimensions.screenHeight / 3.5,
            extraLinesBelow: 4, // Opening bal + Incoming + Outgoing + Ending
          ),
          SizedBox(height: Dimensions.height20),

          // ── 5. Income & Expense chart card ──────────────────────────────
          _chartCard(
            context,
            chartHeight: Dimensions.screenHeight / 3.2,
            headerSuffix: _toggleSkeleton(context), // Accrual/Cash toggle
            extraLinesBelow: 2, // Income total + Expense total
          ),
          SizedBox(height: Dimensions.height20),

          // ── 6. Project Timer card ────────────────────────────────────────
          _projectTimerSkeleton(context),
          SizedBox(height: Dimensions.height20),

          // ── 7. Expense Breakdown card ────────────────────────────────────
          _chartCard(
            context,
            chartHeight: Dimensions.height80 * 1.8,
            extraLinesBelow: 3, // 3 expense category rows
          ),
          SizedBox(height: Dimensions.height30),
        ],
      ),
    );
  }

  // ── Chart card skeleton ─────────────────────────────────────────────────────
  // Mirrors: title row + optional sub-widget + chart area + bottom stat lines
  Widget _chartCard(
    BuildContext context, {
    required double chartHeight,
    Widget? headerSuffix,
    int extraLinesBelow = 0,
  }) {
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
          // Header row: title placeholder + period dropdown placeholder
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SkeletonLine(
                width: Dimensions.width30 * 4.5,
                height: Dimensions.font16,
              ),
              SkeletonBox(
                width: Dimensions.width30 * 3.5,
                height: Dimensions.font16 * 1.6,
                borderRadius: BorderRadius.circular(Dimensions.radius30),
              ),
            ],
          ),
          if (headerSuffix != null) ...[
            SizedBox(height: Dimensions.height15),
            headerSuffix,
          ],
          SizedBox(height: Dimensions.height20),
          // Chart area
          SkeletonBox(
            width: double.infinity,
            height: chartHeight,
            borderRadius: BorderRadius.circular(Dimensions.radius15),
          ),
          if (extraLinesBelow > 0) ...[
            SizedBox(height: Dimensions.height20),
            for (int i = 0; i < extraLinesBelow; i++) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SkeletonLine(
                    width: Dimensions.width30 * 3,
                    height: Dimensions.font16 * 0.85,
                  ),
                  SkeletonLine(
                    width: Dimensions.width30 * 2.5,
                    height: Dimensions.font16 * 0.85,
                  ),
                ],
              ),
              if (i < extraLinesBelow - 1)
                SizedBox(height: Dimensions.height10),
            ],
          ],
        ],
      ),
    );
  }

  // Accrual/Cash toggle placeholder (two pill-shaped boxes side by side)
  Widget _toggleSkeleton(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SkeletonBox(
          width: Dimensions.width30 * 2.8,
          height: Dimensions.font16 * 1.8,
          borderRadius: BorderRadius.circular(Dimensions.radius30),
        ),
        SizedBox(width: Dimensions.width10 * 0.5),
        SkeletonBox(
          width: Dimensions.width30 * 2.2,
          height: Dimensions.font16 * 1.8,
          borderRadius: BorderRadius.circular(Dimensions.radius30),
        ),
      ],
    );
  }
}

// ── Balances Grid Skeleton ──────────────────────────────────────────────────
// Matches: GridView.count(crossAxisCount:2, childAspectRatio:1.5, radius20)
class _BalancesGridSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Replicate the aspect-ratio height calculation: same padding & spacing as
    // the real GridView so tiles have matching height.
    final tileWidth =
        (Dimensions.screenWidth -
            Dimensions.width20 * 2 - // screen horizontal padding
            Dimensions.width15) / // crossAxisSpacing
        2;
    final tileHeight = tileWidth / 1.5;

    return Column(
      children: [
        for (int r = 0; r < 2; r++) ...[
          Row(
            children: [
              for (int c = 0; c < 2; c++) ...[
                Expanded(
                  child: Container(
                    height: tileHeight,
                    padding: EdgeInsets.all(Dimensions.width15),
                    decoration: BoxDecoration(
                      color: context.colors.card,
                      borderRadius: BorderRadius.circular(Dimensions.radius20),
                      border: Border.all(color: context.colors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Icon badge placeholder
                        SkeletonBox(
                          width: Dimensions.iconSize16 * 1.8,
                          height: Dimensions.iconSize16 * 1.8,
                          borderRadius: BorderRadius.circular(
                            Dimensions.radius30,
                          ),
                        ),
                        // Value text placeholder
                        SkeletonLine(
                          width: Dimensions.width30 * 2,
                          height: Dimensions.font20,
                        ),
                        // Label text placeholder
                        SkeletonLine(
                          width: Dimensions.width30 * 3,
                          height: Dimensions.font16 * 0.75,
                        ),
                      ],
                    ),
                  ),
                ),
                if (c == 0) SizedBox(width: Dimensions.width15),
              ],
            ],
          ),
          if (r == 0) SizedBox(height: Dimensions.height15),
        ],
      ],
    );
  }
}

// ── Quick Actions Skeleton ──────────────────────────────────────────────────
// Matches: one card wrapper, single Row of 4 action items (icon + 2-line text)
Widget _quickActionsSkeleton(BuildContext context) {
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
        // "Quick Actions" title
        SkeletonLine(
          width: Dimensions.width30 * 3.5,
          height: Dimensions.font16,
        ),
        SizedBox(height: Dimensions.height15),
        // Single row of 4 items
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(4, (_) {
            return Column(
              children: [
                SkeletonBox(
                  width: Dimensions.iconSize24 * 1.8,
                  height: Dimensions.iconSize24 * 1.8,
                  borderRadius: BorderRadius.circular(Dimensions.radius15),
                ),
                SizedBox(height: Dimensions.height10 * 0.6),
                SkeletonLine(
                  width: Dimensions.width30 * 1.8,
                  height: Dimensions.font16 * 0.72,
                ),
                SizedBox(height: Dimensions.height10 * 0.3),
                SkeletonLine(
                  width: Dimensions.width30 * 1.8,
                  height: Dimensions.font16 * 0.72,
                ),
              ],
            );
          }),
        ),
      ],
    ),
  );
}

// ── Banking Strip Skeleton ──────────────────────────────────────────────────
// Matches: SizedBox(height: height45*2.3), 2 partial-width gradient cards
Widget _bankingStripSkeleton(BuildContext context) {
  final stripHeight = Dimensions.height45 * 2.3;
  final cardWidth = Dimensions.screenWidth * 0.55;

  return SizedBox(
    height: stripHeight,
    child: Row(
      children: [
        for (int i = 0; i < 2; i++) ...[
          Container(
            width: cardWidth,
            padding: EdgeInsets.all(Dimensions.width15),
            decoration: BoxDecoration(
              color: context.colors.card,
              borderRadius: BorderRadius.circular(Dimensions.radius20),
              border: Border.all(color: context.colors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Icon
                SkeletonBox(
                  width: Dimensions.iconSize24 - 4,
                  height: Dimensions.iconSize24 - 4,
                  borderRadius: BorderRadius.circular(4),
                ),
                // Value
                SkeletonLine(
                  width: Dimensions.width30 * 2.5,
                  height: Dimensions.font20,
                ),
                // Label
                SkeletonLine(
                  width: Dimensions.width30 * 3,
                  height: Dimensions.font16 * 0.8,
                ),
              ],
            ),
          ),
          if (i == 0) SizedBox(width: Dimensions.width15),
        ],
      ],
    ),
  );
}

// ── Project Timer Skeleton ──────────────────────────────────────────────────
// Matches: card > header + timer display container + 2 stat chips
Widget _projectTimerSkeleton(BuildContext context) {
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
        // Header: title + icon
        SkeletonLine(width: Dimensions.width30 * 4, height: Dimensions.font16),
        SizedBox(height: Dimensions.height15),
        // Timer display container (tinted background box)
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            vertical: Dimensions.height20,
            horizontal: Dimensions.width15,
          ),
          decoration: BoxDecoration(
            color: context.colors.border.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(Dimensions.radius15),
          ),
          child: Column(
            children: [
              // Large timer digits
              SkeletonLine(
                width: Dimensions.width30 * 5,
                height: Dimensions.font26 * 1.4,
              ),
              SizedBox(height: Dimensions.height10 * 0.5),
              // "Associate Project" label
              SkeletonLine(
                width: Dimensions.width30 * 4,
                height: Dimensions.font16 * 0.9,
              ),
              SizedBox(height: Dimensions.height20),
              // Action buttons row (2 buttons)
              Row(
                children: [
                  Expanded(
                    child: SkeletonBox(
                      width: double.infinity,
                      height: Dimensions.height45 * 0.85,
                      borderRadius: BorderRadius.circular(Dimensions.radius30),
                    ),
                  ),
                  SizedBox(width: Dimensions.width10),
                  Expanded(
                    child: SkeletonBox(
                      width: double.infinity,
                      height: Dimensions.height45 * 0.85,
                      borderRadius: BorderRadius.circular(Dimensions.radius30),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: Dimensions.height15),
        // Two stat chips
        Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(Dimensions.width15),
                decoration: BoxDecoration(
                  color: context.colors.border.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(Dimensions.radius15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonLine(
                      width: Dimensions.width30 * 2.5,
                      height: Dimensions.font16 * 0.8,
                    ),
                    SizedBox(height: Dimensions.height10 * 0.5),
                    SkeletonLine(
                      width: Dimensions.width30 * 2,
                      height: Dimensions.font16,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: Dimensions.width10),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(Dimensions.width15),
                decoration: BoxDecoration(
                  color: context.colors.border.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(Dimensions.radius15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonLine(
                      width: Dimensions.width30 * 2.5,
                      height: Dimensions.font16 * 0.8,
                    ),
                    SizedBox(height: Dimensions.height10 * 0.5),
                    SkeletonLine(
                      width: Dimensions.width30 * 2,
                      height: Dimensions.font16,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
