import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:flutter/material.dart';

enum AppBarLeadingType { back, menu, custom, none }

class CustomSliverAppBar extends StatelessWidget {
  /// Main title text
  final String title;

  /// Optional subtitle text (appears below the title)
  final String? subtitle;

  /// Type of leading button: back, menu, custom, or none
  final AppBarLeadingType leadingType;

  /// Custom leading widget (used when leadingType is custom)
  final Widget? customLeading;

  /// Callback for leading button press
  final VoidCallback? onLeadingPressed;

  /// List of action widgets to display on the right side
  final List<Widget>? actions;

  /// Whether the app bar should remain visible when scrolling
  final bool pinned;

  /// Whether the app bar should float
  final bool floating;

  /// Background color
  final Color? backgroundColor;

  /// Height of the toolbar
  final double? toolbarHeight;

  /// Custom title widget (overrides title and subtitle)
  final Widget? customTitle;

  const CustomSliverAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.leadingType = AppBarLeadingType.back,
    this.customLeading,
    this.onLeadingPressed,
    this.actions,
    this.pinned = true,
    this.floating = false,
    this.backgroundColor,
    this.toolbarHeight,
    this.customTitle,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: pinned,
      floating: floating,
      backgroundColor: backgroundColor ?? context.colors.background,
      surfaceTintColor: backgroundColor ?? context.colors.background,
      elevation: 0,
      toolbarHeight: toolbarHeight ?? (Dimensions.height45 * 1.6),
      titleSpacing: Dimensions.width20,
      leading: _buildLeading(context),
      title: customTitle ?? _buildTitle(context),
      actions: actions,
    );
  }

  Widget? _buildLeading(BuildContext context) {
    switch (leadingType) {
      case AppBarLeadingType.back:
        return IconButton(
          icon: Container(
            width: Dimensions.height45 * 0.9,
            height: Dimensions.height45 * 0.9,
            decoration: BoxDecoration(
              color: Appcolors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(Dimensions.radius15),
            ),
            child: Icon(
              Icons.arrow_back,
              size: Dimensions.iconSize24 - 4,
              color: Appcolors.primary,
            ),
          ),
          onPressed: onLeadingPressed ?? () => Navigator.pop(context),
        );

      case AppBarLeadingType.menu:
        return Builder(
          builder: (context) => IconButton(
            icon: Container(
              width: Dimensions.height45 * 0.9,
              height: Dimensions.height45 * 0.9,
              decoration: BoxDecoration(
                color: Appcolors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(Dimensions.radius15),
              ),
              child: Icon(
                Icons.menu_rounded,
                size: Dimensions.iconSize24 - 4,
                color: Appcolors.primary,
              ),
            ),
            onPressed:
                onLeadingPressed ?? () => Scaffold.of(context).openDrawer(),
          ),
        );

      case AppBarLeadingType.custom:
        return customLeading;

      case AppBarLeadingType.none:
        return null;
    }
  }

  Widget _buildTitle(BuildContext context) {
    if (subtitle != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: Dimensions.font26 * 0.85,
              fontWeight: FontWeight.w800,
              color: context.colors.textPrimary,
            ),
          ),
          Text(
            subtitle!,
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.7,
              color: context.colors.textSecondary,
            ),
          ),
        ],
      );
    }

    return Text(
      title,
      style: TextStyle(
        fontSize: Dimensions.font26 * 0.85,
        fontWeight: FontWeight.w800,
        color: context.colors.textPrimary,
      ),
    );
  }
}

/// Helper widget to create icon button actions for the app bar
class AppBarIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback? onPressed;
  final bool showBadge;
  final Color? badgeColor;

  const AppBarIconButton({
    super.key,
    required this.icon,
    this.color = Appcolors.primary,
    this.onPressed,
    this.showBadge = false,
    this.badgeColor,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: Dimensions.height45 * 0.9,
            height: Dimensions.height45 * 0.9,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(Dimensions.radius15),
            ),
            child: Icon(icon, size: Dimensions.iconSize24 - 4, color: color),
          ),
          if (showBadge)
            Positioned(
              top: -2,
              right: -2,
              child: Container(
                width: 9,
                height: 9,
                decoration: BoxDecoration(
                  color: badgeColor ?? Appcolors.warn,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
      onPressed: onPressed,
    );
  }
}

/// Helper widget to create elevated button actions for the app bar
class AppBarElevatedButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final IconData? icon;

  const AppBarElevatedButton({
    super.key,
    required this.label,
    this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: Dimensions.height10),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? Appcolors.primary,
          foregroundColor: foregroundColor ?? Colors.white,
          elevation: 0,
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.width20,
            vertical: Dimensions.height10,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.radius15),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: Dimensions.iconSize16 * 1.2),
              SizedBox(width: Dimensions.width10 / 2),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.85,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
