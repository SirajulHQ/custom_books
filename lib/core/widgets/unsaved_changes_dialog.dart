import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:flutter/material.dart';

class UnsavedChangesDialog extends StatelessWidget {
  const UnsavedChangesDialog({super.key});

  static Future<bool> show(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const UnsavedChangesDialog(),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: context.colors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimensions.radius15),
      ),
      title: Text(
        'Unsaved Changes',
        style: TextStyle(
          fontSize: Dimensions.font16 * 1.1,
          fontWeight: FontWeight.w700,
          color: context.colors.textPrimary,
        ),
      ),
      content: Text(
        'You have unsaved changes. Are you sure you want to leave this page?',
        style: TextStyle(
          fontSize: Dimensions.font16 * 0.85,
          color: context.colors.textSecondary,
          height: 1.4,
        ),
      ),
      actionsPadding: EdgeInsets.symmetric(
        horizontal: Dimensions.width15,
        vertical: Dimensions.height10,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.width15,
              vertical: Dimensions.height10,
            ),
          ),
          child: Text(
            'STAY',
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.85,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          style: TextButton.styleFrom(
            foregroundColor: AppColors.warn,
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.width15,
              vertical: Dimensions.height10,
            ),
          ),
          child: Text(
            'LEAVE',
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.85,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

mixin UnsavedChangesMixin<T extends StatefulWidget> on State<T> {
  bool _isDirty = false;

  bool get isDirty => _isDirty;
  void markDirty() {
    if (!_isDirty) {
      setState(() => _isDirty = true);
    }
  }

  void markClean() {
    if (_isDirty) {
      setState(() => _isDirty = false);
    }
  }

  void onPopInvokedWithResult(bool didPop, dynamic result) async {
    if (didPop) return;

    if (!_isDirty) {
      if (mounted) Navigator.pop(context);
      return;
    }

    final shouldLeave = await UnsavedChangesDialog.show(context);
    if (shouldLeave && mounted) {
      Navigator.pop(context);
    }
  }
}
