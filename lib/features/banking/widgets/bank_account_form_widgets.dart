import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:flutter/material.dart';

class BankFormCard extends StatelessWidget {
  final List<Widget> children;

  const BankFormCard({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Dimensions.width20),
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: BorderRadius.circular(Dimensions.radius20),
        border: Border.all(color: context.colors.border),
        boxShadow: [
          BoxShadow(
            color: context.colors.border.withValues(alpha: 0.5),
            blurRadius: Dimensions.radius15 * 0.67,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

class BankFormTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isRequired;
  final IconData? icon;
  final String? hint;
  final int maxLines;

  const BankFormTextField({
    super.key,
    required this.label,
    required this.controller,
    this.isRequired = false,
    this.icon,
    this.hint,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: Dimensions.iconSize16,
                color: context.colors.textSecondary,
              ),
              SizedBox(width: Dimensions.width10 / 2),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.85,
                fontWeight: FontWeight.w600,
                color: context.colors.textPrimary,
              ),
            ),
            if (isRequired)
              Text(
                ' *',
                style: TextStyle(
                  color: Appcolors.error,
                  fontSize: Dimensions.font16 * 0.85,
                ),
              ),
          ],
        ),
        SizedBox(height: Dimensions.height10 / 2),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: TextStyle(
            fontSize: Dimensions.font16 * 0.85,
            color: context.colors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              fontSize: Dimensions.font16 * 0.8,
              color: context.colors.textTertiary,
            ),
            filled: true,
            fillColor: context.colors.surfaceLight,
            contentPadding: EdgeInsets.symmetric(
              horizontal: Dimensions.width15,
              vertical: Dimensions.height15,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius15 / 2),
              borderSide: BorderSide(color: context.colors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius15 / 2),
              borderSide: BorderSide(color: context.colors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius15 / 2),
              borderSide: BorderSide(color: Appcolors.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}

class BankFormRadioOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const BankFormRadioOption({
    super.key,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.all(Dimensions.width10),
            child: Container(
              width: Dimensions.height20,
              height: Dimensions.height20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? Appcolors.primary
                      : context.colors.textTertiary,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: Dimensions.height10,
                        height: Dimensions.height10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Appcolors.primary,
                        ),
                      ),
                    )
                  : null,
            ),
          ),
          Icon(
            icon,
            size: Dimensions.iconSize16,
            color: isSelected
                ? Appcolors.primary
                : context.colors.textSecondary,
          ),
          SizedBox(width: Dimensions.width10 / 2),
          Text(
            label,
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.85,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected
                  ? Appcolors.primary
                  : context.colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
