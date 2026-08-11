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
    Dimensions.init(context);

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
            foregroundColor: Appcolors.primary,
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
            foregroundColor: Appcolors.warn,
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

/// A mixin for [State] classes that provides unsaved-changes protection.
///
/// Usage:
/// 1. Add `with UnsavedChangesMixin` to your State class.
/// 2. Call `markDirty()` whenever the form data changes.
/// 3. Call `markClean()` after a successful save.
/// 4. Wrap your `Scaffold` with the [buildUnsavedChangesScope] method,
///    or use [PopScope] with [onBackPressed] as the `onPopInvokedWithResult`.
///
/// Example:
/// ```dart
/// class _MyPageState extends State<MyPage> with UnsavedChangesMixin {
///   @override
///   Widget build(BuildContext context) {
///     return PopScope(
///       canPop: false,
///       onPopInvokedWithResult: onPopInvokedWithResult,
///       child: Scaffold(...),
///     );
///   }
/// }
/// ```
mixin UnsavedChangesMixin<T extends StatefulWidget> on State<T> {
  bool _isDirty = false;

  /// Whether the form has been modified since the last save/clean.
  bool get isDirty => _isDirty;

  /// Mark the form as having unsaved changes.
  void markDirty() {
    if (!_isDirty) {
      setState(() => _isDirty = true);
    }
  }

  /// Mark the form as clean (e.g. after saving).
  void markClean() {
    if (_isDirty) {
      setState(() => _isDirty = false);
    }
  }

  /// Use as the `onPopInvokedWithResult` callback for [PopScope].
  ///
  /// If the form is dirty, shows the confirmation dialog.
  /// If the user chooses to leave (or form is clean), pops the page.
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
