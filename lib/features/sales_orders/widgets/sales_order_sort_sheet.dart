import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/features/sales_orders/models/sales_order_model.dart';
import 'package:flutter/material.dart';

Future<void> showSalesOrderSortSheet(
  BuildContext context, {
  required SalesOrderSortField selectedField,
  required SortDirection selectedDirection,
  required void Function(SalesOrderSortField field, SortDirection direction)
  onApply,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return SalesOrderSortSheet(
        initialField: selectedField,
        initialDirection: selectedDirection,
        onApply: onApply,
      );
    },
  );
}

class SalesOrderSortSheet extends StatefulWidget {
  final SalesOrderSortField initialField;
  final SortDirection initialDirection;
  final void Function(SalesOrderSortField, SortDirection) onApply;

  const SalesOrderSortSheet({
    super.key,
    required this.initialField,
    required this.initialDirection,
    required this.onApply,
  });

  @override
  State<SalesOrderSortSheet> createState() => _SalesOrderSortSheetState();
}

class _SalesOrderSortSheetState extends State<SalesOrderSortSheet> {
  late SalesOrderSortField _field;
  late SortDirection _direction;

  @override
  void initState() {
    super.initState();
    _field = widget.initialField;
    _direction = widget.initialDirection;
  }

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);
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
                  'Sort by',
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
          // Radio Options List
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
            child: Column(
              children: SalesOrderSortField.values.map((field) {
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
                              field.label,
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
                              children: [
                                Text(
                                  _direction == SortDirection.ascending
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
                                  _direction == SortDirection.ascending
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
          // Info banner
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
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sort Selected',
                        style: TextStyle(
                          fontSize: Dimensions.font16 * 0.65,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${_field.label} (${_direction == SortDirection.ascending ? 'Ascending' : 'Descending'})',
                        style: TextStyle(
                          fontSize: Dimensions.font16 * 0.85,
                          fontWeight: FontWeight.w700,
                          color: context.colors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: Dimensions.width15),
                OutlinedButton(
                  onPressed: () {
                    widget.onApply(_field, _direction);
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(
                      color: AppColors.primary,
                      width: 1.5,
                    ),
                    backgroundColor: Colors.transparent,
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
