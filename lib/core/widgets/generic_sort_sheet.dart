import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/enums/sort_direction.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:flutter/material.dart';

class GenericSortSheet<F> extends StatefulWidget {
  final List<F> fields;
  final F initialField;
  final SortDirection initialDirection;
  final String Function(F) labelBuilder;
  final void Function(F field, SortDirection direction) onApply;
  final String title;
  final String buttonLabel;
  final bool showInfoBanner;
  final bool compact;

  const GenericSortSheet({
    super.key,
    required this.fields,
    required this.initialField,
    required this.initialDirection,
    required this.labelBuilder,
    required this.onApply,
    this.title = 'Sort by',
    this.buttonLabel = 'Sort',
    this.showInfoBanner = false,
    this.compact = false,
  });

  /// Opens the sheet via [showModalBottomSheet] and wires the apply callback.
  static Future<void> show<F>(
    BuildContext context, {
    required List<F> fields,
    required F initialField,
    required SortDirection initialDirection,
    required String Function(F) labelBuilder,
    required void Function(F field, SortDirection direction) onApply,
    String title = 'Sort by',
    String buttonLabel = 'Sort',
    bool showInfoBanner = false,
    bool compact = false,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => GenericSortSheet<F>(
        fields: fields,
        initialField: initialField,
        initialDirection: initialDirection,
        labelBuilder: labelBuilder,
        onApply: onApply,
        title: title,
        buttonLabel: buttonLabel,
        showInfoBanner: showInfoBanner,
        compact: compact,
      ),
    );
  }

  @override
  State<GenericSortSheet<F>> createState() => _GenericSortSheetState<F>();
}

class _GenericSortSheetState<F> extends State<GenericSortSheet<F>> {
  late F _field;
  late SortDirection _direction;

  @override
  void initState() {
    super.initState();
    _field = widget.initialField;
    _direction = widget.initialDirection;
  }

  void _handleTap(F tapped) {
    setState(() {
      if (_field == tapped) {
        // Toggle direction on the already-selected field
        _direction = _direction == SortDirection.ascending
            ? SortDirection.descending
            : SortDirection.ascending;
      } else {
        _field = tapped;
        _direction = SortDirection.descending;
      }
    });
  }

  /// Used by [_CompactLayout] to select a field without toggling direction.
  void selectField(F field) {
    setState(() => _field = field);
  }

  /// Used by [_CompactLayout] to change the sort direction independently.
  void selectDirection(SortDirection direction) {
    setState(() => _direction = direction);
  }

  void _apply() {
    widget.onApply(_field, _direction);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return widget.compact
        ? _CompactLayout<F>(sheet: widget, state: this)
        : _BottomSheetLayout<F>(sheet: widget, state: this);
  }
}

// ---------------------------------------------------------------------------
// Gen 2 — Standard bottom-sheet layout
// ---------------------------------------------------------------------------
class _BottomSheetLayout<F> extends StatelessWidget {
  final GenericSortSheet<F> sheet;
  final _GenericSortSheetState<F> state;

