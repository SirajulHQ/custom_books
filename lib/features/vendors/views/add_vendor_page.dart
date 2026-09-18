import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/core/widgets/form_widgets.dart';
import 'package:custom_books/core/widgets/skeletons/skeletons.dart';
import 'package:custom_books/core/widgets/unsaved_changes_dialog.dart';
import 'package:custom_books/features/vendors/models/vendor_model.dart';
import 'package:flutter/material.dart';

class AddVendorPage extends StatefulWidget {
  final VendorModel? existing;

  const AddVendorPage({super.key, this.existing});

  @override
  State<AddVendorPage> createState() => _AddVendorPageState();
}

class _AddVendorPageState extends State<AddVendorPage>
    with UnsavedChangesMixin {
  final _displayNameController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _openingBalanceController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
    if (widget.existing != null) {
      final v = widget.existing!;
      _displayNameController.text = v.displayName;
      _companyNameController.text = v.companyName;
      _emailController.text = v.email;
      _phoneController.text = v.phone;
      _openingBalanceController.text = v.payables.toStringAsFixed(2);
    }
    _displayNameController.addListener(markDirty);
    _companyNameController.addListener(markDirty);
    _emailController.addListener(markDirty);
    _phoneController.addListener(markDirty);
    _openingBalanceController.addListener(markDirty);
  }

  @override
  void dispose() {
    _displayNameController.removeListener(markDirty);
    _companyNameController.removeListener(markDirty);
    _emailController.removeListener(markDirty);
    _phoneController.removeListener(markDirty);
    _openingBalanceController.removeListener(markDirty);
    _displayNameController.dispose();
    _companyNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _openingBalanceController.dispose();
    super.dispose();
  }

  /// Simulates preparing the form so the shimmer skeleton is shown briefly.
  Future<void> _load() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() => _isLoading = false);
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

    markClean();
    Navigator.pop(context, newVendor);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: onPopInvokedWithResult,
      child: Scaffold(
        backgroundColor: context.colors.background,
        body: SafeArea(
          child: _isLoading
              ? const FormPageSkeleton()
              : CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    CustomSliverAppBar(
                      title: widget.existing == null
                          ? 'New Vendor'
                          : 'Edit Vendor',
                      leadingType: AppBarLeadingType.back,
                      onLeadingPressed: () =>
                          onPopInvokedWithResult(false, null),
                      actions: [
                        AppBarElevatedButton(
                          label: 'SAVE',
                          onPressed: _saveVendor,
                        ),
                        SizedBox(width: Dimensions.width20),
                      ],
                    ),
                    SliverToBoxAdapter(
                      child: SingleChildScrollView(
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

                                Text(
                                  'Company Name',
                                  style: FormTextStyles.label(),
                                ),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                      prefix: '₹',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
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
          borderSide: BorderSide(color: AppColors.primary),
        ),
      ),
    );
  }
}
