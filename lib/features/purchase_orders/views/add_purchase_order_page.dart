import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/core/widgets/custom_back_appbar.dart';
import 'package:custom_books/core/widgets/form_widgets.dart';
import 'package:custom_books/core/widgets/unsaved_changes_dialog.dart';
import 'package:custom_books/features/purchase_orders/models/purchase_order_model.dart';
import 'package:flutter/material.dart';
import 'package:custom_books/core/utils/date_formatter.dart';

class AddPurchaseOrderPage extends StatefulWidget {
  const AddPurchaseOrderPage({super.key});

  @override
  State<AddPurchaseOrderPage> createState() => _AddPurchaseOrderPageState();
}

class _AddPurchaseOrderPageState extends State<AddPurchaseOrderPage>
    with UnsavedChangesMixin {
  final _purchaseOrderNumController = TextEditingController();
  final _referenceController = TextEditingController();
  final _amountController = TextEditingController();

  String? _vendorName;
  DateTime _orderDate = DateTime.now();
  DateTime? _expectedDeliveryDate;

  static const List<String> _vendors = [
    'Global Supplies',
    'Metro Traders',
    'Al Noor Co',
    'Prime Distributors',
  ];

  @override
  void initState() {
    super.initState();
    _purchaseOrderNumController.text = 'PO-00043';
    _purchaseOrderNumController.addListener(markDirty);
    _referenceController.addListener(markDirty);
    _amountController.addListener(markDirty);
  }

  @override
  void dispose() {
    _purchaseOrderNumController.removeListener(markDirty);
    _referenceController.removeListener(markDirty);
    _amountController.removeListener(markDirty);
    _purchaseOrderNumController.dispose();
    _referenceController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool isDeliveryDate}) async {
    final initialDate = isDeliveryDate
        ? (_expectedDeliveryDate ?? _orderDate.add(const Duration(days: 7)))
        : _orderDate;
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null) {
      setState(() {
        if (isDeliveryDate) {
          _expectedDeliveryDate = picked;
        } else {
          _orderDate = picked;
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

  void _savePurchaseOrder({
    PurchaseOrderStatus status = PurchaseOrderStatus.draft,
  }) {
    if (_vendorName == null || _vendorName!.trim().isEmpty) {
      ToastificationHelper.showWarning(context, 'Please select a Vendor.');
      return;
    }
    if (_purchaseOrderNumController.text.trim().isEmpty) {
      ToastificationHelper.showWarning(
        context,
        'Please enter a Purchase Order Number.',
      );
      return;
    }

    final newOrder = PurchaseOrderModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      purchaseOrderNumber: _purchaseOrderNumController.text.trim(),
      vendorName: _vendorName!.trim(),
      referenceNumber: _referenceController.text.trim(),
      orderDate: _orderDate,
      expectedDeliveryDate: _expectedDeliveryDate,
      status: status,
      total: double.tryParse(_amountController.text.trim()) ?? 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    markClean();
    Navigator.pop(context, newOrder);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: onPopInvokedWithResult,
      child: Scaffold(
        backgroundColor: context.colors.background,
        appBar: CustomBackAppBar(
          title: 'New Purchase Order',
          backgroundColor: context.colors.card,
          onLeadingPressed: () => onPopInvokedWithResult(false, null),
          actions: [
            TextButton(
              onPressed: () =>
                  _savePurchaseOrder(status: PurchaseOrderStatus.draft),
              child: Text(
                'SAVE AS DRAFT',
                style: TextStyle(
                  color: AppColors.primary,
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
                if (val == 'save_issued') {
                  _savePurchaseOrder(status: PurchaseOrderStatus.issued);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'save_issued',
                  child: Text('Save as Issued'),
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

                  const RequiredLabel(text: 'Purchase Order#'),
                  SizedBox(height: Dimensions.height10 / 2),
                  TextField(
                    controller: _purchaseOrderNumController,
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

                  const RequiredLabel(text: 'Order Date'),
                  SizedBox(height: Dimensions.height10 / 2),
                  _dateField(formatDate(_orderDate), () {
                    _pickDate(isDeliveryDate: false);
                  }),
                  SizedBox(height: Dimensions.height20),

                  Text('Expected Delivery Date', style: FormTextStyles.label()),
                  SizedBox(height: Dimensions.height10 / 2),
                  _dateField(
                    _expectedDeliveryDate != null
                        ? formatDate(_expectedDeliveryDate!)
                        : 'dd MMM yyyy',
                    () => _pickDate(isDeliveryDate: true),
                    isPlaceholder: _expectedDeliveryDate == null,
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

  Widget _dateField(
    String text,
    VoidCallback onTap, {
    bool isPlaceholder = false,
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
            Text(
              text,
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.9,
                color: isPlaceholder
                    ? context.colors.textTertiary
                    : context.colors.textPrimary,
                fontWeight: isPlaceholder ? FontWeight.normal : FontWeight.w500,
              ),
            ),
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
