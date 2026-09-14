import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:flutter/material.dart';

/// Shows the app's branded exit confirmation dialog.
///
/// The dialog uses the app's semantic theme tokens ([BuildContext.colors]) so
/// it automatically matches the device's light/dark theme, and keeps the
/// custom card design (header strip, icon, styled action buttons).
///
/// Returns `true` if the user confirmed exit, `false` otherwise (including when
/// the dialog is dismissed by tapping the barrier).
Future<bool> showExitConfirmationDialog(BuildContext context) async {
  final result = await showGeneralDialog<bool>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Exit',
    barrierColor: Colors.black.withValues(alpha: 0.45),
    transitionDuration: const Duration(milliseconds: 220),
    transitionBuilder: (ctx, anim, ignored, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.12),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
        child: FadeTransition(opacity: anim, child: child),
      );
    },
    pageBuilder: (ctx, anim1, anim2) => const _ExitConfirmationDialog(),
  );
  return result ?? false;
}

class _ExitConfirmationDialog extends StatelessWidget {
  const _ExitConfirmationDialog();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Dimensions.width20 * 1.2),
        child: Material(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: colors.card,
              borderRadius: BorderRadius.circular(Dimensions.radius20),
              border: Border.all(color: colors.border),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: Dimensions.radius20 * 1.2,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Header strip ──────────────────────────────────
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.width20,
                    vertical: Dimensions.height20,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(Dimensions.radius20),
                      topRight: Radius.circular(Dimensions.radius20),
                    ),
                    border: Border(bottom: BorderSide(color: colors.border)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(Dimensions.width10 * 0.8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(
                            Dimensions.radius15 / 2,
                          ),
                        ),
                        child: Icon(
                          Icons.exit_to_app_rounded,
                          color: AppColors.primary,
                          size: Dimensions.iconSize24,
                        ),
                      ),
                      SizedBox(width: Dimensions.width10),
                      Text(
                        'Exit App',
                        style: TextStyle(
                          fontSize: Dimensions.font20,
                          fontWeight: FontWeight.w700,
                          color: colors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Body ──────────────────────────────────────────
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    Dimensions.width20,
                    Dimensions.height20,
                    Dimensions.width20,
                    Dimensions.height10,
                  ),
                  child: Text(
                    'Are you sure you want to exit the app?',
                    style: TextStyle(
                      fontSize: Dimensions.font16 * 0.95,
                      color: colors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ),

                // ── Actions ───────────────────────────────────────
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    Dimensions.width20,
                    Dimensions.height10,
                    Dimensions.width20,
                    Dimensions.height20,
                  ),
                  child: Row(
                    children: [
                      // Cancel
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).pop(false),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: Dimensions.height15,
                            ),
                            decoration: BoxDecoration(
                              color: colors.surfaceLight,
                              borderRadius: BorderRadius.circular(
                                Dimensions.radius15 / 2,
                              ),
                              border: Border.all(color: colors.border),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: Dimensions.font16 * 0.9,
                                fontWeight: FontWeight.w600,
                                color: colors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: Dimensions.width10),
                      // Exit
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).pop(true),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: Dimensions.height15,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(
                                Dimensions.radius15 / 2,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.logout_rounded,
                                  color: Colors.white,
                                  size: Dimensions.iconSize16,
                                ),
                                SizedBox(width: Dimensions.width10 / 2),
                                Text(
                                  'Exit',
                                  style: TextStyle(
                                    fontSize: Dimensions.font16 * 0.9,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
