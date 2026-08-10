import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/features/drawer/views/custom_drawer.dart';
import 'package:custom_books/features/reports/views/report_detail_page.dart';
import 'package:custom_books/features/reports/models/report_type.dart';
import 'package:flutter/material.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  @override
  void initState() {
    super.initState();
    appLog('📊 ReportsPage initialized', name: 'ReportsPage');
  }

  void _openReport(ReportType reportType) {
    appLog('📊 Opening report: ${reportType.title}', name: 'ReportsPage');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ReportDetailPage(reportType: reportType),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);

    return Scaffold(
      backgroundColor: context.colors.background,
      drawer: const DrawerView(currentRoute: 'reports'),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            const CustomSliverAppBar(
              title: 'Reports',
              leadingType: AppBarLeadingType.menu,
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  SizedBox(height: Dimensions.height10),

                  // Financial Reports
                  _buildSectionHeader('Financial Reports'),
                  _buildReportTile(ReportType.balanceSheet),
                  _buildReportTile(ReportType.profitAndLoss),
                  _buildReportTile(ReportType.cashFlowStatement),

                  SizedBox(height: Dimensions.height20),

                  // Sales
                  _buildSectionHeader('Sales'),
                  _buildReportTile(ReportType.salesByCustomer),
                  _buildReportTile(ReportType.salesByItem),
                  _buildReportTile(ReportType.salesBySalesPerson),

                  SizedBox(height: Dimensions.height20),

                  // Receivables
                  _buildSectionHeader('Receivables'),
                  _buildReportTile(ReportType.customerBalanceSummary),
                  _buildReportTile(ReportType.arAgingSummary),
                  _buildReportTile(ReportType.arAgingDetails),
                  _buildReportTile(ReportType.paymentsReceived),

                  SizedBox(height: Dimensions.height20),

                  // Expenses
                  _buildSectionHeader('Expenses'),
                  _buildReportTile(ReportType.expensesByCategory),

                  SizedBox(height: Dimensions.height20),

                  // Payables
                  _buildSectionHeader('Payables'),
                  _buildReportTile(ReportType.paymentsMade),
                  _buildReportTile(ReportType.vendorBalanceSummary),

                  SizedBox(height: Dimensions.height30),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: Dimensions.height10),
      child: Text(
        title,
        style: TextStyle(
          fontSize: Dimensions.font16 * 0.9,
          fontWeight: FontWeight.w700,
          color: Appcolors.primary,
        ),
      ),
    );
  }

  Widget _buildReportTile(ReportType reportType) {
    return Column(
      children: [
        InkWell(
          onTap: () => _openReport(reportType),
          borderRadius: BorderRadius.circular(Dimensions.radius15),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: Dimensions.height15),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    reportType.title,
                    style: TextStyle(
                      fontSize: Dimensions.font16,
                      fontWeight: FontWeight.w500,
                      color: context.colors.textPrimary,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  size: Dimensions.iconSize24,
                  color: context.colors.textTertiary,
                ),
              ],
            ),
          ),
        ),
        Divider(height: 1, color: context.colors.border),
      ],
    );
  }
}
