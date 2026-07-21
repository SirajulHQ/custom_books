import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/features/inventory_adjustments/model/inventory_adjustments_model.dart';
import 'package:custom_books/features/inventory_adjustments/widgets/sort_by_sheet_widget.dart';
import 'package:flutter/material.dart';

/// Icon badge widget with colored background
class IconBadge extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const IconBadge({
    super.key,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(Dimensions.radius15),
      onTap: onTap,
      child: Container(
        width: Dimensions.height45 * 0.9,
        height: Dimensions.height45 * 0.9,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(Dimensions.radius15),
        ),
        child: Icon(icon, size: Dimensions.iconSize24 - 4, color: color),
      ),
    );
  }
}

/// Search field for filtering adjustments by reason or person
class AdjustmentsSearchField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onChanged;

  const AdjustmentsSearchField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        Dimensions.width20,
        0,
        Dimensions.width20,
        Dimensions.height15,
      ),
      child: TextField(
        controller: controller,
        autofocus: true,
        onChanged: (_) => onChanged(),
        style: TextStyle(fontSize: Dimensions.font16 * 0.85),
        decoration: InputDecoration(
          hintText: 'Search by reason or person',
          hintStyle: const TextStyle(color: Colors.black26),
          prefixIcon: const Icon(Icons.search_rounded, color: Colors.black38),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(vertical: Dimensions.height10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Dimensions.radius15),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Dimensions.radius15),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Dimensions.radius15),
            borderSide: BorderSide(color: Appcolors.primary, width: 1.5),
          ),
        ),
      ),
    );
  }
}

/// Tabs and sort button widget for filtering adjustments
class AdjustmentsTabsAndSort extends StatelessWidget {
  final int selectedTab;
  final ValueChanged<int> onTabChanged;
  final AdjustmentSortField sortField;
  final SortDirection sortDirection;
  final Function(AdjustmentSortField, SortDirection) onSortChanged;

  const AdjustmentsTabsAndSort({
    super.key,
    required this.selectedTab,
    required this.onTabChanged,
    required this.sortField,
    required this.sortDirection,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    final segments = ['All', 'By Quantity', 'By Value'];

    return Padding(
      padding: EdgeInsets.fromLTRB(
        Dimensions.width20,
        0,
        Dimensions.width20,
        Dimensions.height15,
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(Dimensions.radius15),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: List.generate(segments.length, (i) {
                  final selected = i == selectedTab;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => onTabChanged(i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: EdgeInsets.symmetric(
                          vertical: Dimensions.height10,
                        ),
                        decoration: BoxDecoration(
                          color: selected
                              ? Appcolors.primary
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(
                            Dimensions.radius15 - 5,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          segments[i],
                          style: TextStyle(
                            fontSize: Dimensions.font16 * 0.72,
                            fontWeight: selected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: selected ? Colors.white : Colors.black54,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          SizedBox(width: Dimensions.width10),
          IconBadge(
            icon: Icons.swap_vert_rounded,
            color: Appcolors.primary,
            onTap: () {
              showSortBySheet(
                context,
                selectedField: sortField,
                selectedDirection: sortDirection,
                onApply: onSortChanged,
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Empty state widget when no adjustments are found
class AdjustmentsEmptyState extends StatelessWidget {
  const AdjustmentsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: Dimensions.height45 * 1.6,
              height: Dimensions.height45 * 1.6,
              decoration: BoxDecoration(
                color: Appcolors.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.inventory_2_rounded,
                size: Dimensions.iconSize24 * 1.3,
                color: Appcolors.primary,
              ),
            ),
            SizedBox(height: Dimensions.height15),
            Text(
              'No adjustments found',
              style: TextStyle(
                fontSize: Dimensions.font16,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0F172A),
              ),
            ),
            SizedBox(height: Dimensions.height10 / 2),
            Text(
              'Tap the + button to record a stock adjustment.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.75,
                color: Colors.black45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
