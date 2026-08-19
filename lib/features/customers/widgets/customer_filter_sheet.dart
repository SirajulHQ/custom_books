import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:flutter/material.dart';

class CustomerFilterSheet extends StatelessWidget {
  final String selectedFilter;
  final List<String> filterOptions;
  final ValueChanged<String> onSelected;

  const CustomerFilterSheet({
    super.key,
    required this.selectedFilter,
    required this.filterOptions,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Dimensions.radius20),
          topRight: Radius.circular(Dimensions.radius20),
        ),
      ),
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
                bottom: BorderSide(color: context.colors.border, width: 1),
              ),
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

          // Default Filters Label
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(
              Dimensions.width20,
              Dimensions.height20,
              Dimensions.width20,
              Dimensions.height10,
            ),
            child: Text(
              'DEFAULT FILTERS',
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.7,
                fontWeight: FontWeight.w600,
                color: context.colors.textTertiary,
                letterSpacing: 0.5,
              ),
            ),
          ),

          // Filter options
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.width20,
              vertical: Dimensions.height10,
            ),
            itemCount: filterOptions.length,
            itemBuilder: (context, index) {
              final filter = filterOptions[index];
              final isSelected = filter == selectedFilter;

              return GestureDetector(
                onTap: () {
                  onSelected(filter);
                  Navigator.pop(context);
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: Dimensions.height10),
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.width15,
                    vertical: Dimensions.height15,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withValues(alpha: 0.05)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(Dimensions.radius15),
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
                        filter,
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

          SizedBox(height: Dimensions.height20),
        ],
      ),
    );
  }
}
