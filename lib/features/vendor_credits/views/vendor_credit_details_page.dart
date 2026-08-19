import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/date_formatter.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/core/widgets/detail_row.dart';
import 'package:custom_books/features/vendor_credits/models/vendor_credit_model.dart';
import 'package:custom_books/features/vendor_credits/views/add_vendor_credit_page.dart';
import 'package:flutter/material.dart';

class VendorCreditDetailsPage extends StatefulWidget {
  final VendorCreditModel credit;

  const VendorCreditDetailsPage({super.key, required this.credit});

  @override
  State<VendorCreditDetailsPage> createState() =>
      _VendorCreditDetailsPageState();
}

class _VendorCreditDetailsPageState extends State<VendorCreditDetailsPage>
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
    final credit = widget.credit;
    final statusColor = credit.status.color;

    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: Dimensions.height45 * 1.6,
              child: CustomScrollView(
                physics: const NeverScrollableScrollPhysics(),
                slivers: [
                  CustomSliverAppBar(
                    title: 'Vendor Credit Details',
                    leadingType: AppBarLeadingType.back,
                    actions: [
                      AppBarIconButton(
                        icon: Icons.edit_rounded,
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AddVendorCreditPage(),
                          ),
                        ),
                      ),
                      AppBarIconButton(
                        icon: Icons.more_vert_rounded,
                        color: AppColors.accent,
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            builder: (ctx) => Container(
                              decoration: BoxDecoration(
                                color: context.colors.card,
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(
                                    Dimensions.radius20 * 1.2,
                                  ),
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: Dimensions.width20 * 2,
                                    height: Dimensions.height10 * 0.4,
                                    margin: EdgeInsets.symmetric(
                                      vertical: Dimensions.height10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: context.colors.border,
                                      borderRadius: BorderRadius.circular(
                                        Dimensions.radius30,
                                      ),
                                    ),
                                  ),
                                  ListTile(
                                    leading: Icon(
                                      Icons.print_rounded,
                                      color: context.colors.textSecondary,
                                    ),
                                    title: Text(
                                      'Print',
                                      style: TextStyle(
                                        fontSize: Dimensions.font16 * 0.9,
                                        fontWeight: FontWeight.w600,
                                        color: context.colors.textPrimary,
                                      ),
                                    ),
                                    onTap: () => Navigator.pop(ctx),
                                  ),
                                  ListTile(
                                    leading: Icon(
                                      Icons.delete_outline_rounded,
                                      color: AppColors.warn,
                                    ),
                                    title: Text(
                                      'Delete',
                                      style: TextStyle(
                                        fontSize: Dimensions.font16 * 0.9,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.warn,
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.pop(ctx);
                                      showDialog(
                                        context: context,
                                        builder: (dlgCtx) => AlertDialog(
                                          backgroundColor: context.colors.card,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              Dimensions.radius20,
                                            ),
                                          ),
                                          title: Text(
                                            'Delete Vendor Credit',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: Dimensions.font20,
                                            ),
                                          ),
                                          content: Text(
                                            'Are you sure you want to delete this vendor credit? This action cannot be undone.',
                                            style: TextStyle(
                                              color:
                                                  context.colors.textSecondary,
                                              fontSize: Dimensions.font16 * 0.9,
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(dlgCtx),
                                              child: Text(
                                                'Cancel',
                                                style: TextStyle(
                                                  color: context
                                                      .colors
                                                      .textSecondary,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(dlgCtx);
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                'Delete',
                                                style: TextStyle(
                                                  color: AppColors.warn,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                  SizedBox(height: Dimensions.height20),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(width: Dimensions.width10),
                    ],
                  ),
                ],
              ),
            ),
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
                        'Credit Date',
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
                          credit.status.label,
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
                    formatDate(credit.creditDate),
                    style: TextStyle(
                      fontSize: Dimensions.font20 * 0.95,
                      fontWeight: FontWeight.w800,
                      color: context.colors.textPrimary,
                    ),
                  ),
                  SizedBox(height: Dimensions.height20),
                  Text(
                    credit.vendorName,
                    style: TextStyle(
                      fontSize: Dimensions.font20 * 0.95,
                      fontWeight: FontWeight.w800,
                      color: context.colors.textPrimary,
                    ),
                  ),
                  SizedBox(height: Dimensions.height10 / 2.5),
                  Text(
                    credit.creditNoteNumber,
                    style: TextStyle(
                      fontSize: Dimensions.font16 * 0.85,
                      fontWeight: FontWeight.w600,
                      color: context.colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: Dimensions.height15),

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
                    color: AppColors.primary.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      blurRadius: Dimensions.radius15 * 0.53,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: AppColors.primary,
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
    final credit = widget.credit;
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
                label: 'Reference#:',
                value: credit.referenceNumber.isEmpty
                    ? '—'
                    : credit.referenceNumber,
              ),
              SizedBox(height: Dimensions.height15),
              DetailRow(
                label: 'Amount:',
                value: '₹${credit.total.toStringAsFixed(2)}',
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
                color: AppColors.primary.withValues(alpha: 0.07),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.history_rounded,
                size: Dimensions.iconSize24 * 2,
                color: AppColors.primary,
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
