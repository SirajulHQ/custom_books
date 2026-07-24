import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/features/customers/models/customer_model.dart';
import 'package:custom_books/features/customers/view/add_customer_page.dart';
import 'package:custom_books/features/invoices/view/new_invoice_page.dart';
import 'package:flutter/material.dart';

class CustomerDetailsPage extends StatefulWidget {
  final CustomerModel customer;

  const CustomerDetailsPage({super.key, required this.customer});

  @override
  State<CustomerDetailsPage> createState() => _CustomerDetailsPageState();
}

class _CustomerDetailsPageState extends State<CustomerDetailsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _commentController = TextEditingController();

  // Track expansion state for each section
  bool _isReceivablesExpanded = false;
  bool _isMoreInfoExpanded = false;
  bool _isContactPersonsExpanded = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    appLog(
      '🎯 CustomerDetailsPage initialized for: ${widget.customer.name}',
      name: 'CustomerDetailsPage',
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    appLog('🏗️ Building CustomerDetailsPage', name: 'CustomerDetailsPage');
    Dimensions.init(context);

    return Scaffold(
      backgroundColor: Appcolors.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Custom Sliver App Bar
            CustomSliverAppBar(
              title: widget.customer.name,
              leadingType: AppBarLeadingType.back,
              onLeadingPressed: () {
                appLog('⬅️ Back button pressed', name: 'CustomerDetailsPage');
                Navigator.pop(context);
              },
              actions: [
                AppBarIconButton(
                  icon: Icons.edit_outlined,
                  color: Appcolors.primary,
                  onPressed: () {
                    appLog(
                      '✏️ Edit button pressed',
                      name: 'CustomerDetailsPage',
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AddCustomerPage(customer: widget.customer),
                      ),
                    );
                  },
                ),
                SizedBox(width: Dimensions.width10),
                AppBarIconButton(
                  icon: Icons.attach_file_rounded,
                  color: Appcolors.textSecondary,
                  onPressed: () {
                    appLog(
                      '📎 Attachment button pressed',
                      name: 'CustomerDetailsPage',
                    );
                    // TODO: Handle attachments
                  },
                ),
                SizedBox(width: Dimensions.width10),
                AppBarIconButton(
                  icon: Icons.more_vert_rounded,
                  color: Appcolors.textSecondary,
                  onPressed: () {
                    appLog(
                      '⋮ More options pressed',
                      name: 'CustomerDetailsPage',
                    );
                    // TODO: Show more options
                  },
                ),
                SizedBox(width: Dimensions.width20),
              ],
            ),

            // Header Section
            SliverToBoxAdapter(child: _buildHeaderSection()),

            // Tab Bar
            SliverToBoxAdapter(child: _buildTabBar()),

            // Tab Bar View Content
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
      floatingActionButton: AnimatedBuilder(
        animation: _tabController,
        builder: (context, child) {
          // Show FAB only on Transactions tab (index 1)
          if (_tabController.index == 1) {
            return FloatingActionButton(
              onPressed: () {
                appLog(
                  '➕ Add Transaction FAB tapped',
                  name: 'CustomerDetailsPage',
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        NewInvoicePage(customer: widget.customer),
                  ),
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
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Dimensions.width20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Appcolors.border, width: 1)),
      ),
      child: Row(
        children: [
          // Receivables
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Receivables',
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.75,
                    color: Appcolors.textTertiary,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: Dimensions.height10 / 2),
                Text(
                  'AED${widget.customer.receivables.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: Dimensions.font26,
                    fontWeight: FontWeight.w800,
                    color: Appcolors.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          Container(
            height: Dimensions.height45,
            width: 1,
            color: Appcolors.border,
          ),

          SizedBox(width: Dimensions.width20),

          // Unused Credits
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Unused Credits',
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.75,
                    color: Appcolors.textTertiary,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: Dimensions.height10 / 2),
                Text(
                  'AED${widget.customer.unusedCredits.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: Dimensions.font26,
                    fontWeight: FontWeight.w800,
                    color: Appcolors.textPrimary,
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
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Appcolors.border, width: 1)),
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: Appcolors.primary,
        unselectedLabelColor: Appcolors.textSecondary,
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

          // Contact Information Section
          _buildContactInformationSection(),

          // Receivables Section
          _buildReceivablesSection(),

          // More Information Section
          _buildMoreInformationSection(),

          // Contact Persons Section
          _buildContactPersonsSection(),

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
        color: Colors.white,
        borderRadius: BorderRadius.circular(Dimensions.radius15),
        border: Border.all(color: Appcolors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Text(
            'CONTACT INFORMATION',
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.7,
              fontWeight: FontWeight.w700,
              color: Appcolors.textTertiary,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: Dimensions.height20),

          // Mobile
          _buildContactInfoRow(
            icon: Icons.phone_iphone_rounded,
            iconColor: const Color(0xFF5C6BC0),
            label: 'Mobile',
            value: widget.customer.mobileNumber,
            placeholder: 'Add mobile number',
            onTap: () {
              appLog('📱 Mobile tapped', name: 'CustomerDetailsPage');
              // TODO: Handle mobile action
            },
          ),

          SizedBox(height: Dimensions.height20),

          // Work Phone
          _buildContactInfoRow(
            icon: Icons.phone_rounded,
            iconColor: const Color(0xFF5C6BC0),
            label: 'Work Phone',
            value: widget.customer.workPhone,
            placeholder: 'Add work phone',
            onTap: () {
              appLog('☎️ Work Phone tapped', name: 'CustomerDetailsPage');
              // TODO: Handle work phone action
            },
          ),

          SizedBox(height: Dimensions.height20),

          // Email
          _buildContactInfoRow(
            icon: Icons.email_rounded,
            iconColor: const Color(0xFF5C6BC0),
            label: 'Email',
            value: widget.customer.email,
            placeholder: 'Add email',
            onTap: () {
              appLog('✉️ Email tapped', name: 'CustomerDetailsPage');
              // TODO: Handle email action
            },
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
    required VoidCallback onTap,
  }) {
    final hasValue = value != null && value.isNotEmpty;

    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          // Icon
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

          // Label and Value/Placeholder
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.9,
                    fontWeight: FontWeight.w700,
                    color: Appcolors.textPrimary,
                  ),
                ),
                SizedBox(height: Dimensions.height10 / 3),
                Text(
                  hasValue ? value : placeholder,
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.8,
                    color: hasValue
                        ? Appcolors.textSecondary
                        : Appcolors.textTertiary,
                    fontWeight: hasValue ? FontWeight.w500 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReceivablesSection() {
    return Container(
      margin: EdgeInsets.fromLTRB(
        Dimensions.width20,
        Dimensions.height15,
        Dimensions.width20,
        0,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Dimensions.radius15),
        border: Border.all(color: Appcolors.border),
      ),
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() {
                  _isReceivablesExpanded = !_isReceivablesExpanded;
                });
                appLog(
                  '💰 Receivables section tapped: ${_isReceivablesExpanded ? "expanded" : "collapsed"}',
                  name: 'CustomerDetailsPage',
                );
              },
              borderRadius: BorderRadius.circular(Dimensions.radius15),
              child: Padding(
                padding: EdgeInsets.all(Dimensions.width20),
                child: Row(
                  children: [
                    Icon(
                      Icons.account_balance_wallet_outlined,
                      size: Dimensions.iconSize24,
                      color: Appcolors.primary,
                    ),
                    SizedBox(width: Dimensions.width15),
                    Expanded(
                      child: Text(
                        'Receivables',
                        style: TextStyle(
                          fontSize: Dimensions.font16,
                          fontWeight: FontWeight.w700,
                          color: Appcolors.textPrimary,
                        ),
                      ),
                    ),
                    Icon(
                      _isReceivablesExpanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      size: Dimensions.iconSize24,
                      color: Appcolors.textSecondary,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_isReceivablesExpanded) ...[
            Divider(height: 1, color: Appcolors.border),
            Padding(
              padding: EdgeInsets.all(Dimensions.width20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Currency Header
                  Row(
                    children: [
                      Text(
                        'UAE Dirham',
                        style: TextStyle(
                          fontSize: Dimensions.font16 * 0.9,
                          fontWeight: FontWeight.w700,
                          color: Appcolors.textPrimary,
                        ),
                      ),
                      SizedBox(width: Dimensions.width10),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.width10,
                          vertical: Dimensions.height10 / 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE3F2FD),
                          borderRadius: BorderRadius.circular(
                            Dimensions.radius15 / 3,
                          ),
                        ),
                        child: Text(
                          'AED',
                          style: TextStyle(
                            fontSize: Dimensions.font16 * 0.7,
                            fontWeight: FontWeight.w700,
                            color: Appcolors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Dimensions.height15),

                  // Receivables and Unused Credits
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Receivables',
                              style: TextStyle(
                                fontSize: Dimensions.font16 * 0.8,
                                color: Appcolors.textTertiary,
                              ),
                            ),
                            SizedBox(height: Dimensions.height10 / 2),
                            Text(
                              'AED${widget.customer.receivables.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: Dimensions.font16 * 0.9,
                                fontWeight: FontWeight.w700,
                                color: Appcolors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Unused Credits',
                              style: TextStyle(
                                fontSize: Dimensions.font16 * 0.8,
                                color: Appcolors.textTertiary,
                              ),
                            ),
                            SizedBox(height: Dimensions.height10 / 2),
                            Text(
                              'AED${widget.customer.unusedCredits.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: Dimensions.font16 * 0.9,
                                fontWeight: FontWeight.w700,
                                color: Appcolors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Dimensions.height20),

                  // Enter Opening Balance Link
                  GestureDetector(
                    onTap: () {
                      appLog(
                        '💵 Enter Opening Balance tapped',
                        name: 'CustomerDetailsPage',
                      );
                      // TODO: Handle opening balance
                    },
                    child: Text(
                      'Enter Opening Balance',
                      style: TextStyle(
                        fontSize: Dimensions.font16 * 0.85,
                        color: Appcolors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMoreInformationSection() {
    return Container(
      margin: EdgeInsets.fromLTRB(
        Dimensions.width20,
        Dimensions.height15,
        Dimensions.width20,
        0,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Dimensions.radius15),
        border: Border.all(color: Appcolors.border),
      ),
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() {
                  _isMoreInfoExpanded = !_isMoreInfoExpanded;
                });
                appLog(
                  'ℹ️ More Information section tapped: ${_isMoreInfoExpanded ? "expanded" : "collapsed"}',
                  name: 'CustomerDetailsPage',
                );
              },
              borderRadius: BorderRadius.circular(Dimensions.radius15),
              child: Padding(
                padding: EdgeInsets.all(Dimensions.width20),
                child: Row(
                  children: [
                    Icon(
                      Icons.grid_view_rounded,
                      size: Dimensions.iconSize24,
                      color: Appcolors.primary,
                    ),
                    SizedBox(width: Dimensions.width15),
                    Expanded(
                      child: Text(
                        'More Information',
                        style: TextStyle(
                          fontSize: Dimensions.font16,
                          fontWeight: FontWeight.w700,
                          color: Appcolors.textPrimary,
                        ),
                      ),
                    ),
                    Icon(
                      _isMoreInfoExpanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      size: Dimensions.iconSize24,
                      color: Appcolors.textSecondary,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_isMoreInfoExpanded) ...[
            Divider(height: 1, color: Appcolors.border),
            Padding(
              padding: EdgeInsets.all(Dimensions.width20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [_buildInfoRow('Payment Terms', 'Due on Receipt')],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: Dimensions.height10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.8,
              color: Appcolors.textTertiary,
            ),
          ),
          SizedBox(height: Dimensions.height10 / 3),
          Text(
            value,
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.9,
              fontWeight: FontWeight.w600,
              color: Appcolors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactPersonsSection() {
    return Container(
      margin: EdgeInsets.fromLTRB(
        Dimensions.width20,
        Dimensions.height15,
        Dimensions.width20,
        0,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Dimensions.radius15),
        border: Border.all(color: Appcolors.border),
      ),
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() {
                  _isContactPersonsExpanded = !_isContactPersonsExpanded;
                });
                appLog(
                  '👥 Contact Persons section tapped: ${_isContactPersonsExpanded ? "expanded" : "collapsed"}',
                  name: 'CustomerDetailsPage',
                );
              },
              borderRadius: BorderRadius.circular(Dimensions.radius15),
              child: Padding(
                padding: EdgeInsets.all(Dimensions.width20),
                child: Row(
                  children: [
                    Icon(
                      Icons.person_outline_rounded,
                      size: Dimensions.iconSize24,
                      color: Appcolors.primary,
                    ),
                    SizedBox(width: Dimensions.width15),
                    Expanded(
                      child: Text(
                        'Contact Persons',
                        style: TextStyle(
                          fontSize: Dimensions.font16,
                          fontWeight: FontWeight.w700,
                          color: Appcolors.textPrimary,
                        ),
                      ),
                    ),
                    Icon(
                      _isContactPersonsExpanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      size: Dimensions.iconSize24,
                      color: Appcolors.textSecondary,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_isContactPersonsExpanded) ...[
            Divider(height: 1, color: Appcolors.border),
            Padding(
              padding: EdgeInsets.all(Dimensions.width20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'You haven\'t added any contact persons for this contact yet.',
                    style: TextStyle(
                      fontSize: Dimensions.font16 * 0.85,
                      color: Appcolors.textTertiary,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: Dimensions.height20),
                  GestureDetector(
                    onTap: () {
                      appLog(
                        '➕ Add Contact Person tapped',
                        name: 'CustomerDetailsPage',
                      );
                      // TODO: Navigate to add contact person page
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.add_circle_outline_rounded,
                          color: Appcolors.primary,
                          size: Dimensions.iconSize24,
                        ),
                        SizedBox(width: Dimensions.width10),
                        Text(
                          'Add Contact Person',
                          style: TextStyle(
                            fontSize: Dimensions.font16 * 0.85,
                            color: Appcolors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTransactionsTab() {
    return Column(
      children: [
        // Transaction type dropdown and actions
        Container(
          padding: EdgeInsets.all(Dimensions.width20),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: Appcolors.border, width: 1),
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
                    border: Border.all(color: Appcolors.border),
                    borderRadius: BorderRadius.circular(
                      Dimensions.radius15 / 1.5,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Invoice',
                        style: TextStyle(
                          fontSize: Dimensions.font16 * 0.85,
                          fontWeight: FontWeight.w600,
                          color: Appcolors.textPrimary,
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: Dimensions.iconSize24,
                        color: Appcolors.textPrimary,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: Dimensions.width10),
              IconButton(
                icon: Icon(
                  Icons.filter_list_rounded,
                  size: Dimensions.iconSize24,
                  color: Appcolors.textSecondary,
                ),
                onPressed: () {
                  appLog(
                    '🔍 Filter button pressed',
                    name: 'CustomerDetailsPage',
                  );
                  // TODO: Show filter options
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.sort_rounded,
                  size: Dimensions.iconSize24,
                  color: Appcolors.textSecondary,
                ),
                onPressed: () {
                  appLog('🔀 Sort button pressed', name: 'CustomerDetailsPage');
                  // TODO: Show sort options
                },
              ),
            ],
          ),
        ),

        // Empty state
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: Dimensions.height45 * 3,
                height: Dimensions.height45 * 3,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8EAF6),
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
              SizedBox(height: Dimensions.height20),
              Text(
                'Total Count',
                style: TextStyle(
                  fontSize: Dimensions.font16 * 0.8,
                  color: Appcolors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: Dimensions.height30),
              Text(
                'No Invoices created so far.',
                style: TextStyle(
                  fontSize: Dimensions.font16,
                  color: Appcolors.textTertiary,
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
        // Empty state
        Expanded(
          child: Center(
            child: Text(
              'No comments yet.',
              style: TextStyle(
                fontSize: Dimensions.font16,
                color: Appcolors.textTertiary,
              ),
            ),
          ),
        ),

        // Comment input
        Container(
          padding: EdgeInsets.all(Dimensions.width20),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Appcolors.border, width: 1)),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    hintText: 'Type to add a comment',
                    hintStyle: TextStyle(
                      color: Appcolors.textTertiary,
                      fontSize: Dimensions.font16 * 0.85,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Dimensions.radius30),
                      borderSide: BorderSide(color: Appcolors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Dimensions.radius30),
                      borderSide: BorderSide(color: Appcolors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Dimensions.radius30),
                      borderSide: BorderSide(
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
                decoration: BoxDecoration(
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
                      appLog(
                        '💬 Comment sent: ${_commentController.text}',
                        name: 'CustomerDetailsPage',
                      );
                      // TODO: Add comment functionality
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
