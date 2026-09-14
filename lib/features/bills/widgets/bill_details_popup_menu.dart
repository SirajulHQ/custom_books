import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/widgets/confirmation_dialog.dart';
import 'package:flutter/material.dart';

class BillDetailsPopupMenu extends StatelessWidget {
  final VoidCallback onDelete;

  const BillDetailsPopupMenu({super.key, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_vert_rounded,
        color: context.colors.textSecondary,
        size: Dimensions.iconSize24 - 2,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimensions.radius15),
      ),
      surfaceTintColor: context.colors.card,
      color: context.colors.card,
      elevation: 8,
      onSelected: (value) async {
        if (value == 'print') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Print functionality coming soon'),
              duration: const Duration(seconds: 2),
              backgroundColor: context.colors.textSecondary,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Dimensions.radius15),
              ),
            ),
          );
        } else if (value == 'delete') {
          final confirmed = await showConfirmationDialog(
            context,
            title: 'Delete Bill',
            message:
                'Are you sure you want to delete this bill? This action cannot be undone.',
          );
          if (confirmed) {
            onDelete();
          }
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'print',
          child: Row(
            children: [
              Icon(
                Icons.print_rounded,
                size: Dimensions.iconSize16 + 4,
                color: context.colors.textSecondary,
              ),
              SizedBox(width: Dimensions.width10),
              Text(
                'Print',
                style: TextStyle(
                  fontSize: Dimensions.font16 * 0.85,
                  fontWeight: FontWeight.w600,
                  color: context.colors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(
                Icons.delete_outline_rounded,
                size: Dimensions.iconSize16 + 4,
                color: AppColors.warn,
              ),
              SizedBox(width: Dimensions.width10),
              Text(
                'Delete',
                style: TextStyle(
                  fontSize: Dimensions.font16 * 0.85,
                  fontWeight: FontWeight.w600,
                  color: AppColors.warn,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
