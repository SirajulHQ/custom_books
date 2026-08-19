import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/core/widgets/unsaved_changes_dialog.dart';
import 'package:custom_books/features/customers/models/customer_model.dart';
import 'package:custom_books/features/customers/views/add_address_page.dart';
import 'package:custom_books/features/customers/views/add_contact_person_page.dart';
import 'package:custom_books/features/customers/widgets/form_section_card.dart';
import 'package:custom_books/features/customers/widgets/other_details_card.dart';
import 'package:custom_books/features/customers/widgets/salutation_bottom_sheet.dart';
import 'package:flutter/material.dart';

class AddCustomerPage extends StatefulWidget {
  final CustomerModel? customer;

  const AddCustomerPage({super.key, this.customer});

  @override
  State<AddCustomerPage> createState() => _AddCustomerPageState();
}

class _AddCustomerPageState extends State<AddCustomerPage>
    with UnsavedChangesMixin {
  String _customerType = 'Business';
  String _selectedSalutation = '';

  final List<String> _salutationOptions = [
    'Mr.',
    'Mrs.',
    'Ms.',
    'Miss.',
    'Dr.',
  ];

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _facebookController = TextEditingController();
  final TextEditingController _twitterController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _openingBalanceController =
      TextEditingController();
  final TextEditingController _remarksController = TextEditingController();

  String _phoneCountryCode = '+91';
  String _mobileCountryCode = '+91';
  final String _selectedTaxTreatment = 'Select a Tax Treatment';
  final String _selectedPlaceOfSupply = 'Select a Place Of Supply';
  String _selectedCurrency = 'INR- Indian Rupee';
  String _selectedAccountsReceivable = 'Select a Accounts Receivable';
  String _selectedAccountsPayable = 'Select a Accounts Payable';

  @override
  void initState() {
    super.initState();
    _firstNameController.addListener(markDirty);
    _websiteController.addListener(markDirty);
    _facebookController.addListener(markDirty);
    _twitterController.addListener(markDirty);
    _lastNameController.addListener(markDirty);
    _companyNameController.addListener(markDirty);
    _displayNameController.addListener(markDirty);
    _emailController.addListener(markDirty);
    _phoneController.addListener(markDirty);
    _mobileController.addListener(markDirty);
    _openingBalanceController.addListener(markDirty);
    _remarksController.addListener(markDirty);
    if (widget.customer != null) {
      // Pre-populate with customer data for editing
      _displayNameController.text = widget.customer!.name;
      _emailController.text = widget.customer!.email ?? '';
      _phoneController.text = widget.customer!.workPhone ?? '';
      _mobileController.text = widget.customer!.mobileNumber ?? '';
      _phoneCountryCode = '+971';
      _mobileCountryCode = '+971';
      appLog(
        '📝 Editing customer: ${widget.customer!.name}',
        name: 'AddCustomerPage',
      );
    }
  }

  @override
  void dispose() {
    _firstNameController.removeListener(markDirty);
    _websiteController.removeListener(markDirty);
    _facebookController.removeListener(markDirty);
    _twitterController.removeListener(markDirty);
    _lastNameController.removeListener(markDirty);
    _companyNameController.removeListener(markDirty);
    _displayNameController.removeListener(markDirty);
    _emailController.removeListener(markDirty);
    _phoneController.removeListener(markDirty);
    _mobileController.removeListener(markDirty);
    _openingBalanceController.removeListener(markDirty);
    _remarksController.removeListener(markDirty);
    _firstNameController.dispose();
    _websiteController.dispose();
    _facebookController.dispose();
    _twitterController.dispose();
    _lastNameController.dispose();
    _companyNameController.dispose();
    _displayNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _mobileController.dispose();
    _openingBalanceController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: onPopInvokedWithResult,
      child: Scaffold(
        backgroundColor: context.colors.background,
        body: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // App Bar
              CustomSliverAppBar(
                title: widget.customer != null
                    ? 'Edit Customer'
                    : 'New Customer',
                leadingType: AppBarLeadingType.back,
                onLeadingPressed: () => onPopInvokedWithResult(false, null),
                actions: [
                  AppBarIconButton(
                    icon: Icons.contacts_outlined,
                    color: context.colors.textSecondary,
                    onPressed: () {
                      appLog(
                        '📱 Contacts button tapped',
                        name: 'AddCustomerPage',
                      );
                      ToastificationHelper.showInfo(
                        context,
                        'Importing from device contacts is coming soon.',
                      );
                    },
                  ),
                  SizedBox(width: Dimensions.width10),
                  AppBarElevatedButton(label: 'SAVE', onPressed: _saveCustomer),
                  SizedBox(width: Dimensions.width20),
                ],
              ),

              // Content
              SliverPadding(
                padding: EdgeInsets.all(Dimensions.width20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Customer Information Card
                    FormSectionCard(
                      title: 'Customer Information',
                      children: [
                        _buildSectionHeader('Customer Type', hasInfo: true),
                        SizedBox(height: Dimensions.height10),
                        Row(
                          children: [
                            Expanded(child: _buildRadioOption('Business')),
                            SizedBox(width: Dimensions.width15),
                            Expanded(child: _buildRadioOption('Individual')),
                          ],
                        ),
                        SizedBox(height: Dimensions.height20),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: _buildSalutationDropdown(),
                            ),
                            SizedBox(width: Dimensions.width15),
                            Expanded(
                              flex: 2,
                              child: _buildTextField(
                                'First Name',
                                _firstNameController,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: Dimensions.height20),
                        _buildTextField('Last Name', _lastNameController),
                        SizedBox(height: Dimensions.height20),
                        _buildTextField('Company Name', _companyNameController),
                        SizedBox(height: Dimensions.height20),
                        _buildTextField(
                          'Display Name',
                          _displayNameController,
                          isRequired: true,
                          hasInfo: true,
                        ),
                        SizedBox(height: Dimensions.height20),
                        _buildTextField(
                          'Email Address',
                          _emailController,
                          hasInfo: true,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(height: Dimensions.height20),
                        _buildPhoneField(
                          'Phone',
                          _phoneController,
                          _phoneCountryCode,
                          (value) => setState(() => _phoneCountryCode = value!),
                          hasInfo: true,
                        ),
                        SizedBox(height: Dimensions.height20),
                        _buildPhoneField(
                          'Mobile',
                          _mobileController,
                          _mobileCountryCode,
                          (value) =>
                              setState(() => _mobileCountryCode = value!),
                          hasInfo: true,
                        ),
                      ],
                    ),

                    SizedBox(height: Dimensions.height15),

                    // Other Details Card
                    OtherDetailsCard(
                      selectedCurrency: _selectedCurrency,
                      selectedAccountsReceivable: _selectedAccountsReceivable,
                      selectedAccountsPayable: _selectedAccountsPayable,
                      selectedTaxTreatment: _selectedTaxTreatment,
                      selectedPlaceOfSupply: _selectedPlaceOfSupply,
                      onCurrencyChanged: (value) {
                        setState(() => _selectedCurrency = value!);
                      },
                      onAccountsReceivableChanged: (value) {
                        setState(() => _selectedAccountsReceivable = value!);
                      },
                      onAccountsPayableChanged: (value) {
                        setState(() => _selectedAccountsPayable = value!);
                      },
                    ),

                    SizedBox(height: Dimensions.height15),

                    // Add Billing & Shipping Address Button
                    _buildExpandableButton(
                      'Add Billing & Shipping address',
                      onTap: () {
                        appLog(
                          '📍 Add Address tapped',
                          name: 'AddCustomerPage',
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddAddressPage(),
                          ),
                        );
                      },
                    ),

                    SizedBox(height: Dimensions.height15),

                    // Add Contact Person Button
                    _buildExpandableButton(
                      'Add Contact Person',
                      onTap: () {
                        appLog(
                          '👤 Add Contact Person tapped',
                          name: 'AddCustomerPage',
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddContactPersonPage(),
                          ),
                        );
                      },
                    ),

                    SizedBox(height: Dimensions.height15),

                    // Remarks Card
                    FormSectionCard(
                      title: 'Remarks (For Internal Use)',
                      children: [
                        _buildTextField(
                          '',
                          _remarksController,
                          maxLines: 4,
                          hint: 'Enter internal remarks...',
                        ),
                      ],
                    ),

                    SizedBox(height: Dimensions.height30),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String label, {bool hasInfo = false}) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: Dimensions.font16 * 0.85,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
        if (hasInfo) ...[
          SizedBox(width: Dimensions.width10 / 2),
          Icon(
            Icons.info_outline,
            size: Dimensions.iconSize16,
            color: context.colors.textTertiary,
          ),
        ],
      ],
    );
  }

  void _saveCustomer() {
    appLog('💾 Save button tapped', name: 'AddCustomerPage');
    final displayName = _displayNameController.text.trim();
    final firstName = _firstNameController.text.trim();
    if (displayName.isEmpty && firstName.isEmpty) {
      ToastificationHelper.showError(
        context,
        'Please enter a customer name before saving.',
      );
      return;
    }
    final name = displayName.isNotEmpty ? displayName : firstName;
    ToastificationHelper.showSuccess(context, '$name saved successfully.');
    markClean();
    Navigator.pop(context);
  }

  Widget _buildRadioOption(String label) {
    final isSelected = _customerType == label;
    return GestureDetector(
      onTap: () {
        setState(() => _customerType = label);
        appLog('📝 Customer type changed to: $label', name: 'AddCustomerPage');
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.width15,
          vertical: Dimensions.height15,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.05)
              : context.colors.surfaceLight,
          borderRadius: BorderRadius.circular(Dimensions.radius15),
          border: Border.all(
            color: isSelected ? AppColors.primary : context.colors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: isSelected
                  ? AppColors.primary
                  : context.colors.textTertiary,
              size: Dimensions.iconSize16 * 1.2,
            ),
            SizedBox(width: Dimensions.width10),
            Text(
              label,
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.85,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? AppColors.primary
                    : context.colors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController? controller, {
    bool isRequired = false,
    bool hasInfo = false,
    String? hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? prefix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) ...[
          Row(
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: Dimensions.font16 * 0.85,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
              if (isRequired) ...[
                SizedBox(width: Dimensions.width10 / 3),
                Text(
                  '*',
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.85,
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                  ),
                ),
              ],
              if (hasInfo) ...[
                SizedBox(width: Dimensions.width10 / 2),
                Icon(
                  Icons.info_outline,
                  size: Dimensions.iconSize16,
                  color: context.colors.textTertiary,
                ),
              ],
            ],
          ),
          SizedBox(height: Dimensions.height10),
        ],
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: TextStyle(
            fontSize: Dimensions.font16 * 0.85,
            color: context.colors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: context.colors.textTertiary,
              fontSize: Dimensions.font16 * 0.85,
            ),
            prefixText: prefix != null ? '$prefix ' : null,
            prefixStyle: TextStyle(
              fontSize: Dimensions.font16 * 0.85,
              color: context.colors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
            filled: true,
            fillColor: context.colors.surfaceLight,
            contentPadding: EdgeInsets.symmetric(
              horizontal: Dimensions.width15,
              vertical: Dimensions.height15,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius15),
              borderSide: BorderSide(color: context.colors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius15),
              borderSide: BorderSide(color: context.colors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius15),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneField(
    String label,
    TextEditingController controller,
    String countryCode,
    Function(String?) onCountryChanged, {
    bool hasInfo = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.85,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            if (hasInfo) ...[
              SizedBox(width: Dimensions.width10 / 2),
              Icon(
                Icons.info_outline,
                size: Dimensions.iconSize16,
                color: context.colors.textTertiary,
              ),
            ],
          ],
        ),
        SizedBox(height: Dimensions.height10),
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.width15,
                vertical: Dimensions.height15,
              ),
              decoration: BoxDecoration(
                color: context.colors.surfaceLight,
                borderRadius: BorderRadius.circular(Dimensions.radius15),
                border: Border.all(color: context.colors.border),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    countryCode,
                    style: TextStyle(
                      fontSize: Dimensions.font16 * 0.85,
                      fontWeight: FontWeight.w600,
                      color: context.colors.textPrimary,
                    ),
                  ),
                  SizedBox(width: Dimensions.width10 / 2),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: Dimensions.iconSize16 * 1.2,
                    color: context.colors.textSecondary,
                  ),
                ],
              ),
            ),
            SizedBox(width: Dimensions.width10),
            Expanded(
              child: TextField(
                controller: controller,
                keyboardType: TextInputType.phone,
                style: TextStyle(
                  fontSize: Dimensions.font16 * 0.85,
                  color: context.colors.textPrimary,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: context.colors.surfaceLight,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: Dimensions.width15,
                    vertical: Dimensions.height15,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Dimensions.radius15),
                    borderSide: BorderSide(color: context.colors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Dimensions.radius15),
                    borderSide: BorderSide(color: context.colors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Dimensions.radius15),
                    borderSide: BorderSide(color: AppColors.primary, width: 2),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildExpandableButton(String label, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(Dimensions.width20),
        decoration: BoxDecoration(
          color: context.colors.card,
          borderRadius: BorderRadius.circular(Dimensions.radius20),
          border: Border.all(color: context.colors.border),
          boxShadow: [
            BoxShadow(
              color: context.colors.border.withValues(alpha: 0.5),
              blurRadius: Dimensions.radius15 * 0.67,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(Dimensions.width10 * 0.7),
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add,
                size: Dimensions.iconSize16 * 1.2,
                color: Colors.white,
              ),
            ),
            SizedBox(width: Dimensions.width15),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: Dimensions.font16 * 0.9,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSalutationDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Salutation',
          style: TextStyle(
            fontSize: Dimensions.font16 * 0.85,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
        SizedBox(height: Dimensions.height10),
        GestureDetector(
          onTap: () => _showSalutationBottomSheet(),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.width15,
              vertical: Dimensions.height15,
            ),
            decoration: BoxDecoration(
              color: context.colors.surfaceLight,
              borderRadius: BorderRadius.circular(Dimensions.radius15),
              border: Border.all(
                color: _selectedSalutation.isEmpty
                    ? context.colors.border
                    : AppColors.primary,
                width: _selectedSalutation.isEmpty ? 1 : 2,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    _selectedSalutation.isEmpty ? '' : _selectedSalutation,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: Dimensions.font16 * 0.85,
                      color: _selectedSalutation.isEmpty
                          ? context.colors.textTertiary
                          : context.colors.textPrimary,
                      fontWeight: _selectedSalutation.isEmpty
                          ? FontWeight.w500
                          : FontWeight.w600,
                    ),
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: Dimensions.iconSize16 * 1.2,
                  color: context.colors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showSalutationBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: context.colors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Dimensions.radius20),
        ),
      ),
      builder: (_) {
        return SalutationBottomSheet(
          options: _salutationOptions,
          selectedSalutation: _selectedSalutation,
          onSelected: (value) {
            setState(() {
              _selectedSalutation = value;
            });

            appLog('✅ Salutation selected: $value', name: 'AddCustomerPage');
          },
        );
      },
    );
  }
}
