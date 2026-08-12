import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:flutter/material.dart';

class SelectionSheet extends StatelessWidget {
  final String title;
  final List<String> options;
  final String selectedOption;
  final ValueChanged<String> onSelected;

  const SelectionSheet({
    super.key,
    required this.title,
    required this.options,
    required this.selectedOption,
    required this.onSelected,
  });

  static void show(
    BuildContext context, {
    required String title,
    required List<String> options,
    required String selectedOption,
    required ValueChanged<String> onSelected,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return SelectionSheet(
          title: title,
          options: options,
          selectedOption: selectedOption,
          onSelected: onSelected,
        );
      },
    );
  }

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
                  title,
                  style: TextStyle(
                    fontSize: Dimensions.font20,
                    fontWeight: FontWeight.w700,
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

          // Options list
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(Dimensions.width20),
            itemCount: options.length,
            itemBuilder: (context, index) {
              final option = options[index];
              final isSelected = option == selectedOption;

              return GestureDetector(
                onTap: () {
                  onSelected(option);
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
                        ? Appcolors.primary.withValues(alpha: 0.05)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(Dimensions.radius15),
                    border: Border.all(
                      color: isSelected
                          ? Appcolors.primary
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
                              ? Appcolors.primary
                              : context.colors.textPrimary,
                        ),
                      ),
                      if (isSelected)
                        Icon(
                          Icons.check_circle,
                          color: Appcolors.primary,
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
