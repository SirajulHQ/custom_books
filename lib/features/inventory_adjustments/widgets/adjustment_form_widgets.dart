import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/widgets/line_item_form_widgets.dart';
import 'package:custom_books/features/inventory_adjustments/models/line_item_model.dart';
import 'package:flutter/material.dart';

/// Radio option widget for selecting mode of adjustment (Quantity or Value)
class AdjustmentRadioOption extends StatelessWidget {
  final String label;
  final ModeOfAdjustment value;
  final ModeOfAdjustment selectedValue;
  final ValueChanged<ModeOfAdjustment> onChanged;

  const AdjustmentRadioOption({
    super.key,
    required this.label,
    required this.value,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final selected = selectedValue == value;
    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            selected
                ? Icons.radio_button_checked_rounded
                : Icons.radio_button_off_rounded,
            color: selected ? Appcolors.primary : context.colors.textTertiary,
            size: Dimensions.iconSize24 - 2,
          ),
          SizedBox(width: Dimensions.width10 / 2),
          Text(
            label,
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.85,
              color: context.colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Card widget displaying a single line item with edit and delete functionality
class AdjustmentLineItemCard extends StatelessWidget {
  final LineItem item;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const AdjustmentLineItemCard({
    super.key,
    required this.item,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final qtyColor = item.quantityAdjusted < 0
        ? Colors.red.shade600
        : Colors.green.shade600;

    return Container(
      margin: EdgeInsets.only(bottom: Dimensions.height10),
      child: InkWell(
        borderRadius: BorderRadius.circular(Dimensions.radius15),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(Dimensions.width20 * 0.8),
          decoration: BoxDecoration(
            color: context.colors.card,
            borderRadius: BorderRadius.circular(Dimensions.radius15),
            border: Border.all(color: context.colors.border),
          ),
          child: Row(
            children: [
              ItemThumbnail(
                imageUrl: item.imageUrl,
                size: Dimensions.height45 * 0.8,
              ),
              SizedBox(width: Dimensions.width10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.itemName,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: Dimensions.font16 * 0.85,
                        color: context.colors.textPrimary,
                      ),
                    ),
                    SizedBox(height: Dimensions.height10 / 4),
                    Text(
                      '${item.quantityAdjusted > 0 ? '+' : ''}${item.quantityAdjusted.toStringAsFixed(2)} qty  •  AED ${item.valueChange.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: Dimensions.font16 * 0.7,
                        color: qtyColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.close_rounded,
                  size: Dimensions.iconSize24 - 6,
                  color: context.colors.textTertiary,
                ),
                onPressed: onRemove,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Button widget for adding new line items
class AddLineItemButton extends StatelessWidget {
  final VoidCallback onPressed;

  const AddLineItemButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(Dimensions.radius15),
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: Dimensions.height15),
        decoration: BoxDecoration(
          color: context.colors.card,
          borderRadius: BorderRadius.circular(Dimensions.radius15),
          border: Border.all(color: Appcolors.primary.withValues(alpha: 0.4)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_circle_rounded,
              color: Appcolors.primary,
              size: Dimensions.iconSize24 - 2,
            ),
            SizedBox(width: Dimensions.width10 / 2),
            Text(
              'Add Line Item',
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.9,
                fontWeight: FontWeight.w700,
                color: Appcolors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
