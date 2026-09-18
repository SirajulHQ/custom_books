import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/date_formatter.dart';
import 'package:custom_books/core/widgets/bottom_sheet_drag_handle.dart';
import 'package:custom_books/core/widgets/confirmation_dialog.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/core/widgets/detail_row.dart';
import 'package:custom_books/features/time_entries/models/time_entry_model.dart';
import 'package:custom_books/features/time_entries/views/add_time_entry_page.dart';
import 'package:flutter/material.dart';
import 'package:custom_books/core/widgets/skeletons/skeletons.dart';

class TimeEntryDetailsPage extends StatefulWidget {
  final TimeEntryModel entry;

  const TimeEntryDetailsPage({super.key, required this.entry});

  @override
  State<TimeEntryDetailsPage> createState() => _TimeEntryDetailsPageState();
}

class _TimeEntryDetailsPageState extends State<TimeEntryDetailsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _load();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// Simulates fetching details so the shimmer skeleton is shown briefly.
  Future<void> _load() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _isLoading = false);
  }

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          color: context.colors.card,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(Dimensions.radius20 * 1.2),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const BottomSheetDragHandle(),
            ListTile(
              leading: Icon(
                Icons.print_rounded,
                color: context.colors.textSecondary,
              ),
              title: Text(
                'Print',
                style: TextStyle(
                  fontSize: Dimensions.font16 * 0.9,
                  fontWeight: FontWeight.w600,
                  color: context.colors.textPrimary,
                ),
              ),
              onTap: () => Navigator.pop(ctx),
            ),
            ListTile(
              leading: Icon(
                Icons.delete_outline_rounded,
                color: AppColors.warn,
              ),
              title: Text(
                'Delete',
                style: TextStyle(
                  fontSize: Dimensions.font16 * 0.9,
                  fontWeight: FontWeight.w600,
                  color: AppColors.warn,
                ),
              ),
              onTap: () async {
                Navigator.pop(ctx);
                final confirmed = await showConfirmationDialog(
                  context,
                  title: 'Delete Time Entry',
                  message:
                      'Are you sure you want to delete this time entry? This action cannot be undone.',
                );
                if (!mounted) return;
                if (confirmed) {
                  Navigator.pop(context);
                }
              },
            ),
            SizedBox(height: Dimensions.height20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final entry = widget.entry;
    final statusColor = entry.isBillable
        ? AppColors.success
        : context.colors.textTertiary;

    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: Column(
          children: [
            // App bar via CustomScrollView
            SizedBox(
              height: Dimensions.height45 * 1.6,
              child: CustomScrollView(
                physics: const NeverScrollableScrollPhysics(),
                slivers: [
                  CustomSliverAppBar(
                    title: 'Time Entry Details',
                    leadingType: AppBarLeadingType.back,
                    actions: [
                      AppBarIconButton(
                        icon: Icons.edit_rounded,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AddTimeEntryPage(existing: widget.entry),
                            ),
                          );
                        },
                      ),
                      AppBarIconButton(
                        icon: Icons.more_vert_rounded,
                        color: AppColors.accent,
                        onPressed: _showMoreOptions,
                      ),
                      SizedBox(width: Dimensions.width10),
                    ],
                  ),
                ],
              ),
            ),
            if (_isLoading)
              const Expanded(child: DetailsPageSkeleton())
            else ...[
              // Header section
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(Dimensions.width20),
                decoration: BoxDecoration(
                  color: context.colors.card,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x08000000),
                      blurRadius: Dimensions.radius15 * 0.53,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          formatDate(entry.logDate),
                          style: TextStyle(
                            fontSize: Dimensions.font20 * 0.95,
                            fontWeight: FontWeight.w800,
                            color: context.colors.textPrimary,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.width10 + 2,
                            vertical: Dimensions.height10 * 0.5,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(
                              Dimensions.radius30,
                            ),
                          ),
                          child: Text(
                            entry.isBillable ? 'BILLABLE' : 'NON-BILLABLE',
                            style: TextStyle(
                              fontSize: Dimensions.font16 * 0.62,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.6,
                              color: statusColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Dimensions.height20),
                    Text(
                      entry.taskName,
                      style: TextStyle(
                        fontSize: Dimensions.font20 * 0.95,
                        fontWeight: FontWeight.w800,
                        color: context.colors.textPrimary,
                      ),
                    ),
                    SizedBox(height: Dimensions.height10 / 2.5),
                    Text(
                      entry.projectName,
                      style: TextStyle(
                        fontSize: Dimensions.font16 * 0.85,
                        color: context.colors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: Dimensions.height15),
              // Tabs
              Container(
                margin: EdgeInsets.symmetric(horizontal: Dimensions.width20),
                decoration: BoxDecoration(
                  color: context.colors.surfaceLight,
                  borderRadius: BorderRadius.circular(Dimensions.radius30),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: context.colors.card,
                    borderRadius: BorderRadius.circular(Dimensions.radius30),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        blurRadius: Dimensions.radius15 * 0.53,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: AppColors.primary,
                  unselectedLabelColor: context.colors.textSecondary,
                  labelStyle: TextStyle(
                    fontSize: Dimensions.font16 * 0.72,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.3,
                  ),
                  dividerColor: Colors.transparent,
                  padding: EdgeInsets.all(Dimensions.width10 / 2),
                  tabs: const [
                    Tab(text: 'DETAILS'),
                    Tab(text: 'COMMENTS & HISTORY'),
                  ],
                ),
              ),
              SizedBox(height: Dimensions.height15),
              // Tab content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [_buildDetailsTab(), _buildCommentsTab()],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsTab() {
    final entry = widget.entry;
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
      physics: const BouncingScrollPhysics(),
      children: [
        Container(
          padding: EdgeInsets.all(Dimensions.width20),
          decoration: BoxDecoration(
            color: context.colors.card,
            borderRadius: BorderRadius.circular(Dimensions.radius15),
            boxShadow: [
              BoxShadow(
                color: Color(0x08000000),
                blurRadius: Dimensions.radius15 * 0.53,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DetailRow(label: 'Project:', value: entry.projectName),
              SizedBox(height: Dimensions.height15),
              DetailRow(label: 'Task:', value: entry.taskName),
              SizedBox(height: Dimensions.height15),
              DetailRow(label: 'User:', value: entry.userName),
              SizedBox(height: Dimensions.height15),
              DetailRow(label: 'Log Date:', value: formatDate(entry.logDate)),
              SizedBox(height: Dimensions.height15),
              DetailRow(label: 'Duration:', value: entry.durationLabel),
              SizedBox(height: Dimensions.height15),
              DetailRow(
                label: 'Billable:',
                value: entry.isBillable ? 'Yes' : 'No',
              ),
              SizedBox(height: Dimensions.height15),
              DetailRow(
                label: 'Notes:',
                value: entry.notes.isEmpty ? '-' : entry.notes,
              ),
            ],
          ),
        ),
        SizedBox(height: Dimensions.height30),
      ],
    );
  }

  Widget _buildCommentsTab() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(Dimensions.width20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(Dimensions.width20),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.07),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.history_rounded,
                size: Dimensions.iconSize24 * 2,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: Dimensions.height20),
            Text(
              'No comments or history yet',
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.95,
                fontWeight: FontWeight.w700,
                color: context.colors.textPrimary,
              ),
            ),
            SizedBox(height: Dimensions.height10),
            Text(
              'Comments and activity history\nwill appear here',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.8,
                color: context.colors.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
