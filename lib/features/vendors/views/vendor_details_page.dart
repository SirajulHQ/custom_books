import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/features/vendors/models/vendor_model.dart';
import 'package:custom_books/features/vendors/views/add_vendor_page.dart';
import 'package:flutter/material.dart';

class VendorDetailsPage extends StatefulWidget {
  final VendorModel vendor;

  const VendorDetailsPage({super.key, required this.vendor});

  @override
  State<VendorDetailsPage> createState() => _VendorDetailsPageState();
}

class _VendorDetailsPageState extends State<VendorDetailsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  Color _statusColor(VendorStatus status) {
    switch (status) {
      case VendorStatus.active:
        return Appcolors.success;
      case VendorStatus.inactive:
        return context.colors.textTertiary;
    }
  }

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);

    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            CustomSliverAppBar(
              title: widget.vendor.displayName,
              leadingType: AppBarLeadingType.back,
              onLeadingPressed: () => Navigator.pop(context),
              actions: [
                AppBarIconButton(
                  icon: Icons.edit_outlined,
                  color: Appcolors.primary,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AddVendorPage()),
                    );
                  },
                ),
                SizedBox(width: Dimensions.width20),
              ],
            ),
            SliverToBoxAdapter(child: _buildHeaderSection()),
            SliverToBoxAdapter(child: _buildTabBar()),
            SliverFillRemaining(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildDetailsTab(),
                  _buildTransactionsTab(),
                  _buildCommentsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Dimensions.width20),
      decoration: BoxDecoration(
        color: context.colors.card,
        border: Border(
          bottom: BorderSide(color: context.colors.border, width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Payables',
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.75,
                    color: context.colors.textTertiary,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: Dimensions.height10 / 2),
                Text(
                  '₹${widget.vendor.payables.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: Dimensions.font26,
                    fontWeight: FontWeight.w800,
                    color: context.colors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: Dimensions.height45,
            width: 1,
            color: context.colors.border,
          ),
          SizedBox(width: Dimensions.width20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Unused Credits',
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.75,
                    color: context.colors.textTertiary,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: Dimensions.height10 / 2),
                Text(
                  '₹${widget.vendor.unusedCredits.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: Dimensions.font26,
                    fontWeight: FontWeight.w800,
                    color: context.colors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.card,
        border: Border(
          bottom: BorderSide(color: context.colors.border, width: 1),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: Appcolors.primary,
        unselectedLabelColor: context.colors.textSecondary,
        labelStyle: TextStyle(
          fontSize: Dimensions.font16 * 0.8,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: Dimensions.font16 * 0.8,
          fontWeight: FontWeight.w600,
        ),
        indicatorColor: Appcolors.primary,
        indicatorWeight: 3,
        tabs: const [
          Tab(text: 'DETAILS'),
          Tab(text: 'TRANSACTIONS'),
          Tab(text: 'COMMENTS'),
        ],
      ),
    );
  }

  Widget _buildDetailsTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          SizedBox(height: Dimensions.height20),
          _buildContactInformationSection(),
          SizedBox(height: Dimensions.height30),
        ],
      ),
    );
  }

  Widget _buildContactInformationSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: Dimensions.width20),
      padding: EdgeInsets.all(Dimensions.width20),
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: BorderRadius.circular(Dimensions.radius15),
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'CONTACT INFORMATION',
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.7,
                    fontWeight: FontWeight.w700,
                    color: context.colors.textTertiary,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.width10 + 2,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: _statusColor(
                    widget.vendor.status,
                  ).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(Dimensions.radius30),
                ),
                child: Text(
                  widget.vendor.status.label,
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.62,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                    color: _statusColor(widget.vendor.status),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: Dimensions.height20),
          _buildContactInfoRow(
            icon: Icons.business_rounded,
            iconColor: const Color(0xFF5C6BC0),
            label: 'Company Name',
            value: widget.vendor.companyName,
            placeholder: 'No company name',
          ),
          SizedBox(height: Dimensions.height20),
          _buildContactInfoRow(
            icon: Icons.email_rounded,
            iconColor: const Color(0xFF5C6BC0),
            label: 'Email',
            value: widget.vendor.email,
            placeholder: 'No email',
          ),
          SizedBox(height: Dimensions.height20),
          _buildContactInfoRow(
            icon: Icons.phone_rounded,
            iconColor: const Color(0xFF5C6BC0),
            label: 'Phone',
            value: widget.vendor.phone,
            placeholder: 'No phone',
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfoRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    String? value,
    required String placeholder,
  }) {
    final hasValue = value != null && value.isNotEmpty;

    return Row(
      children: [
        Container(
          width: Dimensions.height45,
          height: Dimensions.height45,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(Dimensions.radius15 / 1.5),
          ),
          child: Icon(icon, color: iconColor, size: Dimensions.iconSize24),
        ),
        SizedBox(width: Dimensions.width15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: Dimensions.font16 * 0.9,
                  fontWeight: FontWeight.w700,
                  color: context.colors.textPrimary,
                ),
              ),
              SizedBox(height: Dimensions.height10 / 3),
              Text(
                hasValue ? value : placeholder,
                style: TextStyle(
                  fontSize: Dimensions.font16 * 0.8,
                  color: hasValue
                      ? context.colors.textSecondary
                      : context.colors.textTertiary,
                  fontWeight: hasValue ? FontWeight.w500 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionsTab() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(Dimensions.width20),
          decoration: BoxDecoration(
            color: context.colors.card,
            border: Border(
              bottom: BorderSide(color: context.colors.border, width: 1),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.width15,
                    vertical: Dimensions.height10,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: context.colors.border),
                    borderRadius: BorderRadius.circular(
                      Dimensions.radius15 / 1.5,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Bills',
                        style: TextStyle(
                          fontSize: Dimensions.font16 * 0.85,
                          fontWeight: FontWeight.w600,
                          color: context.colors.textPrimary,
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: Dimensions.iconSize24,
                        color: context.colors.textPrimary,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: Dimensions.height45 * 3,
                height: Dimensions.height45 * 3,
                decoration: BoxDecoration(
                  color: context.colors.surfaceLight,
                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                ),
                child: Center(
                  child: Icon(
                    Icons.description_outlined,
                    size: Dimensions.height45 * 1.5,
                    color: Appcolors.primary.withValues(alpha: 0.5),
                  ),
                ),
              ),
              SizedBox(height: Dimensions.height30),
              Text(
                'No Bills created so far.',
                style: TextStyle(
                  fontSize: Dimensions.font16,
                  color: context.colors.textTertiary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCommentsTab() {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Text(
              'No comments yet.',
              style: TextStyle(
                fontSize: Dimensions.font16,
                color: context.colors.textTertiary,
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(Dimensions.width20),
          decoration: BoxDecoration(
            color: context.colors.card,
            border: Border(
              top: BorderSide(color: context.colors.border, width: 1),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    hintText: 'Type to add a comment',
                    hintStyle: TextStyle(
                      color: context.colors.textTertiary,
                      fontSize: Dimensions.font16 * 0.85,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Dimensions.radius30),
                      borderSide: BorderSide(color: context.colors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Dimensions.radius30),
                      borderSide: BorderSide(color: context.colors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Dimensions.radius30),
                      borderSide: const BorderSide(
                        color: Appcolors.primary,
                        width: 2,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: Dimensions.width20,
                      vertical: Dimensions.height15,
                    ),
                  ),
                ),
              ),
              SizedBox(width: Dimensions.width10),
              Container(
                decoration: const BoxDecoration(
                  color: Appcolors.primary,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.send_rounded,
                    color: Colors.white,
                    size: Dimensions.iconSize24 * 0.9,
                  ),
                  onPressed: () {
                    if (_commentController.text.trim().isNotEmpty) {
                      _commentController.clear();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
