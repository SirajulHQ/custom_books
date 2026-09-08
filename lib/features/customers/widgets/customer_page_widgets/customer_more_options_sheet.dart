import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/widgets/bottom_sheet_drag_handle.dart';
import 'package:flutter/material.dart';

class CustomerMoreOptionsSheet extends StatelessWidget {
  final VoidCallback onRefresh;
  final VoidCallback onImport;
  final VoidCallback onExport;

  const CustomerMoreOptionsSheet({
    super.key,
    required this.onRefresh,
    required this.onImport,
    required this.onExport,
  });

  @override
  Widget build(BuildContext context) {
    Widget tile(IconData icon, String label, VoidCallback onTap) {
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
          tile(Icons.refresh_rounded, 'Refresh', onRefresh),
          tile(Icons.upload_file_outlined, 'Import customers', onImport),
          tile(Icons.file_download_outlined, 'Export customers', onExport),
          SizedBox(height: Dimensions.height20),
        ],
      ),
    );
  }
}
