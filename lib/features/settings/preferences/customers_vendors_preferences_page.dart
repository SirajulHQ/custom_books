import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/widgets/custom_add_button.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/core/widgets/form_widgets.dart';
import 'package:custom_books/core/widgets/unsaved_changes_dialog.dart';
import 'package:flutter/material.dart';

class CustomersVendorsPreferencesPage extends StatefulWidget {
  const CustomersVendorsPreferencesPage({super.key});

  @override
  State<CustomersVendorsPreferencesPage> createState() =>
      _CustomersVendorsPreferencesPageState();
}

class _CustomersVendorsPreferencesPageState
    extends State<CustomersVendorsPreferencesPage>
    with SingleTickerProviderStateMixin, UnsavedChangesMixin {
  late TabController _tabController;

  // General Tab
  String _defaultCustomerType = 'Business';
  bool _allowDuplicates = true;
  bool _enableCreditLimit = false;

  String _billingAddressFormat =
      '\${CONTACT.CONTACT_DISPLAYNAME}\n\${CONTACT.CONTACT_ADDRESS}\n\${CONTACT.CONTACT_CITY}\n\${CONTACT.CONTACT_CODE} \$\n{CONTACT.CONTACT_STATE}\n\${CONTACT.CONTACT_COUNTRY}\n\${CONTACT.TRN_LABEL} \${CONTACT.TRN}';

  String _shippingAddressFormat =
      '\${CONTACT.CONTACT_ADDRESS}\n\${CONTACT.CONTACT_CITY}\n\${CONTACT.CONTACT_CODE} \$\n{CONTACT.CONTACT_STATE}\n\${CONTACT.CONTACT_COUNTRY}\n\${CONTACT.TRN_LABEL} \${CONTACT.TRN}';

  // Placeholder tokens that can be inserted into the address formats.
  static const Map<String, String> _addressPlaceholders = {
    'Display Name': r'${CONTACT.CONTACT_DISPLAYNAME}',
    'Attention': r'${CONTACT.CONTACT_ATTENTION}',
    'Address': r'${CONTACT.CONTACT_ADDRESS}',
    'City': r'${CONTACT.CONTACT_CITY}',
    'State': r'${CONTACT.CONTACT_STATE}',
    'Zip Code': r'${CONTACT.CONTACT_CODE}',
    'Country': r'${CONTACT.CONTACT_COUNTRY}',
    'Phone': r'${CONTACT.CONTACT_PHONE}',
    'Fax': r'${CONTACT.CONTACT_FAX}',
    'TRN': r'${CONTACT.TRN}',
  };

  // In-memory custom fields (Field Customization tab).
  final List<_CustomField> _customFields = [];

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
    markClean();
    Navigator.pop(context);
  }

  void _insertPlaceholder({required bool isBilling}) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: context.colors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Dimensions.radius20),
        ),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.width20,
            vertical: Dimensions.height10,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Insert Placeholder',
                style: TextStyle(
                  fontSize: Dimensions.font16,
                  fontWeight: FontWeight.w800,
                  color: context.colors.textPrimary,
                ),
              ),
              SizedBox(height: Dimensions.height10),
              Wrap(
                spacing: Dimensions.width10,
                runSpacing: Dimensions.height10,
                children: _addressPlaceholders.entries.map((entry) {
                  return ActionChip(
                    label: Text(entry.key),
                    labelStyle: TextStyle(
                      fontSize: Dimensions.font16 * 0.8,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                    backgroundColor: AppColors.primary.withValues(alpha: 0.08),
                    side: BorderSide(
                      color: AppColors.primary.withValues(alpha: 0.3),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Dimensions.radius15),
                    ),
                    onPressed: () {
                      Navigator.pop(sheetContext);
                      setState(() {
                        if (isBilling) {
                          _billingAddressFormat =
                              '$_billingAddressFormat\n${entry.value}';
                        } else {
                          _shippingAddressFormat =
                              '$_shippingAddressFormat\n${entry.value}';
                        }
                      });
                      markDirty();
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: Dimensions.height15),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddCustomFieldSheet() {
    appLog('➕ Add custom field tapped', name: 'CustomersVendorsPreferences');
    final labelController = TextEditingController();
    String selectedType = _CustomField.types.first;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: context.colors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Dimensions.radius20),
        ),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            left: Dimensions.width20,
            right: Dimensions.width20,
            top: Dimensions.height10,
            bottom:
                MediaQuery.of(sheetContext).viewInsets.bottom +
                Dimensions.height20,
          ),
          child: StatefulBuilder(
            builder: (ctx, setSheetState) => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'New Custom Field',
                  style: TextStyle(
                    fontSize: Dimensions.font16,
                    fontWeight: FontWeight.w800,
                    color: context.colors.textPrimary,
                  ),
                ),
                SizedBox(height: Dimensions.height15),
                TextField(
                  controller: labelController,
                  autofocus: true,
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.9,
                    color: context.colors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Field Label',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Dimensions.radius15),
                    ),
                  ),
                ),
                SizedBox(height: Dimensions.height15),
                DropdownButtonFormField<String>(
                  initialValue: selectedType,
                  decoration: InputDecoration(
                    labelText: 'Data Type',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Dimensions.radius15),
                    ),
                  ),
                  items: _CustomField.types
                      .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                      .toList(),
                  onChanged: (v) =>
                      setSheetState(() => selectedType = v ?? selectedType),
                ),
                SizedBox(height: Dimensions.height20),
                SizedBox(
                  width: double.infinity,
                  height: Dimensions.height45,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          Dimensions.radius30,
                        ),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      final label = labelController.text.trim();
                      if (label.isEmpty) return;
                      Navigator.pop(sheetContext);
                      setState(() {
                        _customFields.add(
                          _CustomField(label: label, type: selectedType),
                        );
                      });
                      markDirty();
                    },
                    child: Text(
                      'Add Field',
                      style: TextStyle(
                        fontSize: Dimensions.font16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).whenComplete(labelController.dispose);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: onPopInvokedWithResult,
      child: Scaffold(
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
                onLeadingPressed: () => onPopInvokedWithResult(false, null),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: _TabBarDelegate(
                  tabBar: TabBar(
                    controller: _tabController,
                    labelColor: AppColors.primary,
                    unselectedLabelColor: context.colors.textSecondary,
                    indicatorColor: AppColors.primary,
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
                    onChanged: (val) {
                      setState(() => _enableCreditLimit = val);
                      markDirty();
                    },
                    activeThumbColor: AppColors.primary,
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
                () => _insertPlaceholder(isBilling: true),
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
                () => _insertPlaceholder(isBilling: false),
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
        if (_customFields.isEmpty)
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
          )
        else
          ListView.separated(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(
              Dimensions.width15,
              Dimensions.height15,
              Dimensions.width15,
              Dimensions.height45 * 2,
            ),
            itemCount: _customFields.length,
            separatorBuilder: (_, _) => SizedBox(height: Dimensions.height10),
            itemBuilder: (context, index) {
              final field = _customFields[index];
              return Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.width15,
                  vertical: Dimensions.height10,
                ),
                decoration: BoxDecoration(
                  color: context.colors.card,
                  borderRadius: BorderRadius.circular(Dimensions.radius15),
                  border: Border.all(color: context.colors.border),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.label_outline_rounded,
                      size: Dimensions.iconSize24,
                      color: AppColors.primary,
                    ),
                    SizedBox(width: Dimensions.width15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            field.label,
                            style: TextStyle(
                              fontSize: Dimensions.font16 * 0.9,
                              fontWeight: FontWeight.w700,
                              color: context.colors.textPrimary,
                            ),
                          ),
                          Text(
                            field.type,
                            style: TextStyle(
                              fontSize: Dimensions.font16 * 0.75,
                              color: context.colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.delete_outline_rounded,
                        color: AppColors.warn,
                        size: Dimensions.iconSize24 * 0.9,
                      ),
                      onPressed: () {
                        setState(() => _customFields.removeAt(index));
                        markDirty();
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        Positioned(
          bottom: Dimensions.height30,
          right: Dimensions.width20,
          child: CustomAddButton(onPressed: _showAddCustomFieldSheet),
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
              backgroundColor: AppColors.primary,
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
    void handleTap() {
      onTap();
      markDirty();
    }

    return InkWell(
      onTap: handleTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          RadioGroup<bool>(
            groupValue: selected ? true : null,
            onChanged: (_) => handleTap(),
            child: Radio<bool>(
              value: true,
              activeColor: AppColors.primary,
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
    void handleChanged(bool? val) {
      onChanged(val);
      markDirty();
    }

    return InkWell(
      onTap: () => handleChanged(!value),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: Dimensions.iconSize24,
            height: Dimensions.iconSize24,
            child: Checkbox(
              value: value,
              onChanged: handleChanged,
              activeColor: AppColors.primary,
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
          Icon(icon, size: Dimensions.iconSize16, color: AppColors.primary),
          SizedBox(width: Dimensions.width10 / 2),
          Text(
            label,
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.8,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
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

class _CustomField {
  final String label;
  final String type;

  const _CustomField({required this.label, required this.type});

  static const List<String> types = [
    'Text',
    'Number',
    'Decimal',
    'Amount',
    'Date',
    'Checkbox',
    'Dropdown',
  ];
}
