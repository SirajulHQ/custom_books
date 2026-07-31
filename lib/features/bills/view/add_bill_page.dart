import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/core/widgets/form_widgets.dart';
import 'package:custom_books/features/bills/models/bill_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddBillPage extends StatefulWidget {
  const AddBillPage({super.key});

  @override
  State<AddBillPage> createState() => _AddBillPageState();
}

class _AddBillPageState extends State<AddBillPage> {
  final _billNumController = TextEditingController();
  final _amountController = TextEditingController();

  String? _vendorName;
  DateTime _billDate = DateTime.now();
  DateTime _dueDate = DateTime.now().add(const Duration(days: 15));

  static const List<String> _vendors = [
    'Global Supplies',
    'Metro Traders',
    'Al Noor Co',
    'Prime Distributors',
  ];

  @override
  void initState() {
    super.initState();
    _billNumController.text = 'BILL-00043';
  }

  @override
  void dispose() {
    _billNumController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool isDueDate}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isDueDate ? _dueDate : _billDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null) {
      setState(() {
        if (isDueDate) {
          _dueDate = picked;
        } else {
          _billDate = picked;
        }
      });
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

  void _saveBill({BillStatus status = BillStatus.draft}) {
    if (_vendorName == null || _vendorName!.trim().isEmpty) {
      ToastificationHelper.showWarning(context, 'Please select a Vendor.');
      return;
    }
    if (_billNumController.text.trim().isEmpty) {
      ToastificationHelper.showWarning(context, 'Please enter a Bill Number.');
      return;
    }
    if (_amountController.text.trim().isEmpty) {
      ToastificationHelper.showWarning(context, 'Please enter an Amount.');
      return;
    }

    final amount = double.tryParse(_amountController.text.trim()) ?? 0;

    final newBill = BillModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      billNumber: _billNumController.text.trim(),
      vendorName: _vendorName!.trim(),
      billDate: _billDate,
      dueDate: _dueDate,
      status: status,
      total: amount,
      balanceDue: amount,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    Navigator.pop(context, newBill);
  }

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);
    final dateFormat = DateFormat('dd MMM yyyy');

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
          'New Bill',
          style: TextStyle(
            color: context.colors.textPrimary,
            fontSize: Dimensions.font20 * 0.9,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => _saveBill(status: BillStatus.draft),
            child: Text(
              'SAVE AS DRAFT',
              style: TextStyle(
                color: Appcolors.primary,
                fontWeight: FontWeight.w800,
                fontSize: Dimensions.font16 * 0.75,
                letterSpacing: 0.5,
              ),
            ),
          ),
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert_rounded,
              color: context.colors.textPrimary,
            ),
            onSelected: (val) {
              if (val == 'save_open') {
                _saveBill(status: BillStatus.open);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'save_open',
                child: Text('Save as Open'),
              ),
            ],
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

                const RequiredLabel(text: 'Bill#'),
                SizedBox(height: Dimensions.height10 / 2),
                TextField(
                  controller: _billNumController,
                  style: FormTextStyles.value(context),
                  decoration: _underlineDecoration(),
                ),
                SizedBox(height: Dimensions.height20),

                const RequiredLabel(text: 'Bill Date'),
                SizedBox(height: Dimensions.height10 / 2),
                _dateField(dateFormat.format(_billDate), () {
                  _pickDate(isDueDate: false);
                }),
                SizedBox(height: Dimensions.height20),

                const RequiredLabel(text: 'Due Date'),
                SizedBox(height: Dimensions.height10 / 2),
                _dateField(dateFormat.format(_dueDate), () {
                  _pickDate(isDueDate: true);
                }),
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
