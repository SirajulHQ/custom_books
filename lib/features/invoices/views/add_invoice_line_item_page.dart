import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/core/widgets/custom_back_appbar.dart';
import 'package:custom_books/core/widgets/form_widgets.dart';
import 'package:custom_books/core/widgets/line_item_form_widgets.dart';
import 'package:custom_books/core/widgets/unsaved_changes_dialog.dart';
import 'package:custom_books/features/invoices/models/invoice_model.dart';
import 'package:custom_books/features/invoices/models/item_lookup_model.dart';
import 'package:flutter/material.dart';

class AddInvoiceLineItemPage extends StatefulWidget {
  final InvoiceLineItem? initial;

  const AddInvoiceLineItemPage({super.key, this.initial});

  @override
  State<AddInvoiceLineItemPage> createState() => _AddInvoiceLineItemPageState();
}

class _AddInvoiceLineItemPageState extends State<AddInvoiceLineItemPage>
    with UnsavedChangesMixin {
  final _itemSearchController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _quantityController = TextEditingController();
  final _rateController = TextEditingController();
  final _discountController = TextEditingController();
  final _taxRateController = TextEditingController();

  final _quantityFocusNode = FocusNode();
  final _rateFocusNode = FocusNode();
  final _discountFocusNode = FocusNode();

  ItemLookup? _selectedItem;

  final List<ItemLookup> _catalog = const [
    ItemLookup(
      id: '1',
      name: 'Consulting Services',
      salesPrice: 150.0,
      unit: 'hrs',
      taxRate: 5.0,
    ),
    ItemLookup(
      id: '2',
      name: 'Web Design',
      salesPrice: 2500.0,
      unit: 'project',
      taxRate: 5.0,
      imageUrl:
          'https://images.unsplash.com/photo-1467232004584-a241de8bcf5d?w=200',
    ),
    ItemLookup(
      id: '3',
      name: 'Software License',
      salesPrice: 500.0,
      unit: 'license',
      taxRate: 5.0,
    ),
    ItemLookup(
      id: '4',
      name: 'Cloud Hosting',
      salesPrice: 99.0,
      unit: 'month',
      taxRate: 5.0,
    ),
    ItemLookup(
      id: '5',
      name: 'Marketing Campaign',
      salesPrice: 3000.0,
      unit: 'campaign',
      taxRate: 5.0,
      imageUrl:
          'https://images.unsplash.com/photo-1460925895917-afdab827c52f?w=200',
    ),
  ];

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    if (initial != null) {
      _selectedItem = ItemLookup(
        id: initial.itemId,
        name: initial.itemName,
        salesPrice: initial.rate,
        unit: initial.unit,
        taxRate: initial.taxRate ?? 5.0,
      );
      _itemSearchController.text = initial.itemName;
      _descriptionController.text = initial.description ?? '';
      _quantityController.text = initial.quantity.toStringAsFixed(2);
      _rateController.text = initial.rate.toStringAsFixed(2);
      _discountController.text = initial.discount?.toStringAsFixed(2) ?? '';
      _taxRateController.text = initial.taxRate?.toStringAsFixed(2) ?? '5.00';
    } else {
      _taxRateController.text = '5.00';
    }
    _itemSearchController.addListener(markDirty);
    _descriptionController.addListener(markDirty);
    _quantityController.addListener(markDirty);
    _rateController.addListener(markDirty);
    _discountController.addListener(markDirty);
    _taxRateController.addListener(markDirty);
  }

  @override
  void dispose() {
    _itemSearchController.removeListener(markDirty);
    _descriptionController.removeListener(markDirty);
    _quantityController.removeListener(markDirty);
    _rateController.removeListener(markDirty);
    _discountController.removeListener(markDirty);
    _taxRateController.removeListener(markDirty);
    _itemSearchController.dispose();
    _descriptionController.dispose();
    _quantityController.dispose();
    _rateController.dispose();
    _discountController.dispose();
    _taxRateController.dispose();
    _quantityFocusNode.dispose();
    _rateFocusNode.dispose();
    _discountFocusNode.dispose();
    super.dispose();
  }

  List<ItemLookup> get _suggestions {
    final query = _itemSearchController.text.trim().toLowerCase();
    if (query.isEmpty || _selectedItem != null) return [];
    return _catalog
        .where((item) => item.name.toLowerCase().contains(query))
        .toList();
  }

  void _selectItem(ItemLookup item) {
    appLog('📦 Item selected: ${item.name}', name: 'AddInvoiceLineItem');
    setState(() {
      _selectedItem = item;
      _itemSearchController.text = item.name;
      _rateController.text = item.salesPrice.toStringAsFixed(2);
      _taxRateController.text = item.taxRate.toStringAsFixed(2);
      if (_quantityController.text.isEmpty) _quantityController.text = '1.00';
    });
    FocusScope.of(context).unfocus();
  }

  void _clearItem() {
    appLog('🗑️ Clearing selected item', name: 'AddInvoiceLineItem');
    setState(() {
      _selectedItem = null;
      _itemSearchController.clear();
      _quantityController.clear();
      _rateController.clear();
      _discountController.clear();
    });
  }

  double get _calculatedAmount {
    final quantity = double.tryParse(_quantityController.text) ?? 0;
    final rate = double.tryParse(_rateController.text) ?? 0;
    final discount = double.tryParse(_discountController.text) ?? 0;
    return (quantity * rate) - discount;
  }

  double get _calculatedTaxAmount {
    final taxRate = double.tryParse(_taxRateController.text) ?? 0;
    return (_calculatedAmount * taxRate) / 100;
  }

  void _done() {
    if (_selectedItem == null) {
      ToastificationHelper.showWarning(context, 'Please select an item.');
      return;
    }
    final quantity = double.tryParse(_quantityController.text) ?? 1;
    final rate = double.tryParse(_rateController.text) ?? 0;

    markClean();
    Navigator.pop(
      context,
      InvoiceLineItem(
        id:
            widget.initial?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        itemId: _selectedItem!.id,
        itemName: _selectedItem!.name,
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        quantity: quantity,
        unit: _selectedItem!.unit,
        rate: rate,
        amount: _calculatedAmount,
        discount: double.tryParse(_discountController.text),
        taxRate: double.tryParse(_taxRateController.text),
        taxAmount: _calculatedTaxAmount,
      ),
    );
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
          title: 'Add Line Item',
          onLeadingPressed: () => onPopInvokedWithResult(false, null),
          actions: [
            TextButton(
              onPressed: _done,
              child: Text(
                'DONE',
                style: TextStyle(
                  fontSize: Dimensions.font16 * 0.8,
                  fontWeight: FontWeight.w700,
                  color: Appcolors.primary,
                ),
              ),
            ),
            SizedBox(width: Dimensions.width10),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(Dimensions.width20),
            physics: const BouncingScrollPhysics(),
            child: FormCard(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const RequiredLabel(text: 'Item'),
                    SizedBox(height: Dimensions.height10 / 2),
                    ItemSearchField<ItemLookup>(
                      controller: _itemSearchController,
                      isItemSelected: _selectedItem != null,
                      suggestions: _suggestions,
                      selectedItemImageUrl: _selectedItem?.imageUrl,
                      onChanged: (_) => setState(() {}),
                      onClear: _clearItem,
                      onBarcodeScan: () => ToastificationHelper.showInfo(
                        context,
                        'Barcode scan coming soon',
                      ),
                      suggestionBuilder: (item) => InkWell(
                        onTap: () => _selectItem(item),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: Dimensions.height10,
                          ),
                          child: Row(
                            children: [
                              ItemThumbnail(imageUrl: item.imageUrl),
                              SizedBox(width: Dimensions.width10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: Dimensions.font16 * 0.85,
                                        color: context.colors.textPrimary,
                                      ),
                                    ),
                                    SizedBox(height: Dimensions.height10 / 4),
                                    Text(
                                      '₹${item.salesPrice.toStringAsFixed(2)} per ${item.unit}',
                                      style: TextStyle(
                                        color: context.colors.textSecondary,
                                        fontSize: Dimensions.font16 * 0.75,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (_selectedItem != null) ...[
                  const FormDivider(),
                  _InvoiceItemDetails(controller: _descriptionController),
                  const FormDivider(),
                  SizedBox(height: Dimensions.height10),
                  _InvoicePricingFields(
                    quantityController: _quantityController,
                    rateController: _rateController,
                    discountController: _discountController,
                    taxRateController: _taxRateController,
                    quantityFocusNode: _quantityFocusNode,
                    rateFocusNode: _rateFocusNode,
                    discountFocusNode: _discountFocusNode,
                    onChanged: (_) => setState(() {}),
                  ),
                  SizedBox(height: Dimensions.height20),
                  Container(
                    padding: EdgeInsets.all(Dimensions.width15),
                    decoration: BoxDecoration(
                      color: Appcolors.primary.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(
                        Dimensions.radius15 / 2,
                      ),
                      border: Border.all(
                        color: Appcolors.primary.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Column(
                      children: [
                        _SummaryRow(
                          label: 'Amount:',
                          amount: _calculatedAmount,
                        ),
                        SizedBox(height: Dimensions.height10 / 2),
                        _SummaryRow(
                          label: 'Tax Amount:',
                          amount: _calculatedTaxAmount,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InvoiceItemDetails extends StatelessWidget {
  final TextEditingController controller;

  const _InvoiceItemDetails({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: Dimensions.height10),
        Text('Description', style: FormTextStyles.label()),
        TextField(
          controller: controller,
          style: FormTextStyles.value(context),
          decoration: InputDecoration(
            hintText: 'Add a description for your item',
            hintStyle: TextStyle(color: context.colors.textTertiary),
            border: InputBorder.none,
            isDense: true,
          ),
        ),
      ],
    );
  }
}

class _InvoicePricingFields extends StatelessWidget {
  final TextEditingController quantityController;
  final TextEditingController rateController;
  final TextEditingController discountController;
  final TextEditingController taxRateController;
  final FocusNode quantityFocusNode;
  final FocusNode rateFocusNode;
  final FocusNode discountFocusNode;
  final ValueChanged<String> onChanged;

  const _InvoicePricingFields({
    required this.quantityController,
    required this.rateController,
    required this.discountController,
    required this.taxRateController,
    required this.quantityFocusNode,
    required this.rateFocusNode,
    required this.discountFocusNode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _numberRow(
          label: 'Quantity',
          required: true,
          field: FormNumberField(
            controller: quantityController,
            focusNode: quantityFocusNode,
            hint: 'Eg. 1, 2, 3',
            onChanged: onChanged,
          ),
        ),
        SizedBox(height: Dimensions.height15),
        _numberRow(
          label: 'Rate',
          required: true,
          field: FormNumberField(
            controller: rateController,
            focusNode: rateFocusNode,
            hint: 'Eg. 100.00',
            prefix: '₹',
            onChanged: onChanged,
          ),
        ),
        SizedBox(height: Dimensions.height15),
        _numberRow(
          label: 'Discount',
          field: FormNumberField(
            controller: discountController,
            focusNode: discountFocusNode,
            hint: 'Eg. 10.00',
            prefix: '₹',
            onChanged: onChanged,
          ),
        ),
        SizedBox(height: Dimensions.height15),
        _numberRow(
          label: 'Tax Rate (%)',
          field: FormNumberField(
            controller: taxRateController,
            hint: '5.00',
            suffix: '%',
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _numberRow({
    required String label,
    required Widget field,
    bool required = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        required
            ? RequiredLabel(text: label)
            : Text(label, style: FormTextStyles.label()),
        field,
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final double amount;

  const _SummaryRow({required this.label, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: Dimensions.font16 * 0.85,
            color: context.colors.textSecondary,
          ),
        ),
        Text(
          '₹${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: Dimensions.font16 * 0.9,
            fontWeight: FontWeight.w700,
            color: context.colors.textPrimary,
          ),
        ),
      ],
    );
  }
}
