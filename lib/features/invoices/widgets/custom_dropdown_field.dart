import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:flutter/material.dart';

class CustomDropdownField extends StatelessWidget {
  final String label;
  final String value;
  final List<String> options;
  final bool isRequired;
  final Function(String?)? onChanged;
  final void Function(String, String, List<String>, Function(String?)?)
  onShowSheet;

  const CustomDropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.onShowSheet,
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
                color: Appcolors.primary,
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
          onTap: () => onShowSheet(label, value, options, onChanged),
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