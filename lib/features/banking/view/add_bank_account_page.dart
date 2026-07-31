import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:flutter/material.dart';

class AddBankAccountPage extends StatefulWidget {
  const AddBankAccountPage({super.key});

  @override
  State<AddBankAccountPage> createState() => _AddBankAccountPageState();
}

class _AddBankAccountPageState extends State<AddBankAccountPage> {
  String _selectedAccountType = 'Bank';
  bool _makePrimary = false;
  String _selectedCurrency = 'INR- Indian Rupee';
  final TextEditingController _currencySearchController =
      TextEditingController();

  final _accountNameController = TextEditingController();
  final _accountCodeController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _ifscCodeController = TextEditingController();
  final _descriptionController = TextEditingController();

  final List<String> _currencies = [
    'AED- UAE Dirham',
    'AUD- Australian Dollar',
    'BND- Brunei Dollar',
    'CAD- Canadian Dollar',
    'CNY- Yuan Renminbi',
    'EUR- Euro',
    'GBP- Pound Sterling',
    'INR- Indian Rupee',
    'JPY- Japanese Yen',
    'SAR- Saudi Riyal',
    'USD- United States Dollar',
    'ZAR- South African Rand',
  ];

  List<String> get _filteredCurrencies {
    final query = _currencySearchController.text.toLowerCase();
    if (query.isEmpty) {
      return _currencies;
    }
    return _currencies
        .where((currency) => currency.toLowerCase().contains(query))
        .toList();
  }

