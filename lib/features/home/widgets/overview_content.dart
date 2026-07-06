import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/dummy_data/dummy_data_list.dart';
import 'package:custom_books/features/home/widgets/cash_flow_card.dart';
import 'package:custom_books/features/home/models/income_expense_point.dart';
import 'package:flutter/material.dart';

class OverviewContent extends StatefulWidget {
  const OverviewContent({super.key});

  @override
  State<OverviewContent> createState() => _OverviewContentState();
}

class _OverviewContentState extends State<OverviewContent> {
  bool _isAccrual = true;

  @override
  Widget build(BuildContext context) {
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
