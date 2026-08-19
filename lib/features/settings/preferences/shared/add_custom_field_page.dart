import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/core/widgets/form_widgets.dart';
import 'package:custom_books/core/widgets/unsaved_changes_dialog.dart';
import 'package:flutter/material.dart';

class AddCustomFieldPage extends StatefulWidget {
  const AddCustomFieldPage({super.key});

  @override
  State<AddCustomFieldPage> createState() => _AddCustomFieldPageState();
}

class _AddCustomFieldPageState extends State<AddCustomFieldPage>
    with UnsavedChangesMixin {
  final TextEditingController _labelController = TextEditingController();
  final TextEditingController _defaultValueController = TextEditingController();
  String _dataType = 'Number';
  String _piiOption = 'not_pii';
  bool _isMandatory = false;
  bool _showInAllPdf = false;

  static const List<String> _dataTypes = [
    'Text',
    'Number',
    'Date',
    'Email',
    'Phone',
    'URL',
    'Dropdown',
    'Checkbox',
  ];

  @override
  void initState() {
    super.initState();
    appLog('➕ AddCustomFieldPage initialized', name: 'AddCustomField');
    _labelController.addListener(markDirty);
    _defaultValueController.addListener(markDirty);
  }

  @override
  void dispose() {
    _labelController.removeListener(markDirty);
    _defaultValueController.removeListener(markDirty);
    _labelController.dispose();
    _defaultValueController.dispose();
    super.dispose();
  }

  void _save() {
    if (_labelController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Label Name is required'),
          backgroundColor: AppColors.warn,
        ),
      );
      return;
    }

    appLog(
      '💾 Save Custom Field: ${_labelController.text}',
      name: 'AddCustomField',
    );

    markClean();
    Navigator.pop(context, {
      'label': _labelController.text.trim(),
      'dataType': _dataType,
      'defaultValue': _defaultValueController.text.trim(),
      'piiOption': _piiOption,
      'isMandatory': _isMandatory,
      'showInAllPdf': _showInAllPdf,
    });
  }

  void _showDataTypePicker() {
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
              'Select Data Type',
              style: TextStyle(
                fontSize: Dimensions.font16,
                fontWeight: FontWeight.w600,
                color: context.colors.textPrimary,
              ),
            ),
            SizedBox(height: Dimensions.height15),
            ..._dataTypes.map(
              (type) => ListTile(
                title: Text(
                  type,
                  style: TextStyle(
                    color: context.colors.textPrimary,
                    fontWeight: _dataType == type
                        ? FontWeight.w600
                        : FontWeight.w400,
                  ),
                ),
                trailing: _dataType == type
                    ? Icon(Icons.check, color: AppColors.primary)
                    : null,
                onTap: () {
                  setState(() => _dataType = type);
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
                title: 'Add a new field',
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
                      // Label Name
                      RequiredLabel(text: 'Label Name'),
                      TextField(
                        controller: _labelController,
                        style: TextStyle(
                          fontSize: Dimensions.font16 * 0.9,
                          color: context.colors.textPrimary,
                        ),
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: context.colors.border,
                            ),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: context.colors.border,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.primary,
                              width: 2,
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: Dimensions.height10,
                          ),
                        ),
                      ),

                      SizedBox(height: Dimensions.height20),

                      // Data Type
                      Text(
                        'Data Type',
                        style: TextStyle(
                          fontSize: Dimensions.font16 * 0.85,
                          color: context.colors.textSecondary,
                        ),
                      ),
                      InkWell(
                        onTap: _showDataTypePicker,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: Dimensions.height10,
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: context.colors.border),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _dataType,
                                style: TextStyle(
                                  fontSize: Dimensions.font16 * 0.9,
                                  color: context.colors.textPrimary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Icon(
                                Icons.keyboard_arrow_down,
                                color: context.colors.textSecondary,
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: Dimensions.height20),

                      // Default Value
                      Text(
                        'Default Value',
                        style: TextStyle(
                          fontSize: Dimensions.font16 * 0.85,
                          color: context.colors.textSecondary,
                        ),
                      ),
                      TextField(
                        controller: _defaultValueController,
                        style: TextStyle(
                          fontSize: Dimensions.font16 * 0.9,
                          color: context.colors.textPrimary,
                        ),
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: context.colors.border,
                            ),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: context.colors.border,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.primary,
                              width: 2,
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: Dimensions.height10,
                          ),
                        ),
                      ),

                      SizedBox(height: Dimensions.height30),

                      // PII Section
                      Text(
                        'Is this PII ( Personally Identifiable Information ) ?',
                        style: TextStyle(
                          fontSize: Dimensions.font16 * 0.85,
                          color: context.colors.textSecondary,
                        ),
                      ),
                      SizedBox(height: Dimensions.height15),

                      _buildRadioTile(
                        "Yes it's PII. Encrypt and store it.",
                        _piiOption == 'pii_encrypt',
                        () => setState(() => _piiOption = 'pii_encrypt'),
                      ),
                      SizedBox(height: Dimensions.height10),
                      _buildRadioTile(
                        "Yes it's PII but not sensitive. Store it without encryption",
                        _piiOption == 'pii_no_encrypt',
                        () => setState(() => _piiOption = 'pii_no_encrypt'),
                      ),
                      SizedBox(height: Dimensions.height10),
                      _buildRadioTile(
                        "No it's not PII.",
                        _piiOption == 'not_pii',
                        () => setState(() => _piiOption = 'not_pii'),
                      ),

                      if (_piiOption == 'not_pii') ...[
                        SizedBox(height: Dimensions.height10),
                        Padding(
                          padding: EdgeInsets.only(
                            left: Dimensions.width30 + Dimensions.width10,
                          ),
                          child: Text(
                            'The data will not be encrypted and all users can view the details. This field can be used to perform advanced searches.',
                            style: TextStyle(
                              fontSize: Dimensions.font16 * 0.75,
                              color: context.colors.textTertiary,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],

                      SizedBox(height: Dimensions.height20),

                      // Is Mandatory
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Is Mandatory',
                            style: TextStyle(
                              fontSize: Dimensions.font16 * 0.9,
                              color: context.colors.textPrimary,
                            ),
                          ),
                          Switch(
                            value: _isMandatory,
                            onChanged: (val) =>
                                setState(() => _isMandatory = val),
                            activeThumbColor: Colors.white,
                            activeTrackColor: AppColors.primary,
                            inactiveThumbColor: Colors.white,
                            inactiveTrackColor: context.colors.border,
                          ),
                        ],
                      ),

                      SizedBox(height: Dimensions.height10),

                      // Show in all PDF
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Show in all PDF',
                            style: TextStyle(
                              fontSize: Dimensions.font16 * 0.9,
                              color: context.colors.textPrimary,
                            ),
                          ),
                          Switch(
                            value: _showInAllPdf,
                            onChanged: (val) =>
                                setState(() => _showInAllPdf = val),
                            activeThumbColor: Colors.white,
                            activeTrackColor: AppColors.primary,
                            inactiveThumbColor: Colors.white,
                            inactiveTrackColor: context.colors.border,
                          ),
                        ],
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

  Widget _buildRadioTile(String label, bool selected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: RadioGroup<bool>(
        groupValue: selected ? true : null,
        onChanged: (_) => onTap(),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Radio<bool>(
              value: true,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            SizedBox(width: Dimensions.width10 / 2),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: Dimensions.height10),
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.85,
                    color: context.colors.textPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
