import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:flutter/material.dart';

class TaxToggle extends StatelessWidget {
  final bool isTaxInclusive;
  final ValueChanged<bool> onChanged;

  const TaxToggle({
    super.key,
    required this.isTaxInclusive,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Dimensions.height10 * 0.4),
      decoration: BoxDecoration(
        color: context.colors.surfaceLight,
        borderRadius: BorderRadius.circular(Dimensions.radius15),
        border: Border.all(color: context.colors.border),
      ),
      child: Row(
        children: [
          _buildOption(context, 'Exclusive', false),
          _buildOption(context, 'Inclusive', true),
        ],
      ),
    );
  }

  Widget _buildOption(BuildContext context, String label, bool value) {
    final selected = isTaxInclusive == value;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(Dimensions.radius15 - 3),
        onTap: () => onChanged(value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: EdgeInsets.symmetric(vertical: Dimensions.height10),
          decoration: BoxDecoration(
            color: selected ? context.colors.card : Colors.transparent,
            borderRadius: BorderRadius.circular(Dimensions.radius15 - 3),
            border: selected
                ? Border.all(color: AppColors.primary.withValues(alpha: 0.3))
                : null,
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      blurRadius: Dimensions.radius15 * 0.53,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.8,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              color: selected
                  ? AppColors.primary
                  : context.colors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
