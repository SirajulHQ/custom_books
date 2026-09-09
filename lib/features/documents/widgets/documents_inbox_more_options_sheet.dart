import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/widgets/bottom_sheet_header.dart';
import 'package:flutter/material.dart';

class DocumentsInboxMoreOptionsSheet extends StatelessWidget {
  final VoidCallback onUpload;
  final VoidCallback onRefresh;
  final VoidCallback onClose;

  const DocumentsInboxMoreOptionsSheet({
    super.key,
    required this.onUpload,
    required this.onRefresh,
    required this.onClose,
  });

  static void show(
    BuildContext context, {
    required VoidCallback onUpload,
    required VoidCallback onRefresh,
  }) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) => DocumentsInboxMoreOptionsSheet(
        onClose: () => Navigator.pop(sheetContext),
        onUpload: () {
          Navigator.pop(sheetContext);
          onUpload();
        },
        onRefresh: () {
          Navigator.pop(sheetContext);
          onRefresh();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        decoration: BoxDecoration(
          color: context.colors.card,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(Dimensions.radius20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BottomSheetHeader(
              title: 'More Options',
              onClose: onClose,
              showBorder: true,
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(
                Dimensions.width20,
                Dimensions.height20,
                Dimensions.width20,
                Dimensions.height10,
              ),
              child: Text(
                'INBOX ACTIONS',
                style: TextStyle(
                  fontSize: Dimensions.font16 * 0.7,
                  fontWeight: FontWeight.w600,
                  color: context.colors.textTertiary,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
              child: Column(
                children: [
                  _ActionOption(
                    icon: Icons.upload_file_rounded,
                    title: 'Upload Document',
                    subtitle: 'Add a new document to your inbox',
                    onTap: onUpload,
                  ),
                  SizedBox(height: Dimensions.height10),
                  _ActionOption(
                    icon: Icons.refresh_rounded,
                    title: 'Refresh',
                    subtitle: 'Reload the latest documents',
                    onTap: onRefresh,
                  ),
                ],
              ),
            ),
            SizedBox(height: Dimensions.height20),
          ],
        ),
      ),
    );
  }
}

class _ActionOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(Dimensions.radius15),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(Dimensions.width15),
        decoration: BoxDecoration(
          color: context.colors.card,
          borderRadius: BorderRadius.circular(Dimensions.radius15),
          border: Border.all(color: context.colors.border),
        ),
        child: Row(
          children: [
            Container(
              width: Dimensions.height45 * 0.9,
              height: Dimensions.height45 * 0.9,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(Dimensions.radius15 - 3),
              ),
              child: Icon(
                icon,
                size: Dimensions.iconSize24 - 4,
                color: AppColors.primary,
              ),
            ),
            SizedBox(width: Dimensions.width15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: Dimensions.font16 * 0.9,
                      fontWeight: FontWeight.w700,
                      color: context.colors.textPrimary,
                    ),
                  ),
                  SizedBox(height: Dimensions.height10 / 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: Dimensions.font16 * 0.7,
                      color: context.colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: Dimensions.iconSize24 - 4,
              color: context.colors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
}
