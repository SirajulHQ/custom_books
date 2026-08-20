import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:custom_books/core/enums/sort_direction.dart';

class CreditNoteSortSheet<T> extends StatelessWidget {
  final String title;
  final List<T> items;
  final String Function(T) labelBuilder;
  final T selectedItem;
  final SortDirection direction;
  final ValueChanged<T> onItemChanged;
  final VoidCallback onApply;

  const CreditNoteSortSheet({
    super.key,
    required this.title,
    required this.items,
    required this.labelBuilder,
    required this.selectedItem,
    required this.direction,
    required this.onItemChanged,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    var field = selectedItem;
    var sortDirection = direction;

    return StatefulBuilder(
      builder: (context, setSheetState) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: BoxDecoration(
            color: context.colors.card,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(Dimensions.radius20 * 1.2),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: Dimensions.width20 * 2,
                height: Dimensions.height10 * 0.4,
                margin: EdgeInsets.symmetric(vertical: Dimensions.height10),
                decoration: BoxDecoration(
                  color: context.colors.border,
                  borderRadius: BorderRadius.circular(Dimensions.radius30),
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: Dimensions.font20,
                        fontWeight: FontWeight.w800,
                        color: context.colors.textPrimary,
                      ),
                    ),

                    InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(Dimensions.radius15),
                      child: Container(
                        padding: EdgeInsets.all(Dimensions.width10 * 0.6),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(
                            Dimensions.radius15,
                          ),
                        ),
                        child: Icon(
                          Icons.close_rounded,
                          size: Dimensions.iconSize16,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: Dimensions.height15),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
                child: Column(
                  children: items.map((item) {
                    final selected = item == field;

                    return Padding(
                      padding: EdgeInsets.only(bottom: Dimensions.height10),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(
                          Dimensions.radius15,
                        ),
                        onTap: () {
                          setSheetState(() {
                            if (field == item) {
                              sortDirection =
                                  sortDirection == SortDirection.ascending
                                  ? SortDirection.descending
                                  : SortDirection.ascending;
                            } else {
                              field = item;
                              sortDirection = SortDirection.descending;
                            }
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.width15,
                            vertical: Dimensions.height15 * 0.75,
                          ),
                          decoration: BoxDecoration(
                            color: selected
                                ? AppColors.primary.withValues(alpha: 0.06)
                                : context.colors.card,
                            borderRadius: BorderRadius.circular(
                              Dimensions.radius15,
                            ),
                            border: Border.all(
                              color: selected
                                  ? AppColors.primary
                                  : context.colors.border,
                              width: selected ? 1.5 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                selected
                                    ? Icons.radio_button_checked_rounded
                                    : Icons.radio_button_off_rounded,
                                size: Dimensions.iconSize24 - 4,
                                color: selected
                                    ? AppColors.primary
                                    : context.colors.textTertiary,
                              ),

                              SizedBox(width: Dimensions.width10),

                              Expanded(
                                child: Text(
                                  labelBuilder(item),
                                  style: TextStyle(
                                    fontSize: Dimensions.font16 * 0.9,
                                    fontWeight: selected
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                    color: context.colors.textPrimary,
                                  ),
                                ),
                              ),

                              if (selected)
                                Icon(
                                  sortDirection == SortDirection.ascending
                                      ? Icons.arrow_upward_rounded
                                      : Icons.arrow_downward_rounded,
                                  size: Dimensions.iconSize16,
                                  color: AppColors.primary,
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              SizedBox(height: Dimensions.height15),

              Container(
                padding: EdgeInsets.fromLTRB(
                  Dimensions.width20,
                  Dimensions.height15,
                  Dimensions.width20,
                  Dimensions.height20,
                ),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: context.colors.border)),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      onItemChanged(field);
                      onApply();
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(
                        color: AppColors.primary,
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          Dimensions.radius15,
                        ),
                      ),
                    ),
                    child: Text(
                      "Sort",
                      style: TextStyle(
                        fontSize: Dimensions.font16 * 0.9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
