import 'dart:io' show File;

import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/core/widgets/empty_state_widget.dart';
import 'package:custom_books/core/widgets/form_widgets.dart';
import 'package:custom_books/core/widgets/skeletons/skeletons.dart';
import 'package:custom_books/core/widgets/bottom_sheet_drag_handle.dart';
import 'package:custom_books/core/widgets/unsaved_changes_dialog.dart';
import 'package:custom_books/features/items/controllers/items_controller.dart';
import 'package:custom_books/features/items/models/item_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddItemPage extends StatefulWidget {
  final ItemModel? existing;

  const AddItemPage({super.key, this.existing});

  @override
  State<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> with UnsavedChangesMixin {
  final ItemsController _itemsController = ItemsController();

  String _itemType = 'Goods';
  bool _isLoading = true;
  bool _trackInventory = true;
  bool _salesInformation = true;
  bool _purchaseInformation = true;
  bool _isExciseProduct = false;

  XFile? _itemImage;
  final _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1080,
      );
      if (picked != null) {
        setState(() => _itemImage = picked);
        markDirty();
        appLog('📷 Image picked: ${picked.path}', name: 'AddItemPage');
      }
    } catch (e) {
      appLog('❌ Image pick error: $e', name: 'AddItemPage');
    }
  }

  void _showImageSourceSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: context.colors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Dimensions.radius20),
        ),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.width20,
            vertical: Dimensions.height20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Photo Source',
                style: TextStyle(
                  fontSize: Dimensions.font20 * 0.85,
                  fontWeight: FontWeight.w800,
                  color: context.colors.textPrimary,
                ),
              ),
              SizedBox(height: Dimensions.height20),
              _sourceOption(
                icon: Icons.camera_alt_outlined,
                label: 'Take Photo',
                subtitle: 'Use your camera',
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              SizedBox(height: Dimensions.height10),
              _sourceOption(
                icon: Icons.photo_library_outlined,
                label: 'Choose from Gallery',
                subtitle: 'Pick from your photo library',
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              SizedBox(height: Dimensions.height10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sourceOption({
    required IconData icon,
    required String label,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Dimensions.radius15),
      child: Container(
        padding: EdgeInsets.all(Dimensions.width15),
        decoration: BoxDecoration(
          color: context.colors.surfaceLight,
          borderRadius: BorderRadius.circular(Dimensions.radius15),
          border: Border.all(color: context.colors.border),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(Dimensions.width10),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(Dimensions.radius15 / 2),
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
                size: Dimensions.iconSize24,
              ),
            ),
            SizedBox(width: Dimensions.width15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.9,
                    fontWeight: FontWeight.w700,
                    color: context.colors.textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.75,
                    color: context.colors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _skuController = TextEditingController();
  final TextEditingController _unitController = TextEditingController();

  /// GTIN options offered in the searchable selection sheet. Empty for now,
  /// so the sheet shows the "No result found" empty state.
  static const List<String> _gtinOptions = [];
  String _selectedGtin = 'Select a GTIN';

  /// Search query controller for the GTIN selection sheet. Owned by the page
  /// so it survives the sheet's rebuilds and is only disposed once.
  final TextEditingController _gtinSearchController = TextEditingController();
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

  /// Inventory valuation methods offered in the Track Inventory section.
  static const List<String> _valuationMethodOptions = [
    'FIFO (First In First Out)',
    'Weighted Average Cost (Moving Average)',
  ];
  String _selectedValuationMethod = 'FIFO (First In First Out)';

  /// Account options offered in the Purchase Information section.
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

  /// Account options offered in the Sales Information section.
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

  /// Tax options offered in the Sales Information section.
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
    final existing = widget.existing;
    if (existing != null) {
      _itemNameController.text = existing.name;
      _skuController.text = existing.sku ?? '';
      _unitController.text = existing.unit ?? '';
      if (existing.gtin != null && existing.gtin!.isNotEmpty) {
        _selectedGtin = existing.gtin!;
      }
      _sellingPriceController.text = existing.salesPrice.toStringAsFixed(2);
      _costPriceController.text = existing.purchasePrice.toStringAsFixed(2);
      _salesDescriptionController.text = existing.salesDescription ?? '';
      _purchaseDescriptionController.text = existing.purchaseDescription ?? '';
      // Reflect the item's saved options in the form toggles.
      _itemType = (existing.itemType ?? 'goods').toLowerCase() == 'service'
          ? 'Service'
          : 'Goods';
      _trackInventory = existing.trackInventory ?? _trackInventory;
      _salesInformation = existing.salesEnabled ?? _salesInformation;
      _purchaseInformation = existing.purchaseEnabled ?? _purchaseInformation;
      // Map the API valuation code back to its display label.
      final savedValuation = existing.valuationMethod?.toLowerCase();
      if (savedValuation != null && savedValuation.isNotEmpty) {
        if (savedValuation.contains('weighted') ||
            savedValuation.contains('average')) {
          _selectedValuationMethod = 'Weighted Average Cost (Moving Average)';
        } else if (savedValuation.contains('fifo')) {
          _selectedValuationMethod = 'FIFO (First In First Out)';
        }
      }
      // Restore the saved sales account if it matches one of our options.
      final savedSalesAccount = existing.salesAccount;
      if (savedSalesAccount != null) {
        _selectedSalesAccount = _salesAccountOptions.firstWhere(
          (a) => a.toLowerCase() == savedSalesAccount.toLowerCase(),
          orElse: () => _selectedSalesAccount,
        );
      }
      // Restore the saved purchase account if it matches one of our options.
      final savedPurchaseAccount = existing.purchaseAccount;
      if (savedPurchaseAccount != null) {
        _selectedAccount = _purchaseAccountOptions.firstWhere(
          (a) => a.toLowerCase() == savedPurchaseAccount.toLowerCase(),
          orElse: () => _selectedAccount,
        );
      }
      // Restore the saved tax if it matches one of our options.
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
    _gtinSearchController.dispose();
    _sellingPriceController.dispose();
    _costPriceController.dispose();
    _openingStockController.dispose();
    _openingStockRateController.dispose();
    _salesDescriptionController.dispose();
    _purchaseDescriptionController.dispose();
    _itemsController.dispose();
    super.dispose();
  }

  /// Simulates preparing the form so the shimmer skeleton is shown briefly.
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
                    // App Bar
                    CustomSliverAppBar(
                      title: widget.existing == null ? 'New Item' : 'Edit Item',
                      subtitle: 'Fill in the details below',
                      leadingType: AppBarLeadingType.back,
                      onLeadingPressed: () {
                        appLog('⬅️ Back button tapped', name: 'AddItemPage');
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

                    // Content
                    SliverPadding(
                      padding: EdgeInsets.all(Dimensions.width20),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          // Item Type and Image Card
                          _ItemOverviewSection(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Item Type',
                                          style: TextStyle(
                                            fontSize: Dimensions.font16 * 0.9,
                                            fontWeight: FontWeight.w700,
                                            color: context.colors.textPrimary,
                                          ),
                                        ),
                                        SizedBox(height: Dimensions.height10),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: context.colors.surfaceLight,
                                            borderRadius: BorderRadius.circular(
                                              Dimensions.radius15 / 2,
                                            ),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: Dimensions.width10,
                                            vertical: Dimensions.height10 / 2,
                                          ),
                                          child: Column(
                                            children: [
                                              _buildRadioOption(
                                                'Goods',
                                                Icons.inventory_2_outlined,
                                              ),
                                              _buildRadioOption(
                                                'Service',
                                                Icons
                                                    .home_repair_service_outlined,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: Dimensions.width15),
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      children: [
                                        Text(
                                          'Item Image',
                                          style: TextStyle(
                                            fontSize: Dimensions.font16 * 0.9,
                                            fontWeight: FontWeight.w700,
                                            color: context.colors.textPrimary,
                                          ),
                                        ),
                                        SizedBox(height: Dimensions.height10),
                                        // ---- Live image preview / picker ----
                                        Stack(
                                          children: [
                                            GestureDetector(
                                              onTap: _showImageSourceSheet,
                                              child: Container(
                                                width: double.infinity,
                                                height:
                                                    Dimensions.height45 * 2.5,
                                                decoration: BoxDecoration(
                                                  color: context
                                                      .colors
                                                      .surfaceLight,
                                                  border: Border.all(
                                                    color: AppColors.primary
                                                        .withValues(alpha: 0.3),
                                                    width: 2,
                                                    style: BorderStyle.solid,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        Dimensions.radius15,
                                                      ),
                                                ),
                                                clipBehavior: Clip.antiAlias,
                                                child: _itemImage != null
                                                    ? Image.file(
                                                        File(_itemImage!.path),
                                                        fit: BoxFit.cover,
                                                      )
                                                    : Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                  Dimensions
                                                                      .width10,
                                                                ),
                                                            decoration:
                                                                BoxDecoration(
                                                                  color: AppColors
                                                                      .primary
                                                                      .withValues(
                                                                        alpha:
                                                                            0.1,
                                                                      ),
                                                                  shape: BoxShape
                                                                      .circle,
                                                                ),
                                                            child: Icon(
                                                              Icons
                                                                  .add_photo_alternate_outlined,
                                                              size: Dimensions
                                                                  .iconSize24,
                                                              color: AppColors
                                                                  .primary,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height:
                                                                Dimensions
                                                                    .height10 /
                                                                2,
                                                          ),
                                                          Text(
                                                            'Add Photo',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              fontSize:
                                                                  Dimensions
                                                                      .font16 *
                                                                  0.75,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: AppColors
                                                                  .primary,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                              ),
                                            ),
                                            // Remove button — only shown when an image is selected
                                            if (_itemImage != null)
                                              Positioned(
                                                top: Dimensions.height10 * 0.6,
                                                right: Dimensions.width10 * 0.6,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    setState(
                                                      () => _itemImage = null,
                                                    );
                                                    markDirty();
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.all(
                                                      Dimensions.height10 * 0.4,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: context
                                                          .colors
                                                          .textSecondary,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Icon(
                                                      Icons.close,
                                                      color: Colors.white,
                                                      size:
                                                          Dimensions
                                                              .iconSize16 *
                                                          0.875,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: Dimensions.height20),
                              Divider(height: 1, color: context.colors.border),
                              SizedBox(height: Dimensions.height20),
                              _buildTextField(
                                'Item Name',
                                _itemNameController,
                                isRequired: true,
                                icon: Icons.inventory_outlined,
                              ),
                              SizedBox(height: Dimensions.height20),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildTextField(
                                      'SKU',
                                      _skuController,
                                      hasInfo: true,
                                      hasScan: true,
                                      icon: Icons.qr_code_2_outlined,
                                    ),
                                  ),
                                  SizedBox(width: Dimensions.width15),
                                  Expanded(
                                    child: _buildTextField(
                                      'Unit',
                                      _unitController,
                                      hint: 'e.g., pcs, kg, box',
                                      icon: Icons.straighten_outlined,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: Dimensions.height20),
                              GestureDetector(
                                onTap: _showGtinSearchSheet,
                                child: _buildDropdown('GTIN', _selectedGtin),
                              ),
                              SizedBox(height: Dimensions.height15),
                              _buildCheckbox(
                                'It is an excise product',
                                _isExciseProduct,
                                (value) {
                                  setState(
                                    () => _isExciseProduct = value ?? false,
                                  );
                                  markDirty();
                                },
                              ),
                            ],
                          ),

                          SizedBox(height: Dimensions.height15),

                          // Sales Information Card
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
                                    child: _buildDropdown(
                                      'Account',
                                      _selectedSalesAccount,
                                      isRequired: true,
                                      options: _salesAccountOptions,
                                      onSelected: (account) {
                                        setState(
                                          () => _selectedSalesAccount = account,
                                        );
                                        markDirty();
                                        appLog(
                                          '💰 Sales account selected: $account',
                                          name: 'AddItemPage',
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
                              _buildDropdown(
                                'Tax',
                                _selectedTax,
                                options: _taxOptions,
                                onSelected: (tax) {
                                  setState(() => _selectedTax = tax);
                                  markDirty();
                                  appLog(
                                    '🧾 Tax selected: $tax',
                                    name: 'AddItemPage',
                                  );
                                },
                              ),
                            ],
                          ),

                          SizedBox(height: Dimensions.height15),

                          // Purchase Information Card
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
                                    child: _buildDropdown(
                                      'Account',
                                      _selectedAccount,
                                      isRequired: true,
                                      options: _purchaseAccountOptions,
                                      onSelected: (account) {
                                        setState(
                                          () => _selectedAccount = account,
                                        );
                                        markDirty();
                                        appLog(
                                          '🛒 Purchase account selected: $account',
                                          name: 'AddItemPage',
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

                          // Track Inventory Card
                          _ItemToggleSection(
                            'Track Inventory',
                            Icons.inventory_outlined,
                            _trackInventory,
                            (value) {
                              setState(() => _trackInventory = value);
                              markDirty();
                            },
                            [
                              _buildDropdown(
                                'Inventory Account',
                                _selectedInventoryAccount,
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
                              _buildDropdown(
                                'Valuation Method',
                                _selectedValuationMethod,
                                isRequired: true,
                                options: _valuationMethodOptions,
                                onSelected: (method) {
                                  setState(
                                    () => _selectedValuationMethod = method,
                                  );
                                  markDirty();
                                  appLog(
                                    '📊 Valuation method selected: $method',
                                    name: 'AddItemPage',
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

  Widget _buildRadioOption(String label, IconData icon) {
    final isSelected = _itemType == label;
    return GestureDetector(
      onTap: () {
        setState(() => _itemType = label);
        markDirty();
        appLog('📝 Item type changed to: $label', name: 'AddItemPage');
      },
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.all(Dimensions.width10),
            child: Container(
              width: Dimensions.height20,
              height: Dimensions.height20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : context.colors.textTertiary,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: Dimensions.height10,
                        height: Dimensions.height10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary,
                        ),
                      ),
                    )
                  : null,
            ),
          ),
          Icon(
            icon,
            size: Dimensions.iconSize16,
            color: context.colors.textSecondary,
          ),
          SizedBox(width: Dimensions.width10 / 2),
          Text(
            label,
            style: TextStyle(
              fontSize: Dimensions.font16,
              color: context.colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveItem() async {
    appLog('💾 Save button tapped', name: 'AddItemPage');
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
        ? await _itemsController.updateItem(existing.id, body)
        : await _itemsController.createItem(body);
    if (!mounted) return;

    if (ok) {
      ToastificationHelper.showSuccess(
        context,
        isEdit ? '$name updated successfully.' : '$name saved successfully.',
      );
      markClean();
      // Return `true` so the items list knows to refresh.
      Navigator.pop(context, true);
    } else {
      ToastificationHelper.showError(
        context,
        _itemsController.errorMessage ??
            'Could not save item. Please try again.',
      );
    }
  }

  /// Maps the current form state to the API request payload.
  Map<String, dynamic> _buildRequestBody() {
    double parsePrice(String text) => double.tryParse(text.trim()) ?? 0.0;

    // The UI shows a friendly label; the API expects a short code.
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

  Widget _buildDropdown(
    String label,
    String value, {
    bool isRequired = false,
    List<String>? options,
    ValueChanged<String>? onSelected,
  }) {
    final bool interactive = options != null && onSelected != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.85,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            if (isRequired)
              Text(
                ' *',
                style: TextStyle(
                  fontSize: Dimensions.font16 * 0.85,
                  color: AppColors.error,
                ),
              ),
          ],
        ),
        SizedBox(height: Dimensions.height10 / 2),
        GestureDetector(
          onTap: interactive
              ? () => _showSelectionSheet(
                  title: label,
                  options: options,
                  selected: value,
                  onSelected: onSelected,
                )
              : null,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.width15,
              vertical: Dimensions.height10,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: context.colors.border),
              borderRadius: BorderRadius.circular(Dimensions.radius15 / 2),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: Dimensions.font16,
                      color: value.startsWith('Select')
                          ? context.colors.textTertiary
                          : context.colors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: Dimensions.width10),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: context.colors.textSecondary,
                  size: Dimensions.iconSize24,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Opens a searchable bottom sheet for picking a GTIN.
  ///
  /// Filters [_gtinOptions] by the search query and shows a "No result found"
  /// empty state when nothing matches (which is the default, since no GTIN
  /// options are configured yet).
  void _showGtinSearchSheet() {
    // Reset the query each time the sheet opens.
    _gtinSearchController.clear();

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        return Padding(
          // Lift the sheet above the keyboard when the search field is focused.
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
          ),
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(sheetContext).size.height * 0.75,
            ),
            decoration: BoxDecoration(
              color: context.colors.card,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(Dimensions.radius20),
              ),
            ),
            child: StatefulBuilder(
              builder: (context, setSheetState) {
                final query = _gtinSearchController.text.trim().toLowerCase();
                final results = query.isEmpty
                    ? _gtinOptions
                    : _gtinOptions
                          .where((g) => g.toLowerCase().contains(query))
                          .toList();

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const BottomSheetDragHandle(),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.width20,
                      ),
                      child: Text(
                        'GTIN',
                        style: TextStyle(
                          fontSize: Dimensions.font20,
                          fontWeight: FontWeight.w800,
                          color: context.colors.textPrimary,
                        ),
                      ),
                    ),
                    SizedBox(height: Dimensions.height15),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.width20,
                      ),
                      child: TextField(
                        controller: _gtinSearchController,
                        autofocus: true,
                        onChanged: (_) => setSheetState(() {}),
                        style: TextStyle(
                          fontSize: Dimensions.font16,
                          color: context.colors.textPrimary,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search',
                          prefixIcon: Icon(
                            Icons.search,
                            color: context.colors.textSecondary,
                            size: Dimensions.iconSize24 * 0.9,
                          ),
                          hintStyle: TextStyle(
                            fontSize: Dimensions.font16,
                            color: context.colors.textTertiary,
                          ),
                          filled: true,
                          fillColor: context.colors.surfaceLight,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              Dimensions.radius15,
                            ),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              Dimensions.radius15,
                            ),
                            borderSide: BorderSide(
                              color: context.colors.border,
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              Dimensions.radius15,
                            ),
                            borderSide: BorderSide(
                              color: AppColors.primary,
                              width: 2,
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: Dimensions.width15,
                            vertical: Dimensions.height15,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: Dimensions.height15),
                    Flexible(
                      child: results.isEmpty
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: Dimensions.height30,
                              ),
                              child: const EmptyStateWidget(
                                icon: Icons.inventory_2_outlined,
                                title: 'No result found',
                                subtitle: '',
                              ),
                            )
                          : ListView(
                              shrinkWrap: true,
                              padding: EdgeInsets.only(
                                bottom: Dimensions.height20,
                              ),
                              children: results.map((gtin) {
                                final isSelected = gtin == _selectedGtin;
                                return ListTile(
                                  leading: Icon(
                                    isSelected
                                        ? Icons.radio_button_checked_rounded
                                        : Icons.radio_button_off_rounded,
                                    color: isSelected
                                        ? AppColors.primary
                                        : context.colors.textSecondary,
                                  ),
                                  title: Text(
                                    gtin,
                                    style: TextStyle(
                                      fontSize: Dimensions.font16 * 0.9,
                                      fontWeight: isSelected
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                      color: context.colors.textPrimary,
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() => _selectedGtin = gtin);
                                    markDirty();
                                    appLog(
                                      '🏷️ GTIN selected: $gtin',
                                      name: 'AddItemPage',
                                    );
                                    Navigator.pop(sheetContext);
                                  },
                                );
                              }).toList(),
                            ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  /// Opens a bottom sheet listing [options] and reports the chosen value.
  void _showSelectionSheet({
    required String title,
    required List<String> options,
    required String selected,
    required ValueChanged<String> onSelected,
  }) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      // Allow the sheet to grow (and its list to scroll) instead of forcing
      // all options into a fixed-height column that can overflow.
      isScrollControlled: true,
      builder: (sheetContext) {
        return Container(
          // Cap the sheet at 70% of the screen so long option lists scroll.
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(sheetContext).size.height * 0.7,
          ),
          decoration: BoxDecoration(
            color: context.colors.card,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(Dimensions.radius20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const BottomSheetDragHandle(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: Dimensions.font20,
                      fontWeight: FontWeight.w800,
                      color: context.colors.textPrimary,
                    ),
                  ),
                ),
              ),
              SizedBox(height: Dimensions.height10),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(bottom: Dimensions.height20),
                  children: options.map((option) {
                    final isSelected = option == selected;
                    return ListTile(
                      leading: Icon(
                        isSelected
                            ? Icons.radio_button_checked_rounded
                            : Icons.radio_button_off_rounded,
                        color: isSelected
                            ? AppColors.primary
                            : context.colors.textSecondary,
                      ),
                      title: Text(
                        option,
                        style: TextStyle(
                          fontSize: Dimensions.font16 * 0.9,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: context.colors.textPrimary,
                        ),
                      ),
                      onTap: () {
                        onSelected(option);
                        Navigator.pop(sheetContext);
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCheckbox(String label, bool value, Function(bool?) onChanged) {
    return Row(
      children: [
        SizedBox(
          width: Dimensions.iconSize24,
          height: Dimensions.iconSize24,
          child: Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius15 * 0.27),
            ),
          ),
        ),
        SizedBox(width: Dimensions.width10),
        Text(
          label,
          style: TextStyle(
            fontSize: Dimensions.font16,
            color: context.colors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _ItemOverviewSection extends StatelessWidget {
  final List<Widget> children;

  const _ItemOverviewSection({required this.children});

  @override
  Widget build(BuildContext context) {
    return FormCard(
      borderRadius: Dimensions.radius20,
      showShadow: true,
      children: children,
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
