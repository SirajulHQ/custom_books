import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/core/widgets/form_widgets.dart';
import 'package:custom_books/features/expenses/models/expense_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final _referenceController = TextEditingController();
  final _amountController = TextEditingController();

  String? _category;
  String? _vendorName;
  DateTime _expenseDate = DateTime.now();

  static const List<String> _categories = [
    'Fuel/Mileage',
    'Meals',
    'Office Supplies',
    'Travel',
    'Rent',
    'Utilities',
    'Other',
  ];

  static const List<String> _vendors = [
    'Global Supplies',
    'Metro Traders',
    'Al Noor Co',
    'Prime Distributors',
  ];

  @override
  void dispose() {
    _referenceController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _expenseDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null) {
      setState(() => _expenseDate = picked);
    }
  }

  Future<void> _selectCategory() async {
    final selected = await _selectFromSheet(
      'Select Category',
      _categories,
      _category,
    );
    if (selected != null) {
      setState(() => _category = selected);
    }
  }

  Future<void> _selectVendor() async {
    final selected = await _selectFromSheet(
      'Select Vendor',
      _vendors,
      _vendorName,
    );
    if (selected != null) {
      setState(() => _vendorName = selected);
    }
  }

  Future<String?> _selectFromSheet(
    String title,
    List<String> options,
    String? current,
  ) {
    return showModalBottomSheet<String>(
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
                title,
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
                  ...options.map(
                    (option) => ListTile(
                      title: Text(
                        option,
                        style: TextStyle(
                          color: option == current
                              ? Appcolors.primary
                              : context.colors.textPrimary,
                          fontWeight: option == current
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      trailing: option == current
                          ? Icon(Icons.check_rounded, color: Appcolors.primary)
                          : null,
                      onTap: () => Navigator.pop(context, option),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveExpense({ExpenseStatus status = ExpenseStatus.unbilled}) {
    if (_category == null || _category!.trim().isEmpty) {
      ToastificationHelper.showWarning(context, 'Please select a Category.');
      return;
    }
    if (_amountController.text.trim().isEmpty) {
      ToastificationHelper.showWarning(context, 'Please enter an Amount.');
      return;
    }

    final newExpense = ExpenseModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      category: _category!.trim(),
      vendorName: _vendorName ?? '',
      expenseDate: _expenseDate,
      referenceNumber: _referenceController.text.trim(),
      status: status,
      amount: double.tryParse(_amountController.text.trim()) ?? 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    Navigator.pop(context, newExpense);
  }

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);
    final dateFormat = DateFormat('dd MMM yyyy');

    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            CustomSliverAppBar(
              title: 'New Expense',
              leadingType: AppBarLeadingType.back,
              actions: [
                AppBarElevatedButton(
                  label: 'SAVE',
                  onPressed: () => _saveExpense(status: ExpenseStatus.unbilled),
                ),
                SizedBox(width: Dimensions.width10),
                AppBarIconButton(
                  icon: Icons.more_vert_rounded,
                  color: Appcolors.accent,
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
                                Icons.receipt_rounded,
                                color: Appcolors.primary,
                              ),
                              title: Text(
                                'Save as Billed',
                                style: TextStyle(
                                  fontSize: Dimensions.font16 * 0.9,
                                  fontWeight: FontWeight.w600,
                                  color: context.colors.textPrimary,
                                ),
                              ),
                              onTap: () {
                                Navigator.pop(ctx);
                                _saveExpense(status: ExpenseStatus.billed);
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
                        const RequiredLabel(text: 'Category'),
                        SizedBox(height: Dimensions.height10 / 2),
                        _selectorField(
                          value: _category,
                          hint: 'Select a category',
                          onTap: _selectCategory,
                        ),
                        SizedBox(height: Dimensions.height20),

                        Text('Vendor', style: FormTextStyles.label()),
                        SizedBox(height: Dimensions.height10 / 2),
                        _selectorField(
                          value: _vendorName,
                          hint: 'Select a vendor',
                          onTap: _selectVendor,
                        ),
                        SizedBox(height: Dimensions.height20),

                        const RequiredLabel(text: 'Expense Date'),
                        SizedBox(height: Dimensions.height10 / 2),
                        _dateField(dateFormat.format(_expenseDate), _pickDate),
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
