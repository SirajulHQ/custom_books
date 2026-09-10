import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/widgets/bottom_sheet_header.dart';
import 'package:flutter/material.dart';

/// A single action item shown inside [MoreOptionsSheet].
class MoreOptionsItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const MoreOptionsItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
}

class MoreOptionsSheet extends StatelessWidget {
  final String sectionLabel;
  final List<MoreOptionsItem> items;
  final VoidCallback onClose;

  const MoreOptionsSheet({
    super.key,
    required this.sectionLabel,
    required this.items,
    required this.onClose,
  });

  /// Opens the sheet as a transparent modal bottom sheet.
  /// Each item's [onTap] is wrapped to dismiss the sheet first.
  static void show(
    BuildContext context, {
    required String sectionLabel,
    required List<MoreOptionsItem> items,
  }) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) => MoreOptionsSheet(
        sectionLabel: sectionLabel,
        onClose: () => Navigator.pop(sheetContext),
        items: items
            .map(
              (item) => MoreOptionsItem(
                icon: item.icon,
                title: item.title,
                subtitle: item.subtitle,
                onTap: () {
                  Navigator.pop(sheetContext);
                  item.onTap();
                },
              ),
            )
            .toList(),
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
                sectionLabel,
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
                  for (int i = 0; i < items.length; i++) ...[
                    _MoreOptionsItemTile(item: items[i]),
                    if (i < items.length - 1) SizedBox(height: Dimensions.height10),
                  ],
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

class _MoreOptionsItemTile extends StatelessWidget {
  final MoreOptionsItem item;

  const _MoreOptionsItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(Dimensions.radius15),
      onTap: item.onTap,
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
                item.icon,
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
                    item.title,
                    style: TextStyle(
                      fontSize: Dimensions.font16 * 0.9,
                      fontWeight: FontWeight.w700,
                      color: context.colors.textPrimary,
                    ),
                  ),
                  SizedBox(height: Dimensions.height10 / 4),
                  Text(
                    item.subtitle,
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
