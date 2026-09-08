import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/widgets/bottom_sheet_drag_handle.dart';
import 'package:custom_books/core/widgets/bottom_sheet_header.dart';
import 'package:flutter/material.dart';

enum FilterOptionStyle { border, card, radio }

class FilterSheet<T> extends StatelessWidget {
  final String title;
  final List<T?> options;
  final T? selectedValue;
  final String Function(T?) labelBuilder;
  final IconData? Function(T?)? iconBuilder;
  final ValueChanged<T?> onSelected;
  final VoidCallback? onClose;
  final String? sectionLabel;
  final FilterOptionStyle style;
  final bool compact;
  final bool showHeaderBorder;
  final bool? showDragHandle;

  const FilterSheet({
    super.key,
    required this.title,
    required this.options,
    required this.selectedValue,
    required this.labelBuilder,
    required this.onSelected,
    this.iconBuilder,
    this.onClose,
    this.sectionLabel,
    this.style = FilterOptionStyle.border,
    this.compact = false,
    this.showHeaderBorder = false,
    this.showDragHandle,
  });

  void _close(BuildContext context) {
    if (onClose != null) {
      onClose!();
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return _CompactLayout<T>(sheet: this);
    }
    return _BottomSheetLayout<T>(sheet: this);
  }
}

// ---------------------------------------------------------------------------
// _BottomSheetLayout  (standard — SafeArea + top-rounded container)
// ---------------------------------------------------------------------------
class _BottomSheetLayout<T> extends StatelessWidget {
  final FilterSheet<T> sheet;
  const _BottomSheetLayout({required this.sheet});

  @override
  Widget build(BuildContext context) {
    final showHandle = sheet.showDragHandle ?? !sheet.showHeaderBorder;

    return SafeArea(
      top: false,
      child: Container(
        decoration: BoxDecoration(
          color: context.colors.card,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(Dimensions.radius20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            if (showHandle) const BottomSheetDragHandle(),
            // Header row
            BottomSheetHeader(
              title: sheet.title,
              onClose: () => sheet._close(context),
              showBorder: sheet.showHeaderBorder,
            ),
            // Optional section label
            if (sheet.sectionLabel != null)
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(
                  Dimensions.width20,
                  Dimensions.height10,
                  Dimensions.width20,
                  Dimensions.height10,
                ),
                child: Text(
                  sheet.sectionLabel!,
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.7,
                    fontWeight: FontWeight.w600,
                    color: context.colors.textTertiary,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            // Options list
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(
                  Dimensions.width20,
                  Dimensions.height10,
                  Dimensions.width20,
                  Dimensions.height20,
                ),
                itemCount: sheet.options.length,
                itemBuilder: (context, index) {
                  final item = sheet.options[index];
                  return FilterOptionTile(
                    label: sheet.labelBuilder(item),
                    icon: sheet.iconBuilder?.call(item),
                    isSelected: item == sheet.selectedValue,
                    style: sheet.style,
                    onTap: () {
                      sheet.onSelected(item);
                      if (sheet.onClose == null) Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _CompactLayout  (floating card — margin + full border-radius)
// ---------------------------------------------------------------------------
class _CompactLayout<T> extends StatelessWidget {
  final FilterSheet<T> sheet;
  const _CompactLayout({required this.sheet});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(Dimensions.width15),
        child: Container(
          padding: EdgeInsets.all(Dimensions.width20),
          decoration: BoxDecoration(
            color: context.colors.card,
            borderRadius: BorderRadius.circular(Dimensions.radius20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                sheet.title,
                style: TextStyle(
                  fontSize: Dimensions.font16 * 0.95,
                  fontWeight: FontWeight.w800,
                  color: context.colors.textPrimary,
                ),
              ),
              SizedBox(height: Dimensions.height15),
              for (final item in sheet.options)
                FilterOptionTile(
                  label: sheet.labelBuilder(item),
                  icon: sheet.iconBuilder?.call(item),
                  isSelected: item == sheet.selectedValue,
                  style: sheet.style,
                  onTap: () {
                    sheet.onSelected(item);
                    if (sheet.onClose == null) Navigator.pop(context);
                  },
                ),
              SizedBox(height: Dimensions.height10),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// FilterOptionTile
// ---------------------------------------------------------------------------
/// A single selectable option row used inside filter sheets.
///
/// Three visual styles match the three distinct [_FilterOption] implementations
/// found across the codebase, so each sheet renders identically after migration.
class FilterOptionTile extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback onTap;
  final FilterOptionStyle style;

  const FilterOptionTile({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.icon,
    this.style = FilterOptionStyle.border,
  });

  @override
  Widget build(BuildContext context) {
    switch (style) {
      case FilterOptionStyle.border:
        return _BorderOption(
          label: label,
          isSelected: isSelected,
          onTap: onTap,
        );
      case FilterOptionStyle.card:
        return _CardOption(label: label, isSelected: isSelected, onTap: onTap);
      case FilterOptionStyle.radio:
        return _RadioOption(
          label: label,
          icon: icon,
          isSelected: isSelected,
          onTap: onTap,
        );
    }
  }
}

// -- Border style (check_circle_rounded, transparent/primary fill) --
class _BorderOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const _BorderOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: Dimensions.height10),
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.width15,
          vertical: Dimensions.height15,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.05)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(Dimensions.radius15),
          border: Border.all(
            color: isSelected ? AppColors.primary : context.colors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: Dimensions.font16,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? AppColors.primary
                    : context.colors.textPrimary,
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle_rounded,
                color: AppColors.primary,
                size: Dimensions.iconSize24,
              ),
          ],
        ),
      ),
    );
  }
}

// -- Card style (surfaceLight fill, small check_rounded) --
class _CardOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const _CardOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(Dimensions.radius15),
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: Dimensions.height10 / 2),
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.width15,
          vertical: Dimensions.height10,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.08)
              : context.colors.surfaceLight,
          borderRadius: BorderRadius.circular(Dimensions.radius15),
          border: isSelected
              ? Border.all(color: AppColors.primary.withValues(alpha: 0.4))
              : null,
        ),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.8,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? AppColors.primary
                    : context.colors.textPrimary,
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(
                Icons.check_rounded,
                size: Dimensions.iconSize16,
                color: AppColors.primary,
              ),
          ],
        ),
      ),
    );
  }
}

// -- Radio style (radio icon prefix) --
class _RadioOption extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback onTap;
  const _RadioOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(Dimensions.radius15),
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: Dimensions.height10 / 2),
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.width15,
          vertical: Dimensions.height10,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.08)
              : context.colors.surfaceLight,
          borderRadius: BorderRadius.circular(Dimensions.radius15),
          border: Border.all(
            color: isSelected ? AppColors.primary : context.colors.border,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_off_rounded,
              size: Dimensions.iconSize16 + 2,
              color: isSelected
                  ? AppColors.primary
                  : context.colors.textTertiary,
            ),
            SizedBox(width: Dimensions.width10),
            if (icon != null) ...[
              Icon(
                icon,
                size: Dimensions.iconSize16,
                color: isSelected
                    ? AppColors.primary
                    : context.colors.textSecondary,
              ),
              SizedBox(width: Dimensions.width10 / 2),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.8,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: context.colors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
