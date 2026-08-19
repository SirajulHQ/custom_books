import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:flutter/material.dart';

class UnderlineTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final bool readOnly;
  final int maxLines;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool enabled;
  final TextStyle? style;
  final VoidCallback? onTap;

  const UnderlineTextField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.readOnly = false,
    this.maxLines = 1,
    this.keyboardType,
    this.onChanged,
    this.suffixIcon,
    this.prefixIcon,
    this.enabled = true,
    this.style,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      maxLines: maxLines,
      keyboardType: keyboardType,
      onChanged: onChanged,
      enabled: enabled,
      onTap: onTap,
      style: style ??
          TextStyle(
            fontSize: Dimensions.font16 * 0.9,
            fontWeight: FontWeight.w500,
            color: context.colors.textPrimary,
          ),
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        hintStyle: TextStyle(
          color: context.colors.textTertiary,
          fontSize: Dimensions.font16 * 0.9,
        ),
        isDense: true,
        contentPadding: EdgeInsets.symmetric(
          vertical: Dimensions.height10,
        ),
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: context.colors.border),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: context.colors.border),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary),
        ),
      ),
    );
  }
}
