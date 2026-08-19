import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FormCard extends StatelessWidget {
  final List<Widget> children;
  final double? borderRadius;
  final bool showShadow;
  final EdgeInsetsGeometry? padding;

  const FormCard({
    super.key,
    required this.children,
    this.borderRadius,
    this.showShadow = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? EdgeInsets.all(Dimensions.width20),
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: BorderRadius.circular(
          borderRadius ?? Dimensions.radius15,
        ),
        border: Border.all(color: context.colors.border),
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: context.colors.border.withValues(alpha: 0.5),
                  blurRadius: Dimensions.radius15 * 0.67,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

class RequiredLabel extends StatelessWidget {
  final String text;

  const RequiredLabel({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: '$text ',
        style: FormTextStyles.label(),
        children: [
          TextSpan(
            text: '*',
            style: TextStyle(color: Colors.red.shade400),
          ),
        ],
      ),
    );
  }
}

class FormDivider extends StatelessWidget {
  const FormDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Dimensions.height10 / 2),
      child: Divider(height: 1, color: context.colors.border),
    );
  }
}

class FormTextStyles {
  static TextStyle label() => TextStyle(
    fontSize: Dimensions.font16 * 0.8,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
  );

  static TextStyle value(BuildContext context) => TextStyle(
    fontSize: Dimensions.font16 * 0.9,
    fontWeight: FontWeight.w500,
    color: context.colors.textPrimary,
  );
}

class FormLabel extends StatelessWidget {
  final String text;
  final bool required;
  final bool showInfo;
  final VoidCallback? onInfoTap;

  const FormLabel({
    super.key,
    required this.text,
    this.required = false,
    this.showInfo = false,
    this.onInfoTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: Dimensions.height15,
        bottom: Dimensions.height10 / 2,
      ),
      child: Row(
        children: [
          required
              ? RequiredLabel(text: text.trim())
              : Text(text.trim(), style: FormTextStyles.label()),
          if (showInfo)
            Padding(
              padding: EdgeInsets.only(left: Dimensions.width10 / 2),
              child: GestureDetector(
                onTap: onInfoTap,
                child: Icon(
                  Icons.info_outline_rounded,
                  size: Dimensions.iconSize24 - 7,
                  color: context.colors.textSecondary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class FormNumberField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String hint;
  final String? prefix;
  final String? suffix;
  final bool signed;
  final bool enabled;
  final double? width;
  final ValueChanged<String>? onChanged;

  const FormNumberField({
    super.key,
    required this.controller,
    required this.hint,
    this.focusNode,
    this.prefix,
    this.suffix,
    this.signed = false,
    this.enabled = true,
    this.width,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? Dimensions.height45 * 2.2,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        enabled: enabled,
        onChanged: onChanged,
        textAlign: TextAlign.right,
        keyboardType: TextInputType.numberWithOptions(
          decimal: true,
          signed: signed,
        ),
        inputFormatters: [
          FilteringTextInputFormatter.allow(
            signed ? RegExp(r'^-?\d*\.?\d*') : RegExp(r'^\d*\.?\d*'),
          ),
        ],
        style: FormTextStyles.value(context),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: context.colors.textTertiary),
          prefixText: prefix == null ? null : '$prefix ',
          suffixText: suffix,
          prefixStyle: TextStyle(
            color: context.colors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
          suffixStyle: TextStyle(
            color: context.colors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
          filled: !enabled,
          fillColor: context.colors.surfaceLight,
          border: _border(context.colors.border),
          enabledBorder: _border(context.colors.border),
          focusedBorder: _border(AppColors.primary, width: 2),
          contentPadding: EdgeInsets.symmetric(
            horizontal: Dimensions.width15,
            vertical: Dimensions.height10,
          ),
        ),
      ),
    );
  }

  OutlineInputBorder _border(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(Dimensions.radius15 / 2),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
