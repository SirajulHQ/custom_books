import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/core/widgets/unsaved_changes_dialog.dart';
import 'package:custom_books/features/customers/models/customer_model.dart';
import 'package:custom_books/features/customers/views/add_address_page.dart';
import 'package:custom_books/features/customers/views/add_contact_person_page.dart';
import 'package:custom_books/features/customers/widgets/add_customer_page_widgets/customer_custom_text_field.dart';
import 'package:custom_books/features/customers/widgets/add_customer_page_widgets/add_customer_info_card.dart';
import 'package:custom_books/features/customers/widgets/form_section_card.dart';
import 'package:custom_books/features/customers/widgets/add_customer_page_widgets/other_details_card.dart';
import 'package:flutter/material.dart';

class AddCustomerPage extends StatefulWidget {
  final CustomerModel? customer;

  const AddCustomerPage({super.key, this.customer});

  @override
  State<AddCustomerPage> createState() => _AddCustomerPageState();
}

class _AddCustomerPageState extends State<AddCustomerPage>
    with UnsavedChangesMixin {
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
                    AddCustomerInfoCard(
                      firstNameController: _firstNameController,
                      lastNameController: _lastNameController,
                      companyNameController: _companyNameController,
                      displayNameController: _displayNameController,
                      emailController: _emailController,
                      phoneController: _phoneController,
                      mobileController: _mobileController,
                      onChanged: markDirty,
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
                        markDirty();
                      },
                      onAccountsReceivableChanged: (value) {
                        setState(() => _selectedAccountsReceivable = value!);
                        markDirty();
                      },
                      onAccountsPayableChanged: (value) {
                        setState(() => _selectedAccountsPayable = value!);
                        markDirty();
                      },
                    ),

                    SizedBox(height: Dimensions.height15),

                    // Add Billing & Shipping Address Button
                    _buildExpandableButton(
                      'Add Billing & Shipping address',
                      onTap: () async {
                        appLog(
                          '📍 Add Address tapped',
                          name: 'AddCustomerPage',
                        );
                        final saved = await Navigator.push<bool>(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddAddressPage(),
                          ),
                        );
                        if (saved == true) markDirty();
                      },
                    ),

                    SizedBox(height: Dimensions.height15),

                    // Add Contact Person Button
                    _buildExpandableButton(
                      'Add Contact Person',
                      onTap: () async {
                        appLog(
                          '👤 Add Contact Person tapped',
                          name: 'AddCustomerPage',
                        );
                        final saved = await Navigator.push<bool>(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddContactPersonPage(),
                          ),
                        );
                        if (saved == true) markDirty();
                      },
                    ),

                    SizedBox(height: Dimensions.height15),

                    // Remarks Card
                    FormSectionCard(
                      title: 'Remarks (For Internal Use)',
                      children: [
                        CustomerCustomTextField(
                          label: '',
                          controller: _remarksController,
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
}
