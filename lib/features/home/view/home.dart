import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/dummy_data/cash_flow_point.dart';
import 'package:custom_books/features/drawer/view/custom_drawer.dart';
import 'package:custom_books/features/home/widgets/cash_flow_card.dart';
import 'package:flutter/material.dart';

class OwnStoreDashboardPage extends StatefulWidget {
  const OwnStoreDashboardPage({super.key});

  @override
  State<OwnStoreDashboardPage> createState() => _OwnStoreDashboardPageState();
}

class _OwnStoreDashboardPageState extends State<OwnStoreDashboardPage> {
  int _selectedSegment = 0;
  bool _isAccrual = true;

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
          _buildBalancesGrid(),
          SizedBox(height: Dimensions.height20),
          _buildQuickActionsGrid(),
          SizedBox(height: Dimensions.height20),
          _buildBankingStrip(),
          SizedBox(height: Dimensions.height20),
          const CashFlowCard(),
          SizedBox(height: Dimensions.height20),
          _buildIncomeExpenseCard(),
          SizedBox(height: Dimensions.height20),
          _buildProjectTimerCard(),
          SizedBox(height: Dimensions.height20),
          _buildExpenseBreakdownCard(),
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

  // -------- Balances grid (2x2 instead of a wide split row) --------
  Widget _buildBalancesGrid() {
    final tiles = [
      _BalanceTileData(
        'Receivables',
        'AED5,886.00',
        Icons.call_received_rounded,
        Appcolors.primary,
      ),
      _BalanceTileData(
        'Payables',
        'AED0.00',
        Icons.call_made_rounded,
        Appcolors.accent,
      ),
      _BalanceTileData(
        'Overdue Invoices',
        '6',
        Icons.error_outline_rounded,
        Appcolors.warn,
      ),
      _BalanceTileData(
        'Overdue Bills',
        '0',
        Icons.check_circle_outline_rounded,
        Appcolors.ok,
      ),
    ];
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: Dimensions.height15,
      crossAxisSpacing: Dimensions.width15,
      childAspectRatio: 1.5,
      children: tiles.map((t) => _balanceTile(t)).toList(),
    );
  }

  Widget _balanceTile(_BalanceTileData data) {
    return Container(
      padding: EdgeInsets.all(Dimensions.width15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Dimensions.radius20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: data.color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              data.icon,
              size: Dimensions.iconSize16,
              color: data.color,
            ),
          ),
          Text(
            data.value,
            style: TextStyle(
              fontSize: Dimensions.font20,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF0F172A),
            ),
          ),
          Text(
            data.label,
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.75,
              color: Colors.black54,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // -------- Quick actions grid (replaces the icon row) --------
  Widget _buildQuickActionsGrid() {
    final items = [
      _ActionItem(
        Icons.person_add_alt_1_rounded,
        'Customer',
        Appcolors.primary,
      ),
      _ActionItem(Icons.note_add_rounded, 'Invoice', Appcolors.primaryLight),
      _ActionItem(Icons.assignment_rounded, 'Bill', Appcolors.accent),
      _ActionItem(Icons.shopping_bag_rounded, 'Expense', Appcolors.warn),
    ];
    return Container(
      padding: EdgeInsets.all(Dimensions.width15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Dimensions.radius20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: Dimensions.font16,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: Dimensions.height15),
          Wrap(
            spacing: Dimensions.width10,
            runSpacing: Dimensions.height15,
            children: items.map((item) {
              return SizedBox(
                width:
                    (Dimensions.screenWidth -
                        Dimensions.width20 * 2 -
                        Dimensions.width15 * 2 -
                        Dimensions.width10 * 3) /
                    4,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(Dimensions.width15 * 0.7),
                      decoration: BoxDecoration(
                        color: item.color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(
                          Dimensions.radius15,
                        ),
                      ),
                      child: Icon(
                        item.icon,
                        size: Dimensions.iconSize24 - 4,
                        color: item.color,
                      ),
                    ),
                    SizedBox(height: Dimensions.height10 / 2),
                    Text(
                      item.label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: Dimensions.font16 * 0.7,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // -------- Banking strip (horizontal scroll instead of a row of two cards) --------
  Widget _buildBankingStrip() {
    final entries = [
      _BankEntry('Bank Balance', 'AED306.73', Icons.account_balance_rounded),
      _BankEntry('Cash In Hand', 'AED6,135.00', Icons.wallet_rounded),
    ];
    return SizedBox(
      height: Dimensions.height45 * 2.3,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: entries.length,
        separatorBuilder: (_, index) => SizedBox(width: Dimensions.width15),
        itemBuilder: (context, i) {
          final e = entries[i];
          return Container(
            width: Dimensions.screenWidth * 0.55,
            padding: EdgeInsets.all(Dimensions.width15),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Appcolors.primary, Appcolors.primaryLight],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(Dimensions.radius20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  e.icon,
                  color: Colors.white,
                  size: Dimensions.iconSize24 - 4,
                ),
                Text(
                  e.value,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Dimensions.font20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  e.label,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: Dimensions.font16 * 0.8,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // -------- Helper method for card titles --------
  Widget _cardTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: Dimensions.iconSize16, color: Appcolors.primary),
        SizedBox(width: Dimensions.width10 / 2),
        Text(
          title,
          style: TextStyle(
            fontSize: Dimensions.font16 * 1.05,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  // -------- Income & Expense --------
  Widget _buildIncomeExpenseCard() {
    final totalIncome = incomeExpenseData.fold<double>(
      0,
      (p, e) => p + e.income,
    );
    final totalExpense = incomeExpenseData.fold<double>(
      0,
      (p, e) => p + e.expense,
    );
    return Container(
      padding: EdgeInsets.all(Dimensions.width15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Dimensions.radius20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _cardTitle('Income vs Expense', Icons.stacked_bar_chart_rounded),
              GestureDetector(
                onTap: () => setState(() => _isAccrual = !_isAccrual),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.width10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Appcolors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(Dimensions.radius30),
                  ),
                  child: Text(
                    _isAccrual ? 'Accrual' : 'Cash',
                    style: TextStyle(
                      fontSize: Dimensions.font16 * 0.75,
                      fontWeight: FontWeight.w700,
                      color: Appcolors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: Dimensions.height20),
          Row(
            children: [
              Expanded(
                child: _miniStat(
                  'Income',
                  totalIncome,
                  Appcolors.ok,
                  Icons.arrow_upward_rounded,
                ),
              ),
              SizedBox(width: Dimensions.width15),
              Expanded(
                child: _miniStat(
                  'Expense',
                  totalExpense,
                  Appcolors.warn,
                  Icons.arrow_downward_rounded,
                ),
              ),
            ],
          ),
          SizedBox(height: Dimensions.height20),
          SizedBox(
            height: Dimensions.screenHeight / 3.5,
            width: double.infinity,
            child: CustomPaint(
              painter: _GroupedBarPainter(
                data: incomeExpenseData,
                colorA: Appcolors.ok,
                colorB: Appcolors.warn,
              ),
            ),
          ),
          SizedBox(height: Dimensions.height10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: incomeExpenseData
                .map(
                  (e) => Text(
                    e.month,
                    style: TextStyle(
                      fontSize: Dimensions.font16 * 0.65,
                      color: Colors.black38,
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _miniStat(String label, double value, Color color, IconData icon) {
    return Container(
      padding: EdgeInsets.all(Dimensions.width10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(Dimensions.radius15),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: Dimensions.iconSize16),
          SizedBox(width: Dimensions.width10 / 2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.7,
                    color: Colors.black54,
                  ),
                ),
                Text(
                  'AED${value.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.95,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // -------- Project timer --------
  Widget _buildProjectTimerCard() {
    return Container(
      padding: EdgeInsets.all(Dimensions.width20),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(Dimensions.radius20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Project Timer',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: Dimensions.font16 * 0.85,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Icon(
                Icons.schedule_rounded,
                color: Appcolors.primaryLight,
                size: Dimensions.iconSize16,
              ),
            ],
          ),
          SizedBox(height: Dimensions.height10),
          Text(
            '00:00:00',
            style: TextStyle(
              color: Colors.white,
              fontSize: Dimensions.font26 * 1.3,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
            ),
          ),
          SizedBox(height: Dimensions.height20),
          Row(
            children: [
              Expanded(child: _outlineChip('Log Time', Colors.white)),
              SizedBox(width: Dimensions.width15),
              Expanded(
                child: _filledChip('Start Timer', Appcolors.primaryLight),
              ),
            ],
          ),
          SizedBox(height: Dimensions.height15),
          Row(
            children: [
              Expanded(child: _statChip('Unbilled Hours', '00:00')),
              SizedBox(width: Dimensions.width15),
              Expanded(child: _statChip('Unbilled Expenses', 'AED0.00')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _outlineChip(String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: Dimensions.height10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radius30),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: Dimensions.font16 * 0.85,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _filledChip(String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: Dimensions.height10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(Dimensions.radius30),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontSize: Dimensions.font16 * 0.85,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _statChip(String label, String value) {
    return Container(
      padding: EdgeInsets.all(Dimensions.width10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(Dimensions.radius15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white54,
              fontSize: Dimensions.font16 * 0.65,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: Dimensions.font16 * 0.9,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  // -------- Expense breakdown (list with trailing bars instead of a stacked bar + list) --------
  Widget _buildExpenseBreakdownCard() {
    final total = topExpenses.fold<double>(0, (p, e) => p + e.amount);
    return Container(
      padding: EdgeInsets.all(Dimensions.width15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Dimensions.radius20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _cardTitle('Expense Breakdown', Icons.donut_small_rounded),
              Text(
                'AED${total.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: Dimensions.font16,
                  fontWeight: FontWeight.w800,
                  color: Appcolors.accent,
                ),
              ),
            ],
          ),
          SizedBox(height: Dimensions.height20),
          ...topExpenses.map((e) {
            final ratio = total == 0 ? 0.0 : (e.amount / total).clamp(0.0, 1.0);
            return Padding(
              padding: EdgeInsets.symmetric(
                vertical: Dimensions.height10 / 1.5,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        e.label,
                        style: TextStyle(
                          fontSize: Dimensions.font16 * 0.85,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'AED${e.amount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: Dimensions.font16 * 0.85,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Dimensions.height10 / 2),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                      Dimensions.radius15 - 5,
                    ),
                    child: LinearProgressIndicator(
                      value: ratio,
                      minHeight: 6,
                      backgroundColor: const Color(0xFFE2E8F0),
                      valueColor: AlwaysStoppedAnimation(e.color),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ---------------- Small data holders ----------------

class _BalanceTileData {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  _BalanceTileData(this.label, this.value, this.icon, this.color);
}

class _ActionItem {
  final IconData icon;
  final String label;
  final Color color;
  _ActionItem(this.icon, this.label, this.color);
}

class _BankEntry {
  final String label;
  final String value;
  final IconData icon;
  _BankEntry(this.label, this.value, this.icon);
}

// ---------------- Custom Painters ----------------

class _GroupedBarPainter extends CustomPainter {
  final List<IncomeExpensePoint> data;
  final Color colorA;
  final Color colorB;
  _GroupedBarPainter({
    required this.data,
    required this.colorA,
    required this.colorB,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final maxVal = data
        .map((e) => e.income > e.expense ? e.income : e.expense)
        .reduce((a, b) => a > b ? a : b)
        .clamp(1, double.infinity);

    final groupWidth = size.width / data.length;
    final barWidth = groupWidth * 0.28;
    const radius = Radius.circular(4);

    final paintA = Paint()..color = colorA;
    final paintB = Paint()..color = colorB;

    for (int i = 0; i < data.length; i++) {
      final centerX = groupWidth * i + groupWidth / 2;

      final aHeight = (data[i].income / maxVal) * size.height;
      final aRect = RRect.fromRectAndCorners(
        Rect.fromLTWH(
          centerX - barWidth - 2,
          size.height - aHeight,
          barWidth,
          aHeight,
        ),
        topLeft: radius,
        topRight: radius,
      );
      canvas.drawRRect(aRect, paintA);

      final bHeight = (data[i].expense / maxVal) * size.height;
      final bRect = RRect.fromRectAndCorners(
        Rect.fromLTWH(centerX + 2, size.height - bHeight, barWidth, bHeight),
        topLeft: radius,
        topRight: radius,
      );
      canvas.drawRRect(bRect, paintB);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
