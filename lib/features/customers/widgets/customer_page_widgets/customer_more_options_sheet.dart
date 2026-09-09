import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/widgets/bottom_sheet_header.dart';
import 'package:flutter/material.dart';

class CustomerMoreOptionsSheet extends StatelessWidget {
  final VoidCallback onRefresh;
  final VoidCallback onImport;
  final VoidCallback onExport;
  final VoidCallback onClose;

  const CustomerMoreOptionsSheet({
    super.key,
    required this.onRefresh,
    required this.onImport,
    required this.onExport,
    required this.onClose,
  });

  static void show(
    BuildContext context, {
    required VoidCallback onRefresh,
    required VoidCallback onImport,
    required VoidCallback onExport,
  }) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) => CustomerMoreOptionsSheet(
        onClose: () => Navigator.pop(sheetContext),
        onRefresh: () {
          Navigator.pop(sheetContext);
          onRefresh();
        },
        onImport: () {
          Navigator.pop(sheetContext);
          onImport();
        },
        onExport: () {
          Navigator.pop(sheetContext);
          onExport();
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
                'CUSTOMER ACTIONS',
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
                    icon: Icons.upload_file_outlined,
                    title: 'Import Customers',
                    subtitle: 'Import customers from a file',
                    onTap: onImport,
                  ),
                  SizedBox(height: Dimensions.height10),
                  _ActionOption(
                    icon: Icons.file_download_outlined,
                    title: 'Export Customers',
                    subtitle: 'Export the current customer list',
                    onTap: onExport,
                  ),
                  SizedBox(height: Dimensions.height10),
                  _ActionOption(
                    icon: Icons.refresh_rounded,
                    title: 'Refresh',
                    subtitle: 'Reload the latest customers',
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
