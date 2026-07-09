import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
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
      drawer: const DrawerView(),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              pinned: true,
              backgroundColor: Appcolors.background,
              surfaceTintColor: Appcolors.background,
              elevation: 0,
              toolbarHeight: Dimensions.height45 * 1.6,
              titleSpacing: Dimensions.width20,
              leading: Builder(
                builder: (context) => IconButton(
                  icon: Container(
                    width: Dimensions.height45 * 0.9,
                    height: Dimensions.height45 * 0.9,
                    decoration: BoxDecoration(
                      color: Appcolors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(Dimensions.radius15),
                    ),
                    child: Icon(
                      Icons.menu_rounded,
                      size: Dimensions.iconSize24 - 4,
                      color: Appcolors.primary,
                    ),
                  ),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Business Overview',
                    style: TextStyle(
                      fontSize: Dimensions.font26 * 0.85,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  Text(
                    'Snapshot for this fiscal year',
                    style: TextStyle(
                      fontSize: Dimensions.font16 * 0.7,
                      color: Colors.black45,
                    ),
                  ),
                ],
              ),
              actions: [
                _iconBadge(Icons.tune_rounded, Appcolors.primary),
                SizedBox(width: Dimensions.width10),
                _iconBadge(
                  Icons.notifications_none_rounded,
                  Appcolors.accent,
                  showDot: true,
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

  Widget _iconBadge(IconData icon, Color color, {bool showDot = false}) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: Dimensions.height45 * 0.9,
          height: Dimensions.height45 * 0.9,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(Dimensions.radius15),
          ),
          child: Icon(icon, size: Dimensions.iconSize24 - 4, color: color),
        ),
        if (showDot)
          Positioned(
            top: -2,
            right: -2,
            child: Container(
              width: 9,
              height: 9,
              decoration: const BoxDecoration(
                color: Appcolors.warn,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
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
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Dimensions.radius15),
          border: Border.all(color: const Color(0xFFE2E8F0)),
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
                    color: selected ? Appcolors.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(
                      Dimensions.radius15 - 5,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    segments[i],
                    style: TextStyle(
                      fontSize: Dimensions.font16 * 0.8,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                      color: selected ? Colors.white : Colors.black54,
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
