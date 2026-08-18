import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:flutter/material.dart';

enum InvoiceSortField {
  createdTime,
  date,
  invoiceNumber,
  customerName,
  amount,
}

extension InvoiceSortFieldLabel on InvoiceSortField {
  String get label => switch (this) {
    InvoiceSortField.createdTime => 'Created Time',
    InvoiceSortField.date => 'Date',
    InvoiceSortField.invoiceNumber => 'Invoice#',
    InvoiceSortField.customerName => 'Customer Name',
    InvoiceSortField.amount => 'Amount',
  };
}

enum SortDirection { ascending, descending }

class InvoiceSortSheet extends StatefulWidget {
  final InvoiceSortField initialField;
  final SortDirection initialDirection;
  final void Function(InvoiceSortField field, SortDirection direction) onApply;

  const InvoiceSortSheet({
    super.key,
    required this.initialField,
    required this.initialDirection,
    required this.onApply,
  });

  /// Opens the sheet and wires the apply callback for you.
  static Future<void> show(
    BuildContext context, {
    required InvoiceSortField initialField,
    required SortDirection initialDirection,
    required void Function(InvoiceSortField field, SortDirection direction)
    onApply,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => InvoiceSortSheet(
        initialField: initialField,
        initialDirection: initialDirection,
        onApply: onApply,
      ),
    );
  }

  @override
  State<InvoiceSortSheet> createState() => _InvoiceSortSheetState();
}

class _InvoiceSortSheetState extends State<InvoiceSortSheet> {
  late InvoiceSortField _field;
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
              children: InvoiceSortField.values.map((f) {
                final selected = f == _field;
                return Padding(
                  padding: EdgeInsets.only(bottom: Dimensions.height10),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(Dimensions.radius15),
                    onTap: () {
                      setState(() {
                        if (_field == f) {
                          _direction = _direction == SortDirection.ascending
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
                            ? Appcolors.primary.withValues(alpha: 0.06)
                            : context.colors.card,
                        borderRadius: BorderRadius.circular(Dimensions.radius15),
                        border: Border.all(
                          color: selected
                              ? Appcolors.primary
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
                                ? Appcolors.primary
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
                              color: Appcolors.primary,
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
              border: Border(top: BorderSide(color: context.colors.border)),
            ),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  widget.onApply(_field, _direction);
                  Navigator.pop(context);
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Appcolors.primary,
                  side: const BorderSide(color: Appcolors.primary, width: 1.5),
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