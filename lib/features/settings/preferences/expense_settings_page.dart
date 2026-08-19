import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/features/settings/preferences/shared/add_custom_field_page.dart';
import 'package:flutter/material.dart';

class ExpenseSettingsPage extends StatefulWidget {
  const ExpenseSettingsPage({super.key});

  @override
  State<ExpenseSettingsPage> createState() => _ExpenseSettingsPageState();
}

class _ExpenseSettingsPageState extends State<ExpenseSettingsPage> {
  // Mileage settings
  String _mileageUnit = 'Kilometer';
  String _mileageCategory = 'Fuel/Mileage Expenses';

  // Mileage rates
  final List<Map<String, String>> _mileageRates = [];

  // Custom fields
  final List<Map<String, dynamic>> _customFields = [];

  static const List<String> _unitOptions = ['Kilometer', 'Mile'];
  static const List<String> _categoryOptions = [
    'Fuel/Mileage Expenses',
    'Travel Expenses',
    'Vehicle Expenses',
  ];

  @override
  void initState() {
    super.initState();
    appLog('💰 ExpenseSettingsPage initialized', name: 'ExpenseSettings');
  }

  void _save() {
    appLog('💾 Save Expense Settings', name: 'ExpenseSettings');
    Navigator.pop(context);
  }

  void _addNewRate() {
    _showAddRateDialog();
  }

  void _addNewField() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (_) => const AddCustomFieldPage()),
    );
    if (result != null) {
      setState(() => _customFields.add(result));
    }
  }

  void _showAddRateDialog() {
    final nameController = TextEditingController();
    final rateController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: context.colors.card,
        title: Text(
          'Add Mileage Rate',
          style: TextStyle(
            fontSize: Dimensions.font16,
            fontWeight: FontWeight.w600,
            color: context.colors.textPrimary,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Rate Name',
                labelStyle: TextStyle(color: context.colors.textSecondary),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: context.colors.border),
                ),
              ),
            ),
            SizedBox(height: Dimensions.height10),
            TextField(
              controller: rateController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Rate per unit',
                labelStyle: TextStyle(color: context.colors.textSecondary),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: context.colors.border),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: TextStyle(color: context.colors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                setState(() {
                  _mileageRates.add({
                    'name': nameController.text,
                    'rate': rateController.text,
                  });
                });
              }
              Navigator.pop(ctx);
            },
            child: Text('Add', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  void _showUnitPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.colors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Dimensions.radius20),
        ),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.all(Dimensions.width20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Unit',
              style: TextStyle(
                fontSize: Dimensions.font16,
                fontWeight: FontWeight.w600,
                color: context.colors.textPrimary,
              ),
            ),
            SizedBox(height: Dimensions.height15),
            ..._unitOptions.map(
              (option) => ListTile(
                title: Text(
                  option,
                  style: TextStyle(
                    color: context.colors.textPrimary,
                    fontWeight: _mileageUnit == option
                        ? FontWeight.w600
                        : FontWeight.w400,
                  ),
                ),
                trailing: _mileageUnit == option
                    ? Icon(Icons.check, color: AppColors.primary)
                    : null,
                onTap: () {
                  setState(() => _mileageUnit = option);
                  Navigator.pop(ctx);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCategoryPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.colors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Dimensions.radius20),
        ),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.all(Dimensions.width20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Category',
              style: TextStyle(
                fontSize: Dimensions.font16,
                fontWeight: FontWeight.w600,
                color: context.colors.textPrimary,
              ),
            ),
            SizedBox(height: Dimensions.height15),
            ..._categoryOptions.map(
              (option) => ListTile(
                title: Text(
                  option,
                  style: TextStyle(
                    color: context.colors.textPrimary,
                    fontWeight: _mileageCategory == option
                        ? FontWeight.w600
                        : FontWeight.w400,
                  ),
                ),
                trailing: _mileageCategory == option
                    ? Icon(Icons.check, color: AppColors.primary)
                    : null,
                onTap: () {
                  setState(() => _mileageCategory = option);
                  Navigator.pop(ctx);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            CustomSliverAppBar(
              title: 'Expense Settings',
              leadingType: AppBarLeadingType.back,
              actions: [
                AppBarElevatedButton(label: 'SAVE', onPressed: _save),
                SizedBox(width: Dimensions.width20),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.width15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: Dimensions.height10),

                    // Mileage Settings Section
                    Text(
                      'Mileage Settings',
                      style: TextStyle(
                        fontSize: Dimensions.font16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: Dimensions.height15),

                    // Unit
                    _buildPickerRow(
                      label: 'Unit',
                      value: _mileageUnit,
                      onTap: _showUnitPicker,
                    ),
                    SizedBox(height: Dimensions.height20),

                    // Category
                    _buildPickerRow(
                      label: 'Category',
                      value: _mileageCategory,
                      onTap: _showCategoryPicker,
                    ),

                    _buildDivider(),

                    // Mileage Rates Section
                    Text(
                      'Mileage Rates',
                      style: TextStyle(
                        fontSize: Dimensions.font16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: Dimensions.height10),

                    // Rates list
                    ..._mileageRates.map((rate) => _buildRateTile(rate)),

                    // Add new rate
                    InkWell(
                      onTap: _addNewRate,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: Dimensions.height15,
                        ),
                        child: Text(
                          'Add new rate',
                          style: TextStyle(
                            fontSize: Dimensions.font16 * 0.9,
                            color: context.colors.textPrimary,
                          ),
                        ),
                      ),
                    ),

                    _buildDivider(),

                    // Fields Section
                    Text(
                      'Fields',
                      style: TextStyle(
                        fontSize: Dimensions.font16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: Dimensions.height10),

                    // Custom fields list
                    ..._customFields.map(
                      (field) => _buildCustomFieldTile(field),
                    ),

                    // Add new field
                    InkWell(
                      onTap: _addNewField,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: Dimensions.height15,
                        ),
                        child: Text(
                          'Add new field',
                          style: TextStyle(
                            fontSize: Dimensions.font16 * 0.9,
                            color: context.colors.textPrimary,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: Dimensions.height30 * 2),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPickerRow({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: Dimensions.font16,
            fontWeight: FontWeight.w600,
            color: context.colors.textPrimary,
          ),
        ),
        InkWell(
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
                  value,
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.9,
                    color: context.colors.textSecondary,
                  ),
                ),
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

  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Dimensions.height20),
      child: Divider(color: context.colors.border),
    );
  }

  Widget _buildRateTile(Map<String, String> rate) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Dimensions.height10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rate['name'] ?? '',
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.9,
                    fontWeight: FontWeight.w500,
                    color: context.colors.textPrimary,
                  ),
                ),
                if (rate['rate']?.isNotEmpty ?? false)
                  Text(
                    '${rate['rate']} per $_mileageUnit',
                    style: TextStyle(
                      fontSize: Dimensions.font16 * 0.8,
                      color: context.colors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.delete_outline,
              color: AppColors.warn,
              size: Dimensions.iconSize24,
            ),
            onPressed: () {
              setState(() => _mileageRates.remove(rate));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCustomFieldTile(Map<String, dynamic> field) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Dimensions.height10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  field['label'] ?? '',
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.9,
                    fontWeight: FontWeight.w500,
                    color: context.colors.textPrimary,
                  ),
                ),
                Text(
                  field['dataType'] ?? '',
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.8,
                    color: context.colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.delete_outline,
              color: AppColors.warn,
              size: Dimensions.iconSize24,
            ),
            onPressed: () {
              setState(() => _customFields.remove(field));
            },
          ),
        ],
      ),
    );
  }
}
