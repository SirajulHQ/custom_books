import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A bottom sheet widget for editing cost price
class CostPriceEditor extends StatelessWidget {
  final double initialValue;

  const CostPriceEditor({super.key, required this.initialValue});

  /// Shows the cost price editor bottom sheet
  /// Returns the new cost price value if saved, null if cancelled
  static Future<double?> show(
    BuildContext context, {
    required double initialValue,
  }) {
    return showModalBottomSheet<double>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Dimensions.radius15),
        ),
      ),
      builder: (context) => CostPriceEditor(initialValue: initialValue),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(
      text: initialValue.toStringAsFixed(2),
    );

    return Padding(
      padding: EdgeInsets.only(
        left: Dimensions.width20,
        right: Dimensions.width20,
        top: Dimensions.height15,
        bottom: MediaQuery.of(context).viewInsets.bottom + Dimensions.height20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: Dimensions.width20 * 2,
              height: 4,
              margin: EdgeInsets.only(bottom: Dimensions.height15),
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header with title and save button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Cost Price',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: Dimensions.font16 * 1.05,
                  color: Appcolors.textPrimary,
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(
                  context,
                  double.tryParse(controller.text) ?? initialValue,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Appcolors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.width20,
                    vertical: Dimensions.height10 * 0.7,
                  ),
                ),
                child: Text(
                  'Save',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: Dimensions.font16 * 0.8,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: Dimensions.height20),

          // Label
          Text.rich(
            TextSpan(
              text: 'Enter Cost Price ',
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
          ),

          SizedBox(height: Dimensions.height10 / 2),

          // Input field with AED prefix
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFCBD5E1)),
              borderRadius: BorderRadius.circular(Dimensions.radius15 - 4),
            ),
            child: Row(
              children: [
                // Currency prefix
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.width10,
                    vertical: Dimensions.height10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(Dimensions.radius15 - 4),
                      bottomLeft: Radius.circular(Dimensions.radius15 - 4),
                    ),
                  ),
                  child: Text(
                    'AED',
                    style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w600,
                      fontSize: Dimensions.font16 * 0.85,
                    ),
                  ),
                ),

                // Text input
                Expanded(
                  child: TextField(
                    controller: controller,
                    autofocus: true,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                    ],
                    style: TextStyle(
                      fontSize: Dimensions.font16 * 0.9,
                      fontWeight: FontWeight.w500,
                      color: Appcolors.textPrimary,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: Dimensions.width10,
                        vertical: Dimensions.height10,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
