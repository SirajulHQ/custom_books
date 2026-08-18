import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/features/invoices/models/invoice_model.dart';
import 'package:flutter/material.dart';

class InvoiceFilterSheet extends StatelessWidget {
  final InvoiceStatus? selectedStatus;
  final ValueChanged<InvoiceStatus?> onSelected;

  const InvoiceFilterSheet({
    super.key,
    required this.selectedStatus,
    required this.onSelected,
  });

  /// Opens the sheet and wires the selection callback for you.
  static Future<void> show(
    BuildContext context, {
    required InvoiceStatus? selectedStatus,
    required ValueChanged<InvoiceStatus?> onSelected,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => InvoiceFilterSheet(
        selectedStatus: selectedStatus,
        onSelected: onSelected,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final options = <InvoiceStatus?>[null, ...InvoiceStatus.values];

    return SafeArea(
      top: false,
      child: Container(
        decoration: BoxDecoration(
          color: context.colors.card,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(Dimensions.radius20),
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
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.width20,
                vertical: Dimensions.height10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filter',
                    style: TextStyle(
                      fontSize: Dimensions.font20,
                      fontWeight: FontWeight.bold,
                      color: context.colors.textPrimary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.close_rounded,
                      size: Dimensions.iconSize24,
                      color: context.colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(
                  Dimensions.width20,
                  Dimensions.height10,
                  Dimensions.width20,
                  Dimensions.height20,
                ),
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final status = options[index];
                  final selected = status == selectedStatus;
                  return GestureDetector(
                    onTap: () {
                      onSelected(status);
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: Dimensions.height10),
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.width15,
                        vertical: Dimensions.height15,
                      ),
                      decoration: BoxDecoration(
                        color: selected
                            ? Appcolors.primary.withValues(alpha: 0.05)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(
                          Dimensions.radius15,
                        ),
                        border: Border.all(
                          color: selected
                              ? Appcolors.primary
                              : context.colors.border,
                          width: selected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            status?.label ?? 'All Statuses',
                            style: TextStyle(
                              fontSize: Dimensions.font16,
                              fontWeight: selected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                              color: selected
                                  ? Appcolors.primary
                                  : context.colors.textPrimary,
                            ),
                          ),
                          if (selected)
                            Icon(
                              Icons.check_circle_rounded,
                              color: Appcolors.primary,
                              size: Dimensions.iconSize24,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
