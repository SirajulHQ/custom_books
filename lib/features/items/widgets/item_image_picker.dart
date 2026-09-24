import 'dart:io' show File;

import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ItemImagePicker extends StatelessWidget {
  const ItemImagePicker({
    super.key,
    required this.image,
    required this.onImagePicked,
    required this.onRemove,
  });

  final XFile? image;
  final ValueChanged<XFile> onImagePicked;
  final VoidCallback onRemove;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picked = await ImagePicker().pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1080,
      );
      if (picked != null) {
        onImagePicked(picked);
        appLog('📷 Image picked: ${picked.path}', name: 'ItemImagePicker');
      }
    } catch (e) {
      appLog('❌ Image pick error: $e', name: 'ItemImagePicker');
    }
  }

  void _showImageSourceSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: context.colors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Dimensions.radius20),
        ),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.width20,
            vertical: Dimensions.height20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Photo Source',
                style: TextStyle(
                  fontSize: Dimensions.font20 * 0.85,
                  fontWeight: FontWeight.w800,
                  color: context.colors.textPrimary,
                ),
              ),
              SizedBox(height: Dimensions.height20),
              _sourceOption(
                context,
                icon: Icons.camera_alt_outlined,
                label: 'Take Photo',
                subtitle: 'Use your camera',
                onTap: () {
                  Navigator.pop(sheetContext);
                  _pickImage(ImageSource.camera);
                },
              ),
              SizedBox(height: Dimensions.height10),
              _sourceOption(
                context,
                icon: Icons.photo_library_outlined,
                label: 'Choose from Gallery',
                subtitle: 'Pick from your photo library',
                onTap: () {
                  Navigator.pop(sheetContext);
                  _pickImage(ImageSource.gallery);
                },
              ),
              SizedBox(height: Dimensions.height10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sourceOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Dimensions.radius15),
      child: Container(
        padding: EdgeInsets.all(Dimensions.width15),
        decoration: BoxDecoration(
          color: context.colors.surfaceLight,
          borderRadius: BorderRadius.circular(Dimensions.radius15),
          border: Border.all(color: context.colors.border),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(Dimensions.width10),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(Dimensions.radius15 / 2),
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
                size: Dimensions.iconSize24,
              ),
            ),
            SizedBox(width: Dimensions.width15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.9,
                    fontWeight: FontWeight.w700,
                    color: context.colors.textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.75,
                    color: context.colors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Item Image',
          style: TextStyle(
            fontSize: Dimensions.font16 * 0.9,
            fontWeight: FontWeight.w700,
            color: context.colors.textPrimary,
          ),
        ),
        SizedBox(height: Dimensions.height10),
        Stack(
          children: [
            GestureDetector(
              onTap: () => _showImageSourceSheet(context),
              child: Container(
                width: double.infinity,
                height: Dimensions.height45 * 2.5,
                decoration: BoxDecoration(
                  color: context.colors.surfaceLight,
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    width: 2,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(Dimensions.radius15),
                ),
                clipBehavior: Clip.antiAlias,
                child: image != null
                    ? Image.file(File(image!.path), fit: BoxFit.cover)
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(Dimensions.width10),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.add_photo_alternate_outlined,
                              size: Dimensions.iconSize24,
                              color: AppColors.primary,
                            ),
                          ),
                          SizedBox(height: Dimensions.height10 / 2),
                          Text(
                            'Add Photo',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: Dimensions.font16 * 0.75,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            if (image != null)
              Positioned(
                top: Dimensions.height10 * 0.6,
                right: Dimensions.width10 * 0.6,
                child: GestureDetector(
                  onTap: onRemove,
                  child: Container(
                    padding: EdgeInsets.all(Dimensions.height10 * 0.4),
                    decoration: BoxDecoration(
                      color: context.colors.textSecondary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: Dimensions.iconSize16 * 0.875,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
