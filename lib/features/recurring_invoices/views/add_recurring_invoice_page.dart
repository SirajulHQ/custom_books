import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/core/widgets/form_widgets.dart';
import 'package:custom_books/features/recurring_invoices/models/recurring_invoice_model.dart';
import 'package:flutter/material.dart';
import 'package:custom_books/core/utils/date_formatter.dart';

class AddRecurringInvoicePage extends StatefulWidget {
  const AddRecurringInvoicePage({super.key});

  @override
  State<AddRecurringInvoicePage> createState() =>
      _AddRecurringInvoicePageState();
}

class _AddRecurringInvoicePageState extends State<AddRecurringInvoicePage> {
  final _profileNameController = TextEditingController();
  final _customerController = TextEditingController();
  final _amountController = TextEditingController();

  DateTime _startDate = DateTime.now();
  RecurringFrequency _frequency = RecurringFrequency.monthly;

  static const List<String> _customers = [
    'Nandhu',
    'Parthiv Ajith',
    'Amal',
    'Nabeel',
    'Tech Geum',
  ];

  @override
  void dispose() {
    _profileNameController.dispose();
    _customerController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null) {
      setState(() => _startDate = picked);
    }
  }

  Future<void> _selectCustomer() async {
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
                'Select Customer',
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
                  ..._customers.map(
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
      setState(() => _customerController.text = selected);
    }
  }

  Future<void> _selectFrequency() async {
    final selected = await showModalBottomSheet<RecurringFrequency>(
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
                'Frequency',
                style: TextStyle(
                  fontSize: Dimensions.font16 * 1.1,
                  fontWeight: FontWeight.w700,
                  color: context.colors.textPrimary,
                ),
              ),
            ),
            const Divider(height: 1),
            ...RecurringFrequency.values.map(
              (freq) => ListTile(
                title: Text(
                  freq.label,
                  style: TextStyle(
                    color: freq == _frequency
                        ? AppColors.primary
                        : context.colors.textPrimary,
                    fontWeight: freq == _frequency
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
                trailing: freq == _frequency
                    ? Icon(Icons.check_rounded, color: AppColors.primary)
                    : null,
                onTap: () => Navigator.pop(context, freq),
              ),
            ),
          ],
        ),
      ),
    );

    if (selected != null) {
      setState(() => _frequency = selected);
    }
  }

  void _saveProfile({
    RecurringInvoiceStatus status = RecurringInvoiceStatus.active,
  }) {
    if (_profileNameController.text.trim().isEmpty) {
      ToastificationHelper.showWarning(context, 'Please enter a Profile Name.');
      return;
    }
    if (_customerController.text.trim().isEmpty) {
      ToastificationHelper.showWarning(context, 'Please select a Customer.');
      return;
    }
    if (_amountController.text.trim().isEmpty) {
      ToastificationHelper.showWarning(context, 'Please enter an Amount.');
      return;
    }

    final newProfile = RecurringInvoiceModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      profileName: _profileNameController.text.trim(),
      customerName: _customerController.text.trim(),
      frequency: _frequency,
      startDate: _startDate,
      status: status,
      amount: double.tryParse(_amountController.text.trim()) ?? 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    Navigator.pop(context, newProfile);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            CustomSliverAppBar(
              title: 'New Recurring Invoice',
              leadingType: AppBarLeadingType.back,
              actions: [
                AppBarElevatedButton(
                  label: 'SAVE',
                  onPressed: () =>
                      _saveProfile(status: RecurringInvoiceStatus.active),
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
                                Icons.drafts_rounded,
                                color: AppColors.primary,
                              ),
                              title: Text(
                                'Save as Draft',
                                style: TextStyle(
                                  fontSize: Dimensions.font16 * 0.9,
                                  fontWeight: FontWeight.w600,
                                  color: context.colors.textPrimary,
                                ),
                              ),
                              onTap: () {
                                Navigator.pop(ctx);
                                _saveProfile(
                                  status: RecurringInvoiceStatus.draft,
                                );
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
                        // Profile Name *
                        const RequiredLabel(text: 'Profile Name'),
                        SizedBox(height: Dimensions.height10 / 2),
                        TextField(
                          controller: _profileNameController,
                          style: FormTextStyles.value(context),
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: Dimensions.height10,
                            ),
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: context.colors.border,
                              ),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: context.colors.border,
                              ),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: AppColors.primary),
                            ),
                          ),
                        ),
                        SizedBox(height: Dimensions.height20),

                        // Customer Name *
                        const RequiredLabel(text: 'Customer Name'),
                        SizedBox(height: Dimensions.height10 / 2),
                        InkWell(
                          onTap: _selectCustomer,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: Dimensions.width10 / 2,
                              vertical: Dimensions.height10,
                            ),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: context.colors.border,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    _customerController.text.isEmpty
                                        ? 'Start typing to select a Customer'
                                        : _customerController.text,
                                    style: TextStyle(
                                      fontSize: Dimensions.font16 * 0.9,
                                      color: _customerController.text.isEmpty
                                          ? context.colors.textTertiary
                                          : context.colors.textPrimary,
                                      fontWeight:
                                          _customerController.text.isEmpty
                                          ? FontWeight.normal
                                          : FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.add_rounded,
                                  size: Dimensions.iconSize24,
                                  color: context.colors.textPrimary,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: Dimensions.height20),

                        // Frequency
                        Text('Frequency', style: FormTextStyles.label()),
                        SizedBox(height: Dimensions.height10 / 2),
                        InkWell(
                          onTap: _selectFrequency,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: Dimensions.height10,
                            ),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: context.colors.border,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _frequency.label,
                                  style: FormTextStyles.value(context),
                                ),
                                Icon(
                                  Icons.arrow_drop_down_rounded,
                                  size: Dimensions.iconSize24,
                                  color: context.colors.textSecondary,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: Dimensions.height20),

                        // Start Date *
                        const RequiredLabel(text: 'Start Date'),
                        SizedBox(height: Dimensions.height10 / 2),
                        InkWell(
                          onTap: _pickDate,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: Dimensions.height10,
                            ),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: context.colors.border,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  formatDate(_startDate),
                                  style: FormTextStyles.value(context),
                                ),
                                Icon(
                                  Icons.calendar_today_outlined,
                                  size: Dimensions.iconSize24 * 0.85,
                                  color: context.colors.textSecondary,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: Dimensions.height20),

                        // Amount (₹) *
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const RequiredLabel(text: 'Amount (₹)'),
                            FormNumberField(
                              controller: _amountController,
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
    );
  }
}
