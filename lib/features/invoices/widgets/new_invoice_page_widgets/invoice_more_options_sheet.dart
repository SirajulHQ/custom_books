import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:flutter/material.dart';

void showInvoiceMoreOptionsSheet(
  BuildContext context, {
  required TextEditingController customerNameController,
  required VoidCallback onResetForm,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (ctx) => Container(
      decoration: BoxDecoration(
        color: ctx.colors.card,
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
              color: ctx.colors.border,
              borderRadius: BorderRadius.circular(Dimensions.radius30),
            ),
          ),
          _moreOptionTile(
            ctx,
            Icons.remove_red_eye_outlined,
            'Preview invoice',
            () {
              ToastificationHelper.showInfo(
                context,
                'Invoice preview is coming soon.',
              );
            },
          ),
          _moreOptionTile(
            ctx,
            Icons.send_rounded,
            'Save and send',
            () {
              if (customerNameController.text.trim().isEmpty) {
                ToastificationHelper.showError(
                  context,
                  'Please select a customer before sending.',
                );
                return;
              }
              ToastificationHelper.showSuccess(
                context,
                'Invoice saved and sent.',
              );
              Navigator.pop(context);
            },
          ),
          _moreOptionTile(
            ctx,
            Icons.refresh_rounded,
            'Reset form',
            () {
              onResetForm();
              ToastificationHelper.showInfo(context, 'Form reset.');
            },
          ),
          SizedBox(height: Dimensions.height20),
        ],
      ),
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
    leading: Icon(icon, color: AppColors.primary),
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