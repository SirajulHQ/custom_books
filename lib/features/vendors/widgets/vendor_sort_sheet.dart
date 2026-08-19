import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/features/vendors/models/vendor_model.dart';
import 'package:flutter/material.dart';

class VendorSortSheet extends StatefulWidget {
  final VendorsSortField selectedField;
  final SortDirection selectedDirection;
  final void Function(VendorsSortField field, SortDirection direction) onApply;

  const VendorSortSheet({
    super.key,
    required this.selectedField,
    required this.selectedDirection,
    required this.onApply,
  });

  @override
  State<VendorSortSheet> createState() => _VendorSortSheetState();
}

class _VendorSortSheetState extends State<VendorSortSheet> {
  late VendorsSortField _sortField;
  late SortDirection _sortDirection;

  @override
  void initState() {
    super.initState();
    _sortField = widget.selectedField;
    _sortDirection = widget.selectedDirection;
  }

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);
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
          for (final field in VendorsSortField.values)
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
              Expanded(
                child: _DirectionButton(
                  label: 'Ascending',
                  icon: Icons.arrow_upward_rounded,
                  isSelected: _sortDirection == SortDirection.ascending,
                  onTap: () =>
                      setState(() => _sortDirection = SortDirection.ascending),
                ),
              ),
              SizedBox(width: Dimensions.width10),
              Expanded(
                child: _DirectionButton(
                  label: 'Descending',
                  icon: Icons.arrow_downward_rounded,
                  isSelected: _sortDirection == SortDirection.descending,
                  onTap: () =>
                      setState(() => _sortDirection = SortDirection.descending),
                ),
              ),
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
                side: const BorderSide(color: AppColors.primary, width: 1.5),
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
}

class _DirectionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _DirectionButton({
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
