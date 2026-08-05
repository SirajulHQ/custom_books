import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/features/drawer/view/custom_drawer.dart';
import 'package:custom_books/features/home/view/notifications_page.dart';
import 'package:custom_books/features/home/widgets/overview_contents/balance_grid_widget.dart';
import 'package:custom_books/features/home/widgets/overview_contents/banking_strip_widget.dart';
import 'package:custom_books/features/home/widgets/overview_contents/cash_flow_card_widget.dart';
import 'package:custom_books/features/home/widgets/overview_contents/income_expense_card_widget.dart';
import 'package:custom_books/features/home/widgets/overview_contents/expense_breakdown_card_widget.dart';
import 'package:custom_books/features/home/widgets/overview_contents/project_timer_card_widget.dart';
import 'package:custom_books/features/home/widgets/overview_contents/quick_action_grid_widget.dart';
import 'package:custom_books/features/home/widgets/support_content_widget.dart';
import 'package:custom_books/features/home/widgets/update_content_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedSegment = 0;
  String _period = 'This Fiscal Year';

  Future<bool> _showExitDialog() async {
    final result = await showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Exit',
      barrierColor: Colors.black.withValues(alpha: 0.45),
      transitionDuration: const Duration(milliseconds: 220),
      transitionBuilder: (ctx, anim, ignored, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.12),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
          child: FadeTransition(opacity: anim, child: child),
        );
      },
      pageBuilder: (ctx, anim1, anim2) {
        return Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.width20 * 1.2),
            child: Material(
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  color: context.colors.card,
                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                  border: Border.all(color: context.colors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ── Header strip ──────────────────────────────────
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.width20,
                        vertical: Dimensions.height20,
                      ),
                      decoration: BoxDecoration(
                        color: Appcolors.primary.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(Dimensions.radius20),
                          topRight: Radius.circular(Dimensions.radius20),
                        ),
                        border: Border(
                          bottom: BorderSide(color: context.colors.border),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(Dimensions.width10 * 0.8),
                            decoration: BoxDecoration(
                              color: Appcolors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(
                                Dimensions.radius15 / 2,
                              ),
                            ),
                            child: Icon(
                              Icons.exit_to_app_rounded,
                              color: Appcolors.primary,
                              size: Dimensions.iconSize24,
                            ),
                          ),
                          SizedBox(width: Dimensions.width10),
                          Text(
                            'Exit App',
                            style: TextStyle(
                              fontSize: Dimensions.font20,
                              fontWeight: FontWeight.w700,
                              color: context.colors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ── Body ──────────────────────────────────────────
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        Dimensions.width20,
                        Dimensions.height20,
                        Dimensions.width20,
                        Dimensions.height10,
                      ),
                      child: Text(
                        'Are you sure you want to exit the app?',
                        style: TextStyle(
                          fontSize: Dimensions.font16 * 0.95,
                          color: context.colors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                    ),

                    // ── Actions ───────────────────────────────────────
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        Dimensions.width20,
                        Dimensions.height10,
                        Dimensions.width20,
                        Dimensions.height20,
                      ),
                      child: Row(
                        children: [
                          // Cancel
                          Expanded(
                            child: GestureDetector(
                              onTap: () => Navigator.of(ctx).pop(false),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: Dimensions.height15,
                                ),
                                decoration: BoxDecoration(
                                  color: context.colors.surfaceLight,
                                  borderRadius: BorderRadius.circular(
                                    Dimensions.radius15 / 2,
                                  ),
                                  border: Border.all(
                                    color: context.colors.border,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                    fontSize: Dimensions.font16 * 0.9,
                                    fontWeight: FontWeight.w600,
                                    color: context.colors.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: Dimensions.width10),
                          // Exit
                          Expanded(
                            child: GestureDetector(
                              onTap: () => Navigator.of(ctx).pop(true),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: Dimensions.height15,
                                ),
                                decoration: BoxDecoration(
                                  color: Appcolors.primary,
                                  borderRadius: BorderRadius.circular(
                                    Dimensions.radius15 / 2,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.logout_rounded,
                                      color: Colors.white,
                                      size: Dimensions.iconSize16,
                                    ),
                                    SizedBox(width: Dimensions.width10 / 2),
                                    Text(
                                      'Exit',
                                      style: TextStyle(
                                        fontSize: Dimensions.font16 * 0.9,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
          _scaffoldKey.currentState?.closeDrawer();
          return;
        }
        final shouldExit = await _showExitDialog();
        if (shouldExit) SystemNavigator.pop();
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: context.colors.background,
        drawer: const DrawerView(currentRoute: 'home'),
        body: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              CustomSliverAppBar(
                title: 'Business Overview',
                subtitle: 'Snapshot • $_period',
                leadingType: AppBarLeadingType.menu,
                actions: [
                  AppBarIconButton(
                    icon: Icons.notifications_none_rounded,
                    color: Appcolors.accent,
                    showBadge: true,
                    onPressed: _openNotificationsPage,
                  ),
                  SizedBox(width: Dimensions.width20),
                ],
              ),
              SliverToBoxAdapter(child: _buildSegmentedControl()),
              _buildSelectedContent(),
            ],
          ),
        ),
      ),
    );
  }

  // -------- Navigate to notifications page --------
  void _openNotificationsPage() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const NotificationsPage()));
  }

  // -------- Content based on selected segment --------
  Widget _buildSelectedContent() {
    switch (_selectedSegment) {
      case 0:
        return _buildOverviewContent();
      case 1:
        return UpdatesContentWidget();
      case 2:
        return SupportContentWidget();
      default:
        return _buildOverviewContent();
    }
  }

  Widget _buildOverviewContent() {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          SizedBox(height: Dimensions.height15),

          const BalancesGridWidget(),
          SizedBox(height: Dimensions.height20),

          const QuickActionsGridWidget(),
          SizedBox(height: Dimensions.height20),

          const BankingStripWidget(),
          SizedBox(height: Dimensions.height20),

          const CashFlowCardWidget(),
          SizedBox(height: Dimensions.height20),

          const IncomeExpenseCardWidget(),
          SizedBox(height: Dimensions.height20),

          const ProjectTimerCardWidget(),
          SizedBox(height: Dimensions.height20),

          const ExpenseBreakdownCardWidget(),
          SizedBox(height: Dimensions.height30),
        ]),
      ),
    );
  }

  // -------- Segmented control (replaces underline tabs) --------
  Widget _buildSegmentedControl() {
    final segments = ['Overview', 'Updates', 'Support'];
    return Padding(
      padding: EdgeInsets.fromLTRB(
        Dimensions.width20,
        0,
        Dimensions.width20,
        Dimensions.height15,
      ),
      child: Container(
        padding: EdgeInsets.all(Dimensions.width10 / 2),
        decoration: BoxDecoration(
          color: context.colors.surfaceLight,
          borderRadius: BorderRadius.circular(Dimensions.radius30),
        ),
        child: Row(
          children: List.generate(segments.length, (i) {
            final selected = i == _selectedSegment;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedSegment = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: EdgeInsets.symmetric(vertical: Dimensions.height10),
                  decoration: BoxDecoration(
                    color: selected ? context.colors.card : Colors.transparent,
                    borderRadius: BorderRadius.circular(Dimensions.radius30),
                    border: selected
                        ? Border.all(
                            color: Appcolors.primary.withValues(alpha: 0.3),
                            width: 1.5,
                          )
                        : null,
                    boxShadow: selected
                        ? [
                            BoxShadow(
                              color: Appcolors.primary.withValues(alpha: 0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    segments[i],
                    style: TextStyle(
                      fontSize: Dimensions.font16 * 0.8,
                      fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
                      letterSpacing: 0.3,
                      color: selected
                          ? Appcolors.primary
                          : context.colors.textSecondary,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