  const _BottomSheetLayout({required this.sheet, required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Dimensions.radius20 * 1.2),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: Dimensions.width20 * 2,
            height: Dimensions.height10 * 0.4,
            margin: EdgeInsets.symmetric(vertical: Dimensions.height10),
            decoration: BoxDecoration(
              color: context.colors.border,
              borderRadius: BorderRadius.circular(Dimensions.radius30),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  sheet.title,
                  style: TextStyle(
                    fontSize: Dimensions.font20,
                    fontWeight: FontWeight.w800,
                    color: context.colors.textPrimary,
                  ),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(Dimensions.radius15),
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: EdgeInsets.all(Dimensions.width10 * 0.6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(Dimensions.radius15),
                    ),
                    child: Icon(
                      Icons.close_rounded,
                      size: Dimensions.iconSize16,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: Dimensions.height15),

          // Field radio list
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
            child: Column(
              children: sheet.fields.map((f) {
                final selected = f == state._field;
                return Padding(
                  padding: EdgeInsets.only(bottom: Dimensions.height10),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(Dimensions.radius15),
                    onTap: () => state._handleTap(f),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.width15,
                        vertical: Dimensions.height15 * 0.75,
                      ),
                      decoration: BoxDecoration(
                        color: selected
                            ? AppColors.primary.withValues(alpha: 0.06)
                            : context.colors.card,
                        borderRadius: BorderRadius.circular(
                          Dimensions.radius15,
                        ),
                        border: Border.all(
                          color: selected
                              ? AppColors.primary
                              : context.colors.border,
                          width: selected ? 1.5 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            selected
                                ? Icons.radio_button_checked_rounded
                                : Icons.radio_button_off_rounded,
                            size: Dimensions.iconSize24 - 4,
                            color: selected
                                ? AppColors.primary
                                : context.colors.textTertiary,
                          ),
                          SizedBox(width: Dimensions.width10),
                          Expanded(
                            child: Text(
                              sheet.labelBuilder(f),
                              style: TextStyle(
                                fontSize: Dimensions.font16 * 0.9,
                                fontWeight: selected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: context.colors.textPrimary,
                              ),
                            ),
                          ),
                          if (selected)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  state._direction == SortDirection.ascending
                                      ? 'Ascending'
                                      : 'Descending',
                                  style: TextStyle(
                                    fontSize: Dimensions.font16 * 0.75,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                                SizedBox(width: Dimensions.width10 / 2),
                                Icon(
                                  state._direction == SortDirection.ascending
                                      ? Icons.arrow_upward_rounded
                                      : Icons.arrow_downward_rounded,
                                  size: Dimensions.iconSize16,
                                  color: AppColors.primary,
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Optional info banner
          if (sheet.showInfoBanner)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
              child: Container(
                padding: EdgeInsets.all(Dimensions.width15 * 0.8),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(Dimensions.radius15),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: Dimensions.iconSize16,
                      color: AppColors.accent,
                    ),
                    SizedBox(width: Dimensions.width10),
                    Expanded(
                      child: Text(
                        'Tap on selection to change from ascending to descending and vice versa',
                        style: TextStyle(
                          fontSize: Dimensions.font16 * 0.7,
                          color: context.colors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          SizedBox(height: Dimensions.height15),

          // Footer
          Container(
            padding: EdgeInsets.fromLTRB(
              Dimensions.width20,
              Dimensions.height15,
              Dimensions.width20,
              Dimensions.height20,
            ),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: context.colors.border)),
            ),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: state._apply,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary, width: 1.5),
                  backgroundColor: Colors.transparent,
                  padding: EdgeInsets.symmetric(
                    vertical: Dimensions.height15 * 0.9,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Dimensions.radius15),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  sheet.buttonLabel,
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Gen 1 — Compact floating-card layout (compact: true)
// ---------------------------------------------------------------------------
class _CompactLayout<F> extends StatelessWidget {
  final GenericSortSheet<F> sheet;
  final _GenericSortSheetState<F> state;

  const _CompactLayout({required this.sheet, required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(Dimensions.width15),
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

          // Field list
          for (final field in sheet.fields)
            InkWell(
              borderRadius: BorderRadius.circular(Dimensions.radius15),
              onTap: () => state.selectField(field),
              child: Container(
                margin: EdgeInsets.only(bottom: Dimensions.height10 / 2),
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.width15,
                  vertical: Dimensions.height10,
                ),
                decoration: BoxDecoration(
                  color: state._field == field
                      ? AppColors.primary.withValues(alpha: 0.08)
                      : context.colors.surfaceLight,
                  borderRadius: BorderRadius.circular(Dimensions.radius15),
                ),
                child: Row(
                  children: [
                    Text(
                      sheet.labelBuilder(field),
                      style: TextStyle(
                        fontSize: Dimensions.font16 * 0.8,
                        fontWeight: state._field == field
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: state._field == field
                            ? AppColors.primary
                            : context.colors.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    if (state._field == field)
                      Icon(
                        Icons.check_rounded,
                        size: Dimensions.iconSize16,
                        color: AppColors.primary,
                      ),
                  ],
                ),
              ),
            ),

          SizedBox(height: Dimensions.height10),

          // Ascending / Descending toggle buttons
          Row(
            children: [
              Expanded(
                child: _SortDirectionButton(
                  label: 'Ascending',
                  icon: Icons.arrow_upward_rounded,
                  isSelected: state._direction == SortDirection.ascending,
                  onTap: () => state.selectDirection(SortDirection.ascending),
                ),
              ),
              SizedBox(width: Dimensions.width10),
              Expanded(
                child: _SortDirectionButton(
                  label: 'Descending',
                  icon: Icons.arrow_downward_rounded,
                  isSelected: state._direction == SortDirection.descending,
                  onTap: () => state.selectDirection(SortDirection.descending),
                ),
              ),
            ],
          ),

          SizedBox(height: Dimensions.height15),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: state._apply,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary, width: 1.5),
                backgroundColor: Colors.transparent,
                elevation: 0,
                padding: EdgeInsets.symmetric(vertical: Dimensions.height15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimensions.radius15),
                ),
              ),
              child: Text(sheet.buttonLabel),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shared ascending / descending toggle button (used by compact layout)
// ---------------------------------------------------------------------------
class _SortDirectionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _SortDirectionButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(Dimensions.radius15),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: Dimensions.height10),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: Dimensions.iconSize16,
              color: isSelected
                  ? AppColors.primary
                  : context.colors.textSecondary,
            ),
            SizedBox(width: Dimensions.width10 / 2),
            Text(
              label,
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.75,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? AppColors.primary
                    : context.colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
