import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/features/customers/view/add_address_page.dart';
import 'package:custom_books/features/customers/view/add_contact_person_page.dart';
import 'package:flutter/material.dart';

class AddCustomerPage extends StatefulWidget {
  const AddCustomerPage({super.key});

  @override
  State<AddCustomerPage> createState() => _AddCustomerPageState();
}

class _AddCustomerPageState extends State<AddCustomerPage> {
  String _customerType = 'Business';
  bool _allowPortalAccess = false;
  bool _showWebsiteSocial = false;
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
  String _selectedTaxTreatment = 'Select a Tax Treatment';
  String _selectedPlaceOfSupply = 'Select a Place Of Supply';
  String _selectedCurrency = 'INR- Indian Rupee';
  String _selectedAccountsReceivable = 'Select a Accounts Receivable';
  String _selectedPaymentTerms = 'Due on Receipt';
  String _selectedPortalLanguage = 'English';

  // Dropdown options for India
  final List<String> _taxTreatmentOptions = [
    'Select a Tax Treatment',
    'GST Registered',
    'Non GST Registered',
    'GST Registered - Composition',
    'Consumer',
    'Overseas',
    'SEZ',
  ];

  final List<String> _placeOfSupplyOptions = [
    'Select a Place Of Supply',
    'Andaman and Nicobar Islands',
    'Andhra Pradesh',
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chandigarh',
    'Chhattisgarh',
    'Dadra and Nagar Haveli and Daman and Diu',
    'Delhi',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jammu and Kashmir',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Ladakh',
    'Lakshadweep',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Puducherry',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Telangana',
    'Tripura',
    'Uttar Pradesh',
    'Uttarakhand',
    'West Bengal',
  ];

  final List<String> _currencyOptions = [
    'INR- Indian Rupee',
    'USD- United States Dollar',
    'EUR- Euro',
    'GBP- Pound Sterling',
    'AED- UAE Dirham',
    'CAD- Canadian Dollar',
    'AUD- Australian Dollar',
    'SGD- Singapore Dollar',
    'JPY- Japanese Yen',
    'CNY- Yuan Renminbi',
  ];

  final List<String> _accountsReceivableOptions = [
    'Select a Accounts Receivable',
    'Accounts Receivable',
    'Accounts Receivable - Domestic',
    'Accounts Receivable - Foreign',
  ];

  final List<String> _paymentTermsOptions = [
    'Due on Receipt',
    'Net 15',
    'Net 30',
    'Net 45',
    'Net 60',
    'Due end of the month',
    'Due end of next month',
  ];

  final List<String> _portalLanguageOptions = [
    'English',
    'Hindi',
    'Tamil',
    'Telugu',
    'Marathi',
    'Bengali',
    'Gujarati',
    'Kannada',
    'Malayalam',
  ];

