import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/image_helper.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/features/inventory_adjustments/model/line_item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddLineItemPage extends StatefulWidget {
  final LineItem? initial;

  const AddLineItemPage({super.key, this.initial});

  @override
  State<AddLineItemPage> createState() => _AddLineItemPageState();
}

class _AddLineItemPageState extends State<AddLineItemPage> {
  final _itemSearchController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _newQtyController = TextEditingController();
  final _adjustedController = TextEditingController();

  // Dedicated focus nodes for the qty fields so taps anywhere inside the
  // bordered box (not just directly on the digits) reliably open the
  // keyboard and place the cursor.
  final _newQtyFocusNode = FocusNode();
  final _adjustedFocusNode = FocusNode();

  InventoryItemLookup? _selectedItem;
  double _costPrice = 0;
  bool _syncing = false;

  final List<InventoryItemLookup> _catalog = const [
    InventoryItemLookup(
      id: '1',
      name: 'Mouse',
      stockOnHand: -10,
      costPrice: 25,
    ),
    InventoryItemLookup(
      id: '2',
      name: 'Pencil',
      stockOnHand: -49,
      costPrice: 2,
      imageUrl:
          'https://images.unsplash.com/photo-1618477461853-cf6ed80faba5?w=200',
    ),
    InventoryItemLookup(
      id: '3',
      name: 'Notebook',
      stockOnHand: 34,
      costPrice: 15,
    ),
    InventoryItemLookup(
      id: '4',
      name: 'Stapler',
      stockOnHand: 6,
      costPrice: 40,
    ),
    InventoryItemLookup(
      id: '5',
      name: 'Keyboard',
      stockOnHand: 15,
      costPrice: 75,
      imageUrl:
          'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=200',
    ),
    InventoryItemLookup(
      id: '6',
      name: 'Monitor',
      stockOnHand: -3,
      costPrice: 250,
      imageUrl:
          'https://images.unsplash.com/photo-1527443224154-c4a3942d3acf?w=200',
    ),
  ];

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    if (initial != null) {
      _selectedItem = InventoryItemLookup(
        id: initial.itemId,
        name: initial.itemName,
        stockOnHand: initial.stockOnHand,
        imageUrl: initial.imageUrl,
        costPrice: initial.costPrice,
      );
      _itemSearchController.text = initial.itemName;
      _descriptionController.text = initial.description ?? '';
      _newQtyController.text = initial.newQuantityOnHand.toStringAsFixed(2);
      _adjustedController.text = initial.quantityAdjusted.toStringAsFixed(2);
      _costPrice = initial.costPrice;
    }
  }

  @override
  void dispose() {
    _itemSearchController.dispose();
    _descriptionController.dispose();
    _newQtyController.dispose();
    _adjustedController.dispose();
    _newQtyFocusNode.dispose();
    _adjustedFocusNode.dispose();
    super.dispose();
  }

  List<InventoryItemLookup> get _suggestions {
    final q = _itemSearchController.text.trim().toLowerCase();
    appLog(
      '🔍 Getting suggestions for query: "$q", _selectedItem: ${_selectedItem?.name ?? "null"}',
      name: 'AddLineItem',
    );
    if (q.isEmpty || _selectedItem != null) {
      appLog(
        '⚠️ Returning empty suggestions (query empty: ${q.isEmpty}, item selected: ${_selectedItem != null})',
        name: 'AddLineItem',
      );
      return [];
    }
    final results = _catalog
        .where((i) => i.name.toLowerCase().contains(q))
        .toList();
    appLog('✅ Found ${results.length} suggestions', name: 'AddLineItem');
    return results;
  }

  void _selectItem(InventoryItemLookup item) {
    appLog(
      '📦 Item selected: ${item.name}, stockOnHand: ${item.stockOnHand}',
      name: 'AddLineItem',
    );
    setState(() {
      _selectedItem = item;
      _itemSearchController.text = item.name;
      _costPrice = item.costPrice;
      _newQtyController.clear();
      _adjustedController.clear();
    });
    appLog(
      '✅ Item selection complete. _selectedItem is now: ${_selectedItem?.name}',
      name: 'AddLineItem',
    );
    FocusScope.of(context).unfocus();
  }

  void _clearItem() {
    appLog('🗑️ Clearing selected item', name: 'AddLineItem');
    setState(() {
      _selectedItem = null;
      _itemSearchController.clear();
      _newQtyController.clear();
      _adjustedController.clear();
    });
    appLog('✅ Item cleared. _selectedItem is now: null', name: 'AddLineItem');
  }

  void _onNewQtyChanged(String value) {
    if (_syncing || _selectedItem == null) return;
    final newQty = double.tryParse(value);
    if (newQty == null) return;
    _syncing = true;
    final adjusted = newQty - _selectedItem!.stockOnHand;
    _adjustedController.text = adjusted.toStringAsFixed(2);
    _syncing = false;
  }

  void _onAdjustedChanged(String value) {
    if (_syncing || _selectedItem == null) return;
    final adjusted = double.tryParse(value);
    if (adjusted == null) return;
    _syncing = true;
    final newQty = _selectedItem!.stockOnHand + adjusted;
    _newQtyController.text = newQty.toStringAsFixed(2);
    _syncing = false;
  }

  // Cost Price is now edited in a bottom sheet instead of a centered
  // AlertDialog: rounded top corners, drag handle, a title row with a
  // pill-shaped "Save" button, and an AED-prefixed input box.
  Future<void> _editCostPrice() async {
    final controller = TextEditingController(
      text: _costPrice.toStringAsFixed(2),
    );
    final result = await showModalBottomSheet<double>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Dimensions.radius15),
        ),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            left: Dimensions.width20,
            right: Dimensions.width20,
            top: Dimensions.height15,
            bottom:
                MediaQuery.of(sheetContext).viewInsets.bottom +
                Dimensions.height20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: Dimensions.width20 * 2,
                  height: 4,
                  margin: EdgeInsets.only(bottom: Dimensions.height15),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Cost Price',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: Dimensions.font16 * 1.05,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(
                      sheetContext,
                      double.tryParse(controller.text) ?? _costPrice,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Appcolors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.width20,
                        vertical: Dimensions.height10 * 0.7,
                      ),
                    ),
                    child: Text(
                      'Save',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: Dimensions.font16 * 0.8,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: Dimensions.height20),
              Text.rich(
                TextSpan(
                  text: 'Enter Cost Price ',
                  style: _label(),
                  children: [
                    TextSpan(
                      text: '*',
                      style: TextStyle(color: Colors.red.shade400),
                    ),
                  ],
                ),
              ),
              SizedBox(height: Dimensions.height10 / 2),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFCBD5E1)),
                  borderRadius: BorderRadius.circular(Dimensions.radius15 - 4),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.width10,
                        vertical: Dimensions.height10,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(Dimensions.radius15 - 4),
                          bottomLeft: Radius.circular(Dimensions.radius15 - 4),
                        ),
                      ),
                      child: Text(
                        'AED',
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                          fontSize: Dimensions.font16 * 0.85,
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: controller,
                        autofocus: true,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d*'),
                          ),
                        ],
                        style: _value(),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: Dimensions.width10,
                            vertical: Dimensions.height10,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
    if (result != null) setState(() => _costPrice = result);
  }

  TextStyle _label() => TextStyle(
    fontSize: Dimensions.font16 * 0.8,
    fontWeight: FontWeight.w600,
    color: Appcolors.primary,
  );

  TextStyle _value() => TextStyle(
    fontSize: Dimensions.font16 * 0.9,
    fontWeight: FontWeight.w500,
    color: const Color(0xFF0F172A),
  );

  Widget _divider() => Padding(
    padding: EdgeInsets.symmetric(vertical: Dimensions.height10 / 2),
    child: const Divider(height: 1, color: Color(0xFFE2E8F0)),
  );

  void _done() {
    if (_selectedItem == null) {
      ToastificationHelper.showWarning(context, 'Please select an item.');
      return;
    }
    final newQty =
        double.tryParse(_newQtyController.text) ?? _selectedItem!.stockOnHand;
    final adjusted =
        double.tryParse(_adjustedController.text) ??
        (newQty - _selectedItem!.stockOnHand);

    final lineItem = LineItem(
      id:
          widget.initial?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      itemId: _selectedItem!.id,
      itemName: _selectedItem!.name,
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      imageUrl: _selectedItem!.imageUrl,
      stockOnHand: _selectedItem!.stockOnHand,
      newQuantityOnHand: newQty,
      quantityAdjusted: adjusted,
      costPrice: _costPrice,
    );
    Navigator.pop(context, lineItem);
  }

  Widget _numberField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required bool enabled,
    required String hint,
    required ValueChanged<String> onChanged,
  }) {
    appLog(
      '🔢 _numberField called - enabled: $enabled, hint: $hint',
      name: 'NumberField',
    );
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: enabled
          ? () {
              appLog(
                '👆 Number field tapped - enabled: $enabled',
                name: 'NumberField',
              );
              appLog(
                '🎯 Requesting focus for field with hint: $hint',
                name: 'NumberField',
              );
              focusNode.requestFocus();
              appLog('✅ Focus requested', name: 'NumberField');
            }
          : () {
              appLog(
                '⚠️ Number field tapped but DISABLED',
                name: 'NumberField',
              );
            },
      child: Container(
        width: Dimensions.height45 * 2.2,
        height: Dimensions.height45,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: Dimensions.width10),
        decoration: BoxDecoration(
          color: enabled ? Colors.white : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(Dimensions.radius15 - 6),
          border: Border.all(color: const Color(0xFFCBD5E1)),
        ),
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          enabled: enabled,
          onChanged: (value) {
            appLog('📝 TextField value changed: $value', name: 'NumberField');
            onChanged(value);
          },
          textAlign: TextAlign.right,
          keyboardType: const TextInputType.numberWithOptions(
            decimal: true,
            signed: true,
          ),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^-?\d*\.?\d*')),
          ],
          style: _value(),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.black26),
            border: InputBorder.none,
            isDense: true,
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);
    appLog(
      '🏗️ Building AddLineItemPage - _selectedItem: ${_selectedItem?.name ?? "null"}',
      name: 'AddLineItem',
    );
    return Scaffold(
      backgroundColor: Appcolors.background,
      appBar: AppBar(
        backgroundColor: Appcolors.background,
        surfaceTintColor: Appcolors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Add Line Item',
          style: TextStyle(
            fontSize: Dimensions.font26 * 0.7,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF0F172A),
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
                Text.rich(
                  TextSpan(
                    text: 'Item ',
                    style: _label(),
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
                        style: _value(),
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
                      Container(
                        width: Dimensions.height45 * 0.9,
                        height: Dimensions.height45 * 0.9,
                        decoration: BoxDecoration(
                          color: Appcolors.primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(
                            Dimensions.radius15 - 4,
                          ),
                          image: _selectedItem!.imageUrl != null
                              ? DecorationImage(
                                  image: ImageHelper.getImageProvider(
                                    _selectedItem!.imageUrl!,
                                  ),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: _selectedItem!.imageUrl == null
                            ? Icon(
                                Icons.inventory_2_outlined,
                                color: Appcolors.primary,
                                size: Dimensions.iconSize24 - 6,
                              )
                            : null,
                      ),
                    ],
                  ],
                ),
                if (_suggestions.isNotEmpty) ...[
                  _divider(),
                  ..._suggestions.map(
                    (item) => InkWell(
                      onTap: () => _selectItem(item),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: Dimensions.height10,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: Dimensions.height45 * 0.9,
                              height: Dimensions.height45 * 0.9,
                              decoration: BoxDecoration(
                                color: Appcolors.primary.withValues(
                                  alpha: 0.08,
                                ),
                                borderRadius: BorderRadius.circular(
                                  Dimensions.radius15 - 4,
                                ),
                                image: item.imageUrl != null
                                    ? DecorationImage(
                                        image: ImageHelper.getImageProvider(
                                          item.imageUrl!,
                                        ),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                              child: item.imageUrl == null
                                  ? Icon(
                                      Icons.inventory_2_outlined,
                                      color: Appcolors.primary,
                                      size: Dimensions.iconSize24 - 6,
                                    )
                                  : null,
                            ),
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
                                      color: const Color(0xFF0F172A),
                                    ),
                                  ),
                                  SizedBox(height: Dimensions.height10 / 4),
                                  Text.rich(
                                    TextSpan(
                                      text: 'Stock on Hand: ',
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: Dimensions.font16 * 0.75,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: item.stockOnHand
                                              .toStringAsFixed(2),
                                          style: TextStyle(
                                            color: item.stockOnHand < 0
                                                ? Colors.red.shade600
                                                : Colors.green.shade600,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
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
                if (_selectedItem != null) ...[
                  _divider(),
                  SizedBox(height: Dimensions.height10),
                  Text('Description', style: _label()),
                  TextField(
                    controller: _descriptionController,
                    style: _value(),
                    decoration: const InputDecoration(
                      hintText: 'Add a description for your item',
                      hintStyle: TextStyle(color: Colors.black26),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                  _divider(),
                  SizedBox(height: Dimensions.height15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Stock on Hand', style: _label()),
                      Text(
                        _selectedItem!.stockOnHand.toStringAsFixed(2),
                        style: TextStyle(
                          fontSize: Dimensions.font16 * 0.9,
                          fontWeight: FontWeight.w700,
                          color: _selectedItem!.stockOnHand < 0
                              ? Colors.red.shade600
                              : const Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Dimensions.height15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('New quantity on hand', style: _label()),
                      _numberField(
                        controller: _newQtyController,
                        focusNode: _newQtyFocusNode,
                        enabled: true,
                        hint: '0.00',
                        onChanged: _onNewQtyChanged,
                      ),
                    ],
                  ),
                  SizedBox(height: Dimensions.height15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Quantity Adjusted', style: _label()),
                      _numberField(
                        controller: _adjustedController,
                        focusNode: _adjustedFocusNode,
                        enabled: true,
                        hint: 'Eg. +10, -10',
                        onChanged: _onAdjustedChanged,
                      ),
                    ],
                  ),
                  SizedBox(height: Dimensions.height15),
                  Row(
                    children: [
                      Text(
                        'Cost Price: ',
                        style: TextStyle(
                          fontSize: Dimensions.font16 * 0.85,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        'AED${_costPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: Dimensions.font16 * 0.85,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                      SizedBox(width: Dimensions.width10 / 2),
                      InkWell(
                        onTap: _editCostPrice,
                        child: Icon(
                          Icons.edit_rounded,
                          size: Dimensions.iconSize24 - 8,
                          color: Appcolors.primary,
                        ),
                      ),
                    ],
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
