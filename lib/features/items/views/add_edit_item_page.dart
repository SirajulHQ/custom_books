import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/core/widgets/form_widgets.dart';
import 'package:custom_books/core/widgets/skeletons/skeletons.dart';
import 'package:custom_books/features/items/widgets/selection_dropdown_field.dart';
import 'package:custom_books/core/widgets/unsaved_changes_dialog.dart';
import 'package:custom_books/features/items/controllers/item_form_controller.dart';
import 'package:custom_books/features/items/models/item_model.dart';
import 'package:custom_books/features/items/widgets/item_overview_section.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddEditItemPage extends StatefulWidget {
  final ItemModel? existing;

  final ItemModel? cloneFrom;

  const AddEditItemPage({super.key, this.existing, this.cloneFrom});

  @override
  State<AddEditItemPage> createState() => _AddEditItemPageState();
}

class _AddEditItemPageState extends State<AddEditItemPage>
    with UnsavedChangesMixin {
  final ItemFormController _itemsController = ItemFormController();

  String _itemType = 'Goods';
  bool _isLoading = true;
  bool _trackInventory = true;
  bool _salesInformation = true;
  bool _purchaseInformation = true;
  bool _isExciseProduct = false;

  XFile? _itemImage;

  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _skuController = TextEditingController();
  final TextEditingController _unitController = TextEditingController();

  static const List<String> _gtinOptions = [];
  String _selectedGtin = 'Select a GTIN';

  final TextEditingController _sellingPriceController = TextEditingController();
  final TextEditingController _costPriceController = TextEditingController();
  final TextEditingController _openingStockController = TextEditingController();
  final TextEditingController _openingStockRateController =
      TextEditingController();
  final TextEditingController _salesDescriptionController =
      TextEditingController();
  final TextEditingController _purchaseDescriptionController =
      TextEditingController();

  final String _selectedInventoryAccount = 'Inventory Asset';

  static const List<String> _valuationMethodOptions = [
    'FIFO (First In First Out)',
    'Weighted Average Cost (Moving Average)',
  ];
  String _selectedValuationMethod = 'FIFO (First In First Out)';

  static const List<String> _purchaseAccountOptions = [
    'Bad Debt',
    'Printing and Stationery',
    'Salaries and Employee Wages',
    'Meals and Entertainment',
    'Depreciation Expense',
    'Consultant Expense',
    'Repairs and Maintenance',
    'Other Expenses',
    'Lodging',
    'Cost of Goods Sold',
    'Uncategorized',
    'Purchase Discounts',
    'Payment Charges',
    'Vat Charges',
    'Gratuity Expense',
    'Air Travel Allowance Expense',
  ];
  String _selectedAccount = 'Cost of Goods Sold';

  static const List<String> _salesAccountOptions = [
    'Sales',
    'General Income',
    'Interest Income',
    'Late Fee Income',
    'Discount',
    'Other Charges',
    'Shipping Charge',
  ];
  String _selectedSalesAccount = 'Sales';

  static const List<String> _taxOptions = [
    'Standard Rate [5%]',
    'Zero Rate [0%]',
    'VAT [5%]',
  ];
  String _selectedTax = 'Select a Tax';

  @override
  void initState() {
    super.initState();
    _load();
    final existing = widget.existing ?? widget.cloneFrom;
    final bool isClone = widget.existing == null && widget.cloneFrom != null;
    if (existing != null) {
      _itemNameController.text = existing.name;
      _skuController.text = isClone ? '' : (existing.sku ?? '');
      _unitController.text = existing.unit ?? '';
      if (existing.gtin != null && existing.gtin!.isNotEmpty) {
        _selectedGtin = existing.gtin!;
      }
      _sellingPriceController.text = existing.salesPrice.toStringAsFixed(2);
      _costPriceController.text = existing.purchasePrice.toStringAsFixed(2);
      _salesDescriptionController.text = existing.salesDescription ?? '';
      _purchaseDescriptionController.text = existing.purchaseDescription ?? '';
      _itemType = (existing.itemType ?? 'goods').toLowerCase() == 'service'
          ? 'Service'
          : 'Goods';
      _trackInventory = existing.trackInventory ?? _trackInventory;
      _salesInformation = existing.salesEnabled ?? _salesInformation;
      _purchaseInformation = existing.purchaseEnabled ?? _purchaseInformation;
      final savedValuation = existing.valuationMethod?.toLowerCase();
      if (savedValuation != null && savedValuation.isNotEmpty) {
        if (savedValuation.contains('weighted') ||
            savedValuation.contains('average')) {
          _selectedValuationMethod = 'Weighted Average Cost (Moving Average)';
        } else if (savedValuation.contains('fifo')) {
          _selectedValuationMethod = 'FIFO (First In First Out)';
        }
      }
      final savedSalesAccount = existing.salesAccount;
      if (savedSalesAccount != null) {
        _selectedSalesAccount = _salesAccountOptions.firstWhere(
          (a) => a.toLowerCase() == savedSalesAccount.toLowerCase(),
          orElse: () => _selectedSalesAccount,
        );
      }
      final savedPurchaseAccount = existing.purchaseAccount;
      if (savedPurchaseAccount != null) {
        _selectedAccount = _purchaseAccountOptions.firstWhere(
          (a) => a.toLowerCase() == savedPurchaseAccount.toLowerCase(),
          orElse: () => _selectedAccount,
        );
      }
      final savedTax = existing.tax;
      if (savedTax != null) {
        _selectedTax = _taxOptions.firstWhere(
          (t) => t.toLowerCase() == savedTax.toLowerCase(),
          orElse: () => _selectedTax,
        );
      }
    }
    _itemNameController.addListener(markDirty);
    _skuController.addListener(markDirty);
    _unitController.addListener(markDirty);
    _sellingPriceController.addListener(markDirty);
    _costPriceController.addListener(markDirty);
    _openingStockController.addListener(markDirty);
    _openingStockRateController.addListener(markDirty);
    _salesDescriptionController.addListener(markDirty);
    _purchaseDescriptionController.addListener(markDirty);
  }

  @override
  void dispose() {
    _itemNameController.removeListener(markDirty);
    _skuController.removeListener(markDirty);
    _unitController.removeListener(markDirty);
    _sellingPriceController.removeListener(markDirty);
    _costPriceController.removeListener(markDirty);
    _openingStockController.removeListener(markDirty);
    _openingStockRateController.removeListener(markDirty);
    _salesDescriptionController.removeListener(markDirty);
    _purchaseDescriptionController.removeListener(markDirty);
    _itemNameController.dispose();
    _skuController.dispose();
    _unitController.dispose();
    _sellingPriceController.dispose();
    _costPriceController.dispose();
    _openingStockController.dispose();
    _openingStockRateController.dispose();
    _salesDescriptionController.dispose();
    _purchaseDescriptionController.dispose();
    _itemsController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: onPopInvokedWithResult,
      child: Scaffold(
        backgroundColor: context.colors.background,
        body: SafeArea(
          child: _isLoading
              ? const FormPageSkeleton()
              : CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    CustomSliverAppBar(
                      title: widget.existing != null
                          ? 'Edit Item'
                          : (widget.cloneFrom != null
                                ? 'Clone Item'
                                : 'New Item'),
                      subtitle: 'Fill in the details below',
                      leadingType: AppBarLeadingType.back,
                      onLeadingPressed: () {
                        appLog(
                          '⬅️ Back button tapped',
                          name: 'AddEditItemPage',
                        );
                        onPopInvokedWithResult(false, null);
                      },
                      actions: [
                        ListenableBuilder(
                          listenable: _itemsController,
                          builder: (context, _) {
                            final saving = _itemsController.isSaving;
                            return AppBarElevatedButton(
                              label: saving ? 'SAVING...' : 'SAVE',
                              onPressed: saving ? null : _saveItem,
                            );
                          },
                        ),
                        SizedBox(width: Dimensions.width20),
                      ],
                    ),

                    SliverPadding(
                      padding: EdgeInsets.all(Dimensions.width20),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          ItemOverviewSection(
                            itemType: _itemType,
                            onItemTypeChanged: (type) {
                              setState(() => _itemType = type);
                              markDirty();
                            },
                            itemImage: _itemImage,
                            onImagePicked: (picked) {
                              setState(() => _itemImage = picked);
                              markDirty();
                            },
                            onImageRemoved: () {
                              setState(() => _itemImage = null);
                              markDirty();
                            },
                            itemNameController: _itemNameController,
                            skuController: _skuController,
                            unitController: _unitController,
                            gtinOptions: _gtinOptions,
                            selectedGtin: _selectedGtin,
                            onGtinSelected: (gtin) {
                              setState(() => _selectedGtin = gtin);
                              markDirty();
                            },
                            isExciseProduct: _isExciseProduct,
                            onExciseProductChanged: (value) {
                              setState(() => _isExciseProduct = value);
                              markDirty();
                            },
                          ),

                          SizedBox(height: Dimensions.height15),

                          _ItemToggleSection(
                            'Sales Information',
                            Icons.point_of_sale_outlined,
                            _salesInformation,
                            (value) {
                              setState(() => _salesInformation = value);
                              markDirty();
                            },
                            [
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildTextField(
                                      'Selling Price',
                                      _sellingPriceController,
                                      isRequired: true,
                                      keyboardType: TextInputType.number,
                                      prefix: '₹',
                                      icon: Icons.sell_outlined,
                                    ),
                                  ),
                                  SizedBox(width: Dimensions.width15),
                                  Expanded(
                                    child: SelectionDropdownField(
                                      label: 'Account',
                                      value: _selectedSalesAccount,
                                      isRequired: true,
                                      options: _salesAccountOptions,
                                      onSelected: (account) {
                                        setState(
                                          () => _selectedSalesAccount = account,
                                        );
                                        markDirty();
                                        appLog(
                                          '💰 Sales account selected: $account',
                                          name: 'AddEditItemPage',
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: Dimensions.height20),
                              _buildTextField(
                                'Description',
                                _salesDescriptionController,
                                maxLines: 3,
                                hint: 'Enter sales description...',
                                icon: Icons.description_outlined,
                              ),
                              SizedBox(height: Dimensions.height20),
                              SelectionDropdownField(
                                label: 'Tax',
                                value: _selectedTax,
                                options: _taxOptions,
                                onSelected: (tax) {
                                  setState(() => _selectedTax = tax);
                                  markDirty();
                                  appLog(
                                    '🧾 Tax selected: $tax',
                                    name: 'AddEditItemPage',
                                  );
                                },
                              ),
                            ],
                          ),

                          SizedBox(height: Dimensions.height15),

                          _ItemToggleSection(
                            'Purchase Information',
                            Icons.shopping_cart_outlined,
                            _purchaseInformation,
                            (value) {
                              setState(() => _purchaseInformation = value);
                              markDirty();
                            },
                            [
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildTextField(
                                      'Cost Price',
                                      _costPriceController,
                                      isRequired: true,
                                      keyboardType: TextInputType.number,
                                      prefix: '₹',
                                      icon: Icons.attach_money_outlined,
                                    ),
                                  ),
                                  SizedBox(width: Dimensions.width15),
                                  Expanded(
                                    child: SelectionDropdownField(
                                      label: 'Account',
                                      value: _selectedAccount,
                                      isRequired: true,
                                      options: _purchaseAccountOptions,
                                      onSelected: (account) {
                                        setState(
                                          () => _selectedAccount = account,
                                        );
                                        markDirty();
                                        appLog(
                                          '🛒 Purchase account selected: $account',
                                          name: 'AddEditItemPage',
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: Dimensions.height20),
                              _buildTextField(
                                'Description',
                                _purchaseDescriptionController,
                                maxLines: 3,
                                hint: 'Enter purchase description...',
                                icon: Icons.description_outlined,
                              ),
                              SizedBox(height: Dimensions.height20),
                              _buildTextField(
                                'Preferred Vendor',
                                null,
                                hint: 'Start typing to select a vendor',
                                hasAdd: true,
                                icon: Icons.person_outline,
                              ),
                            ],
                          ),

                          SizedBox(height: Dimensions.height15),

                          _ItemToggleSection(
                            'Track Inventory',
                            Icons.inventory_outlined,
                            _trackInventory,
                            (value) {
                              setState(() => _trackInventory = value);
                              markDirty();
                            },
                            [
                              SelectionDropdownField(
                                label: 'Inventory Account',
                                value: _selectedInventoryAccount,
                              ),
                              SizedBox(height: Dimensions.height20),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildTextField(
                                      'Opening Stock',
                                      _openingStockController,
                                      hasInfo: true,
                                      keyboardType: TextInputType.number,
                                      hint: '0',
                                      icon: Icons.numbers_outlined,
                                    ),
                                  ),
                                  SizedBox(width: Dimensions.width15),
                                  Expanded(
                                    child: _buildTextField(
                                      'Rate per Unit',
                                      _openingStockRateController,
                                      hasInfo: true,
                                      keyboardType: TextInputType.number,
                                      prefix: '₹',
                                      hint: '0.00',
                                      icon: Icons.calculate_outlined,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: Dimensions.height20),
                              SelectionDropdownField(
                                label: 'Valuation Method',
                                value: _selectedValuationMethod,
                                isRequired: true,
                                options: _valuationMethodOptions,
                                onSelected: (method) {
                                  setState(
                                    () => _selectedValuationMethod = method,
                                  );
                                  markDirty();
                                  appLog(
                                    '📊 Valuation method selected: $method',
                                    name: 'AddEditItemPage',
                                  );
                                },
                              ),
                            ],
                          ),

                          SizedBox(height: Dimensions.height30),
                        ]),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Future<void> _saveItem() async {
    appLog('💾 Save button tapped', name: 'AddEditItemPage');
    if (_itemsController.isSaving) return;

    final name = _itemNameController.text.trim();
    if (name.isEmpty) {
      ToastificationHelper.showError(
        context,
        'Please enter an item name before saving.',
      );
      return;
    }
    if (_salesInformation && _sellingPriceController.text.trim().isEmpty) {
      ToastificationHelper.showError(context, 'Please enter a selling price.');
      return;
    }

    final body = _buildRequestBody();
    final existing = widget.existing;
    final bool isEdit = existing != null;

    final ok = isEdit
        ? await _itemsController.update(existing.id, body)
        : await _itemsController.create(body);
    if (!mounted) return;

    if (ok) {
      ToastificationHelper.showSuccess(
        context,
        isEdit ? '$name updated successfully.' : '$name saved successfully.',
      );
      markClean();
      Navigator.pop(context, true);
    } else {
      ToastificationHelper.showError(
        context,
        _itemsController.errorMessage ??
            'Could not save item. Please try again.',
      );
    }
  }

  Map<String, dynamic> _buildRequestBody() {
    double parsePrice(String text) => double.tryParse(text.trim()) ?? 0.0;

    String valuationCode() {
      final v = _selectedValuationMethod.toLowerCase();
      if (v.contains('fifo')) return 'fifo';
      if (v.contains('lifo')) return 'lifo';
      if (v.contains('average') || v.contains('weighted')) {
        return 'weighted_average';
      }
      return 'fifo';
    }

    return {
      'item_type': _itemType.toLowerCase(),
      'name': _itemNameController.text.trim(),
      'sku': _skuController.text.trim(),
      'unit': _unitController.text.trim(),
      'gtin': _selectedGtin.startsWith('Select') ? '' : _selectedGtin,
      'is_excise_product': _isExciseProduct,
      'sales_enabled': _salesInformation,
      'selling_price': parsePrice(
        _sellingPriceController.text,
      ).toStringAsFixed(2),
      'sales_account': _selectedSalesAccount,
      'sales_description': _salesDescriptionController.text.trim(),
      'tax': _selectedTax.startsWith('Select') ? '' : _selectedTax,
      'purchase_enabled': _purchaseInformation,
      'cost_price': parsePrice(_costPriceController.text).toStringAsFixed(2),
      'purchase_account': _selectedAccount,
      'purchase_description': _purchaseDescriptionController.text.trim(),
      'preferred_vendor_id': null,
      'track_inventory': _trackInventory,
      'inventory_account': _selectedInventoryAccount,
      'opening_stock': parsePrice(
        _openingStockController.text,
      ).toStringAsFixed(2),
      'rate_per_unit': parsePrice(
        _openingStockRateController.text,
      ).toStringAsFixed(2),
      'valuation_method': _trackInventory ? valuationCode() : '',
    };
  }

  Widget _buildTextField(
    String label,
    TextEditingController? controller, {
    bool isRequired = false,
    bool hasInfo = false,
    bool hasScan = false,
    bool hasAdd = false,
    String? hint,
    String? prefix,
    IconData? icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: Dimensions.iconSize16, color: AppColors.primary),
              SizedBox(width: Dimensions.width10 / 2),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.85,
                fontWeight: FontWeight.w600,
                color: context.colors.textPrimary,
              ),
            ),
            if (isRequired)
              Text(
                ' *',
                style: TextStyle(
                  fontSize: Dimensions.font16 * 0.85,
                  fontWeight: FontWeight.w700,
                  color: AppColors.error,
                ),
              ),
            if (hasInfo) ...[
              SizedBox(width: Dimensions.width10 / 2),
              Icon(
                Icons.info_outline,
                size: Dimensions.iconSize16 * 0.9,
                color: context.colors.textTertiary,
              ),
            ],
          ],
        ),
        SizedBox(height: Dimensions.height10 * 0.7),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: TextStyle(
            fontSize: Dimensions.font16,
            fontWeight: FontWeight.w500,
            color: context.colors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            prefixText: prefix != null ? '$prefix ' : null,
            prefixStyle: TextStyle(
              fontSize: Dimensions.font16,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
            hintStyle: TextStyle(
              fontSize: Dimensions.font16,
              color: context.colors.textTertiary,
            ),
            suffixIcon: hasScan
                ? Icon(
                    Icons.qr_code_scanner,
                    color: AppColors.primary,
                    size: Dimensions.iconSize24 * 0.9,
                  )
                : hasAdd
                ? Icon(
                    Icons.add_circle_outline,
                    color: AppColors.primary,
                    size: Dimensions.iconSize24 * 0.9,
                  )
                : null,
            filled: true,
            fillColor: context.colors.surfaceLight,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius15),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius15),
              borderSide: BorderSide(color: context.colors.border, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius15),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: Dimensions.width15,
              vertical: Dimensions.height15,
            ),
          ),
        ),
      ],
    );
  }
}

class _ItemToggleSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool value;
  final ValueChanged<bool> onChanged;
  final List<Widget> children;

  const _ItemToggleSection(
    this.title,
    this.icon,
    this.value,
    this.onChanged,
    this.children,
  );

  @override
  Widget build(BuildContext context) {
    return FormCard(
      borderRadius: Dimensions.radius20,
      showShadow: true,
      padding: EdgeInsets.zero,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.width20,
            vertical: Dimensions.height15,
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(Dimensions.width10 * 0.7),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(Dimensions.radius15 / 2),
                ),
                child: Icon(
                  icon,
                  size: Dimensions.iconSize16 * 1.2,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(width: Dimensions.width10),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.95,
                    fontWeight: FontWeight.w700,
                    color: context.colors.textPrimary,
                  ),
                ),
              ),
              Switch(
                value: value,
                onChanged: onChanged,
                activeThumbColor: AppColors.primary,
              ),
            ],
          ),
        ),
        if (value) ...[
          Divider(height: 1, color: context.colors.border),
          Padding(
            padding: EdgeInsets.all(Dimensions.width20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ],
    );
  }
}
