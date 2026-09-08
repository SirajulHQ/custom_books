import 'package:custom_books/core/enums/sort_direction.dart';
import 'package:custom_books/core/widgets/generic_sort_sheet.dart';
import 'package:custom_books/features/projects/models/project_model.dart';
import 'package:flutter/material.dart';

/// Thin wrapper kept for call-site compatibility.
class ProjectSortSheet extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return GenericSortSheet<ProjectSortField>(
      fields: ProjectSortField.values,
      initialField: selectedField,
      initialDirection: selectedDirection,
      labelBuilder: (f) => f.label,
      onApply: onApply,
      compact: true,
      buttonLabel: 'Apply',
    );
  }
}
