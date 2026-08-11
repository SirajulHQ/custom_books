import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:flutter/material.dart';

class CustomerSortSheet extends StatelessWidget {
  final String selectedField;
  final bool ascending;
  final void Function(String field, bool ascending) onApply;

  const CustomerSortSheet({
    super.key,
    required this.selectedField,
    required this.ascending,
    required this.onApply,
  });

  static const List<String> fields = ['Name', 'Receivables', 'Unused Credits'];

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);
    return Container(
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
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Sort by',
                style: TextStyle(
                  fontSize: Dimensions.font20,
                  fontWeight: FontWeight.w800,
                  color: context.colors.textPrimary,
                ),
              ),
            ),
          ),
          SizedBox(height: Dimensions.height10),
          ...fields.map((f) {
            final selected = f == selectedField;
            return ListTile(
              leading: Icon(
                selected
                    ? Icons.radio_button_checked_rounded
                    : Icons.radio_button_off_rounded,
                color: selected
                    ? Appcolors.primary
                    : context.colors.textSecondary,
              ),
              title: Text(
                f,
                style: TextStyle(
                  fontSize: Dimensions.font16 * 0.9,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: context.colors.textPrimary,
                ),
              ),
              trailing: selected
                  ? Icon(
                      ascending
                          ? Icons.arrow_upward_rounded
                          : Icons.arrow_downward_rounded,
                      color: Appcolors.primary,
                      size: Dimensions.iconSize16,
                    )
                  : null,
              onTap: () {
                if (selectedField == f) {
                  onApply(f, !ascending);
                } else {
                  onApply(f, true);
                }
                Navigator.pop(context);
              },
            );
          }),
          SizedBox(height: Dimensions.height20),
        ],
      ),
    );
  }
}
