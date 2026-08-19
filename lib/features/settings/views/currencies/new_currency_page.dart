import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/core/widgets/unsaved_changes_dialog.dart';
import 'package:flutter/material.dart';

class NewCurrencyPage extends StatefulWidget {
  const NewCurrencyPage({super.key});

  @override
  State<NewCurrencyPage> createState() => _NewCurrencyPageState();
}

class _NewCurrencyPageState extends State<NewCurrencyPage>
    with UnsavedChangesMixin {
  String? _selectedCode;
  final TextEditingController _symbolController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  String? _selectedDecimalPlaces;
  String? _selectedFormat;

  static const List<String> _currencyCodes = [
    'AED',
    'AUD',
    'BND',
    'CAD',
    'CHF',
    'CNY',
    'EUR',
    'GBP',
    'HKD',
    'INR',
    'JPY',
    'KRW',
    'MYR',
    'NZD',
    'PHP',
    'SAR',
    'SGD',
    'THB',
    'USD',
    'ZAR',
  ];

  static const List<String> _decimalOptions = ['0', '2', '3'];
  static const List<String> _formatOptions = [
    '1,234,567.89',
    '1.234.567,89',
    '1 234 567.89',
  ];

  @override
  void initState() {
    super.initState();
    _symbolController.addListener(markDirty);
    _nameController.addListener(markDirty);
    appLog('💱 NewCurrencyPage initialized', name: 'NewCurrency');
  }

  @override
  void dispose() {
    _symbolController.removeListener(markDirty);
    _nameController.removeListener(markDirty);
    _symbolController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _save() {
    if (_selectedCode == null) {
      _showError('Currency Code is required');
      return;
    }
    if (_symbolController.text.trim().isEmpty) {
      _showError('Currency Symbol is required');
      return;
    }
    if (_nameController.text.trim().isEmpty) {
      _showError('Currency Name is required');
      return;
    }
    appLog('💾 Save new currency: $_selectedCode', name: 'NewCurrency');
    markClean();
    Navigator.pop(context);
  }

  void _showError(String message) {
    ToastificationHelper.showError(context, message);
  }

  Future<void> _selectCurrencyCode() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      backgroundColor: context.colors.card,
      isScrollControlled: true,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        expand: false,
        builder: (_, scrollController) => Column(
          children: [
            Padding(
              padding: EdgeInsets.all(Dimensions.width15),
              child: Text(
                'Select Currency Code',
                style: TextStyle(
                  fontSize: Dimensions.font16 * 1.1,
                  fontWeight: FontWeight.w700,
                  color: context.colors.textPrimary,
                ),
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: _currencyCodes.length,
                itemBuilder: (_, index) {
                  final code = _currencyCodes[index];
                  return ListTile(
                    title: Text(code),
                    trailing: code == _selectedCode
                        ? Icon(Icons.check_rounded, color: AppColors.primary)
                        : null,
                    onTap: () => Navigator.pop(ctx, code),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
    if (selected != null) {
      setState(() => _selectedCode = selected);
    }
  }

  Future<void> _selectDecimalPlaces() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      backgroundColor: context.colors.card,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(Dimensions.width15),
              child: Text(
                'Decimal Places',
                style: TextStyle(
                  fontSize: Dimensions.font16 * 1.1,
                  fontWeight: FontWeight.w700,
                  color: context.colors.textPrimary,
                ),
              ),
            ),
            const Divider(height: 1),
            ..._decimalOptions.map(
              (option) => ListTile(
                title: Text(option),
                trailing: option == _selectedDecimalPlaces
                    ? Icon(Icons.check_rounded, color: AppColors.primary)
                    : null,
                onTap: () => Navigator.pop(ctx, option),
              ),
            ),
          ],
        ),
      ),
    );
    if (selected != null) {
      setState(() => _selectedDecimalPlaces = selected);
    }
  }

  Future<void> _selectFormat() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      backgroundColor: context.colors.card,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(Dimensions.width15),
              child: Text(
                'Currency Format',
                style: TextStyle(
                  fontSize: Dimensions.font16 * 1.1,
                  fontWeight: FontWeight.w700,
                  color: context.colors.textPrimary,
                ),
              ),
            ),
            const Divider(height: 1),
            ..._formatOptions.map(
              (option) => ListTile(
                title: Text(option),
                trailing: option == _selectedFormat
                    ? Icon(Icons.check_rounded, color: AppColors.primary)
                    : null,
                onTap: () => Navigator.pop(ctx, option),
              ),
            ),
          ],
        ),
      ),
    );
    if (selected != null) {
      setState(() => _selectedFormat = selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: onPopInvokedWithResult,
      child: Scaffold(
        backgroundColor: context.colors.background,
        bottomNavigationBar: _buildSaveButton(),
        body: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              CustomSliverAppBar(
                title: 'New Currency',
                leadingType: AppBarLeadingType.back,
                onLeadingPressed: () => onPopInvokedWithResult(false, null),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(Dimensions.width15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Currency Code
                      _buildLabel('Currency Code', required: true),
                      SizedBox(height: Dimensions.height10),
                      _buildDropdownField(
                        value: _selectedCode,
                        hint: 'Select a Currency Code',
                        onTap: _selectCurrencyCode,
                      ),

                      SizedBox(height: Dimensions.height20),

                      // Currency Symbol
                      _buildLabel('Currency Symbol', required: true),
                      SizedBox(height: Dimensions.height10),
                      _buildTextField(
                        controller: _symbolController,
                        hint: 'Enter a Currency Symbol',
                      ),

                      SizedBox(height: Dimensions.height20),

                      // Currency Name
                      _buildLabel('Currency Name', required: true),
                      SizedBox(height: Dimensions.height10),
                      _buildTextField(
                        controller: _nameController,
                        hint: 'Enter a Currency Name',
                      ),

                      SizedBox(height: Dimensions.height20),

                      // Decimal Places
                      _buildLabel('Decimal Places'),
                      SizedBox(height: Dimensions.height10),
                      _buildDropdownField(
                        value: _selectedDecimalPlaces,
                        hint: 'Select',
                        onTap: _selectDecimalPlaces,
                      ),

                      SizedBox(height: Dimensions.height20),

                      // Format
                      _buildLabel('Format'),
                      SizedBox(height: Dimensions.height10),
                      _buildDropdownField(
                        value: _selectedFormat,
                        hint: 'Select a Currency Format',
                        onTap: _selectFormat,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text, {bool required = false}) {
    if (required) {
      return Text.rich(
        TextSpan(
          text: '$text ',
          style: TextStyle(
            fontSize: Dimensions.font16 * 0.85,
            fontWeight: FontWeight.w600,
            color: context.colors.textPrimary,
          ),
          children: [
            TextSpan(
              text: '*',
              style: TextStyle(color: Colors.red.shade400),
            ),
          ],
        ),
      );
    }
    return Text(
      text,
      style: TextStyle(
        fontSize: Dimensions.font16 * 0.85,
        fontWeight: FontWeight.w600,
        color: context.colors.textPrimary,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
  }) {
    return TextField(
      controller: controller,
      style: TextStyle(
        fontSize: Dimensions.font16 * 0.9,
        color: context.colors.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: context.colors.textTertiary),
        filled: true,
        fillColor: context.colors.card,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimensions.radius15),
          borderSide: BorderSide(color: context.colors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimensions.radius15),
          borderSide: BorderSide(color: context.colors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimensions.radius15),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: Dimensions.width15,
          vertical: Dimensions.height15,
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String? value,
    required String hint,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Dimensions.radius15),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.width15,
          vertical: Dimensions.height15,
        ),
        decoration: BoxDecoration(
          color: context.colors.card,
          borderRadius: BorderRadius.circular(Dimensions.radius15),
          border: Border.all(color: context.colors.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                value ?? hint,
                style: TextStyle(
                  fontSize: Dimensions.font16 * 0.9,
                  color: value != null
                      ? context.colors.textPrimary
                      : context.colors.textTertiary,
                ),
              ),
            ),
            Icon(
              Icons.arrow_drop_down_rounded,
              color: context.colors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      padding: EdgeInsets.all(Dimensions.width15),
      decoration: BoxDecoration(
        color: context.colors.background,
        border: Border(top: BorderSide(color: context.colors.border)),
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: Dimensions.height45,
          child: ElevatedButton(
            onPressed: _save,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Dimensions.radius30),
              ),
              elevation: 0,
            ),
            child: Text(
              'Save',
              style: TextStyle(
                fontSize: Dimensions.font16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
