import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:flutter/material.dart';

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

  String _selectedAccount = 'Cost of Goods Sold';
  String _selectedSalesAccount = 'Sales';
  String _selectedInventoryAccount = 'Inventory Asset';
  String _selectedValuationMethod = 'FIFO (First In First Out)';

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
      backgroundColor: Appcolors.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // App Bar
            SliverAppBar(
              pinned: true,
              backgroundColor: Appcolors.background,
              surfaceTintColor: Appcolors.background,
              elevation: 0,
              toolbarHeight: Dimensions.height45 * 1.6,
              titleSpacing: Dimensions.width20,
              leading: IconButton(
                icon: Container(
                  width: Dimensions.height45 * 0.9,
                  height: Dimensions.height45 * 0.9,
                  decoration: BoxDecoration(
                    color: Appcolors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(Dimensions.radius15),
                  ),
                  child: Icon(
                    Icons.arrow_back,
                    size: Dimensions.iconSize24 - 4,
                    color: Appcolors.primary,
                  ),
                ),
                onPressed: () {
                  appLog('⬅️ Back button tapped', name: 'AddItemPage');
                  Navigator.pop(context);
                },
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'New Item',
                    style: TextStyle(
                      fontSize: Dimensions.font26 * 0.85,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  Text(
                    'Fill in the details below',
                    style: TextStyle(
                      fontSize: Dimensions.font16 * 0.7,
                      color: Colors.black45,
                    ),
                  ),
                ],
              ),
              actions: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: Dimensions.height10),
                  child: ElevatedButton(
                    onPressed: () {
                      appLog('💾 Save button tapped', name: 'AddItemPage');
                      // TODO: Implement save functionality
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Appcolors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.width20,
                        vertical: Dimensions.height10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          Dimensions.radius15,
                        ),
                      ),
                    ),
                    child: Text(
                      'SAVE',
                      style: TextStyle(
                        fontSize: Dimensions.font16 * 0.85,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
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
                  _buildCard([
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
                                  color: Appcolors.textPrimary,
                                ),
                              ),
                              SizedBox(height: Dimensions.height10),
                              Container(
                                decoration: BoxDecoration(
                                  color: Appcolors.surfaceLight,
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
                                  color: Appcolors.textPrimary,
                                ),
                              ),
                              SizedBox(height: Dimensions.height10),
                              GestureDetector(
                                onTap: () {
                                  appLog(
                                    '📷 Add Image tapped',
                                    name: 'AddItemPage',
                                  );
                                  // TODO: Implement image picker
                                },
                                child: Container(
                                  width: double.infinity,
                                  height: Dimensions.height45 * 2.5,
                                  decoration: BoxDecoration(
                                    color: Appcolors.surfaceLight,
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
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(
                                          Dimensions.width10,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Appcolors.primary.withValues(
                                            alpha: 0.1,
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.add_photo_alternate_outlined,
                                          size: Dimensions.iconSize24,
                                          color: Appcolors.primary,
                                        ),
                                      ),
                                      SizedBox(height: Dimensions.height10 / 2),
                                      Text(
                                        'Add Photo',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: Dimensions.font16 * 0.75,
                                          fontWeight: FontWeight.w600,
                                          color: Appcolors.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Dimensions.height20),
                    Divider(height: 1, color: Appcolors.border),
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
                  ]),

                  SizedBox(height: Dimensions.height15),

                  // Sales Information Card
                  _buildToggleCard(
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
                  _buildToggleCard(
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
                  _buildToggleCard(
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

  Widget _buildCard(List<Widget> children) {
    return Container(
      padding: EdgeInsets.all(Dimensions.width20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Dimensions.radius20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildToggleCard(
    String title,
    IconData icon,
    bool value,
    Function(bool) onChanged,
    List<Widget> children,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Dimensions.radius20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
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
                    borderRadius: BorderRadius.circular(
                      Dimensions.radius15 / 2,
                    ),
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
                      color: Appcolors.textPrimary,
                    ),
                  ),
                ),
                Switch(
                  value: value,
                  onChanged: onChanged,
                  activeColor: Appcolors.primary,
                ),
              ],
            ),
          ),
          if (value) ...[
            Divider(height: 1, color: Appcolors.border),
            Padding(
              padding: EdgeInsets.all(Dimensions.width20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRadioOption(String label, IconData icon) {
    return GestureDetector(
      onTap: () {
        setState(() => _itemType = label);
        appLog('📝 Item type changed to: $label', name: 'AddItemPage');
      },
      child: Row(
        children: [
          Radio<String>(
            value: label,
            groupValue: _itemType,
            onChanged: (value) {
              setState(() => _itemType = value!);
            },
            activeColor: Appcolors.primary,
          ),
          Icon(
            icon,
            size: Dimensions.iconSize16,
            color: Appcolors.textSecondary,
          ),
          SizedBox(width: Dimensions.width10 / 2),
          Text(
            label,
            style: TextStyle(
              fontSize: Dimensions.font16,
              color: Appcolors.textPrimary,
            ),
          ),
        ],
      ),
    );
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
                color: Appcolors.textPrimary,
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
                color: Appcolors.textTertiary,
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
            color: Appcolors.textPrimary,
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
              color: Appcolors.textTertiary,
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
            fillColor: Appcolors.surfaceLight,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius15),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius15),
              borderSide: BorderSide(color: Appcolors.border, width: 1),
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
            border: Border.all(color: Appcolors.border),
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
                        ? Appcolors.textTertiary
                        : Appcolors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: Dimensions.width10),
              Icon(
                Icons.keyboard_arrow_down,
                color: Appcolors.textSecondary,
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
            color: Appcolors.textPrimary,
          ),
        ),
      ],
    );
  }
}
