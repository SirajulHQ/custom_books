import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/core/widgets/exit_confirmation_dialog.dart';
import 'package:custom_books/features/drawer/views/custom_drawer.dart';
import 'package:custom_books/features/home/controllers/dashboard_controller.dart';
import 'package:custom_books/features/home/views/notifications_page.dart';
import 'package:custom_books/features/home/widgets/overview_contents/balance_grid_widget.dart';
import 'package:custom_books/features/home/widgets/overview_contents/banking_strip_widget.dart';
import 'package:custom_books/features/home/widgets/overview_contents/cash_flow_card_widget.dart';
import 'package:custom_books/features/home/widgets/overview_contents/income_expense_card_widget.dart';
import 'package:custom_books/features/home/widgets/overview_contents/expense_breakdown_card_widget.dart';
import 'package:custom_books/features/home/widgets/overview_contents/project_timer_card_widget.dart';
import 'package:custom_books/features/home/widgets/overview_contents/quick_action_grid_widget.dart';
import 'package:custom_books/features/home/widgets/support_content_widget.dart';
import 'package:custom_books/features/home/widgets/update_content_widget.dart';
import 'package:custom_books/core/widgets/skeletons/skeletons.dart';
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
  static const String _period = 'This Fiscal Year';

  final DashboardController _controller = DashboardController();

  @override
  void initState() {
    super.initState();
    _controller.loadDashboard();

    _controller.loadUpdates();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
          _scaffoldKey.currentState?.closeDrawer();
          return;
        }
        if (!context.mounted) return;
        final shouldExit = await showExitConfirmationDialog(context);
        if (shouldExit) SystemNavigator.pop();
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: context.colors.background,
        drawer: const DrawerView(currentRoute: 'home'),
        body: SafeArea(
          child: ListenableBuilder(
            listenable: _controller,
            builder: (context, _) {
              return RefreshIndicator(
                color: AppColors.primary,
                backgroundColor: context.colors.card,
                strokeWidth: 2.5,
                onRefresh: _onRefresh,
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  slivers: [
                    CustomSliverAppBar(
                      title: 'Business Overview',
                      subtitle: 'Snapshot • $_period',
                      leadingType: AppBarLeadingType.menu,
                      actions: [
                        AppBarIconButton(
                          icon: Icons.notifications_none_rounded,
                          color: AppColors.accent,
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
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    switch (_selectedSegment) {
      case 0:
        await _controller.loadDashboard();
      case 1:
        await _controller.loadUpdates();
      case 2:
        await _controller.loadSupport();
    }
  }

  void _openNotificationsPage() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const NotificationsPage()));
  }

  Widget _buildSelectedContent() {
    switch (_selectedSegment) {
      case 0:
        return _buildOverviewContent();
      case 1:
        return UpdatesContentWidget(updates: _controller.updates);
      case 2:
        return SupportContentWidget(data: _controller.support);
      default:
        return _buildOverviewContent();
    }
  }

  Widget _buildOverviewContent() {
    if (_controller.isLoading) {
      return SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
        sliver: const SliverToBoxAdapter(child: DashboardSkeleton()),
      );
    }
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          SizedBox(height: Dimensions.height15),

          BalancesGridWidget(data: _controller.overview),
          SizedBox(height: Dimensions.height20),

          const QuickActionsGridWidget(),
          SizedBox(height: Dimensions.height20),

          BankingStripWidget(data: _controller.overview),
          SizedBox(height: Dimensions.height20),

          CashFlowCardWidget(
            apiData: _controller.cashFlow,
            availablePeriods: _controller.cashFlowPeriods,
            asOnLabel: _controller.cashFlowAsOnLabel,
            currency: _controller.cashFlowCurrency,
            onPeriodChanged: (period) =>
                _controller.loadCashFlow(period: period),
          ),
          SizedBox(height: Dimensions.height20),

          IncomeExpenseCardWidget(
            apiData: _controller.incomeExpense,
            availablePeriods: _controller.incomeExpensePeriods,
            currency: _controller.incomeExpenseCurrency,
            onFilterChanged: (period, method) => _controller.loadIncomeExpense(
              period: period,
              accountingMethod: method,
            ),
          ),
          SizedBox(height: Dimensions.height20),

          ProjectTimerCardWidget(data: _controller.projects),
          SizedBox(height: Dimensions.height20),

          ExpenseBreakdownCardWidget(
            apiData: _controller.expenses,
            availablePeriods: _controller.expensePeriods,
            currency: _controller.expensesCurrency,
            onPeriodChanged: (period) =>
                _controller.loadExpenses(period: period),
          ),
          SizedBox(height: Dimensions.height30),
        ]),
      ),
    );
  }

  Widget _buildUnreadBadge(int count) {
    final label = count > 99 ? '99+' : '$count';
    return Container(
      constraints: BoxConstraints(minWidth: Dimensions.width20),
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.width10,
        vertical: Dimensions.height10 / 4,
      ),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(Dimensions.radius30),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: TextStyle(
          fontSize: Dimensions.font16 * 0.65,
          fontWeight: FontWeight.w800,
          color: Colors.white,
          height: 1.0,
        ),
      ),
    );
  }

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
                onTap: () {
                  setState(() => _selectedSegment = i);

                  if (i == 1 && _controller.updates == null) {
                    _controller.loadUpdates();
                  } else if (i == 2 && _controller.support == null) {
                    _controller.loadSupport();
                  }
                },
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        segments[i],
                        style: TextStyle(
                          fontSize: Dimensions.font16 * 0.8,
                          fontWeight: selected
                              ? FontWeight.w800
                              : FontWeight.w500,
                          letterSpacing: 0.3,
                          color: selected
                              ? AppColors.primary
                              : context.colors.textSecondary,
                        ),
                      ),

                      if (i == 1 && _controller.unreadUpdatesCount > 0) ...[
                        SizedBox(width: Dimensions.width10 / 2),
                        _buildUnreadBadge(_controller.unreadUpdatesCount),
                      ],
                    ],
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
