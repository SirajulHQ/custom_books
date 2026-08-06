import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/core/widgets/custom_back_appbar.dart';
import 'package:custom_books/core/widgets/form_widgets.dart';
import 'package:custom_books/features/payments_made/models/payment_made_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddPaymentMadePage extends StatefulWidget {
  const AddPaymentMadePage({super.key});

  @override
  State<AddPaymentMadePage> createState() => _AddPaymentMadePageState();
}

class _AddPaymentMadePageState extends State<AddPaymentMadePage> {
  final _paymentNumController = TextEditingController();
  final _referenceController = TextEditingController();
  final _amountController = TextEditingController();

  String? _vendorName;
  DateTime _paymentDate = DateTime.now();
  PaymentMode _mode = PaymentMode.bankTransfer;

  static const List<String> _vendors = [
    'Global Supplies',
    'Metro Traders',
    'Al Noor Co',
    'Prime Distributors',
  ];

  @override
  void initState() {
    super.initState();
    _paymentNumController.text = 'PM-00022';
  }

  @override
  void dispose() {
    _paymentNumController.dispose();
    _referenceController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _paymentDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null) {
      setState(() => _paymentDate = picked);
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
                        backgroundColor: Appcolors.primary.withValues(
                          alpha: 0.1,
                        ),
                        child: Text(
                          name.substring(0, 1).toUpperCase(),
                          style: TextStyle(
                            color: Appcolors.primary,
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

  Future<void> _selectPaymentMode() async {
    final selected = await showModalBottomSheet<PaymentMode>(
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
                'Payment Mode',
                style: TextStyle(
                  fontSize: Dimensions.font16 * 1.1,
                  fontWeight: FontWeight.w700,
                  color: context.colors.textPrimary,
                ),
              ),
            ),
            const Divider(height: 1),
            ...PaymentMode.values.map(
              (mode) => ListTile(
                title: Text(
                  mode.label,
                  style: TextStyle(
                    color: mode == _mode
                        ? Appcolors.primary
                        : context.colors.textPrimary,
                    fontWeight: mode == _mode
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
                trailing: mode == _mode
                    ? Icon(Icons.check_rounded, color: Appcolors.primary)
                    : null,
                onTap: () => Navigator.pop(context, mode),
              ),
            ),
          ],
        ),
      ),
    );
    if (selected != null) {
      setState(() => _mode = selected);
    }
  }

  void _savePayment() {
    if (_vendorName == null || _vendorName!.trim().isEmpty) {
      ToastificationHelper.showWarning(context, 'Please select a Vendor.');
      return;
    }
    if (_paymentNumController.text.trim().isEmpty) {
      ToastificationHelper.showWarning(
        context,
        'Please enter a Payment Number.',
      );
      return;
    }
    if (_amountController.text.trim().isEmpty) {
      ToastificationHelper.showWarning(context, 'Please enter an Amount.');
      return;
    }

    final newPayment = PaymentMadeModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      paymentNumber: _paymentNumController.text.trim(),
      vendorName: _vendorName!.trim(),
      billNumbers: const [],
      paymentDate: _paymentDate,
      mode: _mode,
      referenceNumber: _referenceController.text.trim(),
      amount: double.tryParse(_amountController.text.trim()) ?? 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    Navigator.pop(context, newPayment);
  }

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);
    final dateFormat = DateFormat('dd MMM yyyy');

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: CustomBackAppBar(
        title: 'New Payment',
        backgroundColor: context.colors.card,
        actions: [
          TextButton(
            onPressed: _savePayment,
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
                const RequiredLabel(text: 'Vendor'),
                SizedBox(height: Dimensions.height10 / 2),
                _selectorField(
                  value: _vendorName,
                  hint: 'Select a vendor',
                  onTap: _selectVendor,
                ),
                SizedBox(height: Dimensions.height20),

                const RequiredLabel(text: 'Payment#'),
                SizedBox(height: Dimensions.height10 / 2),
                TextField(
                  controller: _paymentNumController,
                  style: FormTextStyles.value(context),
                  decoration: _underlineDecoration(),
                ),
                SizedBox(height: Dimensions.height20),

                const RequiredLabel(text: 'Payment Date'),
                SizedBox(height: Dimensions.height10 / 2),
                _dateField(dateFormat.format(_paymentDate), _pickDate),
                SizedBox(height: Dimensions.height20),

                Text('Payment Mode', style: FormTextStyles.label()),
                SizedBox(height: Dimensions.height10 / 2),
                _selectorField(
                  value: _mode.label,
                  hint: 'Select payment mode',
                  onTap: _selectPaymentMode,
                ),
                SizedBox(height: Dimensions.height20),

                Text('Reference#', style: FormTextStyles.label()),
                SizedBox(height: Dimensions.height10 / 2),
                TextField(
                  controller: _referenceController,
                  style: FormTextStyles.value(context),
                  decoration: _underlineDecoration(),
                ),
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
        borderSide: BorderSide(color: Appcolors.primary),
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
