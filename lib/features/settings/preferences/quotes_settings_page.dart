import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/core/widgets/unsaved_changes_dialog.dart';
import 'package:custom_books/features/settings/preferences/shared/add_custom_field_page.dart';
import 'package:flutter/material.dart';

class QuotesSettingsPage extends StatefulWidget {
  const QuotesSettingsPage({super.key});

  @override
  State<QuotesSettingsPage> createState() => _QuotesSettingsPageState();
}

class _QuotesSettingsPageState extends State<QuotesSettingsPage>
    with UnsavedChangesMixin {
  bool _autoGenerateNumber = true;
  final TextEditingController _prefixController = TextEditingController(
    text: 'QT-',
  );
  final TextEditingController _nextNumberController = TextEditingController(
    text: '000002',
  );
  final TextEditingController _notesController = TextEditingController(
    text: 'Looking forward for your business.',
  );
  final TextEditingController _termsController = TextEditingController();
  bool _convertToInvoice = false;
  bool _prefillCountryCode = false;
  final TextEditingController _defaultCountryCodeController =
      TextEditingController();

  // Custom fields
  final List<Map<String, dynamic>> _customFields = [];

  @override
  void initState() {
    super.initState();
    appLog('📝 QuotesSettingsPage initialized', name: 'QuotesSettings');
    _prefixController.addListener(markDirty);
    _nextNumberController.addListener(markDirty);
    _notesController.addListener(markDirty);
    _termsController.addListener(markDirty);
    _defaultCountryCodeController.addListener(markDirty);
  }

  @override
  void dispose() {
    _prefixController.removeListener(markDirty);
    _nextNumberController.removeListener(markDirty);
    _notesController.removeListener(markDirty);
    _termsController.removeListener(markDirty);
    _defaultCountryCodeController.removeListener(markDirty);
    _prefixController.dispose();
    _nextNumberController.dispose();
    _notesController.dispose();
    _termsController.dispose();
    _defaultCountryCodeController.dispose();
    super.dispose();
  }

  void _save() {
    appLog('💾 Save Quotes Settings', name: 'QuotesSettings');
    markClean();
    Navigator.pop(context);
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
                title: 'Quotes Settings',
                leadingType: AppBarLeadingType.back,
                onLeadingPressed: () => onPopInvokedWithResult(false, null),
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

                      // Quote Number
                      _buildSettingRow(
                        title: 'Quote Number',
                        subtitle: 'Auto-generate?',
                        trailing: Checkbox(
                          value: _autoGenerateNumber,
                          onChanged: (val) => setState(
                            () => _autoGenerateNumber = val ?? false,
                          ),
                          activeColor: Appcolors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),

                      SizedBox(height: Dimensions.height20),

                      // Prefix
                      _buildTextFieldRow(
                        label: 'Prefix',
                        controller: _prefixController,
                      ),

                      SizedBox(height: Dimensions.height20),

                      // Next Number
                      _buildTextFieldRow(
                        label: 'Next Number',
                        controller: _nextNumberController,
                      ),

                      SizedBox(height: Dimensions.height20),

                      // Notes
                      _buildTextFieldRow(
                        label: 'Notes',
                        controller: _notesController,
                        maxLines: 2,
                      ),

                      SizedBox(height: Dimensions.height20),

                      // Terms & Conditions
                      _buildTextFieldRow(
                        label: 'Terms & Conditions',
                        controller: _termsController,
                        maxLines: 3,
                      ),

                      SizedBox(height: Dimensions.height20),

                      // Convert to Invoice
                      _buildSettingRow(
                        title: 'Convert to Invoice',
                        subtitle:
                            'Automatically convert accepted Quote to Invoice',
                        trailing: Checkbox(
                          value: _convertToInvoice,
                          onChanged: (val) =>
                              setState(() => _convertToInvoice = val ?? false),
                          activeColor: Appcolors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),

                      _buildDivider(),

                      // Prefill Country Code
                      Text(
                        'Prefill Country Code',
                        style: TextStyle(
                          fontSize: Dimensions.font16,
                          fontWeight: FontWeight.w600,
                          color: Appcolors.primary,
                        ),
                      ),
                      SizedBox(height: Dimensions.height10),
                      _buildSettingRow(
                        subtitle:
                            "Automatically prefill the country code when verifying a contact's phone number before sharing via WhatsApp.",
                        trailing: Checkbox(
                          value: _prefillCountryCode,
                          onChanged: (val) => setState(
                            () => _prefillCountryCode = val ?? false,
                          ),
                          activeColor: Appcolors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),

                      SizedBox(height: Dimensions.height15),

                      // Default Country Code
                      _buildTextFieldRow(
                        label: 'Default Country Code',
                        controller: _defaultCountryCodeController,
                        hint: 'Enter country code',
                      ),

                      _buildDivider(),

                      // Fields Section
                      Text(
                        'Fields',
                        style: TextStyle(
                          fontSize: Dimensions.font16,
                          fontWeight: FontWeight.w600,
                          color: Appcolors.primary,
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
      ),
    );
  }

  Widget _buildSettingRow({
    String? title,
    String? subtitle,
    required Widget trailing,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null)
                Text(
                  title,
                  style: TextStyle(
                    fontSize: Dimensions.font16,
                    fontWeight: FontWeight.w600,
                    color: context.colors.textPrimary,
                  ),
                ),
              if (subtitle != null) ...[
                SizedBox(height: Dimensions.height10 / 3),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.85,
                    color: context.colors.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ),
        trailing,
      ],
    );
  }

  Widget _buildTextFieldRow({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
    String? hint,
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
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: TextStyle(
            fontSize: Dimensions.font16 * 0.9,
            color: context.colors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: context.colors.textTertiary),
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: context.colors.border),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: context.colors.border),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Appcolors.primary, width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: Dimensions.height10),
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
              color: Appcolors.warn,
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
