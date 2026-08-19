import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/image_helper.dart';
import 'package:custom_books/features/items/models/item_model.dart';
import 'package:flutter/material.dart';

class ItemCardWidget extends StatelessWidget {
  final ItemModel item;

  const ItemCardWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Dimensions.width15),
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: BorderRadius.circular(Dimensions.radius20),
        border: Border.all(color: context.colors.border, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Item image/placeholder
          Container(
            width: Dimensions.height45 * 1.6,
            height: Dimensions.height45 * 1.6,
            decoration: BoxDecoration(
              color: context.colors.surfaceLight,
              borderRadius: BorderRadius.circular(Dimensions.radius15),
            ),
            child: item.imageUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(Dimensions.radius15),
                    child: ImageHelper.buildImage(
                      item.imageUrl!,
                      fit: BoxFit.cover,
                      errorWidget: _buildPlaceholderIcon(context),
                    ),
                  )
                : _buildPlaceholderIcon(context),
          ),

          SizedBox(width: Dimensions.width15),

          // Item details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Item name
                Text(
                  item.name,
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 1.1,
                    fontWeight: FontWeight.w800,
                    color: context.colors.textPrimary,
                  ),
                ),

                // SKU (if available)
                if (item.sku != null) ...[
                  SizedBox(height: Dimensions.height10 / 3),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.width10,
                      vertical: Dimensions.height10 / 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(
                        Dimensions.radius15 / 2,
                      ),
                    ),
                    child: Text(
                      'SKU: ${item.sku}',
                      style: TextStyle(
                        fontSize: Dimensions.font16 * 0.7,
                        fontWeight: FontWeight.w600,
                        color: AppColors.accent,
                      ),
                    ),
                  ),
                ],

                SizedBox(height: Dimensions.height10),

                // Price row
                Row(
                  children: [
                    // Sales Price
                    Expanded(
                      child: _buildPriceBox(
                        context,
                        'Sales',
                        '₹${item.salesPrice.toStringAsFixed(2)}',
                        AppColors.ok,
                        Icons.call_made_rounded,
                      ),
                    ),
                    SizedBox(width: Dimensions.width10),
                    // Purchase Price
                    Expanded(
                      child: _buildPriceBox(
                        context,
                        'Purchase',
                        '₹${item.purchasePrice.toStringAsFixed(2)}',
                        AppColors.primary,
                        Icons.call_received_rounded,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: Dimensions.height10),

                // Profit/Loss
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.width10,
                    vertical: Dimensions.height10 / 2,
                  ),
                  decoration: BoxDecoration(
                    color: item.profit >= 0
                        ? AppColors.success.withValues(alpha: 0.1)
                        : AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(
                      Dimensions.radius15 / 2,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        item.profit >= 0
                            ? Icons.trending_up_rounded
                            : Icons.trending_down_rounded,
                        size: Dimensions.iconSize16 * 0.9,
                        color: item.profit >= 0
                            ? AppColors.success
                            : AppColors.error,
                      ),
                      SizedBox(width: Dimensions.width10 / 3),
                      Text(
                        '${item.profit >= 0 ? '+' : ''}${item.profitDisplay}',
                        style: TextStyle(
                          fontSize: Dimensions.font16 * 0.85,
                          fontWeight: FontWeight.w700,
                          color: item.profit >= 0
                              ? AppColors.success
                              : AppColors.error,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderIcon(BuildContext context) {
    return Icon(
      Icons.image_outlined,
      size: Dimensions.iconSize24 * 1.5,
      color: context.colors.textTertiary,
    );
  }

  Widget _buildPriceBox(
    BuildContext context,
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: EdgeInsets.all(Dimensions.width10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(Dimensions.radius15 / 2),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: Dimensions.iconSize16 * 0.8, color: color),
              SizedBox(width: Dimensions.width10 / 3),
              Text(
                label,
                style: TextStyle(
                  fontSize: Dimensions.font16 * 0.65,
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: Dimensions.height10 / 3),
          Text(
            value,
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.85,
              fontWeight: FontWeight.w700,
              color: context.colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
