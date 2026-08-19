import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/features/customers/widgets/form_section_card.dart';
import 'package:custom_books/features/customers/widgets/salutation_bottom_sheet.dart';
import 'package:custom_books/features/invoices/widgets/new_invoice_page_widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class CustomerInformationCard extends StatefulWidget {
  const CustomerInformationCard({super.key});

  @override
  State<CustomerInformationCard> createState() =>
      _CustomerInformationCardState();
}

class _CustomerInformationCardState extends State<CustomerInformationCard> {
  String _phoneCountryCode = '+91';
  String _mobileCountryCode = '+91';
  String _customerType = 'Business';
  String _selectedSalutation = '';

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  final List<String> _salutationOptions = [
    'Mr.',
    'Mrs.',
    'Ms.',
    'Miss.',
    'Dr.',
  ];

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _companyNameController.dispose();
    _displayNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormSectionCard(
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
            Expanded(flex: 1, child: _buildSalutationDropdown()),

            SizedBox(width: Dimensions.width15),

            Expanded(
              flex: 2,
              child: CustomTextField(
                label: 'First Name',
                controller: _firstNameController,
              ),
            ),
          ],
        ),

        SizedBox(height: Dimensions.height20),

        CustomTextField(label: 'Last Name', controller: _lastNameController),

        SizedBox(height: Dimensions.height20),

        CustomTextField(
          label: 'Company Name',
          controller: _companyNameController,
        ),

        SizedBox(height: Dimensions.height20),

        CustomTextField(
          label: 'Display Name',
          controller: _displayNameController,
          isRequired: true,
          hasInfo: true,
        ),

        SizedBox(height: Dimensions.height20),

        CustomTextField(
          label: 'Email Address',
          controller: _emailController,
          hasInfo: true,
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
