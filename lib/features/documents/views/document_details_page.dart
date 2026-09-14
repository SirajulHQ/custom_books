import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/date_formatter.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/core/widgets/confirmation_dialog.dart';
import 'package:custom_books/core/widgets/custom_back_appbar.dart';
import 'package:custom_books/core/widgets/detail_row.dart';
import 'package:custom_books/features/documents/models/document_model.dart';
import 'package:flutter/material.dart';

class DocumentDetailsPage extends StatelessWidget {
  final DocumentModel document;
  final VoidCallback? onDelete;

  const DocumentDetailsPage({super.key, required this.document, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: CustomBackAppBar(
        title: 'Document',
        backgroundColor: context.colors.card,
        actions: [
          PopupMenuButton<String>(
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
            onSelected: (value) {
              switch (value) {
                case 'download':
                  ToastificationHelper.showInfo(
                    context,
                    'Downloading is coming soon.',
                  );
                  break;
                case 'share':
                  ToastificationHelper.showInfo(
                    context,
                    'Sharing is coming soon.',
                  );
                  break;
                case 'delete':
                  _confirmDelete(context);
                  break;
              }
            },
            itemBuilder: (context) => [
              _menuItem(
                context,
                value: 'download',
                icon: Icons.download_rounded,
                label: 'Download',
              ),
              _menuItem(
                context,
                value: 'share',
                icon: Icons.share_rounded,
                label: 'Share',
              ),
              _menuItem(
                context,
                value: 'delete',
                icon: Icons.delete_outline_rounded,
                label: 'Delete',
                danger: true,
              ),
            ],
          ),
          SizedBox(width: Dimensions.width10),
        ],
      ),
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.all(Dimensions.width20),
          children: [
            _buildPreview(context),
            SizedBox(height: Dimensions.height20),
            _buildInfoCard(context),
            SizedBox(height: Dimensions.height20),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  PopupMenuItem<String> _menuItem(
    BuildContext context, {
    required String value,
    required IconData icon,
    required String label,
    bool danger = false,
  }) {
    final color = danger ? AppColors.warn : context.colors.textSecondary;
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: Dimensions.iconSize16 + 4, color: color),
          SizedBox(width: Dimensions.width10),
          Text(
            label,
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.85,
              fontWeight: FontWeight.w600,
              color: danger ? AppColors.warn : context.colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreview(BuildContext context) {
    return Container(
      width: double.infinity,
      height: Dimensions.height45 * 5,
      decoration: BoxDecoration(
        color: context.colors.surfaceLight,
        borderRadius: BorderRadius.circular(Dimensions.radius20),
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: Dimensions.height45 * 1.6,
            height: Dimensions.height45 * 1.6,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(Dimensions.radius20),
            ),
            child: Icon(
              document.fileType.iconData,
              size: Dimensions.iconSize24 * 1.6,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: Dimensions.height15),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
            child: Text(
              document.fileName,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.95,
                fontWeight: FontWeight.w700,
                color: context.colors.textPrimary,
              ),
            ),
          ),
          SizedBox(height: Dimensions.height10 / 2),
          Text(
            'Preview will be available once connected.',
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.75,
              color: context.colors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Dimensions.width20),
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: BorderRadius.circular(Dimensions.radius15),
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'FILE DETAILS',
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.7,
              fontWeight: FontWeight.w700,
              color: context.colors.textTertiary,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: Dimensions.height15),
          DetailRow(label: 'Name:', value: document.fileName),
          SizedBox(height: Dimensions.height15),
          DetailRow(label: 'Type:', value: document.fileType.label),
          SizedBox(height: Dimensions.height15),
          DetailRow(label: 'Size:', value: formatBytes(document.sizeBytes)),
          if (document.folderName.isNotEmpty) ...[
            SizedBox(height: Dimensions.height15),
            DetailRow(label: 'Folder:', value: document.folderName),
          ],
          SizedBox(height: Dimensions.height15),
          DetailRow(
            label: 'Uploaded:',
            value: formatDate(document.uploadedDate),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => ToastificationHelper.showInfo(
              context,
              'Downloading is coming soon.',
            ),
            icon: const Icon(Icons.download_rounded),
            label: const Text('Download'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: BorderSide(color: AppColors.primary.withValues(alpha: 0.5)),
              padding: EdgeInsets.symmetric(vertical: Dimensions.height15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Dimensions.radius15),
              ),
            ),
          ),
        ),
        SizedBox(width: Dimensions.width15),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => ToastificationHelper.showInfo(
              context,
              'Sharing is coming soon.',
            ),
            icon: const Icon(Icons.share_rounded),
            label: const Text('Share'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: BorderSide(color: AppColors.primary.withValues(alpha: 0.5)),
              padding: EdgeInsets.symmetric(vertical: Dimensions.height15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Dimensions.radius15),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showConfirmationDialog(
      context,
      title: 'Delete Document',
      message:
          'Are you sure you want to delete "${document.fileName}"? This action cannot be undone.',
    );
    if (confirmed && context.mounted) {
      onDelete?.call();
      Navigator.pop(context);
    }
  }
}
