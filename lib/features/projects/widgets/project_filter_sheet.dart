import 'package:custom_books/core/widgets/filter_sheet.dart';
import 'package:custom_books/features/projects/models/project_model.dart';
import 'package:flutter/material.dart';

class ProjectFilterSheet extends StatelessWidget {
  final ProjectStatus? selectedStatus;
  final ValueChanged<ProjectStatus?> onSelected;

  const ProjectFilterSheet({
    super.key,
    required this.selectedStatus,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterSheet<ProjectStatus>(
      title: 'Filter by Status',
      compact: true,
      style: FilterOptionStyle.radio,
      options: const [null, ...ProjectStatus.values],
      selectedValue: selectedStatus,
      labelBuilder: (status) => status?.label ?? 'All Statuses',
      onSelected: onSelected,
    );
  }
}
