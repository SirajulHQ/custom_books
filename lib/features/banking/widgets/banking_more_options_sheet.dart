import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/widgets/bottom_sheet_drag_handle.dart';
import 'package:flutter/material.dart';

class BankingMoreOptionsSheet extends StatelessWidget {
  final VoidCallback onRefresh;
  final VoidCallback onExportStatement;

  const BankingMoreOptionsSheet({
    super.key,
    required this.onRefresh,
    required this.onExportStatement,
  });

  static void show(
    BuildContext context, {
    required VoidCallback onRefresh,
    required VoidCallback onExportStatement,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return BankingMoreOptionsSheet(
          onRefresh: onRefresh,
          onExportStatement: onExportStatement,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Dimensions.radius20 * 1.2),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const BottomSheetDragHandle(),
          _buildTile(
            context,
            icon: Icons.refresh_rounded,
            label: 'Refresh',
            onTap: onRefresh,
          ),
          _buildTile(
            context,
            icon: Icons.file_download_outlined,
            label: 'Export statement',
            onTap: onExportStatement,
          ),
          SizedBox(height: Dimensions.height20),
        ],
      ),
    );
  }

  Widget _buildTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(
        label,
        style: TextStyle(
          fontSize: Dimensions.font16 * 0.9,
          fontWeight: FontWeight.w600,
          color: context.colors.textPrimary,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }
}