  @override
  void dispose() {
    _currencySearchController.dispose();
    _accountNameController.dispose();
    _accountCodeController.dispose();
    _accountNumberController.dispose();
    _bankNameController.dispose();
    _ifscCodeController.dispose();
    _descriptionController.dispose();
    super.dispose();
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
            // App Bar
            CustomSliverAppBar(
              title: 'Add Bank or Credit Card',
              subtitle: 'Fill in the account details',
              leadingType: AppBarLeadingType.back,
              actions: [
                AppBarElevatedButton(label: 'SAVE', onPressed: _saveAccount),
                SizedBox(width: Dimensions.width20),
              ],
            ),

            // Content
            SliverPadding(
              padding: EdgeInsets.all(Dimensions.width20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Account Type and Details Card
                  _buildCard([
                    // Account Type Selection
                    Text(
                      'Select Account Type',
                      style: TextStyle(
                        fontSize: Dimensions.font16 * 0.9,
                        fontWeight: FontWeight.w700,
                        color: context.colors.textPrimary,
                      ),
                    ),
                    SizedBox(height: Dimensions.height10),
                    Container(
                      decoration: BoxDecoration(
                        color: context.colors.surfaceLight,
                        borderRadius: BorderRadius.circular(
                          Dimensions.radius15 / 2,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.width10,
                        vertical: Dimensions.height10 / 2,
                      ),
                      child: Column(
                        children: [
                          _buildRadioOption(
                            'Bank',
                            Icons.account_balance_outlined,
                          ),
                          _buildRadioOption(
                            'Credit Card',
                            Icons.credit_card_outlined,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: Dimensions.height20),
                    Divider(height: 1, color: context.colors.border),
                    SizedBox(height: Dimensions.height20),

                    // Account Name
                    _buildTextField(
                      'Account Name',
                      _accountNameController,
                      isRequired: true,
                      icon: Icons.account_balance_wallet_outlined,
                      hint: 'Enter Account Name',
                    ),
                    SizedBox(height: Dimensions.height20),

                    // Account Code
                    _buildTextField(
                      'Account Code',
                      _accountCodeController,
                      icon: Icons.numbers_outlined,
                      hint: 'Enter Account Code',
                    ),
                    SizedBox(height: Dimensions.height20),

                    // Currency
                    _buildCurrencyField('Currency', isRequired: true),
                  ]),

                  SizedBox(height: Dimensions.height15),

                  // Bank Details Card
                  _buildCard([
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(Dimensions.width10 * 0.7),
                          decoration: BoxDecoration(
                            color: Appcolors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(
                              Dimensions.radius15 / 2,
                            ),
                          ),
                          child: Icon(
                            Icons.account_balance_outlined,
                            size: Dimensions.iconSize16 * 1.2,
                            color: Appcolors.primary,
                          ),
                        ),
                        SizedBox(width: Dimensions.width10),
                        Text(
                          'Bank Details',
                          style: TextStyle(
                            fontSize: Dimensions.font16 * 0.95,
                            fontWeight: FontWeight.w700,
                            color: context.colors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Dimensions.height20),

                    // Account Number
                    _buildTextField(
                      'Account Number',
                      _accountNumberController,
                      icon: Icons.tag_outlined,
                      hint: 'Enter Account Number',
                    ),
                    SizedBox(height: Dimensions.height20),

                    // Bank Name
                    _buildTextField(
                      'Bank Name',
                      _bankNameController,
                      icon: Icons.domain_outlined,
                      hint: 'Enter Bank Name',
                    ),
                    SizedBox(height: Dimensions.height20),

                    // IFSC Code
                    _buildTextField(
                      'IFSC Code',
                      _ifscCodeController,
                      icon: Icons.qr_code_outlined,
                      hint: 'Enter IFSC Code',
                    ),
                  ]),

                  SizedBox(height: Dimensions.height15),

                  // Additional Information Card
                  _buildCard([
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(Dimensions.width10 * 0.7),
                          decoration: BoxDecoration(
                            color: Appcolors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(
                              Dimensions.radius15 / 2,
                            ),
                          ),
                          child: Icon(
                            Icons.description_outlined,
                            size: Dimensions.iconSize16 * 1.2,
                            color: Appcolors.primary,
                          ),
                        ),
                        SizedBox(width: Dimensions.width10),
                        Text(
                          'Additional Information',
                          style: TextStyle(
                            fontSize: Dimensions.font16 * 0.95,
                            fontWeight: FontWeight.w700,
                            color: context.colors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Dimensions.height20),

                    // Description
                    _buildTextField(
                      'Description',
                      _descriptionController,
                      icon: Icons.notes_outlined,
                      hint: 'Max. 500 characters',
                      maxLines: 4,
                    ),
                    SizedBox(height: Dimensions.height20),

                    // Make this primary checkbox
                    _buildCheckbox('Make this primary', _makePrimary, (value) {
                      setState(() {
                        _makePrimary = value ?? false;
                      });
                    }),
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

  Widget _buildCard(List<Widget> children) {
    return Container(
      padding: EdgeInsets.all(Dimensions.width20),
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: BorderRadius.circular(Dimensions.radius20),
        border: Border.all(color: context.colors.border),
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
        children: children,
      ),
    );
  }

  Widget _buildRadioOption(String label, IconData icon) {
    final isSelected = _selectedAccountType == label;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedAccountType = label);
      },
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.all(Dimensions.width10),
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? Appcolors.primary
                      : context.colors.textTertiary,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Appcolors.primary,
                        ),
                      ),
                    )
                  : null,
            ),
          ),
          Icon(
            icon,
            size: Dimensions.iconSize16,
            color: isSelected
                ? Appcolors.primary
                : context.colors.textSecondary,
          ),
          SizedBox(width: Dimensions.width10 / 2),
          Text(
            label,
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.85,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected
                  ? Appcolors.primary
                  : context.colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool isRequired = false,
    IconData? icon,
    String? hint,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: Dimensions.iconSize16,
                color: context.colors.textSecondary,
              ),
              SizedBox(width: Dimensions.width10 / 2),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.85,
                fontWeight: FontWeight.w600,
                color: context.colors.textPrimary,
              ),
            ),
            if (isRequired)
              Text(
                ' *',
                style: TextStyle(
                  color: Appcolors.error,
                  fontSize: Dimensions.font16 * 0.85,
                ),
              ),
          ],
        ),
        SizedBox(height: Dimensions.height10 / 2),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: TextStyle(
            fontSize: Dimensions.font16 * 0.85,
            color: context.colors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              fontSize: Dimensions.font16 * 0.8,
              color: context.colors.textTertiary,
            ),
            filled: true,
            fillColor: context.colors.surfaceLight,
            contentPadding: EdgeInsets.symmetric(
              horizontal: Dimensions.width15,
              vertical: Dimensions.height15,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius15 / 2),
              borderSide: BorderSide(color: context.colors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius15 / 2),
              borderSide: BorderSide(color: context.colors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius15 / 2),
              borderSide: BorderSide(color: Appcolors.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCurrencyField(String label, {bool isRequired = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.currency_exchange_outlined,
              size: Dimensions.iconSize16,
              color: context.colors.textSecondary,
            ),
            SizedBox(width: Dimensions.width10 / 2),
            Text(
              label,
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.85,
                fontWeight: FontWeight.w600,
                color: context.colors.textPrimary,
              ),
            ),
            if (isRequired)
              Text(
                ' *',
                style: TextStyle(
                  color: Appcolors.error,
                  fontSize: Dimensions.font16 * 0.85,
                ),
              ),
          ],
        ),
        SizedBox(height: Dimensions.height10 / 2),
        GestureDetector(
          onTap: _showCurrencyBottomSheet,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.width15,
              vertical: Dimensions.height15,
            ),
            decoration: BoxDecoration(
              color: context.colors.surfaceLight,
              borderRadius: BorderRadius.circular(Dimensions.radius15 / 2),
              border: Border.all(color: context.colors.border),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedCurrency,
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.85,
                    color: context.colors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: context.colors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showCurrencyBottomSheet() {
    _currencySearchController.clear();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              decoration: BoxDecoration(
                color: context.colors.card,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(Dimensions.radius20),
                  topRight: Radius.circular(Dimensions.radius20),
                ),
              ),
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.width20,
                      vertical: Dimensions.height15,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: context.colors.border,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Currency',
                          style: TextStyle(
                            fontSize: Dimensions.font20,
                            fontWeight: FontWeight.w700,
                            color: context.colors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Search Field
                  Padding(
                    padding: EdgeInsets.all(Dimensions.width20),
                    child: TextField(
                      controller: _currencySearchController,
                      onChanged: (value) {
                        setModalState(() {});
                      },
                      style: TextStyle(
                        fontSize: Dimensions.font16 * 0.85,
                        color: context.colors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search',
                        hintStyle: TextStyle(
                          fontSize: Dimensions.font16 * 0.85,
                          color: context.colors.textTertiary,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: context.colors.textSecondary,
                        ),
                        filled: true,
                        fillColor: context.colors.surfaceLight,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: Dimensions.width15,
                          vertical: Dimensions.height10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            Dimensions.radius15 / 2,
                          ),
                          borderSide: BorderSide(color: context.colors.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            Dimensions.radius15 / 2,
                          ),
                          borderSide: BorderSide(color: context.colors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            Dimensions.radius15 / 2,
                          ),
                          borderSide: BorderSide(
                            color: Appcolors.primary,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Currency List
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.width20,
                      ),
                      itemCount: _filteredCurrencies.length,
                      itemBuilder: (context, index) {
                        final currency = _filteredCurrencies[index];
                        final isSelected = currency == _selectedCurrency;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedCurrency = currency;
                            });
                            Navigator.pop(context);
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                              bottom: Dimensions.height10,
                            ),
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
                                    : context.colors.border,
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  currency,
                                  style: TextStyle(
                                    fontSize: Dimensions.font16,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                                    color: isSelected
                                        ? Appcolors.primary
                                        : context.colors.textPrimary,
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
            );
          },
        );
      },
    );
  }

  Widget _buildCheckbox(String label, bool value, Function(bool?) onChanged) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            height: 24,
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
          Text(
            label,
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.85,
              color: context.colors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _saveAccount() {
    // Validate required fields
    if (_accountNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter account name'),
          backgroundColor: Appcolors.error,
        ),
      );
      return;
    }

    ToastificationHelper.showSuccess(
      context,
      '${_accountNameController.text.trim()} saved successfully.',
    );
    Navigator.pop(context);
  }
}
