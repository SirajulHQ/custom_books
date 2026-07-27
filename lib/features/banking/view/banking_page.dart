import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/features/banking/models/bank_account.dart';
import 'package:custom_books/features/banking/view/add_bank_account_page.dart';
import 'package:custom_books/features/banking/widgets/account_card.dart';
import 'package:custom_books/features/banking/widgets/active_account_item.dart';
import 'package:custom_books/features/banking/widgets/banking_chart.dart';
import 'package:custom_books/features/drawer/view/custom_drawer.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BankingPage extends StatefulWidget {
  const BankingPage({super.key});

  @override
  State<BankingPage> createState() => _BankingPageState();
}

class _BankingPageState extends State<BankingPage> {
  bool _isChartVisible = false;
  String _selectedAccountFilter = 'All Accounts';
  String _selectedDateFilter = 'Last 30 days';

  // Filter options
  final List<String> _accountFilterOptions = [
    'All Accounts',
    'ADBC',
    'Petty Cash',
    'Undeposited Funds',
  ];

  final List<String> _dateFilterOptions = [
    'Last 30 days',
    'Last 60 days',
    'Last 90 days',
    'This Month',
    'Last Month',
    'This Quarter',
    'This Year',
  ];

  // Sample data
  final double cashInHand = 6135.00;
  final double bankBalance = 306.73;

  // Sample chart data
  final List<FlSpot> chartData = [
    const FlSpot(0, 100),
    const FlSpot(1, 150),
    const FlSpot(2, 200),
    const FlSpot(3, 800),
    const FlSpot(4, 1000),
    const FlSpot(5, 1200),
    const FlSpot(6, 5000),
    const FlSpot(7, 5200),
    const FlSpot(8, 5500),
    const FlSpot(9, 5500),
    const FlSpot(10, 5500),
    const FlSpot(15, 5500),
    const FlSpot(20, 6000),
    const FlSpot(25, 6200),
    const FlSpot(29, 6200),
  ];