  @override
  void dispose() {
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

    return Scaffold(
      backgroundColor: Appcolors.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // App Bar
            SliverAppBar(
              pinned: true,
              backgroundColor: Appcolors.background,
              surfaceTintColor: Appcolors.background,
              elevation: 0,
              toolbarHeight: Dimensions.height45 * 1.6,
              titleSpacing: Dimensions.width20,
              leading: IconButton(
                icon: Container(
                  width: Dimensions.height45 * 0.9,
                  height: Dimensions.height45 * 0.9,
                  decoration: BoxDecoration(
                    color: Appcolors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(Dimensions.radius15),
                  ),
                  child: Icon(
                    Icons.arrow_back,
                    size: Dimensions.iconSize24 - 4,
                    color: Appcolors.primary,
                  ),
                ),
                onPressed: () {
                  appLog('⬅️ Back button tapped', name: 'AddCustomerPage');
                  Navigator.pop(context);
                },
              ),
              title: Text(
                'New Customer',
                style: TextStyle(
                  fontSize: Dimensions.font26 * 0.85,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F172A),
                ),
              ),
              actions: [
                IconButton(
                  icon: Container(
                    width: Dimensions.height45 * 0.9,
                    height: Dimensions.height45 * 0.9,
                    decoration: BoxDecoration(
                      color: Appcolors.textSecondary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(Dimensions.radius15),
                    ),
                    child: Icon(
                      Icons.contacts_outlined,
                      size: Dimensions.iconSize24 - 4,
                      color: Appcolors.textSecondary,
                    ),
                  ),
                  onPressed: () {
                    appLog(
                      '📱 Contacts button tapped',
                      name: 'AddCustomerPage',
                    );
                  },
                ),
                SizedBox(width: Dimensions.width10),
                Container(
                  margin: EdgeInsets.symmetric(vertical: Dimensions.height10),
                  child: ElevatedButton(
                    onPressed: () {
                      appLog('💾 Save button tapped', name: 'AddCustomerPage');
                      // TODO: Implement save functionality
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Appcolors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.width20,
                        vertical: Dimensions.height10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          Dimensions.radius15,
                        ),
                      ),
                    ),
                    child: Text(
                      'SAVE',
                      style: TextStyle(
                        fontSize: Dimensions.font16 * 0.85,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: Dimensions.width20),
              ],
            ),

            // Content
            SliverPadding(
              padding: EdgeInsets.all(Dimensions.width20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Customer Information Card
                  _buildCard('Customer Information', [
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
                        Expanded(flex: 1, child: _buildSalutationDropdown()),
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
                      (value) => setState(() => _mobileCountryCode = value!),
                      hasInfo: true,
                    ),
                  ]),

                  SizedBox(height: Dimensions.height15),

                  // Other Details Card
                  _buildCard('Other Details', [
                    _buildDropdown(
                      'Tax Treatment',
                      _selectedTaxTreatment,
                      _taxTreatmentOptions,
                      isRequired: true,
                      onChanged: (value) {
                        setState(() => _selectedTaxTreatment = value!);
                      },
                    ),
                    SizedBox(height: Dimensions.height20),
                    _buildDropdown(
                      'Place Of Supply',
                      _selectedPlaceOfSupply,
                      _placeOfSupplyOptions,
                      isRequired: true,
                      onChanged: (value) {
                        setState(() => _selectedPlaceOfSupply = value!);
                      },
                    ),
                    SizedBox(height: Dimensions.height20),
                    _buildDropdown(
                      'Currency',
                      _selectedCurrency,
                      _currencyOptions,
                      isRequired: true,
                      onChanged: (value) {
                        setState(() => _selectedCurrency = value!);
                      },
                    ),
                    SizedBox(height: Dimensions.height20),
                    _buildDropdown(
                      'Accounts Receivable',
                      _selectedAccountsReceivable,
                      _accountsReceivableOptions,
                      onChanged: (value) {
                        setState(() => _selectedAccountsReceivable = value!);
                      },
                    ),
                    SizedBox(height: Dimensions.height20),
                    _buildTextField(
                      'Opening Balance',
                      _openingBalanceController,
                      prefix: 'INR',
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: Dimensions.height20),
                    _buildDropdown(
                      'Payment Terms',
                      _selectedPaymentTerms,
                      _paymentTermsOptions,
                      onChanged: (value) {
                        setState(() => _selectedPaymentTerms = value!);
                      },
                    ),
                    SizedBox(height: Dimensions.height20),
                    _buildSectionHeader('Enable Portal?', hasInfo: true),
                    SizedBox(height: Dimensions.height10),
                    _buildCheckbox(
                      'Allow portal access for this customer',
                      _allowPortalAccess,
                      (value) {
                        setState(() => _allowPortalAccess = value ?? false);
                      },
                    ),
                    SizedBox(height: Dimensions.height20),
                    _buildDropdown(
                      'Portal Language',
                      _selectedPortalLanguage,
                      _portalLanguageOptions,
                      hasInfo: true,
                      onChanged: (value) {
                        setState(() => _selectedPortalLanguage = value!);
                      },
                    ),
                    SizedBox(height: Dimensions.height20),
                    if (_showWebsiteSocial) ...[
                      _buildTextField(
                        'Website',
                        _websiteController,
                        keyboardType: TextInputType.url,
                      ),
                      SizedBox(height: Dimensions.height20),
                      _buildTextField(
                        'Facebook',
                        _facebookController,
                        hint: 'https://www.facebook.com/',
                        keyboardType: TextInputType.url,
                      ),
                      SizedBox(height: Dimensions.height20),
                      _buildTextField(
                        'Twitter',
                        _twitterController,
                        hint: 'https://www.twitter.com/',
                        keyboardType: TextInputType.url,
                      ),
                      SizedBox(height: Dimensions.height20),
                    ],
                    _buildActionButton(
                      _showWebsiteSocial
                          ? 'Hide Website & Social'
                          : 'Add Website & Social',
                      _showWebsiteSocial
                          ? Icons.remove_circle_outline
                          : Icons.language_outlined,
                      onTap: () {
                        setState(() {
                          _showWebsiteSocial = !_showWebsiteSocial;
                        });
                        appLog(
                          _showWebsiteSocial
                              ? '🌐 Website & Social fields shown'
                              : '🌐 Website & Social fields hidden',
                          name: 'AddCustomerPage',
                        );
                      },
                    ),
                  ]),

                  SizedBox(height: Dimensions.height15),

                  // Add Billing & Shipping Address Button
                  _buildExpandableButton(
                    'Add Billing & Shipping address',
                    onTap: () {
                      appLog('📍 Add Address tapped', name: 'AddCustomerPage');
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
                  _buildCard('Remarks (For Internal Use)', [
                    _buildTextField(
                      '',
                      _remarksController,
                      maxLines: 4,
                      hint: 'Enter internal remarks...',
                    ),
                  ]),

                  SizedBox(height: Dimensions.height30),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String title, List<Widget> children) {
    return Container(
      padding: EdgeInsets.all(Dimensions.width20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Dimensions.radius20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.95,
              fontWeight: FontWeight.w700,
              color: Appcolors.textPrimary,
            ),
          ),
          SizedBox(height: Dimensions.height20),
          ...children,
        ],
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
            color: Appcolors.primary,
          ),
        ),
        if (hasInfo) ...[
          SizedBox(width: Dimensions.width10 / 2),
          Icon(
            Icons.info_outline,
            size: Dimensions.iconSize16,
            color: Appcolors.textTertiary,
          ),
        ],
      ],
    );
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
              ? Appcolors.primary.withValues(alpha: 0.05)
              : Appcolors.surfaceLight,
          borderRadius: BorderRadius.circular(Dimensions.radius15),
          border: Border.all(
            color: isSelected ? Appcolors.primary : Appcolors.border,
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
              color: isSelected ? Appcolors.primary : Appcolors.textTertiary,
              size: Dimensions.iconSize16 * 1.2,
            ),
            SizedBox(width: Dimensions.width10),
            Text(
              label,
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.85,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? Appcolors.primary : Appcolors.textPrimary,
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
                  color: Appcolors.primary,
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
                  color: Appcolors.textTertiary,
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
            color: Appcolors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Appcolors.textTertiary,
              fontSize: Dimensions.font16 * 0.85,
            ),
            prefixText: prefix != null ? '$prefix ' : null,
            prefixStyle: TextStyle(
              fontSize: Dimensions.font16 * 0.85,
              color: Appcolors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
            filled: true,
            fillColor: Appcolors.surfaceLight,
            contentPadding: EdgeInsets.symmetric(
              horizontal: Dimensions.width15,
              vertical: Dimensions.height15,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius15),
              borderSide: BorderSide(color: Appcolors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius15),
              borderSide: BorderSide(color: Appcolors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius15),
              borderSide: BorderSide(color: Appcolors.primary, width: 2),
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
                color: Appcolors.primary,
              ),
            ),
            if (hasInfo) ...[
              SizedBox(width: Dimensions.width10 / 2),
              Icon(
                Icons.info_outline,
                size: Dimensions.iconSize16,
                color: Appcolors.textTertiary,
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
                color: Appcolors.surfaceLight,
                borderRadius: BorderRadius.circular(Dimensions.radius15),
                border: Border.all(color: Appcolors.border),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    countryCode,
                    style: TextStyle(
                      fontSize: Dimensions.font16 * 0.85,
                      fontWeight: FontWeight.w600,
                      color: Appcolors.textPrimary,
                    ),
                  ),
                  SizedBox(width: Dimensions.width10 / 2),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: Dimensions.iconSize16 * 1.2,
                    color: Appcolors.textSecondary,
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
                  color: Appcolors.textPrimary,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Appcolors.surfaceLight,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: Dimensions.width15,
                    vertical: Dimensions.height15,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Dimensions.radius15),
                    borderSide: BorderSide(color: Appcolors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Dimensions.radius15),
                    borderSide: BorderSide(color: Appcolors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Dimensions.radius15),
                    borderSide: BorderSide(color: Appcolors.primary, width: 2),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDropdown(
    String label,
    String value,
    List<String> options, {
    bool isRequired = false,
    bool hasInfo = false,
    Function(String?)? onChanged,
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
                color: Appcolors.primary,
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
                color: Appcolors.textTertiary,
              ),
            ],
          ],
        ),
        SizedBox(height: Dimensions.height10),
        GestureDetector(
          onTap: () =>
              _showDropdownBottomSheet(label, value, options, onChanged),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.width15,
              vertical: Dimensions.height15,
            ),
            decoration: BoxDecoration(
              color: Appcolors.surfaceLight,
              borderRadius: BorderRadius.circular(Dimensions.radius15),
              border: Border.all(color: Appcolors.border),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: Dimensions.font16 * 0.85,
                      color: value.startsWith('Select')
                          ? Appcolors.textTertiary
                          : Appcolors.textPrimary,
                      fontWeight: value.startsWith('Select')
                          ? FontWeight.w500
                          : FontWeight.w600,
                    ),
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: Dimensions.iconSize16 * 1.2,
                  color: Appcolors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showDropdownBottomSheet(
    String label,
    String currentValue,
    List<String> options,
    Function(String?)? onChanged,
  ) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Dimensions.radius20),
        ),
      ),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (_, scrollController) => Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.width20,
                vertical: Dimensions.height15,
              ),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Appcolors.border, width: 1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: Dimensions.font20 * 0.85,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.close_rounded,
                      size: Dimensions.iconSize24,
                      color: Appcolors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            // Options
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                padding: EdgeInsets.all(Dimensions.width20),
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final option = options[index];
                  final isSelected = currentValue == option;
                  final isPlaceholder = option.startsWith('Select');

                  // Skip the placeholder option in the list
                  if (isPlaceholder && index == 0) {
                    return const SizedBox.shrink();
                  }

                  return GestureDetector(
                    onTap: () {
                      if (onChanged != null) {
                        onChanged(option);
                      }
                      Navigator.pop(context);
                      appLog('✅ Selected: $option', name: 'AddCustomerPage');
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: Dimensions.height10),
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.width15,
                        vertical: Dimensions.height15,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Appcolors.primary.withValues(alpha: 0.05)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(
                          Dimensions.radius15,
                        ),
                        border: Border.all(
                          color: isSelected
                              ? Appcolors.primary
                              : Appcolors.border,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              option,
                              style: TextStyle(
                                fontSize: Dimensions.font16,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                color: isSelected
                                    ? Appcolors.primary
                                    : Appcolors.textPrimary,
                              ),
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              Icons.check_circle,
                              color: Appcolors.primary,
                              size: Dimensions.iconSize24,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckbox(String label, bool value, Function(bool?) onChanged) {
    return Row(
      children: [
        SizedBox(
          width: Dimensions.iconSize24,
          height: Dimensions.iconSize24,
          child: Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: Appcolors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        SizedBox(width: Dimensions.width10),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.85,
              color: Appcolors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.width15,
          vertical: Dimensions.height15,
        ),
        decoration: BoxDecoration(
          color: Appcolors.primary.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(Dimensions.radius15),
          border: Border.all(color: Appcolors.primary.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: Dimensions.iconSize16, color: Appcolors.primary),
            SizedBox(width: Dimensions.width10),
            Text(
              label,
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.85,
                fontWeight: FontWeight.w600,
                color: Appcolors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableButton(String label, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(Dimensions.width20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Dimensions.radius20),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(Dimensions.width10 * 0.7),
              decoration: BoxDecoration(
                color: Appcolors.primary,
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
                  color: Appcolors.primary,
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
            color: Appcolors.primary,
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
              color: Appcolors.surfaceLight,
              borderRadius: BorderRadius.circular(Dimensions.radius15),
              border: Border.all(
                color: _selectedSalutation.isEmpty
                    ? Appcolors.border
                    : Appcolors.primary,
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
                          ? Appcolors.textTertiary
                          : Appcolors.textPrimary,
                      fontWeight: _selectedSalutation.isEmpty
                          ? FontWeight.w500
                          : FontWeight.w600,
                    ),
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: Dimensions.iconSize16 * 1.2,
                  color: Appcolors.textSecondary,
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
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Dimensions.radius20),
        ),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.width20,
                vertical: Dimensions.height15,
              ),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Appcolors.border, width: 1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Salutation',
                    style: TextStyle(
                      fontSize: Dimensions.font20 * 0.85,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.close_rounded,
                      size: Dimensions.iconSize24,
                      color: Appcolors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            // Options
            ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.all(Dimensions.width20),
              itemCount: _salutationOptions.length,
              itemBuilder: (context, index) {
                final option = _salutationOptions[index];
                final isSelected = _selectedSalutation == option;

                return GestureDetector(
                  onTap: () {
                    setState(() => _selectedSalutation = option);
                    Navigator.pop(context);
                    appLog(
                      '✅ Salutation selected: $option',
                      name: 'AddCustomerPage',
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: Dimensions.height10),
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.width15,
                      vertical: Dimensions.height15,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Appcolors.primary.withValues(alpha: 0.05)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(Dimensions.radius15),
                      border: Border.all(
                        color: isSelected
                            ? Appcolors.primary
                            : Appcolors.border,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          option,
                          style: TextStyle(
                            fontSize: Dimensions.font16,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w500,
                            color: isSelected
                                ? Appcolors.primary
                                : Appcolors.textPrimary,
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            Icons.check_circle,
                            color: Appcolors.primary,
                            size: Dimensions.iconSize24,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: Dimensions.height10),
          ],
        ),
      ),
    );
  }
}
