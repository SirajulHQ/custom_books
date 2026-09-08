import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/widgets/bottom_sheet_drag_handle.dart';
import 'package:flutter/material.dart';

class InvoiceDropdownField extends StatelessWidget {
  final String label;
  final String value;
  final List<String> options;
  final bool isRequired;
  final Function(String?)? onChanged;
  // final void Function(String, String, List<String>, Function(String?)?)
  // onShowSheet;

  const InvoiceDropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    // required this.onShowSheet,
    this.isRequired = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.85,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            if (isRequired) ...[
              SizedBox(width: Dimensions.width10 / 3),
              Text(
                '*',
                style: TextStyle(
                  fontSize: Dimensions.font16 * 0.85,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
            ],
          ],
        ),
        SizedBox(height: Dimensions.height10),
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              builder: (ctx) {
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
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.width20,
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            label,
                            style: TextStyle(
                              fontSize: Dimensions.font20,
                              fontWeight: FontWeight.w800,
                              color: context.colors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: Dimensions.height10),
                      ...options.map((option) {
                        final selected = option == value;
                        return ListTile(
                          title: Text(
                            option,
                            style: TextStyle(
                              fontSize: Dimensions.font16 * 0.9,
                              fontWeight: selected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: context.colors.textPrimary,
                            ),
                          ),
                          trailing: selected
                              ? Icon(
                                  Icons.check_rounded,
                                  color: AppColors.primary,
                                )
                              : null,
                          onTap: () {
                            onChanged?.call(option);
                            Navigator.pop(ctx);
                          },
                        );
                      }),
                      SizedBox(height: Dimensions.height20),
                    ],
                  ),
                );
              },
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.width15,
              vertical: Dimensions.height15,
            ),
            decoration: BoxDecoration(
              color: context.colors.surfaceLight,
              borderRadius: BorderRadius.circular(Dimensions.radius15),
              border: Border.all(color: context.colors.border),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: Dimensions.font16 * 0.85,
                      color: context.colors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: Dimensions.iconSize24,
                  color: context.colors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