  // Sample accounts
  final List<BankAccount> accounts = [
    BankAccount(
      id: '1',
      name: 'ADBC',
      icon: 'bank',
      amountInZohoBooks: 306.73,
      amountInBank: 0.00,
    ),
    BankAccount(
      id: '2',
      name: 'Petty Cash',
      icon: 'cash',
      amountInZohoBooks: 1528.00,
      amountInBank: 0.00,
    ),
    BankAccount(
      id: '3',
      name: 'Undeposited Funds',
      icon: 'undeposited',
      amountInZohoBooks: 4607.00,
      amountInBank: 0.00,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);

    return Scaffold(
      backgroundColor: context.colors.background,
      drawer: const DrawerView(currentRoute: 'banking'),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // App Bar
            CustomSliverAppBar(
              title: 'Banking Overview',
              subtitle: 'Track your accounts & transactions',
              leadingType: AppBarLeadingType.menu,
              actions: [
                AppBarIconButton(
                  icon: Icons.filter_list_rounded,
                  color: Appcolors.primary,
                ),
                SizedBox(width: Dimensions.width10),
                AppBarIconButton(
                  icon: Icons.more_vert_rounded,
                  color: Appcolors.accent,
                ),
                SizedBox(width: Dimensions.width20),
              ],
            ),

            // Filter Buttons
            SliverToBoxAdapter(child: _buildFilterSection()),

            // Account Summary Cards
            SliverToBoxAdapter(child: _buildAccountCards()),

            // Banking Summary Chart
            SliverToBoxAdapter(child: _buildBankingSummary()),

            // Active Accounts Header
            SliverToBoxAdapter(child: _buildActiveAccountsHeader()),

            // Active Accounts List
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) =>
                      ActiveAccountItem(account: accounts[index]),
                  childCount: accounts.length,
                ),
              ),
            ),

            SliverToBoxAdapter(child: SizedBox(height: Dimensions.height30)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddBankAccountPage()),
          );
        },
        backgroundColor: Appcolors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radius20),
        ),
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: Dimensions.iconSize24 * 1.2,
        ),
      ),
    );
  }

  Widget _buildFilterSection() {
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
          children: [
            Expanded(
              child: _buildFilterButton(
                _selectedAccountFilter,
                null,
                isFirst: true,
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: _buildFilterButton(
                _selectedDateFilter,
                Icons.calendar_today_rounded,
                isFirst: false,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(
    String label,
    IconData? icon, {
    required bool isFirst,
  }) {
    return GestureDetector(
      onTap: () {
        if (isFirst) {
          _showAccountFilterSheet();
        } else {
          _showDateFilterSheet();
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: Dimensions.height10),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(Dimensions.radius30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: Dimensions.iconSize16,
                color: context.colors.textSecondary,
              ),
              SizedBox(width: Dimensions.width10 / 2),
            ],
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: Dimensions.font16 * 0.75,
                  fontWeight: FontWeight.w500,
                  color: context.colors.textSecondary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: Dimensions.width10 / 3),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: Dimensions.iconSize16,
              color: context.colors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  void _showAccountFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: context.colors.card,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(Dimensions.radius20),
              topRight: Radius.circular(Dimensions.radius20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.width20,
                  vertical: Dimensions.height15,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: context.colors.border, width: 1),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Select Account',
                      style: TextStyle(
                        fontSize: Dimensions.font20,
                        fontWeight: FontWeight.w700,
                        color: context.colors.textPrimary,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.close_rounded,
                        size: Dimensions.iconSize24,
                        color: context.colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              // Filter options
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.all(Dimensions.width20),
                itemCount: _accountFilterOptions.length,
                itemBuilder: (context, index) {
                  final filter = _accountFilterOptions[index];
                  final isSelected = filter == _selectedAccountFilter;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedAccountFilter = filter;
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: Dimensions.height10),
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.width15,
                        vertical: Dimensions.height15,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Appcolors.primary.withValues(alpha: 0.05)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(
                          Dimensions.radius15,
                        ),
                        border: Border.all(
                          color: isSelected
                              ? Appcolors.primary
                              : context.colors.border,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            filter,
                            style: TextStyle(
                              fontSize: Dimensions.font16,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                              color: isSelected
                                  ? Appcolors.primary
                                  : context.colors.textPrimary,
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              Icons.check_circle,
                              color: Appcolors.primary,
                              size: Dimensions.iconSize24,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              SizedBox(height: Dimensions.height10),
            ],
          ),
        );
      },
    );
  }

  void _showDateFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: context.colors.card,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(Dimensions.radius20),
              topRight: Radius.circular(Dimensions.radius20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.width20,
                  vertical: Dimensions.height15,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: context.colors.border, width: 1),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Select Date Range',
                      style: TextStyle(
                        fontSize: Dimensions.font20,
                        fontWeight: FontWeight.w700,
                        color: context.colors.textPrimary,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.close_rounded,
                        size: Dimensions.iconSize24,
                        color: context.colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              // Filter options
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.all(Dimensions.width20),
                itemCount: _dateFilterOptions.length,
                itemBuilder: (context, index) {
                  final filter = _dateFilterOptions[index];
                  final isSelected = filter == _selectedDateFilter;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDateFilter = filter;
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: Dimensions.height10),
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.width15,
                        vertical: Dimensions.height15,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Appcolors.primary.withValues(alpha: 0.05)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(
                          Dimensions.radius15,
                        ),
                        border: Border.all(
                          color: isSelected
                              ? Appcolors.primary
                              : context.colors.border,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            filter,
                            style: TextStyle(
                              fontSize: Dimensions.font16,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                              color: isSelected
                                  ? Appcolors.primary
                                  : context.colors.textPrimary,
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              Icons.check_circle,
                              color: Appcolors.primary,
                              size: Dimensions.iconSize24,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              SizedBox(height: Dimensions.height10),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAccountCards() {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        Dimensions.width20,
        0,
        Dimensions.width20,
        Dimensions.height20,
      ),
      child: Row(
        children: [
          Expanded(
            child: AccountCard(
              icon: Icons.payments_rounded,
              iconBgColor: Appcolors.primary,
              title: 'Cash In Hand',
              amount: 'AED${cashInHand.toStringAsFixed(2)}',
            ),
          ),
          SizedBox(width: Dimensions.width15),
          Expanded(
            child: AccountCard(
              icon: Icons.account_balance_rounded,
              iconBgColor: Appcolors.success,
              title: 'Bank Balance',
              amount: 'AED${bankBalance.toStringAsFixed(2)}',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBankingSummary() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: Dimensions.width20),
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: BorderRadius.circular(Dimensions.radius15),
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        children: [
          // Header with Hide/Show button
          Padding(
            padding: EdgeInsets.all(Dimensions.width20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Banking Summary',
                  style: TextStyle(
                    fontSize: Dimensions.font20 * 0.95,
                    color: context.colors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isChartVisible = !_isChartVisible;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.width15 * 0.8,
                      vertical: Dimensions.height10 / 2,
                    ),
                    decoration: BoxDecoration(
                      color: Appcolors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(Dimensions.radius20),
                    ),
                    child: Row(
                      children: [
                        Text(
                          _isChartVisible ? 'Hide' : 'Show',
                          style: TextStyle(
                            fontSize: Dimensions.font16 * 0.8,
                            color: Appcolors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: Dimensions.width10 / 3),
                        Icon(
                          _isChartVisible
                              ? Icons.keyboard_arrow_up_rounded
                              : Icons.keyboard_arrow_down_rounded,
                          color: Appcolors.primary,
                          size: Dimensions.iconSize16,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Chart (conditionally shown)
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: _isChartVisible
                ? BankingChart(
                    dataPoints: chartData,
                    cashInHand: cashInHand,
                    bankBalance: bankBalance,
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveAccountsHeader() {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        Dimensions.width20,
        Dimensions.height20,
        Dimensions.width20,
        Dimensions.height15,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Active Accounts',
            style: TextStyle(
              fontSize: Dimensions.font20 * 0.95,
              color: context.colors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            '${accounts.length} accounts',
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.75,
              color: context.colors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
