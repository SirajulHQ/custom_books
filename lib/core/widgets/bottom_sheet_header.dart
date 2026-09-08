import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:flutter/material.dart';

/// A standardised title + close button row for bottom sheets.
///
/// Two visual variants exist across the app:
///
/// **Default** (`usePillCloseButton: false`) — used by [FilterSheet]:
/// - `GestureDetector` + plain [Icons.close_rounded] in [AppColorScheme.textSecondary]
/// - [FontWeight.bold] title
/// - Optional bottom [BorderSide] when [showBorder] is `true` (extra vertical
///   padding is added automatically)
///
/// **Pill** (`usePillCloseButton: true`) — used by [GenericSortSheet]:
/// - `InkWell` + [Icons.close_rounded] inside an [AppColors.primary]-tinted
///   rounded container
/// - [FontWeight.w800] title
/// - No bottom border
class BottomSheetHeader extends StatelessWidget {
  final String title;
  final VoidCallback onClose;

  /// Draws a 1-px bottom [BorderSide] and increases vertical padding.
  /// Only meaningful when [usePillCloseButton] is `false`.
  final bool showBorder;

  /// Switches to the tinted-pill close button style used by [GenericSortSheet].
  final bool usePillCloseButton;

  const BottomSheetHeader({
    super.key,
    required this.title,
    required this.onClose,
    this.showBorder = false,
    this.usePillCloseButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return usePillCloseButton ? _PillHeader(this, context) : _PlainHeader(this, context);
  }
}

// ---------------------------------------------------------------------------
// Plain style — FilterSheet
// ---------------------------------------------------------------------------
class _PlainHeader extends StatelessWidget {
  final BottomSheetHeader header;
  final BuildContext parentContext;
  const _PlainHeader(this.header, this.parentContext);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.width20,
        vertical: header.showBorder ? Dimensions.height15 : Dimensions.height10,
      ),
      decoration: header.showBorder
          ? BoxDecoration(
              border: Border(
                bottom: BorderSide(color: context.colors.border, width: 1),
              ),
            )
          : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            header.title,
            style: TextStyle(
              fontSize: Dimensions.font20,
              fontWeight: FontWeight.bold,
              color: context.colors.textPrimary,
            ),
          ),
          GestureDetector(
            onTap: header.onClose,
            child: Icon(
              Icons.close_rounded,
              size: Dimensions.iconSize24,
              color: context.colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Pill style — GenericSortSheet
// ---------------------------------------------------------------------------
class _PillHeader extends StatelessWidget {
  final BottomSheetHeader header;
  final BuildContext parentContext;
  const _PillHeader(this.header, this.parentContext);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            header.title,
            style: TextStyle(
              fontSize: Dimensions.font20,
              fontWeight: FontWeight.w800,
              color: context.colors.textPrimary,
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(Dimensions.radius15),
            onTap: header.onClose,
            child: Container(
              padding: EdgeInsets.all(Dimensions.width10 * 0.6),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(Dimensions.radius15),
              ),
              child: Icon(
                Icons.close_rounded,
                size: Dimensions.iconSize16,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
