import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/core/widgets/form_widgets.dart';
import 'package:custom_books/core/widgets/unsaved_changes_dialog.dart';
import 'package:flutter/material.dart';

class NewTaxGroupPage extends StatefulWidget {
  const NewTaxGroupPage({super.key});

  @override
  State<NewTaxGroupPage> createState() => _NewTaxGroupPageState();
}

class _NewTaxGroupPageState extends State<NewTaxGroupPage>
    with UnsavedChangesMixin {
  final TextEditingController _nameController = TextEditingController();

  final List<_TaxOption> _availableTaxes = [
    _TaxOption(name: 'VAT', rate: 5.0, selected: false),
    _TaxOption(name: 'Zero Rate', rate: 0.0, selected: false),
  ];

  @override
  void initState() {
    super.initState();
    _nameController.addListener(markDirty);
    appLog('📝 NewTaxGroupPage initialized', name: 'NewTaxGroup');
  }

  @override
  void dispose() {
    _nameController.removeListener(markDirty);
    _nameController.dispose();
    super.dispose();
  }

  void _save() {
    if (_nameController.text.trim().isEmpty) {
      _showError('Tax Group Name is required');
      return;
    }
    final selectedTaxes = _availableTaxes.where((t) => t.selected).toList();
    if (selectedTaxes.isEmpty) {
      _showError('Please select at least one tax');
      return;
    }
    appLog('💾 Save tax group: ${_nameController.text}', name: 'NewTaxGroup');
    markClean();
    Navigator.pop(context);
  }

  void _showError(String message) {
    ToastificationHelper.showError(context, message);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: onPopInvokedWithResult,
      child: Scaffold(
        backgroundColor: context.colors.background,
        body: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              CustomSliverAppBar(
                title: 'New Tax Group',
                leadingType: AppBarLeadingType.back,
                onLeadingPressed: () => onPopInvokedWithResult(false, null),
                actions: [
                  AppBarElevatedButton(label: 'SAVE', onPressed: _save),
                  SizedBox(width: Dimensions.width20),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(Dimensions.width15),
                  child: FormCard(
                    children: [
                      const RequiredLabel(text: 'Tax Group Name'),
                      SizedBox(height: Dimensions.height10 / 2),
                      TextField(
                        controller: _nameController,
                        style: FormTextStyles.value(context),
                        decoration: _underlineDecoration(),
                      ),
                      SizedBox(height: Dimensions.height20),
                      const RequiredLabel(text: 'Taxes'),
                      SizedBox(height: Dimensions.height10),
                      ..._availableTaxes.map((tax) => _buildTaxCheckbox(tax)),
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

  Widget _buildTaxCheckbox(_TaxOption tax) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Dimensions.height10 / 2),
      child: InkWell(
        onTap: () => setState(() => tax.selected = !tax.selected),
        child: Row(
          children: [
            SizedBox(
              width: Dimensions.iconSize24,
              height: Dimensions.iconSize24,
              child: Checkbox(
                value: tax.selected,
                onChanged: (val) => setState(() => tax.selected = val ?? false),
                activeColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    Dimensions.radius15 * 0.27,
                  ),
                ),
              ),
            ),
            SizedBox(width: Dimensions.width10),
            Text(
              '${tax.name} [${tax.rate.toStringAsFixed(1)}%]',
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.9,
                color: context.colors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _underlineDecoration() {
    return InputDecoration(
      isDense: true,
      contentPadding: EdgeInsets.symmetric(vertical: Dimensions.height10),
      border: UnderlineInputBorder(
        borderSide: BorderSide(color: context.colors.border),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: context.colors.border),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.primary),
      ),
    );
  }
}

class _TaxOption {
  final String name;
  final double rate;
  bool selected;

  _TaxOption({required this.name, required this.rate, required this.selected});
}
