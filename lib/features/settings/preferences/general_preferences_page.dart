import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/core/widgets/form_widgets.dart';
import 'package:flutter/material.dart';

class GeneralPreferencesPage extends StatefulWidget {
  const GeneralPreferencesPage({super.key});

  @override
  State<GeneralPreferencesPage> createState() => _GeneralPreferencesPageState();
}

class _GeneralPreferencesPageState extends State<GeneralPreferencesPage> {
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

  @override
  void initState() {
    super.initState();
    appLog('⚙️ GeneralPreferencesPage initialized', name: 'GeneralPreferences');
  }

  void _save() {
    appLog('💾 Save General Preferences', name: 'GeneralPreferences');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);

    return Scaffold(
      backgroundColor: context.colors.background,
      bottomNavigationBar: _buildSaveButton(),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            const CustomSliverAppBar(
              title: 'General',
              leadingType: AppBarLeadingType.back,
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
                            (entry) => _buildModuleChip(entry.key, entry.value),
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
                              () {},
                            ),
                            _buildActionLink(
                              Icons.visibility_outlined,
                              'Preview',
                              () {},
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
              backgroundColor: Appcolors.primary,
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
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.width15,
          vertical: Dimensions.height10,
        ),
        decoration: BoxDecoration(
          color: enabled
              ? Appcolors.primary.withValues(alpha: 0.08)
              : context.colors.surfaceLight,
          borderRadius: BorderRadius.circular(Dimensions.radius30),
          border: Border.all(
            color: enabled ? Appcolors.primary : context.colors.border,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: Dimensions.font16 * 0.8,
            fontWeight: FontWeight.w600,
            color: enabled ? Appcolors.primary : context.colors.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildRadioTile(String label, bool selected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: Dimensions.height10 / 2),
        child: Row(
          children: [
            Radio<bool>(
              value: true,
              groupValue: selected ? true : null,
              onChanged: (_) => onTap(),
              activeColor: Appcolors.primary,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
    return InkWell(
      onTap: () => onChanged(!value),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: Dimensions.iconSize24,
            height: Dimensions.iconSize24,
            child: Checkbox(
              value: value,
              onChanged: onChanged,
              activeColor: Appcolors.primary,
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
          Icon(icon, size: Dimensions.iconSize16, color: Appcolors.primary),
          SizedBox(width: Dimensions.width10 / 2),
          Text(
            label,
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.8,
              fontWeight: FontWeight.w600,
              color: Appcolors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
