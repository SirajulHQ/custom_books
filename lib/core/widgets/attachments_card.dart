import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/widgets/dashed_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class AttachmentsCard extends StatelessWidget {
  final List<PlatformFile> attachments;
  final VoidCallback onPickFiles;
  final ValueChanged<int> onRemoveFile;

  const AttachmentsCard({
    super.key,
    required this.attachments,
    required this.onPickFiles,
    required this.onRemoveFile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Attachments', style: _labelStyle()),
            if (attachments.isNotEmpty) ...[
              SizedBox(width: Dimensions.width10 / 2),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.width10 * 0.6,
                  vertical: Dimensions.height10 * 0.2,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  '${attachments.length}',
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.7,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ],
        ),
        SizedBox(height: Dimensions.height10),
        InkWell(
          borderRadius: BorderRadius.circular(Dimensions.radius15),
          onTap: onPickFiles,
          child: DashedBorder(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                vertical: Dimensions.height15,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.upload_file_outlined,
                    color: AppColors.primary,
                    size: Dimensions.iconSize24 - 4,
                  ),
                  SizedBox(width: Dimensions.width10),
                  Text(
                    attachments.isEmpty ? 'Upload File' : 'Add More Files',
                    style: TextStyle(
                      fontSize: Dimensions.font16 * 0.85,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        ...attachments.asMap().entries.map(
              (entry) => Container(
                margin: EdgeInsets.only(top: Dimensions.height10),
                decoration: BoxDecoration(
                  color: context.colors.surfaceLight,
                  borderRadius: BorderRadius.circular(Dimensions.radius15),
                ),
                child: ListTile(
                  dense: true,
                  leading: Icon(
                    Icons.attach_file_rounded,
                    color: AppColors.primary,
                  ),
                  title: Text(
                    entry.value.name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: Dimensions.font16 * 0.8,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => onRemoveFile(entry.key),
                  ),
                ),
              ),
            ),
      ],
    );
  }

  TextStyle _labelStyle() => TextStyle(
        fontSize: Dimensions.font16 * 0.8,
        fontWeight: FontWeight.w600,
        color: AppColors.primary,
      );
}
