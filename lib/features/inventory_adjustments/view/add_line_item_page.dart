import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/image_helper.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/features/inventory_adjustments/model/line_item_model.dart';
import 'package:custom_books/features/inventory_adjustments/widgets/adjustment_form_widgets.dart';
import 'package:custom_books/features/inventory_adjustments/widgets/cost_price_editor.dart';
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

  /// Builds a consistent square item thumbnail with proper error handling.
  /// Uses [ImageHelper.buildImage] so both network and asset images are
  /// supported, and the error / loading states are handled gracefully instead
  /// of failing silently (which happens when a bare [DecorationImage] +
  /// [NetworkImage] combination encounters a bad URL).
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
                    style: AdjustmentTextStyles.label(),
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
                        style: AdjustmentTextStyles.value(),
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
                if (_suggestions.isNotEmpty) ...[
                  const FormDivider(),
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
                  const FormDivider(),
                  SizedBox(height: Dimensions.height10),
                  Text('Description', style: AdjustmentTextStyles.label()),
                  TextField(
                    controller: _descriptionController,
                    style: AdjustmentTextStyles.value(),
                    decoration: const InputDecoration(
                      hintText: 'Add a description for your item',
                      hintStyle: TextStyle(color: Colors.black26),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                  const FormDivider(),
                  SizedBox(height: Dimensions.height15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Stock on Hand',
                        style: AdjustmentTextStyles.label(),
                      ),
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
                      Text(
                        'New quantity on hand',
                        style: AdjustmentTextStyles.label(),
                      ),
                      AdjustmentNumberField(
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
                      Text(
                        'Quantity Adjusted',
                        style: AdjustmentTextStyles.label(),
                      ),
                      AdjustmentNumberField(
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
                        onTap: () async {
                          final result = await CostPriceEditor.show(
                            context,
                            initialValue: _costPrice,
                          );
                          if (result != null) {
                            setState(() => _costPrice = result);
                          }
                        },
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
