import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/date_formatter.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/widgets/custom_back_appbar.dart';
import 'package:custom_books/core/widgets/detail_row.dart';
import 'package:custom_books/features/expenses/models/expense_model.dart';
import 'package:custom_books/features/expenses/views/add_expense_page.dart';
import 'package:flutter/material.dart';

class ExpenseDetailsPage extends StatefulWidget {
  final ExpenseModel expense;

  const ExpenseDetailsPage({super.key, required this.expense});

  @override
  State<ExpenseDetailsPage> createState() => _ExpenseDetailsPageState();
}

class _ExpenseDetailsPageState extends State<ExpenseDetailsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);
    final expense = widget.expense;
    final statusColor = expense.status.color;

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: CustomBackAppBar(
        title: 'Expense Details',
        backgroundColor: context.colors.card,
        actions: [
          IconButton(
            icon: Icon(
              Icons.edit_rounded,
              color: context.colors.textSecondary,
              size: Dimensions.iconSize24 - 2,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddExpensePage()),
              );
            },
          ),
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert_rounded,
              color: context.colors.textSecondary,
              size: Dimensions.iconSize24 - 2,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius15),
            ),
            surfaceTintColor: context.colors.card,
            color: context.colors.card,
            elevation: 8,
            onSelected: (value) {
              if (value == 'print') {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Print functionality coming soon'),
                    duration: const Duration(seconds: 2),
                    backgroundColor: context.colors.textSecondary,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Dimensions.radius15),
                    ),
                  ),
                );
              } else if (value == 'delete') {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    backgroundColor: context.colors.card,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Dimensions.radius20),
                    ),
                    title: Text(
                      'Delete Expense',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: Dimensions.font20,
                      ),
                    ),
                    content: Text(
                      'Are you sure you want to delete this expense? This action cannot be undone.',
                      style: TextStyle(
                        color: context.colors.textSecondary,
                        fontSize: Dimensions.font16 * 0.9,
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: context.colors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Delete',
                          style: TextStyle(
                            color: Appcolors.warn,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'print',
                child: Row(
                  children: [
                    Icon(
                      Icons.print_rounded,
                      size: Dimensions.iconSize16 + 4,
                      color: context.colors.textSecondary,
                    ),
                    SizedBox(width: Dimensions.width10),
                    Text(
                      'Print',
                      style: TextStyle(
                        fontSize: Dimensions.font16 * 0.85,
                        fontWeight: FontWeight.w600,
                        color: context.colors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(
                      Icons.delete_outline_rounded,
                      size: Dimensions.iconSize16 + 4,
                      color: Appcolors.warn,
                    ),
                    SizedBox(width: Dimensions.width10),
                    Text(
                      'Delete',
                      style: TextStyle(
                        fontSize: Dimensions.font16 * 0.85,
                        fontWeight: FontWeight.w600,
                        color: Appcolors.warn,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(width: Dimensions.width10),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header section with date, category, vendor and status
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(Dimensions.width20),
              decoration: BoxDecoration(
                color: context.colors.card,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x08000000),
                    blurRadius: Dimensions.radius15 * 0.53,
                    offset: const Offset(0, 2),
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
                        'Date',
                        style: TextStyle(
                          fontSize: Dimensions.font16 * 0.7,
                          color: context.colors.textSecondary,
                          fontWeight: FontWeight.w500,
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
                          expense.status.label,
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
                  SizedBox(height: Dimensions.height10 / 2.5),
                  Text(
                    formatDate(expense.expenseDate),
                    style: TextStyle(
                      fontSize: Dimensions.font20 * 0.95,
                      fontWeight: FontWeight.w800,
                      color: context.colors.textPrimary,
                    ),
                  ),
                  SizedBox(height: Dimensions.height20),
                  Text(
                    'Category',
                    style: TextStyle(
                      fontSize: Dimensions.font16 * 0.7,
                      color: context.colors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: Dimensions.height10 / 2.5),
                  Text(
                    expense.category,
                    style: TextStyle(
                      fontSize: Dimensions.font20 * 0.95,
                      fontWeight: FontWeight.w800,
                      color: context.colors.textPrimary,
                    ),
                  ),
                  if (expense.vendorName.isNotEmpty) ...[
                    SizedBox(height: Dimensions.height10 / 2.5),
                    Text(
                      expense.vendorName,
                      style: TextStyle(
                        fontSize: Dimensions.font16 * 0.85,
                        fontWeight: FontWeight.w600,
                        color: context.colors.textSecondary,
                      ),
                    ),
                  ],
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
                    color: Appcolors.primary.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Appcolors.primary.withValues(alpha: 0.08),
                      blurRadius: Dimensions.radius15 * 0.53,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Appcolors.primary,
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

            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [_buildDetailsTab(), _buildCommentsTab()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsTab() {
    final expense = widget.expense;
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
                color: const Color(0x08000000),
                blurRadius: Dimensions.radius15 * 0.53,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DetailRow(
                label: 'Vendor:',
                value: expense.vendorName.isEmpty ? '—' : expense.vendorName,
              ),
              SizedBox(height: Dimensions.height15),
              DetailRow(
                label: 'Reference#:',
                value: expense.referenceNumber.isEmpty
                    ? '—'
                    : expense.referenceNumber,
              ),
              SizedBox(height: Dimensions.height15),
              DetailRow(
                label: 'Amount:',
                value: '₹${expense.amount.toStringAsFixed(2)}',
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
                color: Appcolors.primary.withValues(alpha: 0.07),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.history_rounded,
                size: Dimensions.iconSize24 * 2,
                color: Appcolors.primary,
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
