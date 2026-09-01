import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/features/recurring_invoices/models/recurring_invoice_model.dart';
import 'package:custom_books/core/enums/sort_direction.dart';
import 'package:flutter/material.dart';

class RecurringInvoiceSortSheet extends StatefulWidget {
  final RecurringInvoiceSortField selectedField;
  final SortDirection selectedDirection;
  final void Function(RecurringInvoiceSortField field, SortDirection direction)
      onApply;

  const RecurringInvoiceSortSheet({
    super.key,
    required this.selectedField,
    required this.selectedDirection,
    required this.onApply,
  });

  @override
  State<RecurringInvoiceSortSheet> createState() =>
      _RecurringInvoiceSortSheetState();
}

class _RecurringInvoiceSortSheetState extends State<RecurringInvoiceSortSheet> {
  late RecurringInvoiceSortField _field;
  late SortDirection _direction;

  @override
  void initState() {
    super.initState();
    _field = widget.selectedField;
    _direction = widget.selectedDirection;
  }

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
          Container(
            width: Dimensions.width20 * 2,
            height: Dimensions.height10 * 0.4,
            margin: EdgeInsets.symmetric(vertical: Dimensions.height10),
            decoration: BoxDecoration(
              color: context.colors.border,
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
                      borderRadius:
                          BorderRadius.circular(Dimensions.radius15),
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
            child: Column(
              children: RecurringInvoiceSortField.values.map((f) {
                final selected = f == _field;
                return Padding(
                  padding: EdgeInsets.only(bottom: Dimensions.height10),
                  child: InkWell(
                    borderRadius:
                        BorderRadius.circular(Dimensions.radius15),
                    onTap: () {
                      setState(() {
                        if (_field == f) {
                          _direction =
                              _direction == SortDirection.ascending
                                  ? SortDirection.descending
                                  : SortDirection.ascending;
                        } else {
                          _field = f;
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
                        borderRadius:
                            BorderRadius.circular(Dimensions.radius15),
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
                              f.label,
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
                            Icon(
                              _direction == SortDirection.ascending
                                  ? Icons.arrow_upward_rounded
                                  : Icons.arrow_downward_rounded,
                              size: Dimensions.iconSize16,
                              color: AppColors.primary,
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
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
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: context.colors.border),
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton(
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
                    vertical: Dimensions.height15 * 0.9,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(Dimensions.radius15),
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
            ),
          ),
        ],
      ),
    );
  }
}
