import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/core/widgets/custom_back_appbar.dart';
import 'package:custom_books/core/widgets/form_widgets.dart';
import 'package:custom_books/core/widgets/unsaved_changes_dialog.dart';
import 'package:custom_books/features/sales_orders/models/sales_order_model.dart';
import 'package:flutter/material.dart';

class AddSalesOrderLineItemPage extends StatefulWidget {
  final SalesOrderLineItem? existingItem;

  const AddSalesOrderLineItemPage({super.key, this.existingItem});

  @override
  State<AddSalesOrderLineItemPage> createState() =>
      _AddSalesOrderLineItemPageState();
}

class _AddSalesOrderLineItemPageState extends State<AddSalesOrderLineItemPage>
    with UnsavedChangesMixin {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _qtyController = TextEditingController(text: '1');
  final _rateController = TextEditingController(text: '0.00');
  final _discountController = TextEditingController(text: '0');
  final _taxRateController = TextEditingController(text: '5');
  bool _discountIsPercent = true;

  @override
  void initState() {
    super.initState();
    if (widget.existingItem != null) {
      final item = widget.existingItem!;
      _nameController.text = item.itemName;
      _descController.text = item.description;
      _qtyController.text = item.quantity.toString();
      _rateController.text = item.rate.toStringAsFixed(2);
      _discountController.text = item.discount.toString();
      _taxRateController.text = item.taxRate.toString();
      _discountIsPercent = item.discountIsPercent;
    }
    _nameController.addListener(markDirty);
    _descController.addListener(markDirty);
    _qtyController.addListener(markDirty);
    _rateController.addListener(markDirty);
    _discountController.addListener(markDirty);
    _taxRateController.addListener(markDirty);
  }

  @override
  void dispose() {
    _nameController.removeListener(markDirty);
    _descController.removeListener(markDirty);
    _qtyController.removeListener(markDirty);
    _rateController.removeListener(markDirty);
    _discountController.removeListener(markDirty);
    _taxRateController.removeListener(markDirty);
    _nameController.dispose();
    _descController.dispose();
    _qtyController.dispose();
    _rateController.dispose();
    _discountController.dispose();
    _taxRateController.dispose();
    super.dispose();
  }

  void _onSave() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ToastificationHelper.showWarning(context, 'Please enter an item name.');
      return;
    }
    final qty = double.tryParse(_qtyController.text.trim()) ?? 0;
    if (qty <= 0) {
      ToastificationHelper.showWarning(
        context,
        'Quantity must be greater than 0.',
      );
      return;
    }
    final rate = double.tryParse(_rateController.text.trim()) ?? 0;
    final discount = double.tryParse(_discountController.text.trim()) ?? 0;
    final taxRate = double.tryParse(_taxRateController.text.trim()) ?? 0;

    final item = SalesOrderLineItem(
      id:
          widget.existingItem?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      itemName: name,
      description: _descController.text.trim(),
      quantity: qty,
      rate: rate,
      discount: discount,
      discountIsPercent: _discountIsPercent,
      taxRate: taxRate,
    );

    markClean();
    Navigator.pop(context, item);
  }

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: onPopInvokedWithResult,
      child: Scaffold(
        backgroundColor: context.colors.background,
        appBar: CustomBackAppBar(
          title: widget.existingItem != null
              ? 'Edit Line Item'
              : 'Add Line Item',
          backgroundColor: context.colors.card,
          onLeadingPressed: () => onPopInvokedWithResult(false, null),
          actions: [
            TextButton(
              onPressed: _onSave,
              child: Text(
                'SAVE',
                style: TextStyle(
                  color: Appcolors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: Dimensions.font16 * 0.85,
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(Dimensions.width20),
          child: Column(
            children: [
              FormCard(
                children: [
                  const RequiredLabel(text: 'Item Name'),
                  SizedBox(height: Dimensions.height10 / 2),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: 'e.g. Consulting Service / Product A',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          Dimensions.radius15 / 2,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: Dimensions.width15,
                        vertical: Dimensions.height10,
                      ),
                    ),
                  ),
                  SizedBox(height: Dimensions.height15),
                  Text('Description', style: FormTextStyles.label()),
                  SizedBox(height: Dimensions.height10 / 2),
                  TextField(
                    controller: _descController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText: 'Item description...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          Dimensions.radius15 / 2,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: Dimensions.width15,
                        vertical: Dimensions.height10,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: Dimensions.height15),
              FormCard(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const RequiredLabel(text: 'Quantity'),
                            SizedBox(height: Dimensions.height10 / 2),
                            FormNumberField(
                              controller: _qtyController,
                              hint: '1',
                              width: double.infinity,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: Dimensions.width15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const RequiredLabel(text: 'Rate (₹)'),
                            SizedBox(height: Dimensions.height10 / 2),
                            FormNumberField(
                              controller: _rateController,
                              hint: '0.00',
                              width: double.infinity,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Dimensions.height15),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Discount', style: FormTextStyles.label()),
                                GestureDetector(
                                  onTap: () => setState(
                                    () => _discountIsPercent =
                                        !_discountIsPercent,
                                  ),
                                  child: Text(
                                    _discountIsPercent ? '%' : '₹',
                                    style: TextStyle(
                                      color: Appcolors.primary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: Dimensions.font16 * 0.8,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: Dimensions.height10 / 2),
                            FormNumberField(
                              controller: _discountController,
                              hint: '0',
                              suffix: _discountIsPercent ? '%' : '₹',
                              width: double.infinity,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: Dimensions.width15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Tax Rate (%)', style: FormTextStyles.label()),
                            SizedBox(height: Dimensions.height10 / 2),
                            FormNumberField(
                              controller: _taxRateController,
                              hint: '5',
                              suffix: '%',
                              width: double.infinity,
                            ),
                          ],
                        ),
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
}
