import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:flutter/material.dart';

class SalutationBottomSheet extends StatelessWidget {
  final List<String> options;
  final String? selectedSalutation;
  final ValueChanged<String> onSelected;

  const SalutationBottomSheet({
    super.key,
    required this.options,
    required this.selectedSalutation,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.width20,
              vertical: Dimensions.height15,
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: context.colors.border,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Salutation',
                  style: TextStyle(
                    fontSize: Dimensions.font20 * 0.85,
                    fontWeight: FontWeight.w800,
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

          // Options
          ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.all(Dimensions.width20),
            itemCount: options.length,
            itemBuilder: (context, index) {
              final option = options[index];
              final isSelected = selectedSalutation == option;

              return GestureDetector(
                onTap: () {
                  onSelected(option);
                  Navigator.pop(context);
                },
                child: Container(
                  margin: EdgeInsets.only(
                    bottom: Dimensions.height10,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.width15,
                    vertical: Dimensions.height15,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withValues(alpha: 0.05)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(
                      Dimensions.radius15,
                    ),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : context.colors.border,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        option,
                        style: TextStyle(
                          fontSize: Dimensions.font16,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w500,
                          color: isSelected
                              ? AppColors.primary
                              : context.colors.textPrimary,
                        ),
                      ),

                      if (isSelected)
                        Icon(
                          Icons.check_circle,
                          color: AppColors.primary,
                          size: Dimensions.iconSize24,
                        ),
                    ],
                  ),
                ),
              );
            },
          ),

          SizedBox(height: Dimensions.height10),
        ],
      ),
    );
  }
}