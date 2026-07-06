import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/features/drawer/view/custom_drawer.dart';
import 'package:custom_books/features/home/widgets/balance_grid_widget.dart';
import 'package:custom_books/features/home/widgets/banking_strip_widget.dart';
import 'package:custom_books/features/home/widgets/cash_flow_card_widget.dart';
import 'package:custom_books/features/home/widgets/overview_content_widget.dart';
import 'package:custom_books/features/home/widgets/quick_action_grid_widget.dart';
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
            _buildHeaderSliver(),
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
        return _buildUpdatesContent();
      case 2:
        return _buildSupportContent();
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

          const IncomeExpenseCard(),
          SizedBox(height: Dimensions.height20),

          const ProjectTimerCard(),
          SizedBox(height: Dimensions.height20),

          const ExpenseBreakdownCard(),
          SizedBox(height: Dimensions.height30),
        ]),
      ),
    );
  }

  Widget _buildUpdatesContent() {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          SizedBox(height: Dimensions.height15),
          _announcementCard(
            'New Feature: Automated Invoicing',
            'Save time with our new automated invoicing system. Schedule recurring invoices and never miss a payment.',
            '2 hours ago',
            Icons.celebration_rounded,
            Appcolors.primaryLight,
          ),
          SizedBox(height: Dimensions.height15),
          _announcementCard(
            'System Maintenance Scheduled',
            'We will be performing system maintenance on Saturday, 8 PM - 10 PM. Services may be temporarily unavailable.',
            '1 day ago',
            Icons.build_rounded,
            const Color(0xFFF59E0B),
          ),
          SizedBox(height: Dimensions.height15),
          _announcementCard(
            'Tax Season Reminder',
            'Tax season is approaching. Ensure all your financial records are up to date and consult with your accountant.',
            '3 days ago',
            Icons.calendar_today_rounded,
            Appcolors.ok,
          ),
          SizedBox(height: Dimensions.height15),
          _announcementCard(
            'New Payment Gateway Integration',
            'We have added support for multiple payment gateways. Check settings to configure your preferred options.',
            '1 week ago',
            Icons.payment_rounded,
            Appcolors.accent,
          ),
          SizedBox(height: Dimensions.height30),
        ]),
      ),
    );
  }

  Widget _buildSupportContent() {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          SizedBox(height: Dimensions.height15),
          Text(
            'How can we help you?',
            style: TextStyle(
              fontSize: Dimensions.font26,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
              color: const Color(0xFF0F172A),
            ),
          ),
          SizedBox(height: Dimensions.height10),
          Text(
            'Find answers to common questions or contact support',
            style: TextStyle(
              fontSize: Dimensions.font16,
              color: Colors.black54,
            ),
          ),
          SizedBox(height: Dimensions.height30),
          _helpCategoryCard(
            'Getting Started',
            'Learn the basics of using Own Store',
            Icons.rocket_launch_rounded,
            Appcolors.primary,
            [
              'Creating your first invoice',
              'Adding customers and vendors',
              'Setting up payment methods',
              'Understanding the dashboard',
            ],
          ),
          SizedBox(height: Dimensions.height15),
          _helpCategoryCard(
            'Financial Reports',
            'Generate and understand reports',
            Icons.assessment_rounded,
            Appcolors.ok,
            [
              'Cash flow statements',
              'Income and expense reports',
              'Tax preparation reports',
              'Custom report builder',
            ],
          ),
          SizedBox(height: Dimensions.height15),
          _helpCategoryCard(
            'Account Management',
            'Manage your account settings',
            Icons.settings_rounded,
            const Color(0xFFF59E0B),
            [
              'Update profile information',
              'Change password',
              'Notification preferences',
              'Subscription and billing',
            ],
          ),
          SizedBox(height: Dimensions.height30),
          _buildContactSupportCard(),
          SizedBox(height: Dimensions.height30),
        ]),
      ),
    );
  }

  Widget _announcementCard(
    String title,
    String description,
    String time,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(Dimensions.width20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Dimensions.radius20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: Dimensions.height45,
            height: Dimensions.height45,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(Dimensions.radius15),
            ),
            child: Icon(icon, color: color, size: Dimensions.iconSize24),
          ),
          SizedBox(width: Dimensions.width15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 1.05,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                SizedBox(height: Dimensions.height10 / 2),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.9,
                    color: Colors.black54,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: Dimensions.height10),
                Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: Dimensions.iconSize16 * 0.9,
                      color: Colors.black38,
                    ),
                    SizedBox(width: Dimensions.width10 / 2),
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: Dimensions.font16 * 0.75,
                        color: Colors.black38,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _helpCategoryCard(
    String title,
    String description,
    IconData icon,
    Color color,
    List<String> topics,
  ) {
    return Container(
      padding: EdgeInsets.all(Dimensions.width20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Dimensions.radius20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: Dimensions.height45,
                height: Dimensions.height45,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(Dimensions.radius15),
                ),
                child: Icon(icon, color: color, size: Dimensions.iconSize24),
              ),
              SizedBox(width: Dimensions.width15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: Dimensions.font20 * 0.9,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    SizedBox(height: Dimensions.height10 / 2),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: Dimensions.font16 * 0.85,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: Dimensions.height20),
          ...topics.map(
            (topic) => Padding(
              padding: EdgeInsets.only(bottom: Dimensions.height10),
              child: Row(
                children: [
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: Dimensions.iconSize16,
                    color: color,
                  ),
                  SizedBox(width: Dimensions.width10),
                  Expanded(
                    child: Text(
                      topic,
                      style: TextStyle(
                        fontSize: Dimensions.font16 * 0.9,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSupportCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Dimensions.width20),
      decoration: BoxDecoration(
        color: Appcolors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(Dimensions.radius20),
        border: Border.all(color: Appcolors.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.support_agent_rounded,
            size: Dimensions.iconSize24 * 2,
            color: Appcolors.primary,
          ),
          SizedBox(height: Dimensions.height15),
          Text(
            'Still need help?',
            style: TextStyle(
              fontSize: Dimensions.font20,
              fontWeight: FontWeight.w800,
              color: Appcolors.primary,
            ),
          ),
          SizedBox(height: Dimensions.height10),
          Text(
            'Contact our support team',
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.9,
              color: Colors.black54,
            ),
          ),
          SizedBox(height: Dimensions.height20),
          GestureDetector(
            onTap: () {
              // Handle contact support action
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: Dimensions.height15),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Appcolors.primary,
                borderRadius: BorderRadius.circular(Dimensions.radius30),
                boxShadow: [
                  BoxShadow(
                    color: Appcolors.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                'Contact Support',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: Dimensions.font16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // -------- Collapsing header --------
  Widget _buildHeaderSliver() {
    return SliverAppBar(
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
