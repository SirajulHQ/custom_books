import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/core/widgets/custom_add_button.dart';
import 'package:custom_books/core/widgets/custom_search_field.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/features/drawer/views/custom_drawer.dart';
import 'package:custom_books/features/projects/models/project_model.dart';
import 'package:custom_books/features/projects/views/add_project_page.dart';
import 'package:custom_books/features/projects/views/project_details_page.dart';
import 'package:custom_books/features/projects/widgets/project_filter_sheet.dart';
import 'package:custom_books/features/projects/widgets/project_sort_sheet.dart';
import 'package:custom_books/features/projects/widgets/project_page_widgets.dart';
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
                onPressed: _openFilterSheet,
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
            Padding(
              padding: EdgeInsets.fromLTRB(
                Dimensions.width20,
                Dimensions.height10 / 2,
                Dimensions.width20,
                Dimensions.height15,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(Dimensions.height10 * 0.4),
                      decoration: BoxDecoration(
                        color: context.colors.surfaceLight,
                        borderRadius: BorderRadius.circular(
                          Dimensions.radius30,
                        ),
                      ),
                      child: Row(
                        children: [
                          _tabButton('All', 0),
                          _tabButton('Active', 1),
                          _tabButton('Completed', 2),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: Dimensions.width10),
                  InkWell(
                    borderRadius: BorderRadius.circular(Dimensions.radius15),
                    onTap: _openFilterSheet,
                    child: _controlBadge(
                      _statusFilter == null
                          ? Icons.filter_list_rounded
                          : Icons.filter_alt_rounded,
                      active: _statusFilter != null,
                    ),
                  ),
                  SizedBox(width: Dimensions.width10 / 2),
                  InkWell(
                    borderRadius: BorderRadius.circular(Dimensions.radius15),
                    onTap: _openSortSheet,
                    child: _controlBadge(Icons.swap_vert_rounded),
                  ),
                ],
              ),
            ),
            if (_statusFilter != null)
              Container(
                margin: EdgeInsets.fromLTRB(
                  Dimensions.width20,
                  0,
                  Dimensions.width20,
                  Dimensions.height10,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.width15,
                  vertical: Dimensions.height10 / 2,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.07),
                  borderRadius: BorderRadius.circular(Dimensions.radius15),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.filter_alt_rounded,
                      size: Dimensions.iconSize16,
                      color: AppColors.primary,
                    ),
                    SizedBox(width: Dimensions.width10 / 2),
                    Text(
                      'Status: ${_statusFilter!.label}',
                      style: TextStyle(
                        fontSize: Dimensions.font16 * 0.72,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () => setState(() => _statusFilter = null),
                      child: Icon(
                        Icons.close_rounded,
                        size: Dimensions.iconSize16,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: visibleList.isEmpty
                  ? _emptyState()
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

  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: Dimensions.height45 * 1.6,
              height: Dimensions.height45 * 1.6,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.work_outline_rounded,
                size: Dimensions.iconSize24 * 1.3,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: Dimensions.height15),
            Text(
              'No projects found',
              style: TextStyle(
                fontSize: Dimensions.font16,
                fontWeight: FontWeight.w700,
                color: context.colors.textPrimary,
              ),
            ),
            SizedBox(height: Dimensions.height10 / 2),
            Text(
              'Tap the + button to create a new project.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.75,
                color: context.colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabButton(String label, int index) {
    final selected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() {
          _selectedTab = index;
          _statusFilter = null;
        }),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: EdgeInsets.symmetric(vertical: Dimensions.height10),
          decoration: BoxDecoration(
            color: selected ? context.colors.card : Colors.transparent,
            borderRadius: BorderRadius.circular(Dimensions.radius30),
            border: selected
                ? Border.all(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    width: 1.5,
                  )
                : null,
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      blurRadius: Dimensions.radius15 * 0.53,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.72,
              fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
              color: selected
                  ? AppColors.primary
                  : context.colors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _controlBadge(IconData icon, {bool active = false}) {
    return Container(
      width: Dimensions.height45 * 0.9,
      height: Dimensions.height45 * 0.9,
      decoration: BoxDecoration(
        color: (active ? AppColors.accent : AppColors.primary).withValues(
          alpha: 0.1,
        ),
        borderRadius: BorderRadius.circular(Dimensions.radius15),
      ),
      child: Icon(
        icon,
        size: Dimensions.iconSize24 - 4,
        color: active ? AppColors.accent : AppColors.primary,
      ),
    );
  }
}
