import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:flutter/material.dart';

class SelectCustomerBottomSheet extends StatelessWidget {
  final VoidCallback? onPreviewInvoice;
  final VoidCallback? onSaveAndSend;
  final VoidCallback? onResetForm;
  final bool isCustomerSelected;

  const SelectCustomerBottomSheet({
    super.key,
    this.onPreviewInvoice,
    this.onSaveAndSend,
    this.onResetForm,
    this.isCustomerSelected = false,
  });

  static Future<void> show(
    BuildContext context, {
    VoidCallback? onPreviewInvoice,
    VoidCallback? onSaveAndSend,
    VoidCallback? onResetForm,
    bool isCustomerSelected = false,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => SelectCustomerBottomSheet(
        onPreviewInvoice: onPreviewInvoice,
        onSaveAndSend: onSaveAndSend,
        onResetForm: onResetForm,
        isCustomerSelected: isCustomerSelected,
      ),
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
          Container(
            width: Dimensions.width20 * 2,
            height: Dimensions.height10 * 0.4,
            margin: EdgeInsets.symmetric(vertical: Dimensions.height10),
            decoration: BoxDecoration(
              color: context.colors.border,
              borderRadius: BorderRadius.circular(Dimensions.radius30),
            ),
          ),
          _moreOptionTile(
            context,
            Icons.remove_red_eye_outlined,
            'Preview invoice',
            () {
              if (onPreviewInvoice != null) {
                onPreviewInvoice!();
              } else {
                ToastificationHelper.showInfo(
                  context,
                  'Invoice preview is coming soon.',
                );
              }
            },
          ),
          _moreOptionTile(context, Icons.send_rounded, 'Save and send', () {
            if (!isCustomerSelected) {
              ToastificationHelper.showError(
                context,
                'Please select a customer before sending.',
              );
              return;
            }
            onSaveAndSend?.call();
            ToastificationHelper.showSuccess(
              context,
              'Invoice saved and sent.',
            );
            Navigator.pop(context);
          }),
          _moreOptionTile(context, Icons.refresh_rounded, 'Reset form', () {
            onResetForm?.call();
            ToastificationHelper.showInfo(context, 'Form reset.');
          }),
          SizedBox(height: Dimensions.height20),
        ],
      ),
    );
  }

  Widget _moreOptionTile(
    BuildContext sheetContext,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: Appcolors.primary),
      title: Text(
        label,
        style: TextStyle(
          fontSize: Dimensions.font16 * 0.9,
          fontWeight: FontWeight.w600,
          color: sheetContext.colors.textPrimary,
        ),
      ),
      onTap: () {
        Navigator.pop(sheetContext);
        onTap();
      },
    );
  }
}
