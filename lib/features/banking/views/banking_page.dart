import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/core/widgets/skeletons/skeletons.dart';
import 'package:custom_books/features/banking/models/bank_account.dart';
import 'package:custom_books/features/banking/views/add_bank_account_page.dart';
import 'package:custom_books/features/banking/widgets/bank_account_card.dart';
import 'package:custom_books/core/widgets/more_options_sheet.dart';
import 'package:custom_books/features/banking/widgets/banking_summary_card.dart';
import 'package:custom_books/features/banking/widgets/active_account_item.dart';
import 'package:custom_books/features/banking/widgets/banking_filter_button.dart';
import 'package:custom_books/features/banking/widgets/banking_selection_sheet.dart';
import 'package:custom_books/features/drawer/views/custom_drawer.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BankingPage extends StatefulWidget {
  const BankingPage({super.key});

  @override
  State<BankingPage> createState() => _BankingPageState();
}

class _BankingPageState extends State<BankingPage> {
  String _selectedAccountFilter = 'All Accounts';
  String _selectedDateFilter = 'Last 30 days';
  bool _isLoading = true;

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
  void initState() {
    super.initState();
    _loadAccounts();
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// Simulates fetching data so the shimmer skeleton is shown briefly.
  Future<void> _loadAccounts() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
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
                  color: AppColors.primary,
                  onPressed: () {
                    BankingSelectionSheet.show(
                      context,
                      title: 'Select Account',
                      options: _accountFilterOptions,
                      selectedOption: _selectedAccountFilter,
                      onSelected: (filter) {
                        setState(() {
                          _selectedAccountFilter = filter;
                        });
                      },
                    );
                  },
                ),
                SizedBox(width: Dimensions.width10),
                AppBarIconButton(
                  icon: Icons.more_vert_rounded,
                  color: AppColors.accent,
                  onPressed: () {
                    MoreOptionsSheet.show(
                      context,
                      sectionLabel: 'BANKING ACTIONS',
                      items: [
                        MoreOptionsItem(
                          icon: Icons.file_download_outlined,
                          title: 'Export Statement',
                          subtitle: 'Export your bank account statement',
                          onTap: () => ToastificationHelper.showInfo(
                            context,
                            'Exporting statements is coming soon.',
                          ),
                        ),
                        MoreOptionsItem(
                          icon: Icons.refresh_rounded,
                          title: 'Refresh',
                          subtitle: 'Reload the latest banking data',
                          onTap: () {
                            setState(() {});
                            ToastificationHelper.showSuccess(
                              context,
                              'Banking refreshed.',
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(width: Dimensions.width20),
              ],
            ),

            // Filter Buttons
            SliverToBoxAdapter(
              child: Padding(
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
                        child: BankingFilterButton(
                          label: _selectedAccountFilter,
                          onTap: () {
                            BankingSelectionSheet.show(
                              context,
                              title: 'Select Account',
                              options: _accountFilterOptions,
                              selectedOption: _selectedAccountFilter,
                              onSelected: (filter) {
                                setState(() {
                                  _selectedAccountFilter = filter;
                                });
                              },
                            );
                          },
                        ),
                      ),
                      SizedBox(width: Dimensions.width10 * 0.4),
                      Expanded(
                        child: BankingFilterButton(
                          label: _selectedDateFilter,
                          icon: Icons.calendar_today_rounded,
                          onTap: () {
                            BankingSelectionSheet.show(
                              context,
                              title: 'Select Date Range',
                              options: _dateFilterOptions,
                              selectedOption: _selectedDateFilter,
                              onSelected: (filter) {
                                setState(() {
                                  _selectedDateFilter = filter;
                                });
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Account Summary Cards
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  Dimensions.width20,
                  0,
                  Dimensions.width20,
                  Dimensions.height20,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: BankAccountCard(
                        icon: Icons.payments_rounded,
                        iconBgColor: AppColors.primary,
                        title: 'Cash In Hand',
                        amount: '₹${cashInHand.toStringAsFixed(2)}',
                      ),
                    ),
                    SizedBox(width: Dimensions.width15),
                    Expanded(
                      child: BankAccountCard(
                        icon: Icons.account_balance_rounded,
                        iconBgColor: AppColors.success,
                        title: 'Bank Balance',
                        amount: '₹${bankBalance.toStringAsFixed(2)}',
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Banking Summary Chart
            SliverToBoxAdapter(
              child: BankingSummaryCard(
                chartData: chartData,
                cashInHand: cashInHand,
                bankBalance: bankBalance,
              ),
            ),

            // Active Accounts Header
            SliverToBoxAdapter(
              child: Padding(
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
              ),
            ),

            // Active Accounts List
            if (_isLoading)
              const SliverToBoxAdapter(child: DocumentListSkeleton())
            else
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

            SliverToBoxAdapter(
              child: SizedBox(
                height: Dimensions.height30 + Dimensions.listBottomSpace,
              ),
            ),
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
        backgroundColor: AppColors.primary,
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
}
