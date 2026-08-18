import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:flutter/material.dart';

class FilterBottomSheet<T> extends StatelessWidget {
  final String title;
  final List<T?> options;
  final T? selectedValue;
  final String Function(T?) labelBuilder;
  final ValueChanged<T?> onSelected;

  const FilterBottomSheet({
    super.key,
    required this.title,
    required this.options,
    required this.selectedValue,
    required this.labelBuilder,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
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

            // Drag handle
            Container(
              width: Dimensions.width20 * 2,
              height: Dimensions.height10 * 0.4,
              margin: EdgeInsets.symmetric(
                vertical: Dimensions.height10,
              ),
              decoration: BoxDecoration(
                color: context.colors.border,
                borderRadius: BorderRadius.circular(
                  Dimensions.radius30,
                ),
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
                    title,
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

                  final item = options[index];
                  final selected = item == selectedValue;

                  return GestureDetector(
                    onTap: () {
                      onSelected(item);
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
                        color: selected
                            ? Appcolors.primary.withValues(
                                alpha: 0.05,
                              )
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
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,

                        children: [

                          Text(
                            labelBuilder(item),
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