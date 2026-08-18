import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/core/widgets/form_widgets.dart';
import 'package:custom_books/features/invoices/widgets/invoice_form_helpers.dart';
import 'package:flutter/material.dart';

class InvoiceAttachmentsCard extends StatelessWidget {
  final VoidCallback? onUploadTap;

  const InvoiceAttachmentsCard({super.key, this.onUploadTap});

  @override
  Widget build(BuildContext context) {
    return FormCard(
      borderRadius: Dimensions.radius20,
      showShadow: true,
      children: [
        InvoiceFormHelpers.buildSectionHeader(context, 'Attachments'),
        SizedBox(height: Dimensions.height15),
        GestureDetector(
          onTap: () {
            appLog('📎 Upload File tapped', name: 'NewInvoicePage');
            ToastificationHelper.showInfo(
              context,
              'File attachments are coming soon.',
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.width20,
              vertical: Dimensions.height20,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radius15),
              border: Border.all(color: context.colors.border, width: 2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.image_outlined,
                  color: context.colors.textSecondary,
                  size: Dimensions.iconSize24,
                ),
                SizedBox(width: Dimensions.width10),
                Text(
                  'Upload File',
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.85,
                    color: context.colors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
