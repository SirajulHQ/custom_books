import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:flutter/material.dart';

/// A single animated pill-shaped tab button used inside [ListControlBar].
class PillTabButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const PillTabButton({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: EdgeInsets.symmetric(vertical: Dimensions.height10),
          decoration: BoxDecoration(
            color: selected ? context.colors.card : Colors.transparent,
            borderRadius: BorderRadius.circular(Dimensions.radius30),
            border: selected
                ? Border.all(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    width: 1.5,
                  )
                : null,
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      blurRadius: Dimensions.radius15 * 0.53,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.72,
              fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
              color:
                  selected ? AppColors.primary : context.colors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

/// A square icon badge used for filter and sort controls in [ListControlBar].
class ControlBadge extends StatelessWidget {
  final IconData icon;
  final bool active;

  const ControlBadge({
    super.key,
    required this.icon,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Dimensions.height45 * 0.9,
      height: Dimensions.height45 * 0.9,
      decoration: BoxDecoration(
        color: (active ? AppColors.accent : AppColors.primary)
            .withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(Dimensions.radius15),
      ),
      child: Icon(
        icon,
        size: Dimensions.iconSize24 - 4,
        color: active ? AppColors.accent : AppColors.primary,
      ),
    );
  }
}

/// The full horizontal control bar used on every list page:
/// a pill-tray of [tabs] on the left, and filter + sort [ControlBadge]s on
/// the right.
///
/// [filterActive] drives the filter badge's active (accent) state and which
/// filter icon is shown.
class ListControlBar extends StatelessWidget {
  final List<String> tabs;
  final int selectedTab;
  final ValueChanged<int> onTabSelected;
  final bool filterActive;
  final VoidCallback onFilterTap;
  final VoidCallback onSortTap;

  const ListControlBar({
    super.key,
    required this.tabs,
    required this.selectedTab,
    required this.onTabSelected,
    required this.filterActive,
    required this.onFilterTap,
    required this.onSortTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        Dimensions.width20,
        Dimensions.height10 / 2,
        Dimensions.width20,
        Dimensions.height15,
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(Dimensions.height10 * 0.4),
              decoration: BoxDecoration(
                color: context.colors.surfaceLight,
                borderRadius: BorderRadius.circular(Dimensions.radius30),
              ),
              child: Row(
                children: [
                  for (int i = 0; i < tabs.length; i++)
                    PillTabButton(
                      label: tabs[i],
                      selected: selectedTab == i,
                      onTap: () => onTabSelected(i),
                    ),
                ],
              ),
            ),
          ),
          SizedBox(width: Dimensions.width10),
          InkWell(
            borderRadius: BorderRadius.circular(Dimensions.radius15),
            onTap: onFilterTap,
            child: ControlBadge(
              icon: filterActive
                  ? Icons.filter_alt_rounded
                  : Icons.filter_list_rounded,
              active: filterActive,
            ),
          ),
          SizedBox(width: Dimensions.width10 / 2),
          InkWell(
            borderRadius: BorderRadius.circular(Dimensions.radius15),
            onTap: onSortTap,
            child: const ControlBadge(icon: Icons.swap_vert_rounded),
          ),
        ],
      ),
    );
  }
}
