import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/features/projects/models/project_model.dart';
import 'package:custom_books/core/enums/sort_direction.dart';
import 'package:flutter/material.dart';

class ProjectSortSheet extends StatefulWidget {
  final ProjectSortField selectedField;
  final SortDirection selectedDirection;
  final void Function(ProjectSortField field, SortDirection direction) onApply;

  const ProjectSortSheet({
    super.key,
    required this.selectedField,
    required this.selectedDirection,
    required this.onApply,
  });

  @override
  State<ProjectSortSheet> createState() => _ProjectSortSheetState();
}

class _ProjectSortSheetState extends State<ProjectSortSheet> {
  late ProjectSortField _sortField;
  late SortDirection _sortDirection;

  @override
  void initState() {
    super.initState();
    _sortField = widget.selectedField;
    _sortDirection = widget.selectedDirection;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(Dimensions.width20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sort By',
              style: TextStyle(
                fontSize: Dimensions.font20 * 0.85,
                fontWeight: FontWeight.w800,
                color: context.colors.textPrimary,
              ),
            ),
            SizedBox(height: Dimensions.height15),
            for (final field in ProjectSortField.values)
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
                    border: Border.all(
                      color: _sortField == field
                          ? AppColors.primary
                          : context.colors.border,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _sortField == field
                            ? Icons.radio_button_checked_rounded
                            : Icons.radio_button_off_rounded,
                        size: Dimensions.iconSize16 + 2,
                        color: _sortField == field
                            ? AppColors.primary
                            : context.colors.textTertiary,
                      ),
                      SizedBox(width: Dimensions.width10),
                      Text(
                        field.label,
                        style: TextStyle(
                          fontSize: Dimensions.font16 * 0.8,
                          fontWeight: _sortField == field
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: context.colors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            SizedBox(height: Dimensions.height10),
            Row(
              children: [
                Expanded(
                  child: _directionButton(
                    'Ascending',
                    Icons.arrow_upward_rounded,
                    SortDirection.ascending,
                  ),
                ),
                SizedBox(width: Dimensions.width10),
                Expanded(
                  child: _directionButton(
                    'Descending',
                    Icons.arrow_downward_rounded,
                    SortDirection.descending,
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
            SizedBox(height: Dimensions.height10),
          ],
        ),
      ),
    );
  }

  Widget _directionButton(
    String label,
    IconData icon,
    SortDirection direction,
  ) {
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
          border: Border.all(
            color: selected ? AppColors.primary : context.colors.border,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: Dimensions.iconSize16 + 2,
              color: selected
                  ? AppColors.primary
                  : context.colors.textTertiary,
            ),
            SizedBox(width: Dimensions.width10 / 2),
            Text(
              label,
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.75,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected
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
