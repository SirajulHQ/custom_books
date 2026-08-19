import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:flutter/material.dart';

class PaymentGatewaysPage extends StatefulWidget {
  const PaymentGatewaysPage({super.key});

  @override
  State<PaymentGatewaysPage> createState() => _PaymentGatewaysPageState();
}

class _PaymentGatewaysPageState extends State<PaymentGatewaysPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  static const List<String> _tabs = [
    'CREDIT/DEBIT CARD',
    'IDEAL',
    'GIROPAY',
    'BANCONTACT',
    'SOFORT',
    'ALIPAY',
    'KLARNA',
    'PAYNOW',
    'GRABPAY',
    'OTHERS',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    appLog('💳 PaymentGatewaysPage initialized', name: 'PaymentGateways');
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            const CustomSliverAppBar(
              title: 'Online Payment Gateways',
              leadingType: AppBarLeadingType.back,
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _TabBarDelegate(
                tabBar: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  labelColor: AppColors.primary,
                  unselectedLabelColor: context.colors.textSecondary,
                  labelStyle: TextStyle(
                    fontSize: Dimensions.font16 * 0.8,
                    fontWeight: FontWeight.w700,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontSize: Dimensions.font16 * 0.8,
                    fontWeight: FontWeight.w500,
                  ),
                  indicatorColor: AppColors.primary,
                  indicatorWeight: 3,
                  tabAlignment: TabAlignment.start,
                  dividerColor: context.colors.border,
                  tabs: _tabs.map((t) => Tab(text: t)).toList(),
                ),
                backgroundColor: context.colors.background,
              ),
            ),
          ],
          body: TabBarView(
            controller: _tabController,
            children: [
              // CREDIT/DEBIT CARD
              _buildCreditDebitCardTab(),
              // IDEAL
              _buildSingleGatewayTab('Stripe'),
              // GIROPAY
              _buildSingleGatewayTab('Stripe'),
              // BANCONTACT
              _buildSingleGatewayTab('Stripe'),
              // SOFORT
              _buildSingleGatewayTab('Stripe'),
              // ALIPAY
              _buildSingleGatewayTab('Stripe'),
              // KLARNA
              _buildSingleGatewayTab('Stripe'),
              // PAYNOW
              _buildSingleGatewayTab('Stripe'),
              // GRABPAY
              _buildSingleGatewayTab('Stripe'),
              // OTHERS
              _buildSingleGatewayTab('Stripe'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCreditDebitCardTab() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.all(Dimensions.width15),
      children: [
        _buildGatewayCard(
          name: 'Stripe',
          isPreferred: true,
          description:
              'Stripe is an online payment processing platform that allows you to receive one-time and recurring payments securely from customers.',
        ),
        SizedBox(height: Dimensions.height15),
        _buildGatewayCard(
          name: 'PayTabs',
          isPreferred: false,
          description:
              'PayTabs is a simple payment gateway that will allow you to accept payments in nearly 168 currencies from your customers across the globe. This is ideal for businesses that sell globally.',
        ),
        SizedBox(height: Dimensions.height15),
        _buildGatewayCard(
          name: '2Checkout (Verifone)',
          isPreferred: false,
          description:
              '2Checkout enables businesses to accept mobile and online payments from buyers worldwide. It is ideal for businesses that sell products internationally.',
        ),
        SizedBox(height: Dimensions.height15),
        _buildGatewayCard(
          name: 'Braintree',
          isPreferred: false,
          description:
              'Braintree Payments is an all-in-one solution to accept and process payments in your mobile and on the web. Set up Braintree to accept payments in multiple currencies from over 45+ countries.',
        ),
      ],
    );
  }

  Widget _buildSingleGatewayTab(String gatewayName) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.all(Dimensions.width15),
      children: [
        _buildGatewayCard(
          name: gatewayName,
          isPreferred: true,
          description:
              'Stripe is an online payment processing platform that allows you to receive one-time and recurring payments securely from customers.',
        ),
      ],
    );
  }

  Widget _buildGatewayCard({
    required String name,
    required bool isPreferred,
    required String description,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Dimensions.width20),
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: BorderRadius.circular(Dimensions.radius15),
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gateway Name & Badge
          Row(
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: Dimensions.font16 * 1.2,
                  fontWeight: FontWeight.w800,
                  color: context.colors.textPrimary,
                ),
              ),
              if (isPreferred) ...[
                SizedBox(width: Dimensions.width10),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.width10,
                    vertical: Dimensions.height10 * 0.3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.warning,
                    borderRadius: BorderRadius.circular(
                      Dimensions.radius15 * 0.27,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.star_rounded,
                        size: Dimensions.iconSize16 * 0.8,
                        color: Colors.white,
                      ),
                      SizedBox(width: Dimensions.width10 * 0.2),
                      Text(
                        'Preferred',
                        style: TextStyle(
                          fontSize: Dimensions.font16 * 0.65,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: Dimensions.height10),

          // Description
          Text(
            description,
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.85,
              color: context.colors.textSecondary,
              height: 1.5,
            ),
          ),
          SizedBox(height: Dimensions.height15),

          // Setup Button
          OutlinedButton(
            onPressed: () {
              appLog('🔧 Setup $name tapped', name: 'PaymentGateways');
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary, width: 1.5),
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.width20,
                vertical: Dimensions.height10,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Dimensions.radius30),
              ),
            ),
            child: Text(
              'Setup',
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.85,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  final Color backgroundColor;

  _TabBarDelegate({required this.tabBar, required this.backgroundColor});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: backgroundColor, child: tabBar);
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(covariant _TabBarDelegate oldDelegate) {
    return tabBar != oldDelegate.tabBar;
  }
}
