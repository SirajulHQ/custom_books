import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:flutter/material.dart';

enum AppBarLeadingType { back, menu, custom, none }

class CustomSliverAppBar extends StatelessWidget {
  final String title;
  final String? subtitle;
  final AppBarLeadingType leadingType;
  final Widget? customLeading;
  final VoidCallback? onLeadingPressed;
  final List<Widget>? actions;
  final bool pinned;
  final bool floating;
  final Color? backgroundColor;
  final double? toolbarHeight;
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
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(Dimensions.radius15),
            ),
            child: Icon(
              Icons.arrow_back,
              size: Dimensions.iconSize24 - 4,
              color: AppColors.primary,
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
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(Dimensions.radius15),
              ),
              child: Icon(
                Icons.menu_rounded,
                size: Dimensions.iconSize24 - 4,
                color: AppColors.primary,
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
    this.color = AppColors.primary,
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
                  color: badgeColor ?? AppColors.warn,
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

/// Helper widget to create outlined button actions for the app bar
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
    final color = foregroundColor ?? backgroundColor ?? AppColors.primary;
    return Container(
      margin: EdgeInsets.symmetric(vertical: Dimensions.height10),
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          side: BorderSide(color: color, width: 1.5),
          elevation: 0,
          backgroundColor: Colors.transparent,
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
