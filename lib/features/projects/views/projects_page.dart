import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/core/widgets/active_filter_banner.dart';
import 'package:custom_books/core/widgets/custom_add_button.dart';
import 'package:custom_books/core/widgets/custom_search_field.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/core/widgets/empty_state_widget.dart';
import 'package:custom_books/core/widgets/list_control_bar.dart';
import 'package:custom_books/features/drawer/views/custom_drawer.dart';
import 'package:custom_books/features/projects/models/project_model.dart';
import 'package:custom_books/features/projects/views/add_project_page.dart';
import 'package:custom_books/features/projects/views/project_details_page.dart';
import 'package:custom_books/features/projects/widgets/project_filter_sheet.dart';
import 'package:custom_books/features/projects/widgets/project_sort_sheet.dart';
import 'package:custom_books/features/projects/widgets/project_page_widgets.dart';
import 'package:custom_books/features/projects/widgets/projects_more_options_sheet.dart';
import 'package:flutter/material.dart';
import 'package:custom_books/core/enums/sort_direction.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  final TextEditingController _searchController = TextEditingController();

  int _selectedTab = 0; // 0: All, 1: Active, 2: Completed
  bool _searchOpen = false;
  ProjectStatus? _statusFilter;
  ProjectSortField _sortField = ProjectSortField.createdTime;
  SortDirection _sortDirection = SortDirection.descending;

  late List<ProjectModel> _projects;

  @override
  void initState() {
    super.initState();
    _projects = [
      ProjectModel(
        id: '1',
        projectName: 'Website Redesign',
        customerName: 'Nandhu',
        status: ProjectStatus.active,
        billingMethod: BillingMethod.basedOnProjectHours,
        rate: 150,
        budgetHours: 80,
        loggedHours: 42,
        createdAt: DateTime(2026, 7, 3, 10, 0),
        updatedAt: DateTime(2026, 7, 3, 10, 0),
      ),
      ProjectModel(
        id: '2',
        projectName: 'Mobile App Development',
        customerName: 'Parthiv Ajith',
        status: ProjectStatus.active,
        billingMethod: BillingMethod.basedOnStaffHours,
        rate: 200,
        budgetHours: 200,
        loggedHours: 95,
        createdAt: DateTime(2026, 7, 2, 9, 30),
        updatedAt: DateTime(2026, 7, 2, 9, 30),
      ),
      ProjectModel(
        id: '3',
        projectName: 'Brand Identity',
        customerName: 'Nandhu',
        status: ProjectStatus.completed,
        billingMethod: BillingMethod.fixedCost,
        rate: 5000,
        budgetHours: 40,
        loggedHours: 38,
        createdAt: DateTime(2026, 6, 28, 14, 0),
        updatedAt: DateTime(2026, 6, 28, 14, 0),
      ),
      ProjectModel(
        id: '4',
        projectName: 'SEO Audit',
        customerName: 'Aravind',
        status: ProjectStatus.onHold,
        billingMethod: BillingMethod.basedOnTaskHours,
        rate: 120,
        budgetHours: 30,
        loggedHours: 12,
        createdAt: DateTime(2026, 6, 25, 11, 15),
        updatedAt: DateTime(2026, 6, 25, 11, 15),
      ),
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ProjectModel> get _visibleProjects {
    final query = _searchController.text.trim().toLowerCase();
    final list = _projects.where((project) {
      if (_selectedTab == 1 && project.status != ProjectStatus.active) {
        return false;
      }
      if (_selectedTab == 2 && project.status != ProjectStatus.completed) {
        return false;
      }
      if (_statusFilter != null && project.status != _statusFilter) {
        return false;
      }
      return query.isEmpty ||
          project.projectName.toLowerCase().contains(query) ||
          project.customerName.toLowerCase().contains(query);
    }).toList();

    list.sort((a, b) {
      int result;
      switch (_sortField) {
        case ProjectSortField.createdTime:
          result = a.createdAt.compareTo(b.createdAt);
        case ProjectSortField.projectName:
          result = a.projectName.toLowerCase().compareTo(
            b.projectName.toLowerCase(),
          );
        case ProjectSortField.customerName:
          result = a.customerName.toLowerCase().compareTo(
            b.customerName.toLowerCase(),
          );
        case ProjectSortField.rate:
          result = a.rate.compareTo(b.rate);
      }
      return _sortDirection == SortDirection.ascending ? result : -result;
    });

    return list;
  }

  Future<void> _addNewProject() async {
    final result = await Navigator.push<ProjectModel>(
      context,
      MaterialPageRoute(builder: (_) => const AddProjectPage()),
    );
    if (result != null && mounted) {
      setState(() => _projects.insert(0, result));
      ToastificationHelper.showSuccess(context, 'Project created successfully');
    }
  }

  void _showMoreOptions() {
    ProjectsMoreOptionsSheet.show(
      context,
      onExport: () =>
          ToastificationHelper.showSuccess(context, 'Projects exported'),
      onRefresh: () => setState(() {}),
    );
  }

  void _openFilterSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.colors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Dimensions.radius20),
        ),
      ),
      builder: (_) => ProjectFilterSheet(
        selectedStatus: _statusFilter,
        onSelected: (status) => setState(() => _statusFilter = status),
      ),
    );
  }

  void _openSortSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.colors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Dimensions.radius20),
        ),
      ),
      builder: (_) => ProjectSortSheet(
        selectedField: _sortField,
        selectedDirection: _sortDirection,
        onApply: (field, direction) => setState(() {
          _sortField = field;
          _sortDirection = direction;
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final visibleList = _visibleProjects;

    return Scaffold(
      backgroundColor: context.colors.background,
      drawer: const DrawerView(currentRoute: 'projects'),
      floatingActionButton: CustomAddButton(onPressed: _addNewProject),
      body: NestedScrollView(
        physics: const BouncingScrollPhysics(),
        headerSliverBuilder: (context, _) => [
          CustomSliverAppBar(
            title: 'Projects',
            subtitle:
                '${_projects.length} project${_projects.length == 1 ? '' : 's'}',
            leadingType: AppBarLeadingType.menu,
            actions: [
              AppBarIconButton(
                icon: _searchOpen ? Icons.close_rounded : Icons.search_rounded,
                onPressed: () => setState(() {
                  _searchOpen = !_searchOpen;
                  if (!_searchOpen) _searchController.clear();
                }),
              ),
              SizedBox(width: Dimensions.width10),
              AppBarIconButton(
                icon: Icons.more_vert_rounded,
                color: AppColors.accent,
                onPressed: _showMoreOptions,
              ),
              SizedBox(width: Dimensions.width20),
            ],
          ),
        ],
        body: Column(
          children: [
            if (_searchOpen)
              ListSearchField(
                controller: _searchController,
                hintText: 'Search by project or customer',
                onChanged: (_) => setState(() {}),
              ),
            ListControlBar(
              tabs: const ['All', 'Active', 'Completed'],
              selectedTab: _selectedTab,
              onTabSelected: (i) => setState(() {
                _selectedTab = i;
                _statusFilter = null;
              }),
              filterActive: _statusFilter != null,
              onFilterTap: _openFilterSheet,
              onSortTap: _openSortSheet,
            ),
            if (_statusFilter != null)
              ActiveFilterBanner(
                label: 'Status: ${_statusFilter!.label}',
                onClear: () => setState(() => _statusFilter = null),
              ),
            Expanded(
              child: visibleList.isEmpty
                  ? const EmptyStateWidget(
                      icon: Icons.work_outline_rounded,
                      title: 'No projects found',
                      subtitle: 'Tap the + button to create a new project.',
                    )
                  : RefreshIndicator(
                      onRefresh: () async => setState(() {}),
                      child: ListView.builder(
                        padding: EdgeInsets.fromLTRB(
                          Dimensions.width20,
                          0,
                          Dimensions.width20,
                          Dimensions.listBottomSpace,
                        ),
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        itemCount: visibleList.length,
                        itemBuilder: (context, index) => ProjectTile(
                          project: visibleList[index],
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProjectDetailsPage(
                                project: visibleList[index],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
