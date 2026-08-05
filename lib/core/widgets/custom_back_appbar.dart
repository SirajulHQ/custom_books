import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:flutter/material.dart';

class CustomBackAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onLeadingPressed;
  final List<Widget>? actions;
  final Color? backgroundColor;

  const CustomBackAppBar({
    super.key,
    required this.title,
    this.onLeadingPressed,
    this.actions,
    this.backgroundColor,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? context.colors.background;
    return AppBar(
      backgroundColor: bg,
      surfaceTintColor: bg,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_rounded, color: context.colors.textPrimary),
        onPressed: onLeadingPressed ?? () => Navigator.pop(context),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: Dimensions.font26 * 0.7,
          fontWeight: FontWeight.w800,
          color: context.colors.textPrimary,
        ),
      ),
      actions: actions,
    );
  }
}
