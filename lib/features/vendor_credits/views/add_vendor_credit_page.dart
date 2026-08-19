import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/core/widgets/form_widgets.dart';
import 'package:custom_books/core/widgets/unsaved_changes_dialog.dart';
import 'package:custom_books/features/vendor_credits/models/vendor_credit_model.dart';
import 'package:flutter/material.dart';
import 'package:custom_books/core/utils/date_formatter.dart';

class AddVendorCreditPage extends StatefulWidget {
  const AddVendorCreditPage({super.key});

  @override
  State<AddVendorCreditPage> createState() => _AddVendorCreditPageState();
}

class _AddVendorCreditPageState extends State<AddVendorCreditPage>
    with UnsavedChangesMixin {
  final _creditNoteNumController = TextEditingController();
  final _referenceController = TextEditingController();
  final _amountController = TextEditingController();

  String? _vendorName;
  DateTime _creditDate = DateTime.now();

  static const List<String> _vendors = [
    'Global Supplies',
    'Metro Traders',
    'Al Noor Co',
    'Prime Distributors',
  ];

  @override
  void initState() {
    super.initState();
    _creditNoteNumController.text = 'VCN-00016';
    _creditNoteNumController.addListener(markDirty);
    _referenceController.addListener(markDirty);
    _amountController.addListener(markDirty);
  }

  @override
  void dispose() {
    _creditNoteNumController.removeListener(markDirty);
    _referenceController.removeListener(markDirty);
    _amountController.removeListener(markDirty);
    _creditNoteNumController.dispose();
    _referenceController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _creditDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null) {
      setState(() => _creditDate = picked);
    }
  }

  Future<void> _selectVendor() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      backgroundColor: context.colors.card,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(Dimensions.width15),
              child: Text(
                'Select Vendor',
                style: TextStyle(
                  fontSize: Dimensions.font16 * 1.1,
                  fontWeight: FontWeight.w700,
                  color: context.colors.textPrimary,
                ),
              ),
            ),
            const Divider(height: 1),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [
                  ..._vendors.map(
                    (name) => ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primary.withValues(
                          alpha: 0.1,
                        ),
                        child: Text(
                          name.substring(0, 1).toUpperCase(),
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        name,
                        style: TextStyle(color: context.colors.textPrimary),
                      ),
                      onTap: () => Navigator.pop(context, name),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    if (selected != null) {
      setState(() => _vendorName = selected);
    }
  }

  void _saveCredit({VendorCreditStatus status = VendorCreditStatus.draft}) {
    if (_vendorName == null || _vendorName!.trim().isEmpty) {
      ToastificationHelper.showWarning(context, 'Please select a Vendor.');
      return;
    }
    if (_creditNoteNumController.text.trim().isEmpty) {
      ToastificationHelper.showWarning(
        context,
        'Please enter a Credit Note Number.',
      );
      return;
    }

    final newCredit = VendorCreditModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      creditNoteNumber: _creditNoteNumController.text.trim(),
      vendorName: _vendorName!.trim(),
      referenceNumber: _referenceController.text.trim(),
      creditDate: _creditDate,
      status: status,
      total: double.tryParse(_amountController.text.trim()) ?? 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    markClean();
    Navigator.pop(context, newCredit);
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
              CustomSliverAppBar(
                title: 'New Vendor Credit',
                leadingType: AppBarLeadingType.back,
                onLeadingPressed: () => onPopInvokedWithResult(false, null),
                actions: [
                  AppBarElevatedButton(
                    label: 'SAVE AS DRAFT',
                    onPressed: () =>
                        _saveCredit(status: VendorCreditStatus.draft),
                  ),
                  SizedBox(width: Dimensions.width10),
                  AppBarIconButton(
                    icon: Icons.more_vert_rounded,
                    color: AppColors.accent,
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        builder: (ctx) => Container(
                          decoration: BoxDecoration(
                            color: context.colors.card,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(Dimensions.radius20 * 1.2),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: Dimensions.width20 * 2,
                                height: Dimensions.height10 * 0.4,
                                margin: EdgeInsets.symmetric(
                                  vertical: Dimensions.height10,
                                ),
                                decoration: BoxDecoration(
                                  color: context.colors.border,
                                  borderRadius: BorderRadius.circular(
                                    Dimensions.radius30,
                                  ),
                                ),
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.save_rounded,
                                  color: AppColors.primary,
                                ),
                                title: Text(
                                  'Save as Open',
                                  style: TextStyle(
                                    fontSize: Dimensions.font16 * 0.9,
                                    fontWeight: FontWeight.w600,
                                    color: context.colors.textPrimary,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.pop(ctx);
                                  _saveCredit(status: VendorCreditStatus.open);
                                },
                              ),
                              SizedBox(height: Dimensions.height20),
                            ],
                          ),
                        ),
                      );
                    },
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
                          const RequiredLabel(text: 'Vendor'),
                          SizedBox(height: Dimensions.height10 / 2),
                          _selectorField(
                            value: _vendorName,
                            hint: 'Select a vendor',
                            onTap: _selectVendor,
                          ),
                          SizedBox(height: Dimensions.height20),
                          const RequiredLabel(text: 'Credit Note#'),
                          SizedBox(height: Dimensions.height10 / 2),
                          TextField(
                            controller: _creditNoteNumController,
                            style: FormTextStyles.value(context),
                            decoration: _underlineDecoration(),
                          ),
                          SizedBox(height: Dimensions.height20),
                          Text('Reference#', style: FormTextStyles.label()),
                          SizedBox(height: Dimensions.height10 / 2),
                          TextField(
                            controller: _referenceController,
                            style: FormTextStyles.value(context),
                            decoration: _underlineDecoration(),
                          ),
                          SizedBox(height: Dimensions.height20),
                          const RequiredLabel(text: 'Credit Date'),
                          SizedBox(height: Dimensions.height10 / 2),
                          _dateField(formatDate(_creditDate), _pickDate),
                        ],
                      ),
                      SizedBox(height: Dimensions.height15),
                      FormCard(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const RequiredLabel(text: 'Amount'),
                              FormNumberField(
                                controller: _amountController,
                                hint: '0.00',
                                prefix: '₹',
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: Dimensions.height30),
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

  InputDecoration _underlineDecoration() {
    return InputDecoration(
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
    );
  }

  Widget _selectorField({
    required String? value,
    required String hint,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: Dimensions.height10),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: context.colors.border)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                value ?? hint,
                style: TextStyle(
                  fontSize: Dimensions.font16 * 0.9,
                  color: value == null
                      ? context.colors.textTertiary
                      : context.colors.textPrimary,
                  fontWeight: value == null
                      ? FontWeight.normal
                      : FontWeight.w600,
                ),
              ),
            ),
            Icon(
              Icons.arrow_drop_down_rounded,
              size: Dimensions.iconSize24,
              color: context.colors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _dateField(String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: Dimensions.height10),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: context.colors.border)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text, style: FormTextStyles.value(context)),
            Icon(
              Icons.calendar_today_outlined,
              size: Dimensions.iconSize24 * 0.85,
              color: context.colors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
