import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/core/widgets/form_widgets.dart';
import 'package:custom_books/core/widgets/unsaved_changes_dialog.dart';
import 'package:flutter/material.dart';

class NewTaxPage extends StatefulWidget {
  const NewTaxPage({super.key});

  @override
  State<NewTaxPage> createState() => _NewTaxPageState();
}

class _NewTaxPageState extends State<NewTaxPage> with UnsavedChangesMixin {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.addListener(markDirty);
    _rateController.addListener(markDirty);
    appLog('📝 NewTaxPage initialized', name: 'NewTax');
  }

  @override
  void dispose() {
    _nameController.removeListener(markDirty);
    _rateController.removeListener(markDirty);
    _nameController.dispose();
    _rateController.dispose();
    super.dispose();
  }

  void _save() {
    if (_nameController.text.trim().isEmpty) {
      _showError('Tax Name is required');
      return;
    }
    if (_rateController.text.trim().isEmpty) {
      _showError('Rate is required');
      return;
    }
    appLog(
      '💾 Save tax: ${_nameController.text} @ ${_rateController.text}%',
      name: 'NewTax',
    );
    markClean();
    Navigator.pop(context);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Appcolors.warn),
    );
  }

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);

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
                title: 'New Tax',
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
                      const RequiredLabel(text: 'Tax Name'),
                      SizedBox(height: Dimensions.height10 / 2),
                      TextField(
                        controller: _nameController,
                        style: FormTextStyles.value(context),
                        decoration: _underlineDecoration(),
                      ),
                      SizedBox(height: Dimensions.height20),
                      const RequiredLabel(text: 'Rate (%)'),
                      SizedBox(height: Dimensions.height10 / 2),
                      TextField(
                        controller: _rateController,
                        style: FormTextStyles.value(context),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: _underlineDecoration(suffix: '%'),
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

  InputDecoration _underlineDecoration({String? suffix}) {
    return InputDecoration(
      isDense: true,
      suffixText: suffix,
      suffixStyle: TextStyle(
        color: context.colors.textSecondary,
        fontWeight: FontWeight.w600,
      ),
      contentPadding: EdgeInsets.symmetric(vertical: Dimensions.height10),
      border: UnderlineInputBorder(
        borderSide: BorderSide(color: context.colors.border),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: context.colors.border),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Appcolors.primary),
      ),
    );
  }
}
