import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/image_helper.dart';
import 'package:flutter/material.dart';

class ItemThumbnail extends StatelessWidget {
  final String? imageUrl;
  final double? size;

  const ItemThumbnail({super.key, this.imageUrl, this.size});

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);
    final thumbnailSize = size ?? (Dimensions.height45 * 0.9);

    final fallback = Icon(
      Icons.inventory_2_outlined,
      color: AppColors.primary,
      size: Dimensions.iconSize24 * 0.75,
    );

    return Container(
      width: thumbnailSize,
      height: thumbnailSize,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(Dimensions.radius15 * 0.73),
      ),
      clipBehavior: Clip.antiAlias,
      child: imageUrl != null
          ? ImageHelper.buildImage(
              imageUrl!,
              fit: BoxFit.cover,
              errorWidget: fallback,
            )
          : fallback,
    );
  }
}

/// Item search field with suggestion dropdown
class ItemSearchField<T> extends StatelessWidget {
  final TextEditingController controller;
  final bool isItemSelected;
  final List<T> suggestions;
  final Widget Function(T item) suggestionBuilder;
  final VoidCallback onClear;
  final VoidCallback? onBarcodeScan;
  final void Function(String) onChanged;
  final String? selectedItemImageUrl;

  const ItemSearchField({
    super.key,
    required this.controller,
    required this.isItemSelected,
    required this.suggestions,
    required this.suggestionBuilder,
    required this.onClear,
    this.onBarcodeScan,
    required this.onChanged,
    this.selectedItemImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                readOnly: isItemSelected,
                onChanged: onChanged,
                style: TextStyle(
                  fontSize: Dimensions.font16 * 0.85,
                  fontWeight: FontWeight.w600,
                  color: context.colors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'Start typing to select an Item',
                  hintStyle: TextStyle(color: context.colors.textTertiary),
                  border: InputBorder.none,
                  isDense: true,
                  suffixIcon: isItemSelected
                      ? IconButton(
                          icon: Icon(
                            Icons.close_rounded,
                            color: context.colors.textTertiary,
                          ),
                          onPressed: onClear,
                        )
                      : onBarcodeScan != null
                      ? IconButton(
                          icon: Icon(
                            Icons.qr_code_scanner_rounded,
                            color: context.colors.textSecondary,
                            size: Dimensions.iconSize20,
                          ),
                          onPressed: onBarcodeScan,
                        )
                      : null,
                ),
              ),
            ),
            if (isItemSelected) ...[
              SizedBox(width: Dimensions.width10),
              ItemThumbnail(imageUrl: selectedItemImageUrl),
            ],
          ],
        ),
        if (suggestions.isNotEmpty) ...[
          Divider(color: context.colors.border, height: Dimensions.height20),
          ...suggestions.map((item) => suggestionBuilder(item)),
        ],
      ],
    );
  }
}
