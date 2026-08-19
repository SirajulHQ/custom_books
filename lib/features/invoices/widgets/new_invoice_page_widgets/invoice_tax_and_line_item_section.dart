import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/core/widgets/form_widgets.dart';
import 'package:custom_books/features/invoices/models/invoice_model.dart';
import 'package:custom_books/features/invoices/views/add_invoice_line_item_page.dart';
import 'package:flutter/material.dart';

class InvoiceTaxAndLineItemSection extends StatelessWidget {
  final bool isTaxInclusive;
  final ValueChanged<bool> onTaxTypeChanged;
  final ValueChanged<InvoiceLineItem> onLineItemAdded;

  const InvoiceTaxAndLineItemSection({
    super.key,
    required this.isTaxInclusive,
    required this.onTaxTypeChanged,
    required this.onLineItemAdded,
  });

  void _handleTaxTypeChanged(bool value) {
    setStateAndLog(value);
  }

  void setStateAndLog(bool value) {
    appLog(
      '💰 Tax type changed to: ${value ? "Inclusive" : "Exclusive"}',
      name: 'NewInvoicePage',
    );
    onTaxTypeChanged(value);
  }

  Future<void> _handleAddLineItem(BuildContext context) async {
    appLog('➕ Add Line Item tapped', name: 'NewInvoicePage');
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddInvoiceLineItemPage()),
    );
    if (result != null && result is InvoiceLineItem) {
      appLog('✅ Line item added: ${result.itemName}', name: 'NewInvoicePage');
      if (!context.mounted) return;
      ToastificationHelper.showSuccess(
        context,
        '${result.itemName} added to invoice.',
      );
      onLineItemAdded(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FormCard(
          borderRadius: Dimensions.radius20,
          showShadow: true,
          children: [
            Row(
              children: [
                Text(
                  'Tax',
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.85,
                    fontWeight: FontWeight.w600,
                    color: context.colors.textSecondary,
                  ),
                ),
                SizedBox(width: Dimensions.width20),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: buildRadioOption(
                          context,
                          'Exclusive',
                          !isTaxInclusive,
                          () => _handleTaxTypeChanged(false),
                        ),
                      ),
                      SizedBox(width: Dimensions.width15),
                      Expanded(
                        child: buildRadioOption(
                          context,
                          'Inclusive',
                          isTaxInclusive,
                          () => _handleTaxTypeChanged(true),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: Dimensions.height15),
        GestureDetector(
          onTap: () => _handleAddLineItem(context),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.width20,
              vertical: Dimensions.height20,
            ),
            decoration: BoxDecoration(
              color: context.colors.card,
              borderRadius: BorderRadius.circular(Dimensions.radius20),
              border: Border.all(color: AppColors.primary, width: 2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_circle,
                  color: AppColors.primary,
                  size: Dimensions.iconSize24,
                ),
                SizedBox(width: Dimensions.width10),
                Text(
                  'Add Line Item',
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.9,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  
  static Widget buildRadioOption(
    BuildContext context,
    String label,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: Dimensions.iconSize24,
            height: Dimensions.iconSize24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? AppColors.primary : context.colors.border,
                width: 2,
              ),
            ),
            child: isSelected
                ? Center(
                    child: Container(
                      width: Dimensions.iconSize24 / 2,
                      height: Dimensions.iconSize24 / 2,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary,
                      ),
                    ),
                  )
                : null,
          ),
          SizedBox(width: Dimensions.width10),
          Text(
            label,
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.85,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected
                  ? context.colors.textPrimary
                  : context.colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}