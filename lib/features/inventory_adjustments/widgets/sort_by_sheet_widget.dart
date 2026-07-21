import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/features/inventory_adjustments/model/inventory_adjustments_model.dart';
import 'package:flutter/material.dart';

Future<void> showSortBySheet(
  BuildContext context, {
  required AdjustmentSortField selectedField,
  required SortDirection selectedDirection,
  required void Function(AdjustmentSortField field, SortDirection direction)
      onApply,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return _SortBySheet(
        initialField: selectedField,
        initialDirection: selectedDirection,
        onApply: onApply,
      );
    },
  );
}

class _SortBySheet extends StatefulWidget {
  final AdjustmentSortField initialField;
  final SortDirection initialDirection;
  final void Function(AdjustmentSortField, SortDirection) onApply;

  const _SortBySheet({
    required this.initialField,
    required this.initialDirection,
    required this.onApply,
  });

  @override
  State<_SortBySheet> createState() => _SortBySheetState();
}

class _SortBySheetState extends State<_SortBySheet> {
  late AdjustmentSortField _field;
  late SortDirection _direction;

  @override
  void initState() {
    super.initState();
    _field = widget.initialField;
    _direction = widget.initialDirection;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: EdgeInsets.symmetric(vertical: Dimensions.height10),
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(Dimensions.radius30),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Sort by',
                  style: TextStyle(
                    fontSize: Dimensions.font20,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(Dimensions.radius15),
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: EdgeInsets.all(Dimensions.width10 * 0.6),
                    decoration: BoxDecoration(
                      color: Appcolors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(Dimensions.radius15),
                    ),
                    child: Icon(
                      Icons.close_rounded,
                      size: Dimensions.iconSize16,
                      color: Appcolors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: Dimensions.height15),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
            child: Column(
              children: AdjustmentSortField.values.map((field) {
                final selected = field == _field;
                return Padding(
                  padding: EdgeInsets.only(bottom: Dimensions.height10),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(Dimensions.radius15),
                    onTap: () {
                      setState(() {
                        if (_field == field) {
                          _direction = _direction == SortDirection.ascending
                              ? SortDirection.descending
                              : SortDirection.ascending;
                        } else {
                          _field = field;
                          _direction = SortDirection.descending;
                        }
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.width15,
                        vertical: Dimensions.height15 * 0.75,
                      ),
                      decoration: BoxDecoration(
                        color: selected
                            ? Appcolors.primary.withValues(alpha: 0.06)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(Dimensions.radius15),
                        border: Border.all(
                          color: selected
                              ? Appcolors.primary
                              : const Color(0xFFE2E8F0),
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
                            color: selected ? Appcolors.primary : Colors.black26,
                          ),
                          SizedBox(width: Dimensions.width10),
                          Expanded(
                            child: Text(
                              field.label,
                              style: TextStyle(
                                fontSize: Dimensions.font16 * 0.9,
                                fontWeight:
                                    selected ? FontWeight.w700 : FontWeight.w500,
                                color: const Color(0xFF0F172A),
                              ),
                            ),
                          ),
                          if (selected)
                            Row(
                              children: [
                                Text(
                                  _direction == SortDirection.ascending
                                      ? 'Ascending'
                                      : 'Descending',
                                  style: TextStyle(
                                    fontSize: Dimensions.font16 * 0.75,
                                    fontWeight: FontWeight.w600,
                                    color: Appcolors.primary,
                                  ),
                                ),
                                SizedBox(width: Dimensions.width10 / 2),
                                Icon(
                                  _direction == SortDirection.ascending
                                      ? Icons.arrow_upward_rounded
                                      : Icons.arrow_downward_rounded,
                                  size: Dimensions.iconSize16,
                                  color: Appcolors.primary,
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
            child: Container(
              padding: EdgeInsets.all(Dimensions.width15 * 0.8),
              decoration: BoxDecoration(
                color: Appcolors.accent.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(Dimensions.radius15),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: Dimensions.iconSize16,
                    color: Appcolors.accent,
                  ),
                  SizedBox(width: Dimensions.width10),
                  Expanded(
                    child: Text(
                      'Tap a selection again to switch between ascending and descending order.',
                      style: TextStyle(
                        fontSize: Dimensions.font16 * 0.7,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: Dimensions.height15),
          Container(
            padding: EdgeInsets.fromLTRB(
              Dimensions.width20,
              Dimensions.height15,
              Dimensions.width20,
              Dimensions.height20,
            ),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SORT SELECTED',
                        style: TextStyle(
                          fontSize: Dimensions.font16 * 0.6,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                          color: Appcolors.primary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${_field.label} (${_direction == SortDirection.ascending ? 'Ascending' : 'Descending'})',
                        style: TextStyle(
                          fontSize: Dimensions.font16 * 0.85,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: Dimensions.width15),
                ElevatedButton(
                  onPressed: () {
                    widget.onApply(_field, _direction);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Appcolors.primary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.width20 * 1.2,
                      vertical: Dimensions.height15 * 0.8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Dimensions.radius15),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Sort',
                    style: TextStyle(
                      fontSize: Dimensions.font16 * 0.9,
                      fontWeight: FontWeight.w700,
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