import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/features/payments_made/models/payment_made_model.dart';
import 'package:custom_books/core/enums/sort_direction.dart';
import 'package:flutter/material.dart';

class PaymentMadeSortSheet extends StatefulWidget {
  final PaymentMadeSortField selectedField;
  final SortDirection selectedDirection;
  final void Function(PaymentMadeSortField field, SortDirection direction)
      onApply;

  const PaymentMadeSortSheet({
    super.key,
    required this.selectedField,
    required this.selectedDirection,
    required this.onApply,
  });

  @override
  State<PaymentMadeSortSheet> createState() => _PaymentMadeSortSheetState();
}

class _PaymentMadeSortSheetState extends State<PaymentMadeSortSheet> {
  late PaymentMadeSortField _sortField;
  late SortDirection _sortDirection;

  @override
  void initState() {
    super.initState();
    _sortField = widget.selectedField;
    _sortDirection = widget.selectedDirection;
  }

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
            'Sort By',
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.95,
              fontWeight: FontWeight.w800,
              color: context.colors.textPrimary,
            ),
          ),
          SizedBox(height: Dimensions.height15),
          for (final field in PaymentMadeSortField.values)
            InkWell(
              borderRadius: BorderRadius.circular(Dimensions.radius15),
              onTap: () => setState(() => _sortField = field),
              child: Container(
                margin: EdgeInsets.only(bottom: Dimensions.height10 / 2),
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.width15,
                  vertical: Dimensions.height10,
                ),
                decoration: BoxDecoration(
                  color: _sortField == field
                      ? AppColors.primary.withValues(alpha: 0.08)
                      : context.colors.surfaceLight,
                  borderRadius: BorderRadius.circular(Dimensions.radius15),
                ),
                child: Row(
                  children: [
                    Text(
                      field.label,
                      style: TextStyle(
                        fontSize: Dimensions.font16 * 0.8,
                        fontWeight: _sortField == field
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: _sortField == field
                            ? AppColors.primary
                            : context.colors.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    if (_sortField == field)
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
          Row(
            children: [
              Expanded(child: _directionButton('Ascending', Icons.arrow_upward_rounded, SortDirection.ascending)),
              SizedBox(width: Dimensions.width10),
              Expanded(child: _directionButton('Descending', Icons.arrow_downward_rounded, SortDirection.descending)),
            ],
          ),
          SizedBox(height: Dimensions.height15),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                widget.onApply(_sortField, _sortDirection);
                Navigator.pop(context);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(
                  color: AppColors.primary,
                  width: 1.5,
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
                padding: EdgeInsets.symmetric(vertical: Dimensions.height15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimensions.radius15),
                ),
              ),
              child: const Text('Apply'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _directionButton(String label, IconData icon, SortDirection direction) {
    final selected = _sortDirection == direction;
    return InkWell(
      borderRadius: BorderRadius.circular(Dimensions.radius15),
      onTap: () => setState(() => _sortDirection = direction),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: Dimensions.height10),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withValues(alpha: 0.08)
              : context.colors.surfaceLight,
          borderRadius: BorderRadius.circular(Dimensions.radius15),
          border: selected
              ? Border.all(color: AppColors.primary.withValues(alpha: 0.4))
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: Dimensions.iconSize16,
              color: selected ? AppColors.primary : context.colors.textSecondary,
            ),
            SizedBox(width: Dimensions.width10 / 2),
            Text(
              label,
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.75,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected ? AppColors.primary : context.colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
