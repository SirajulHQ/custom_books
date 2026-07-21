import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/image_helper.dart';
import 'package:custom_books/features/inventory_adjustments/model/line_item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
            color: selected ? Appcolors.primary : Colors.black26,
            size: Dimensions.iconSize24 - 2,
          ),
          SizedBox(width: Dimensions.width10 / 2),
          Text(
            label,
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.85,
              color: const Color(0xFF0F172A),
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
            color: Colors.white,
            borderRadius: BorderRadius.circular(Dimensions.radius15),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            children: [
              Container(
                width: Dimensions.height45 * 0.8,
                height: Dimensions.height45 * 0.8,
                decoration: BoxDecoration(
                  color: Appcolors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(Dimensions.radius15 - 4),
                  image: item.imageUrl != null
                      ? DecorationImage(
                          image: ImageHelper.getImageProvider(item.imageUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: item.imageUrl == null
                    ? Icon(
                        Icons.inventory_2_outlined,
                        color: Appcolors.primary,
                        size: Dimensions.iconSize24 - 6,
                      )
                    : null,
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
                        color: const Color(0xFF0F172A),
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
                  color: Colors.black38,
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
          color: Colors.white,
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

/// Card container widget with consistent styling for form sections
class FormCard extends StatelessWidget {
  final List<Widget> children;

  const FormCard({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Dimensions.width20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Dimensions.radius15),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

/// Label widget with asterisk for required fields
class RequiredLabel extends StatelessWidget {
  final String text;

  const RequiredLabel({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: '$text ',
        style: TextStyle(
          fontSize: Dimensions.font16 * 0.8,
          fontWeight: FontWeight.w600,
          color: Appcolors.primary,
        ),
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

/// Divider widget with consistent spacing for form sections
class FormDivider extends StatelessWidget {
  const FormDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Dimensions.height10 / 2),
      child: const Divider(height: 1, color: Color(0xFFE2E8F0)),
    );
  }
}

/// Helper class for consistent text styles in adjustment forms
class AdjustmentTextStyles {
  /// Label text style (used for field labels)
  static TextStyle label() => TextStyle(
    fontSize: Dimensions.font16 * 0.8,
    fontWeight: FontWeight.w600,
    color: Appcolors.primary,
  );

  /// Value text style (used for field values)
  static TextStyle value() => TextStyle(
    fontSize: Dimensions.font16 * 0.9,
    fontWeight: FontWeight.w500,
    color: const Color(0xFF0F172A),
  );
}

/// Number input field widget for quantity adjustments
/// Supports decimal numbers and negative values (signed)
class AdjustmentNumberField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool enabled;
  final String hint;
  final ValueChanged<String> onChanged;

  const AdjustmentNumberField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.enabled,
    required this.hint,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: enabled
          ? () {
              focusNode.requestFocus();
            }
          : null,
      child: Container(
        width: Dimensions.height45 * 2.2,
        height: Dimensions.height45,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: Dimensions.width10),
        decoration: BoxDecoration(
          color: enabled ? Colors.white : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(Dimensions.radius15 - 6),
          border: Border.all(color: const Color(0xFFCBD5E1)),
        ),
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          enabled: enabled,
          onChanged: onChanged,
          textAlign: TextAlign.right,
          keyboardType: const TextInputType.numberWithOptions(
            decimal: true,
            signed: true,
          ),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^-?\d*\.?\d*')),
          ],
          style: AdjustmentTextStyles.value(),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.black26),
            border: InputBorder.none,
            isDense: true,
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ),
    );
  }
}
