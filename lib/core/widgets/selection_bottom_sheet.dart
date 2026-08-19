import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:flutter/material.dart';

class SelectionBottomSheet<T> extends StatelessWidget {
  final String title;
  final List<T> items;
  final T? selectedItem;
  final String Function(T item) labelBuilder;
  final Widget Function(T item)? leadingBuilder;
  final VoidCallback? onAddNew;
  final String? addNewLabel;

  const SelectionBottomSheet({
    super.key,
    required this.title,
    required this.items,
    required this.labelBuilder,
    this.selectedItem,
    this.leadingBuilder,
    this.onAddNew,
    this.addNewLabel,
  });

  /// Shows the bottom sheet and returns the selected item, or null if dismissed.
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required List<T> items,
    required String Function(T item) labelBuilder,
    T? selectedItem,
    Widget Function(T item)? leadingBuilder,
    VoidCallback? onAddNew,
    String? addNewLabel,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      showDragHandle: true,
      backgroundColor: context.colors.card,
      builder: (context) => SelectionBottomSheet<T>(
        title: title,
        items: items,
        selectedItem: selectedItem,
        labelBuilder: labelBuilder,
        leadingBuilder: leadingBuilder,
        onAddNew: onAddNew,
        addNewLabel: addNewLabel,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
                    fontSize: Dimensions.font16 * 1.1,
                    fontWeight: FontWeight.w700,
                    color: context.colors.textPrimary,
                  ),
                ),
                if (onAddNew != null)
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline_rounded),
                    color: AppColors.primary,
                    onPressed: onAddNew,
                  ),
              ],
            ),
          ),
          const Divider(height: 1),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: [
                ...items.map((item) {
                  final label = labelBuilder(item);
                  final isSelected = item == selectedItem;
                  return ListTile(
                    leading: leadingBuilder?.call(item) ??
                        CircleAvatar(
                          backgroundColor:
                              AppColors.primary.withValues(alpha: 0.1),
                          child: Text(
                            label.isNotEmpty
                                ? label.substring(0, 1).toUpperCase()
                                : '?',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    title: Text(
                      label,
                      style: TextStyle(
                        color: isSelected
                            ? AppColors.primary
                            : context.colors.textPrimary,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    trailing: isSelected
                        ? Icon(Icons.check_rounded, color: AppColors.primary)
                        : null,
                    onTap: () => Navigator.pop(context, item),
                  );
                }),
                if (onAddNew != null && addNewLabel != null)
                  ListTile(
                    leading:
                        const Icon(Icons.add_rounded, color: AppColors.primary),
                    title: Text(addNewLabel!),
                    onTap: onAddNew,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
