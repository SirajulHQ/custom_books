import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/widgets/custom_add_button.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/core/widgets/form_widgets.dart';
import 'package:flutter/material.dart';

class CustomersVendorsPreferencesPage extends StatefulWidget {
  const CustomersVendorsPreferencesPage({super.key});

  @override
  State<CustomersVendorsPreferencesPage> createState() =>
      _CustomersVendorsPreferencesPageState();
}

class _CustomersVendorsPreferencesPageState
    extends State<CustomersVendorsPreferencesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // General Tab
  String _defaultCustomerType = 'Business';
  bool _allowDuplicates = true;
  bool _enableCreditLimit = false;

  final String _billingAddressFormat =
      '\${CONTACT.CONTACT_DISPLAYNAME}\n\${CONTACT.CONTACT_ADDRESS}\n\${CONTACT.CONTACT_CITY}\n\${CONTACT.CONTACT_CODE} \$\n{CONTACT.CONTACT_STATE}\n\${CONTACT.CONTACT_COUNTRY}\n\${CONTACT.TRN_LABEL} \${CONTACT.TRN}';

  final String _shippingAddressFormat =
      '\${CONTACT.CONTACT_ADDRESS}\n\${CONTACT.CONTACT_CITY}\n\${CONTACT.CONTACT_CODE} \$\n{CONTACT.CONTACT_STATE}\n\${CONTACT.CONTACT_COUNTRY}\n\${CONTACT.TRN_LABEL} \${CONTACT.TRN}';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    appLog(
      '👥 CustomersVendorsPreferencesPage initialized',
      name: 'CustomersVendorsPreferences',
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _save() {
    appLog(
      '💾 Save Customers & Vendors Preferences',
      name: 'CustomersVendorsPreferences',
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);

    return Scaffold(
      backgroundColor: context.colors.background,
      bottomNavigationBar: _buildSaveButton(),
      body: SafeArea(
        child: NestedScrollView(
          physics: const BouncingScrollPhysics(),
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            CustomSliverAppBar(
              title: 'Customers And Vendors',
              leadingType: AppBarLeadingType.back,
              pinned: true,
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _TabBarDelegate(
                tabBar: TabBar(
                  controller: _tabController,
                  labelColor: Appcolors.primary,
                  unselectedLabelColor: context.colors.textSecondary,
                  indicatorColor: Appcolors.primary,
                  indicatorWeight: 3,
                  labelStyle: TextStyle(
                    fontSize: Dimensions.font16 * 0.9,
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontSize: Dimensions.font16 * 0.9,
                    fontWeight: FontWeight.w500,
                  ),
                  tabs: const [
                    Tab(text: 'General'),
                    Tab(text: 'Field Customization'),
                  ],
                ),
                backgroundColor: context.colors.background,
              ),
            ),
          ],
          body: TabBarView(
            controller: _tabController,
            children: [_buildGeneralTab(), _buildFieldCustomizationTab()],
          ),
        ),
      ),
    );
  }

  Widget _buildGeneralTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.all(Dimensions.width15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Default Customer Type
          Text(
            'Default Customer Type',
            style: TextStyle(
              fontSize: Dimensions.font16,
              fontWeight: FontWeight.w700,
              color: context.colors.textPrimary,
            ),
          ),
          SizedBox(height: Dimensions.height10 / 2),
          Text(
            'Select a type based on your regular customers. This will be auto-selected in the customer creation form.',
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.8,
              color: context.colors.textSecondary,
              height: 1.4,
            ),
          ),
          SizedBox(height: Dimensions.height10),
          Row(
            children: [
              _buildRadioOption(
                'Business',
                _defaultCustomerType == 'Business',
                () => setState(() => _defaultCustomerType = 'Business'),
              ),
              SizedBox(width: Dimensions.width30),
              _buildRadioOption(
                'Individual',
                _defaultCustomerType == 'Individual',
                () => setState(() => _defaultCustomerType = 'Individual'),
              ),
            ],
          ),

          _buildDivider(),

          // Allow Duplicates
          _buildCheckboxTile(
            'Allow duplicates for customer and vendor display name.',
            _allowDuplicates,
            (val) => setState(() => _allowDuplicates = val ?? false),
          ),

          _buildDivider(),

          // Customer Credit Limit
          Text(
            'Customer Credit Limit',
            style: TextStyle(
              fontSize: Dimensions.font16,
              fontWeight: FontWeight.w700,
              color: context.colors.textPrimary,
            ),
          ),
          SizedBox(height: Dimensions.height10 / 2),
          Text(
            'Credit Limit enables you to set limit on the outstanding receivable amount of the customers.',
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.8,
              color: context.colors.textSecondary,
              height: 1.4,
            ),
          ),
          SizedBox(height: Dimensions.height15),
          FormCard(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Enable Credit Limit',
                    style: TextStyle(
                      fontSize: Dimensions.font16 * 0.9,
                      fontWeight: FontWeight.w500,
                      color: context.colors.textPrimary,
                    ),
                  ),
                  Switch(
                    value: _enableCreditLimit,
                    onChanged: (val) =>
                        setState(() => _enableCreditLimit = val),
                    activeThumbColor: Appcolors.primary,
                  ),
                ],
              ),
            ],
          ),

          _buildDivider(),

          // Billing Address Format
          Text(
            'Customer and Vendor Billing Address Format',
            style: TextStyle(
              fontSize: Dimensions.font16,
              fontWeight: FontWeight.w700,
              color: context.colors.textPrimary,
            ),
          ),
          SizedBox(height: Dimensions.height10),
          FormCard(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(Dimensions.width15),
                decoration: BoxDecoration(
                  color: context.colors.surfaceLight,
                  borderRadius: BorderRadius.circular(Dimensions.radius15 / 2),
                  border: Border.all(color: context.colors.border),
                ),
                child: Text(
                  _billingAddressFormat,
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.8,
                    color: context.colors.textPrimary,
                    height: 1.5,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
              SizedBox(height: Dimensions.height10),
              _buildActionLink(
                Icons.add_circle_outline_rounded,
                'Insert Placeholders',
                () {},
              ),
            ],
          ),

          SizedBox(height: Dimensions.height20),

          // Shipping Address Format
          Text(
            'Customer and Vendor Shipping Address Format',
            style: TextStyle(
              fontSize: Dimensions.font16,
              fontWeight: FontWeight.w700,
              color: context.colors.textPrimary,
            ),
          ),
          SizedBox(height: Dimensions.height10),
          FormCard(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(Dimensions.width15),
                decoration: BoxDecoration(
                  color: context.colors.surfaceLight,
                  borderRadius: BorderRadius.circular(Dimensions.radius15 / 2),
                  border: Border.all(color: context.colors.border),
                ),
                child: Text(
                  _shippingAddressFormat,
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.8,
                    color: context.colors.textPrimary,
                    height: 1.5,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
              SizedBox(height: Dimensions.height10),
              _buildActionLink(
                Icons.add_circle_outline_rounded,
                'Insert Placeholders',
                () {},
              ),
            ],
          ),

          SizedBox(height: Dimensions.height30),
        ],
      ),
    );
  }

  Widget _buildFieldCustomizationTab() {
    return Stack(
      children: [
        Center(
          child: Padding(
            padding: EdgeInsets.all(Dimensions.width30),
            child: Text(
              "Do you have information that doesn't go under any existing field? Go ahead and create a field.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.9,
                color: context.colors.textSecondary,
                height: 1.5,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: Dimensions.height30,
          right: Dimensions.width20,
          child: CustomAddButton(
            onPressed: () {
              appLog(
                '➕ Add custom field tapped',
                name: 'CustomersVendorsPreferences',
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return Container(
      padding: EdgeInsets.all(Dimensions.width15),
      decoration: BoxDecoration(
        color: context.colors.card,
        border: Border(top: BorderSide(color: context.colors.border)),
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: Dimensions.height45,
          child: ElevatedButton(
            onPressed: _save,
            style: ElevatedButton.styleFrom(
              backgroundColor: Appcolors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Dimensions.radius30),
              ),
              elevation: 0,
            ),
            child: Text(
              'Save',
              style: TextStyle(
                fontSize: Dimensions.font16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Dimensions.height15),
      child: Divider(color: context.colors.border),
    );
  }

  Widget _buildRadioOption(String label, bool selected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          RadioGroup<bool>(
            groupValue: selected ? true : null,
            onChanged: (_) => onTap(),
            child: Radio<bool>(
              value: true,
              activeColor: Appcolors.primary,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.9,
              color: context.colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckboxTile(
    String label,
    bool value,
    ValueChanged<bool?> onChanged,
  ) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: Dimensions.iconSize24,
            height: Dimensions.iconSize24,
            child: Checkbox(
              value: value,
              onChanged: onChanged,
              activeColor: Appcolors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Dimensions.radius15 * 0.27),
              ),
            ),
          ),
          SizedBox(width: Dimensions.width10),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.85,
                color: context.colors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionLink(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: Dimensions.iconSize16, color: Appcolors.primary),
          SizedBox(width: Dimensions.width10 / 2),
          Text(
            label,
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.8,
              fontWeight: FontWeight.w600,
              color: Appcolors.primary,
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
  bool shouldRebuild(covariant _TabBarDelegate oldDelegate) =>
      tabBar != oldDelegate.tabBar;
}
