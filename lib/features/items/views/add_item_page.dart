import 'dart:io';

import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/core/widgets/form_widgets.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddItemPage extends StatefulWidget {
  const AddItemPage({super.key});

  @override
  State<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  String _itemType = 'Goods';
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
                color: Appcolors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(Dimensions.radius15 / 2),
              ),
              child: Icon(
                icon,
                color: Appcolors.primary,
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
  final TextEditingController _sellingPriceController = TextEditingController();
  final TextEditingController _costPriceController = TextEditingController();
  final TextEditingController _openingStockController = TextEditingController();
  final TextEditingController _openingStockRateController =
      TextEditingController();
  final TextEditingController _salesDescriptionController =
      TextEditingController();
  final TextEditingController _purchaseDescriptionController =
      TextEditingController();

  final String _selectedAccount = 'Cost of Goods Sold';
  final String _selectedSalesAccount = 'Sales';
  final String _selectedInventoryAccount = 'Inventory Asset';
  final String _selectedValuationMethod = 'FIFO (First In First Out)';

  @override
  void dispose() {
    _itemNameController.dispose();
    _skuController.dispose();
    _unitController.dispose();
    _sellingPriceController.dispose();
    _costPriceController.dispose();
    _openingStockController.dispose();
    _openingStockRateController.dispose();
    _salesDescriptionController.dispose();
    _purchaseDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);

    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // App Bar
            CustomSliverAppBar(
              title: 'New Item',
              subtitle: 'Fill in the details below',
              leadingType: AppBarLeadingType.back,
              onLeadingPressed: () {
                appLog('⬅️ Back button tapped', name: 'AddItemPage');
                Navigator.pop(context);
              },
              actions: [
                AppBarElevatedButton(label: 'SAVE', onPressed: _saveItem),
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
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                        Icons.home_repair_service_outlined,
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
                                        height: Dimensions.height45 * 2.5,
                                        decoration: BoxDecoration(
                                          color: context.colors.surfaceLight,
                                          border: Border.all(
                                            color: Appcolors.primary.withValues(
                                              alpha: 0.3,
                                            ),
                                            width: 2,
                                            style: BorderStyle.solid,
                                          ),
                                          borderRadius: BorderRadius.circular(
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
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.all(
                                                      Dimensions.width10,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: Appcolors.primary
                                                          .withValues(
                                                            alpha: 0.1,
                                                          ),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Icon(
                                                      Icons
                                                          .add_photo_alternate_outlined,
                                                      size:
                                                          Dimensions.iconSize24,
                                                      color: Appcolors.primary,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height:
                                                        Dimensions.height10 / 2,
                                                  ),
                                                  Text(
                                                    'Add Photo',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize:
                                                          Dimensions.font16 *
                                                          0.75,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Appcolors.primary,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                      ),
                                    ),
                                    // Remove button — only shown when an image is selected
                                    if (_itemImage != null)
                                      Positioned(
                                        top: 6,
                                        right: 6,
                                        child: GestureDetector(
                                          onTap: () =>
                                              setState(() => _itemImage = null),
                                          child: Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              color:
                                                  context.colors.textSecondary,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.close,
                                              color: Colors.white,
                                              size: 14,
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
                      SizedBox(height: Dimensions.height15),
                      _buildCheckbox(
                        'It is an excise product',
                        _isExciseProduct,
                        (value) {
                          setState(() => _isExciseProduct = value ?? false);
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
                    (value) => setState(() => _salesInformation = value),
                    [
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              'Selling Price',
                              _sellingPriceController,
                              isRequired: true,
                              keyboardType: TextInputType.number,
                              prefix: 'AED',
                              icon: Icons.sell_outlined,
                            ),
                          ),
                          SizedBox(width: Dimensions.width15),
                          Expanded(
                            child: _buildDropdown(
                              'Account',
                              _selectedSalesAccount,
                              isRequired: true,
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
                      _buildDropdown('Tax', 'Select a Tax'),
                    ],
                  ),

                  SizedBox(height: Dimensions.height15),

                  // Purchase Information Card
                  _ItemToggleSection(
                    'Purchase Information',
                    Icons.shopping_cart_outlined,
                    _purchaseInformation,
                    (value) => setState(() => _purchaseInformation = value),
                    [
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              'Cost Price',
                              _costPriceController,
                              isRequired: true,
                              keyboardType: TextInputType.number,
                              prefix: 'AED',
                              icon: Icons.attach_money_outlined,
                            ),
                          ),
                          SizedBox(width: Dimensions.width15),
                          Expanded(
                            child: _buildDropdown(
                              'Account',
                              _selectedAccount,
                              isRequired: true,
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
                    (value) => setState(() => _trackInventory = value),
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
                              prefix: 'AED',
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
    );
  }

  Widget _buildRadioOption(String label, IconData icon) {
    final isSelected = _itemType == label;
    return GestureDetector(
      onTap: () {
        setState(() => _itemType = label);
        appLog('📝 Item type changed to: $label', name: 'AddItemPage');
      },
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.all(Dimensions.width10),
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? Appcolors.primary
                      : context.colors.textTertiary,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Appcolors.primary,
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

  void _saveItem() {
    appLog('💾 Save button tapped', name: 'AddItemPage');
    final name = _itemNameController.text.trim();
    if (name.isEmpty) {
      ToastificationHelper.showError(
        context,
        'Please enter an item name before saving.',
      );
      return;
    }
    if (_sellingPriceController.text.trim().isEmpty) {
      ToastificationHelper.showError(context, 'Please enter a selling price.');
      return;
    }
    ToastificationHelper.showSuccess(context, '$name saved successfully.');
    Navigator.pop(context);
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
              Icon(icon, size: Dimensions.iconSize16, color: Appcolors.primary),
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
                  color: Appcolors.error,
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
              color: Appcolors.primary,
            ),
            hintStyle: TextStyle(
              fontSize: Dimensions.font16,
              color: context.colors.textTertiary,
            ),
            suffixIcon: hasScan
                ? Icon(
                    Icons.qr_code_scanner,
                    color: Appcolors.primary,
                    size: Dimensions.iconSize24 * 0.9,
                  )
                : hasAdd
                ? Icon(
                    Icons.add_circle_outline,
                    color: Appcolors.primary,
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
              borderSide: BorderSide(color: Appcolors.primary, width: 2),
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

  Widget _buildDropdown(String label, String value, {bool isRequired = false}) {
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
                color: Appcolors.primary,
              ),
            ),
            if (isRequired)
              Text(
                ' *',
                style: TextStyle(
                  fontSize: Dimensions.font16 * 0.85,
                  color: Appcolors.error,
                ),
              ),
          ],
        ),
        SizedBox(height: Dimensions.height10 / 2),
        Container(
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
      ],
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
            activeColor: Appcolors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
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
                  color: Appcolors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(Dimensions.radius15 / 2),
                ),
                child: Icon(
                  icon,
                  size: Dimensions.iconSize16 * 1.2,
                  color: Appcolors.primary,
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
                activeThumbColor: Appcolors.primary,
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
