import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/image_helper.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/features/invoices/models/invoice_model.dart';
import 'package:flutter/material.dart';

class AddInvoiceLineItemPage extends StatefulWidget {
  final InvoiceLineItem? initial;

  const AddInvoiceLineItemPage({super.key, this.initial});

  @override
  State<AddInvoiceLineItemPage> createState() => _AddInvoiceLineItemPageState();
}

class _AddInvoiceLineItemPageState extends State<AddInvoiceLineItemPage> {
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

  // Sample catalog of items
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
        imageUrl: null,
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
  }

  @override
  void dispose() {
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
    final q = _itemSearchController.text.trim().toLowerCase();
    if (q.isEmpty || _selectedItem != null) {
      return [];
    }
    return _catalog.where((i) => i.name.toLowerCase().contains(q)).toList();
  }

  void _selectItem(ItemLookup item) {
    appLog('📦 Item selected: ${item.name}', name: 'AddInvoiceLineItem');
    setState(() {
      _selectedItem = item;
      _itemSearchController.text = item.name;
      _rateController.text = item.salesPrice.toStringAsFixed(2);
      _taxRateController.text = item.taxRate.toStringAsFixed(2);
      if (_quantityController.text.isEmpty) {
        _quantityController.text = '1.00';
      }
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
    final qty = double.tryParse(_quantityController.text) ?? 0;
    final rate = double.tryParse(_rateController.text) ?? 0;
    final discount = double.tryParse(_discountController.text) ?? 0;
    return (qty * rate) - discount;
  }

  double get _calculatedTaxAmount {
    final amount = _calculatedAmount;
    final taxRate = double.tryParse(_taxRateController.text) ?? 0;
    return (amount * taxRate) / 100;
  }

  void _done() {
    if (_selectedItem == null) {
      ToastificationHelper.showWarning(context, 'Please select an item.');
      return;
    }
    final qty = double.tryParse(_quantityController.text) ?? 1;
    final rate = double.tryParse(_rateController.text) ?? 0;
    final discount = double.tryParse(_discountController.text);
    final taxRate = double.tryParse(_taxRateController.text);

    final lineItem = InvoiceLineItem(
      id:
          widget.initial?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      itemId: _selectedItem!.id,
      itemName: _selectedItem!.name,
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      quantity: qty,
      unit: _selectedItem!.unit,
      rate: rate,
      amount: _calculatedAmount,
      discount: discount,
      taxRate: taxRate,
      taxAmount: _calculatedTaxAmount,
    );

    Navigator.pop(context, lineItem);
  }

  Widget _buildItemThumbnail(String? imageUrl) {
    final fallback = Icon(
      Icons.inventory_2_outlined,
      color: Appcolors.primary,
      size: Dimensions.iconSize24 - 6,
    );
    return Container(
      width: Dimensions.height45 * 0.9,
      height: Dimensions.height45 * 0.9,
      decoration: BoxDecoration(
        color: Appcolors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(Dimensions.radius15 - 4),
      ),
      clipBehavior: Clip.antiAlias,
      child: imageUrl != null
          ? ImageHelper.buildImage(
              imageUrl,
              fit: BoxFit.cover,
              errorWidget: fallback,
            )
          : fallback,
    );
  }

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);
    return Scaffold(
      backgroundColor: Appcolors.background,
      appBar: AppBar(
        backgroundColor: Appcolors.background,
        surfaceTintColor: Appcolors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: Appcolors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Add Line Item',
          style: TextStyle(
            fontSize: Dimensions.font26 * 0.7,
            fontWeight: FontWeight.w800,
            color: Appcolors.textPrimary,
          ),
        ),
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
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(Dimensions.width20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(Dimensions.radius15),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Item Search Field
                Text.rich(
                  TextSpan(
                    text: 'Item ',
                    style: TextStyle(
                      fontSize: Dimensions.font16 * 0.85,
                      fontWeight: FontWeight.w600,
                      color: Appcolors.primary,
                    ),
                    children: [
                      TextSpan(
                        text: '*',
                        style: TextStyle(color: Colors.red.shade400),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: Dimensions.height10 / 2),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _itemSearchController,
                        readOnly: _selectedItem != null,
                        onChanged: (_) => setState(() {}),
                        style: TextStyle(
                          fontSize: Dimensions.font16 * 0.85,
                          fontWeight: FontWeight.w600,
                          color: Appcolors.textPrimary,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Start typing to select an Item',
                          hintStyle: const TextStyle(color: Colors.black26),
                          border: InputBorder.none,
                          isDense: true,
                          suffixIcon: _selectedItem != null
                              ? IconButton(
                                  icon: const Icon(
                                    Icons.close_rounded,
                                    color: Colors.black38,
                                  ),
                                  onPressed: _clearItem,
                                )
                              : IconButton(
                                  icon: Icon(
                                    Icons.qr_code_scanner_rounded,
                                    color: Colors.black45,
                                    size: Dimensions.iconSize24 - 4,
                                  ),
                                  onPressed: () {
                                    ToastificationHelper.showInfo(
                                      context,
                                      'Barcode scan coming soon',
                                    );
                                  },
                                ),
                        ),
                      ),
                    ),
                    if (_selectedItem != null) ...[
                      SizedBox(width: Dimensions.width10),
                      _buildItemThumbnail(_selectedItem!.imageUrl),
                    ],
                  ],
                ),

                // Item Suggestions
                if (_suggestions.isNotEmpty) ...[
                  Divider(color: Appcolors.border, height: Dimensions.height20),
                  ..._suggestions.map(
                    (item) => InkWell(
                      onTap: () => _selectItem(item),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: Dimensions.height10,
                        ),
                        child: Row(
                          children: [
                            _buildItemThumbnail(item.imageUrl),
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
                                      color: Appcolors.textPrimary,
                                    ),
                                  ),
                                  SizedBox(height: Dimensions.height10 / 4),
                                  Text(
                                    'AED${item.salesPrice.toStringAsFixed(2)} per ${item.unit}',
                                    style: TextStyle(
                                      color: Colors.black54,
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

                // Item Details (shown only when item is selected)
                if (_selectedItem != null) ...[
                  Divider(color: Appcolors.border, height: Dimensions.height20),
                  SizedBox(height: Dimensions.height10),

                  // Description
                  Text(
                    'Description',
                    style: TextStyle(
                      fontSize: Dimensions.font16 * 0.85,
                      fontWeight: FontWeight.w600,
                      color: Appcolors.primary,
                    ),
                  ),
                  TextField(
                    controller: _descriptionController,
                    style: TextStyle(
                      fontSize: Dimensions.font16 * 0.85,
                      color: Appcolors.textPrimary,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Add a description for your item',
                      hintStyle: TextStyle(color: Colors.black26),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),

                  Divider(color: Appcolors.border, height: Dimensions.height20),
                  SizedBox(height: Dimensions.height15),

                  // Quantity
                  _buildNumberRow(
                    'Quantity',
                    _quantityController,
                    _quantityFocusNode,
                    'Eg. 1, 2, 3',
                    isRequired: true,
                  ),
                  SizedBox(height: Dimensions.height15),

                  // Rate
                  _buildNumberRow(
                    'Rate',
                    _rateController,
                    _rateFocusNode,
                    'Eg. 100.00',
                    isRequired: true,
                    prefix: 'AED',
                  ),
                  SizedBox(height: Dimensions.height15),

                  // Discount
                  _buildNumberRow(
                    'Discount',
                    _discountController,
                    _discountFocusNode,
                    'Eg. 10.00',
                    prefix: 'AED',
                  ),
                  SizedBox(height: Dimensions.height15),

                  // Tax Rate
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tax Rate (%)',
                        style: TextStyle(
                          fontSize: Dimensions.font16 * 0.85,
                          fontWeight: FontWeight.w600,
                          color: Appcolors.primary,
                        ),
                      ),
                      SizedBox(
                        width: Dimensions.width20 * 2.25,
                        child: TextField(
                          controller: _taxRateController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: Dimensions.font16 * 0.85,
                            fontWeight: FontWeight.w600,
                            color: Appcolors.textPrimary,
                          ),
                          decoration: InputDecoration(
                            hintText: '5.00',
                            hintStyle: const TextStyle(color: Colors.black26),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                Dimensions.radius15 / 2,
                              ),
                              borderSide: BorderSide(color: Appcolors.border),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                Dimensions.radius15 / 2,
                              ),
                              borderSide: BorderSide(color: Appcolors.border),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                Dimensions.radius15 / 2,
                              ),
                              borderSide: BorderSide(
                                color: Appcolors.primary,
                                width: 2,
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: Dimensions.width15,
                              vertical: Dimensions.height10,
                            ),
                            suffixText: '%',
                            suffixStyle: TextStyle(
                              color: Appcolors.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Dimensions.height20),

                  // Calculated Amount Display
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Amount:',
                              style: TextStyle(
                                fontSize: Dimensions.font16 * 0.85,
                                color: Appcolors.textSecondary,
                              ),
                            ),
                            Text(
                              'AED${_calculatedAmount.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: Dimensions.font16 * 0.9,
                                fontWeight: FontWeight.w700,
                                color: Appcolors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: Dimensions.height10 / 2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Tax Amount:',
                              style: TextStyle(
                                fontSize: Dimensions.font16 * 0.85,
                                color: Appcolors.textSecondary,
                              ),
                            ),
                            Text(
                              'AED${_calculatedTaxAmount.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: Dimensions.font16 * 0.9,
                                fontWeight: FontWeight.w700,
                                color: Appcolors.textPrimary,
                              ),
                            ),
                          ],
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

  Widget _buildNumberRow(
    String label,
    TextEditingController controller,
    FocusNode focusNode,
    String hint, {
    bool isRequired = false,
    String? prefix,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text.rich(
          TextSpan(
            text: label,
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.85,
              fontWeight: FontWeight.w600,
              color: Appcolors.primary,
            ),
            children: [
              if (isRequired)
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red.shade400),
                ),
            ],
          ),
        ),
        SizedBox(
          width: Dimensions.width20 * 2.25,
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.85,
              fontWeight: FontWeight.w600,
              color: Appcolors.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.black26),
              prefixText: prefix != null ? '$prefix ' : null,
              prefixStyle: TextStyle(
                color: Appcolors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.radius15 / 2),
                borderSide: BorderSide(color: Appcolors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.radius15 / 2),
                borderSide: BorderSide(color: Appcolors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.radius15 / 2),
                borderSide: BorderSide(color: Appcolors.primary, width: 2),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: Dimensions.width15,
                vertical: Dimensions.height10,
              ),
            ),
            onChanged: (_) => setState(() {}),
          ),
        ),
      ],
    );
  }
}

// Helper class for item lookup
class ItemLookup {
  final String id;
  final String name;
  final double salesPrice;
  final String unit;
  final String? imageUrl;
  final double taxRate;

  const ItemLookup({
    required this.id,
    required this.name,
    required this.salesPrice,
    required this.unit,
    this.imageUrl,
    this.taxRate = 5.0,
  });
}
