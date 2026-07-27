import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/features/drawer/models/drawer_item.dart';
import 'package:flutter/material.dart';

class DrawerMenuItem extends StatelessWidget {
  final DrawerItem item;
  final VoidCallback? onCustomTap;

  const DrawerMenuItem({super.key, required this.item, this.onCustomTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: Dimensions.height45 * 0.9,
        height: Dimensions.height45 * 0.9,
        decoration: BoxDecoration(
          color: item.isSelected
              ? Appcolors.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(Dimensions.radius15),
        ),
        child: Icon(
          item.icon,
          size: Dimensions.iconSize24 * 0.9,
          color: item.isSelected ? Appcolors.primary : context.colors.textSecondary,
        ),
      ),
      title: Text(
        item.title,
        style: TextStyle(
          fontSize: Dimensions.font16 * 0.9,
          fontWeight: item.isSelected ? FontWeight.w700 : FontWeight.w500,
          color: item.isSelected ? Appcolors.primary : context.colors.textPrimary,
        ),
      ),
      selected: item.isSelected,
      selectedTileColor: Appcolors.primary.withValues(alpha: 0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimensions.radius15),
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: Dimensions.width20,
        vertical: Dimensions.height10 / 4,
      ),
      onTap:
          onCustomTap ??
          () {
            Navigator.pop(context);
            // Handle navigation
          },
    );
  }
}
