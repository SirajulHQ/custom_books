import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/core/widgets/form_widgets.dart';
import 'package:custom_books/core/widgets/unsaved_changes_dialog.dart';
import 'package:flutter/material.dart';

class GeneralPreferencesPage extends StatefulWidget {
  const GeneralPreferencesPage({super.key});

  @override
  State<GeneralPreferencesPage> createState() => _GeneralPreferencesPageState();
}

class _GeneralPreferencesPageState extends State<GeneralPreferencesPage>
    with UnsavedChangesMixin {
  // Module toggles
  final Map<String, bool> _modules = {
    'Quote': true,
    'Sales Orders': true,
    'Delivery Challans': true,
    'Purchase Orders': true,
    'Time Tracking': true,
    'Retainer Invoices': false,
    'Recurring Invoice': true,
    'Credit Note': true,
    'Payment Links': false,
  };

  // PDF Attachment
  bool _attachPdf = true;
  bool _encryptPdf = false;

  // Discounts
  String _discountOption = 'At Line Item Level';
  static const List<String> _discountOptions = [
    "I don't give discounts",
    'At Line Item Level',
    'At Invoice Level',
  ];

  // Tax
  String _taxOption = 'Tax Inclusive or Tax Exclusive';
  static const List<String> _taxOptions = [
    'Tax Inclusive',
    'Tax Exclusive',
    'Tax Inclusive or Tax Exclusive',
  ];

  // Rounding
  String _roundingOption = 'No Rounding';
  static const List<String> _roundingOptions = [
    'No Rounding',
    'Round off the total to the nearest whole number',
  ];

  // Salesperson
  bool _addSalesperson = true;

  // Organization Address Format
  String _orgAddressFormat =
      '{ORGANIZATION.POSTAL_CODE}\n\${ORGANIZATION.COUNTRY}\n\${ORGANIZATION.TRN_LABEL} \$\n{ORGANIZATION.TRN_VALUE}\n\${ORGANIZATION.PHONE}\n\${ORGANIZATION.EMAIL}\n\${ORGANIZATION.WEBSITE}';

  // Placeholder tokens that can be inserted into the address format.
  static const Map<String, String> _orgPlaceholders = {
    'Organization Name': r'${ORGANIZATION.NAME}',
    'Street Address': r'${ORGANIZATION.ADDRESS}',
    'City': r'${ORGANIZATION.CITY}',
    'State': r'${ORGANIZATION.STATE}',
    'Postal Code': r'${ORGANIZATION.POSTAL_CODE}',
    'Country': r'${ORGANIZATION.COUNTRY}',
    'Phone': r'${ORGANIZATION.PHONE}',
    'Email': r'${ORGANIZATION.EMAIL}',
    'Website': r'${ORGANIZATION.WEBSITE}',
    'TRN': r'${ORGANIZATION.TRN_VALUE}',
  };

  // Sample values used to render a human-readable preview.
  static const Map<String, String> _previewValues = {
    r'${ORGANIZATION.NAME}': 'Acme Trading LLC',
    r'${ORGANIZATION.ADDRESS}': '123 Market Street',
    r'${ORGANIZATION.CITY}': 'Dubai',
    r'${ORGANIZATION.STATE}': 'Dubai',
    r'${ORGANIZATION.POSTAL_CODE}': '00000',
    r'${ORGANIZATION.COUNTRY}': 'United Arab Emirates',
    r'${ORGANIZATION.PHONE}': '+971 4 123 4567',
    r'${ORGANIZATION.EMAIL}': 'hello@acme.com',
    r'${ORGANIZATION.WEBSITE}': 'www.acme.com',
    r'${ORGANIZATION.TRN_LABEL}': 'TRN',
    r'${ORGANIZATION.TRN_VALUE}': '100123456700003',
  };

  @override
  void initState() {
    super.initState();
    appLog('⚙️ GeneralPreferencesPage initialized', name: 'GeneralPreferences');
  }

  void _save() {
    appLog('💾 Save General Preferences', name: 'GeneralPreferences');
    markClean();
    Navigator.pop(context);
  }

  void _insertPlaceholder() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: context.colors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Dimensions.radius20),
        ),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.width20,
            vertical: Dimensions.height10,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Insert Placeholder',
                style: TextStyle(
                  fontSize: Dimensions.font16,
                  fontWeight: FontWeight.w800,
                  color: context.colors.textPrimary,
                ),
              ),
              SizedBox(height: Dimensions.height10),
              Wrap(
                spacing: Dimensions.width10,
                runSpacing: Dimensions.height10,
                children: _orgPlaceholders.entries.map((entry) {
                  return ActionChip(
                    label: Text(entry.key),
                    labelStyle: TextStyle(
                      fontSize: Dimensions.font16 * 0.8,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                    backgroundColor: AppColors.primary.withValues(alpha: 0.08),
                    side: BorderSide(
                      color: AppColors.primary.withValues(alpha: 0.3),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Dimensions.radius15),
                    ),
                    onPressed: () {
                      Navigator.pop(sheetContext);
                      setState(() {
                        _orgAddressFormat =
                            '$_orgAddressFormat\n${entry.value}';
                      });
                      markDirty();
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: Dimensions.height15),
            ],
          ),
        ),
      ),
    );
  }

  void _previewAddressFormat() {
    var rendered = _orgAddressFormat;
    _previewValues.forEach((token, value) {
      rendered = rendered.replaceAll(token, value);
    });

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: context.colors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radius20),
        ),
        title: Text(
          'Address Preview',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: Dimensions.font20 * 0.9,
            color: context.colors.textPrimary,
          ),
        ),
        content: Container(
          width: double.infinity,
          padding: EdgeInsets.all(Dimensions.width15),
          decoration: BoxDecoration(
            color: context.colors.surfaceLight,
            borderRadius: BorderRadius.circular(Dimensions.radius15 / 2),
            border: Border.all(color: context.colors.border),
          ),
          child: Text(
            rendered,
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.85,
              height: 1.5,
              color: context.colors.textPrimary,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Close',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                title: 'General',
                leadingType: AppBarLeadingType.back,
                onLeadingPressed: () => onPopInvokedWithResult(false, null),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.width15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: Dimensions.height10),

                      // ── Modules Section ──────────────────────────────────
                      _buildSectionHeader(
                        'Select the modules you would like to enable.',
                      ),
                      SizedBox(height: Dimensions.height10),
                      Wrap(
                        spacing: Dimensions.width10,
                        runSpacing: Dimensions.height10,
                        children: _modules.entries
                            .map(
                              (entry) =>
                                  _buildModuleChip(entry.key, entry.value),
                            )
                            .toList(),
                      ),

                      _buildSectionDivider(),

                      // ── Other Preferences ────────────────────────────────
                      _buildSectionHeader('Other Preferences'),
                      SizedBox(height: Dimensions.height15),

                      // PDF Attachment
                      FormCard(
                        children: [
                          Text(
                            'PDF Attachment',
                            style: TextStyle(
                              fontSize: Dimensions.font16,
                              fontWeight: FontWeight.w600,
                              color: context.colors.textPrimary,
                            ),
                          ),
                          SizedBox(height: Dimensions.height15),
                          _buildCheckboxTile(
                            'Attach PDF file with the link while emailing the invoice & quote?',
                            _attachPdf,
                            (val) => setState(() => _attachPdf = val ?? false),
                          ),
                          SizedBox(height: Dimensions.height10),
                          _buildCheckboxTile(
                            'I would like to encrypt the PDF files that I send',
                            _encryptPdf,
                            (val) => setState(() => _encryptPdf = val ?? false),
                          ),
                        ],
                      ),
                      SizedBox(height: Dimensions.height15),

                      // Discounts
                      FormCard(
                        children: [
                          Text(
                            'Do you give discounts?',
                            style: TextStyle(
                              fontSize: Dimensions.font16,
                              fontWeight: FontWeight.w600,
                              color: context.colors.textPrimary,
                            ),
                          ),
                          SizedBox(height: Dimensions.height10),
                          ..._discountOptions.map(
                            (option) => _buildRadioTile(
                              option,
                              _discountOption == option,
                              () => setState(() => _discountOption = option),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: Dimensions.height15),

                      // Tax
                      FormCard(
                        children: [
                          Text(
                            'Do you sell your items at rates inclusive of Tax?',
                            style: TextStyle(
                              fontSize: Dimensions.font16,
                              fontWeight: FontWeight.w600,
                              color: context.colors.textPrimary,
                            ),
                          ),
                          SizedBox(height: Dimensions.height10),
                          ..._taxOptions.map(
                            (option) => _buildRadioTile(
                              option,
                              _taxOption == option,
                              () => setState(() => _taxOption = option),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: Dimensions.height15),

                      // Rounding
                      FormCard(
                        children: [
                          Text(
                            'Rounding off in Sales Transactions',
                            style: TextStyle(
                              fontSize: Dimensions.font16,
                              fontWeight: FontWeight.w600,
                              color: context.colors.textPrimary,
                            ),
                          ),
                          SizedBox(height: Dimensions.height10),
                          ..._roundingOptions.map(
                            (option) => _buildRadioTile(
                              option,
                              _roundingOption == option,
                              () => setState(() => _roundingOption = option),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: Dimensions.height15),

                      // Salesperson
                      FormCard(
                        children: [
                          _buildCheckboxTile(
                            'I want to add a field for salesperson',
                            _addSalesperson,
                            (val) =>
                                setState(() => _addSalesperson = val ?? false),
                          ),
                        ],
                      ),
                      SizedBox(height: Dimensions.height15),

                      // Organization Address Format
                      _buildSectionHeader('Organization Address Format'),
                      SizedBox(height: Dimensions.height10),
                      FormCard(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(Dimensions.width15),
                            decoration: BoxDecoration(
                              color: context.colors.surfaceLight,
                              borderRadius: BorderRadius.circular(
                                Dimensions.radius15 / 2,
                              ),
                              border: Border.all(color: context.colors.border),
                            ),
                            child: Text(
                              _orgAddressFormat,
                              style: TextStyle(
                                fontSize: Dimensions.font16 * 0.8,
                                color: context.colors.textPrimary,
                                height: 1.5,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ),
                          SizedBox(height: Dimensions.height10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildActionLink(
                                Icons.add_circle_outline_rounded,
                                'Insert Placeholders',
                                _insertPlaceholder,
                              ),
                              _buildActionLink(
                                Icons.visibility_outlined,
                                'Preview',
                                _previewAddressFormat,
                              ),
                            ],
                          ),
                        ],
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

  Widget _buildSaveButton() {
    return Container(
      padding: EdgeInsets.all(Dimensions.width15),
      decoration: BoxDecoration(
        color: context.colors.card,
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

  Widget _buildSectionHeader(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: Dimensions.font16 * 0.9,
        fontWeight: FontWeight.w600,
        color: context.colors.textPrimary,
      ),
    );
  }

  Widget _buildSectionDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Dimensions.height15),
      child: Divider(color: context.colors.border),
    );
  }

  Widget _buildModuleChip(String label, bool enabled) {
    return GestureDetector(
      onTap: () {
        setState(() => _modules[label] = !enabled);
        markDirty();
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.width15,
          vertical: Dimensions.height10,
        ),
        decoration: BoxDecoration(
          color: enabled
              ? AppColors.primary.withValues(alpha: 0.08)
              : context.colors.surfaceLight,
          borderRadius: BorderRadius.circular(Dimensions.radius30),
          border: Border.all(
            color: enabled ? AppColors.primary : context.colors.border,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: Dimensions.font16 * 0.8,
            fontWeight: FontWeight.w600,
            color: enabled ? AppColors.primary : context.colors.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildRadioTile(String label, bool selected, VoidCallback onTap) {
    void handleTap() {
      onTap();
      markDirty();
    }

    return InkWell(
      onTap: handleTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: Dimensions.height10 / 2),
        child: Row(
          children: [
            RadioGroup<bool>(
              groupValue: selected ? true : null,
              onChanged: (_) => handleTap(),
              child: Radio<bool>(
                value: true,
                activeColor: AppColors.primary,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
            SizedBox(width: Dimensions.width10 / 2),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: Dimensions.font16 * 0.85,
                  color: context.colors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckboxTile(
    String label,
    bool value,
    ValueChanged<bool?> onChanged,
  ) {
    void handleChanged(bool? val) {
      onChanged(val);
      markDirty();
    }

    return InkWell(
      onTap: () => handleChanged(!value),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: Dimensions.iconSize24,
            height: Dimensions.iconSize24,
            child: Checkbox(
              value: value,
              onChanged: handleChanged,
              activeColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Dimensions.radius15 * 0.27),
              ),
            ),
          ),
          SizedBox(width: Dimensions.width10),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.85,
                color: context.colors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionLink(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: Dimensions.iconSize16, color: AppColors.primary),
          SizedBox(width: Dimensions.width10 / 2),
          Text(
            label,
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.8,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
