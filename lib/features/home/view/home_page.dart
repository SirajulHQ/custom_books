import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/features/drawer/view/custom_drawer.dart';
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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedSegment = 0;

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);

    return Scaffold(
      backgroundColor: Appcolors.background,
      drawer: const DrawerView(currentRoute: 'home'),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            CustomSliverAppBar(
              title: 'Business Overview',
              subtitle: 'Snapshot for this fiscal year',
              leadingType: AppBarLeadingType.menu,
              actions: [
                AppBarIconButton(
                  icon: Icons.tune_rounded,
                  color: Appcolors.primary,
                ),
                SizedBox(width: Dimensions.width10),
                AppBarIconButton(
                  icon: Icons.notifications_none_rounded,
                  color: Appcolors.accent,
                  showBadge: true,
                ),
                SizedBox(width: Dimensions.width20),
              ],
            ),
            SliverToBoxAdapter(child: _buildSegmentedControl()),
            _buildSelectedContent(),
          ],
        ),
      ),
    );
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
          color: const Color(0xFFF1F3F5),
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
                    color: selected ? Colors.white : Colors.transparent,
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
                      color: selected ? Appcolors.primary : Appcolors.textSecondary,
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
