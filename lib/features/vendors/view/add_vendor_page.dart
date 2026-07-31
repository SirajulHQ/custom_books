import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/core/widgets/form_widgets.dart';
import 'package:custom_books/features/vendors/models/vendor_model.dart';
import 'package:flutter/material.dart';

class AddVendorPage extends StatefulWidget {
  const AddVendorPage({super.key});

  @override
  State<AddVendorPage> createState() => _AddVendorPageState();
}

class _AddVendorPageState extends State<AddVendorPage> {
  final _displayNameController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _openingBalanceController = TextEditingController();

  @override
  void dispose() {
    _displayNameController.dispose();
    _companyNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _openingBalanceController.dispose();
    super.dispose();
  }

  void _saveVendor() {
    if (_displayNameController.text.trim().isEmpty) {
      ToastificationHelper.showWarning(context, 'Please enter a Display Name.');
      return;
    }

    final newVendor = VendorModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      displayName: _displayNameController.text.trim(),
      companyName: _companyNameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      payables: double.tryParse(_openingBalanceController.text.trim()) ?? 0,
      unusedCredits: 0,
      status: VendorStatus.active,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    Navigator.pop(context, newVendor);
  }

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: context.colors.card,
        elevation: 0.5,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: context.colors.textPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'New Vendor',
          style: TextStyle(
            color: context.colors.textPrimary,
            fontSize: Dimensions.font20 * 0.9,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _saveVendor,
            child: Text(
              'SAVE',
              style: TextStyle(
                color: Appcolors.primary,
                fontWeight: FontWeight.w800,
                fontSize: Dimensions.font16 * 0.75,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Dimensions.width15),
        child: Column(
          children: [
            FormCard(
              children: [
                const RequiredLabel(text: 'Display Name'),
                SizedBox(height: Dimensions.height10 / 2),
                _underlineField(
                  controller: _displayNameController,
                  hint: 'Enter display name',
                ),
                SizedBox(height: Dimensions.height20),

                Text('Company Name', style: FormTextStyles.label()),
                SizedBox(height: Dimensions.height10 / 2),
                _underlineField(
                  controller: _companyNameController,
                  hint: 'Enter company name',
                ),
                SizedBox(height: Dimensions.height20),

                Text('Email', style: FormTextStyles.label()),
                SizedBox(height: Dimensions.height10 / 2),
                _underlineField(
                  controller: _emailController,
                  hint: 'name@example.com',
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: Dimensions.height20),

                Text('Phone', style: FormTextStyles.label()),
                SizedBox(height: Dimensions.height10 / 2),
                _underlineField(
                  controller: _phoneController,
                  hint: '+971 50 123 4567',
                  keyboardType: TextInputType.phone,
                ),
              ],
            ),
            SizedBox(height: Dimensions.height15),

            FormCard(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Opening Balance (Payables)',
                        style: FormTextStyles.label(),
                      ),
                    ),
                    SizedBox(width: Dimensions.width10),
                    FormNumberField(
                      controller: _openingBalanceController,
                      hint: '0.00',
                      prefix: 'AED',
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _underlineField({
    required TextEditingController controller,
    String? hint,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: FormTextStyles.value(context),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: context.colors.textTertiary),
        isDense: true,
        contentPadding: EdgeInsets.symmetric(vertical: Dimensions.height10),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: context.colors.border),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: context.colors.border),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Appcolors.primary),
        ),
      ),
    );
  }
}
