import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/features/reports/models/report_type.dart';
import 'package:flutter/material.dart';

class ReportExportDialog extends StatefulWidget {
  final ReportType reportType;
  final String reportBasis;

  const ReportExportDialog({
    super.key,
    required this.reportType,
    required this.reportBasis,
  });

  @override
  State<ReportExportDialog> createState() => _ReportExportDialogState();
}

class _ReportExportDialogState extends State<ReportExportDialog> {
  final TextEditingController _fileNameController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  bool _protectWithPassword = false;
  String _language = 'English';
  bool _showCustomize = false;

  // Details to display
  bool _organizationName = true;
  bool _organizationDetails = false;
  bool _reportBasis = true;
  bool _pageNumber = false;
  bool _generatedBy = false;
  bool _generatedDate = false;
  bool _generatedTime = false;
  bool _columnHeadersOnEachPage = true;

  // Layout
  String _tableDensity = 'Classic';
  bool _autoResize = true;
  String _paperSize = 'A4';
  String _orientation = 'Portrait';
  double _marginTop = 0.7;
  double _marginBottom = 0.55;
  double _marginLeft = 0.2;
  double _marginRight = 0.2;

  @override
  void dispose() {
    _fileNameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _export() {
    appLog(
      '📤 Exporting report: ${widget.reportType.title}',
      name: 'ReportExport',
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      margin: EdgeInsets.all(Dimensions.width15),
      padding: EdgeInsets.all(Dimensions.width20),
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: BorderRadius.circular(Dimensions.radius20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Export Report as PDF',
                style: TextStyle(
                  fontSize: Dimensions.font16 * 1.1,
                  fontWeight: FontWeight.w700,
                  color: context.colors.textPrimary,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close_rounded, color: Appcolors.warn),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          Divider(color: context.colors.border),
          // Scrollable content
          Flexible(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: _buildContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: Dimensions.height15),

        // File name
        _label('Export File Name'),
        SizedBox(height: Dimensions.height10 / 2),
        _textField(_fileNameController, ''),

        SizedBox(height: Dimensions.height15),

        // Password protection
        Text(
          'You can protect the exported report with a password to keep your data secure.',
          style: TextStyle(
            fontSize: Dimensions.font16 * 0.8,
            color: context.colors.textSecondary,
          ),
        ),
        SizedBox(height: Dimensions.height10),
        _checkboxTile(
          'I want to protect this file with a password.',
          _protectWithPassword,
          (v) => setState(() => _protectWithPassword = v!),
        ),

        SizedBox(height: Dimensions.height20),

        // Language
        Text(
          'Select the language in which you want to export the report as PDF:',
          style: TextStyle(
            fontSize: Dimensions.font16 * 0.8,
            color: context.colors.textSecondary,
          ),
        ),
        SizedBox(height: Dimensions.height10),
        _radioTile('Arabic', 'Arabic'),
        _radioTile('English', 'English'),

        SizedBox(height: Dimensions.height15),

        // Customize toggle
        InkWell(
          onTap: () => setState(() => _showCustomize = !_showCustomize),
          child: Row(
            children: [
              Text(
                'Customize the details in the export file',
                style: TextStyle(
                  fontSize: Dimensions.font16 * 0.85,
                  fontWeight: FontWeight.w600,
                  color: Appcolors.primary,
                ),
              ),
              SizedBox(width: Dimensions.width10 / 2),
              Icon(
                _showCustomize
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
                color: Appcolors.primary,
                size: Dimensions.iconSize24,
              ),
            ],
          ),
        ),

        if (_showCustomize) ...[
          SizedBox(height: Dimensions.height20),
          _buildCustomizeSection(),
        ],

        SizedBox(height: Dimensions.height20),

        // Action buttons
        Row(
          children: [
            ElevatedButton(
              onPressed: _export,
              style: ElevatedButton.styleFrom(
                backgroundColor: Appcolors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.width20,
                  vertical: Dimensions.height10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimensions.radius15),
                ),
              ),
              child: Text(
                'Export',
                style: TextStyle(
                  fontSize: Dimensions.font16 * 0.9,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(width: Dimensions.width15),
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                foregroundColor: context.colors.textPrimary,
                side: BorderSide(color: context.colors.border),
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.width20,
                  vertical: Dimensions.height10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimensions.radius15),
                ),
              ),
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontSize: Dimensions.font16 * 0.9,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: Dimensions.height10),
      ],
    );
  }

  Widget _buildCustomizeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Choose Details to Display
        Text(
          'Choose Details to Display',
          style: TextStyle(
            fontSize: Dimensions.font16,
            fontWeight: FontWeight.w700,
            color: context.colors.textPrimary,
          ),
        ),
        SizedBox(height: Dimensions.height10),
        _checkboxTile(
          'Organization Name',
          _organizationName,
          (v) => setState(() => _organizationName = v!),
        ),
        _checkboxTile(
          'Organization Details',
          _organizationDetails,
          (v) => setState(() => _organizationDetails = v!),
        ),
        _checkboxTile(
          'Report Basis',
          _reportBasis,
          (v) => setState(() => _reportBasis = v!),
        ),
        _checkboxTile(
          'Page Number',
          _pageNumber,
          (v) => setState(() => _pageNumber = v!),
        ),
        _checkboxTile(
          'Generated By',
          _generatedBy,
          (v) => setState(() => _generatedBy = v!),
        ),
        _checkboxTile(
          'Generated Date',
          _generatedDate,
          (v) => setState(() => _generatedDate = v!),
        ),
        _checkboxTile(
          'Generated Time',
          _generatedTime,
          (v) => setState(() => _generatedTime = v!),
        ),

        SizedBox(height: Dimensions.height20),

        // Choose how to display
        Text(
          'Choose How to Display the Details',
          style: TextStyle(
            fontSize: Dimensions.font16,
            fontWeight: FontWeight.w700,
            color: context.colors.textPrimary,
          ),
        ),
        SizedBox(height: Dimensions.height10),
        _checkboxTile(
          'Column Headers on Each Page',
          _columnHeadersOnEachPage,
          (v) => setState(() => _columnHeadersOnEachPage = v!),
        ),

        SizedBox(height: Dimensions.height20),

        // Temporary Note
        Text(
          'Temporary Note',
          style: TextStyle(
            fontSize: Dimensions.font16,
            fontWeight: FontWeight.w700,
            color: context.colors.textPrimary,
          ),
        ),
        SizedBox(height: Dimensions.height10 / 2),
        Text(
          'Enter any additional information about this report as a note to display it at the footer of the report when it is exported.',
          style: TextStyle(
            fontSize: Dimensions.font16 * 0.8,
            color: context.colors.textSecondary,
          ),
        ),
        SizedBox(height: Dimensions.height10),
        TextField(
          controller: _notesController,
          maxLines: 3,
          style: TextStyle(fontSize: Dimensions.font16 * 0.85),
          decoration: InputDecoration(
            hintText: 'Enter your notes',
            hintStyle: TextStyle(color: context.colors.textTertiary),
            filled: true,
            fillColor: context.colors.surfaceLight,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius15),
              borderSide: BorderSide(color: Appcolors.primary),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius15),
              borderSide: BorderSide(color: Appcolors.primary),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius15),
              borderSide: BorderSide(color: Appcolors.primary, width: 1.5),
            ),
          ),
        ),

        SizedBox(height: Dimensions.height20),
        Divider(color: context.colors.border),
        SizedBox(height: Dimensions.height15),

        // Report Layout
        Text(
          'Report Layout',
          style: TextStyle(
            fontSize: Dimensions.font16,
            fontWeight: FontWeight.w700,
            color: context.colors.textPrimary,
          ),
        ),
        SizedBox(height: Dimensions.height15),
        _label('Table Density'),
        _buildLayoutDropdown(
          value: _tableDensity,
          items: ['Classic', 'Compact', 'Comfortable'],
          onChanged: (v) => setState(() => _tableDensity = v!),
        ),

        SizedBox(height: Dimensions.height15),
        _checkboxTile(
          'Re-size the table and its font automatically to fit the content within the table.',
          _autoResize,
          (v) => setState(() => _autoResize = v!),
        ),

        SizedBox(height: Dimensions.height20),

        // Paper Size
        _label('Paper Size'),
        _buildLayoutDropdown(
          value: _paperSize,
          items: ['A4', 'Letter', 'Legal'],
          onChanged: (v) => setState(() => _paperSize = v!),
        ),

        SizedBox(height: Dimensions.height15),

        // Orientation
        _label('Orientation'),
        Row(
          children: [
            _orientationRadio('Portrait'),
            SizedBox(width: Dimensions.width20),
            _orientationRadio('Landscape'),
          ],
        ),

        SizedBox(height: Dimensions.height20),

        // Margins
        _label('Margins'),
        _marginField('Top', _marginTop, (v) {
          setState(() => _marginTop = double.tryParse(v) ?? _marginTop);
        }),
        SizedBox(height: Dimensions.height10),
        _marginField('Bottom', _marginBottom, (v) {
          setState(() => _marginBottom = double.tryParse(v) ?? _marginBottom);
        }),
        SizedBox(height: Dimensions.height10),
        _marginField('Left', _marginLeft, (v) {
          setState(() => _marginLeft = double.tryParse(v) ?? _marginLeft);
        }),
        SizedBox(height: Dimensions.height10),
        _marginField('Right', _marginRight, (v) {
          setState(() => _marginRight = double.tryParse(v) ?? _marginRight);
        }),

        SizedBox(height: Dimensions.height20),

        // Preview
        _buildPreview(),

        SizedBox(height: Dimensions.height15),

        // Note
        Container(
          padding: EdgeInsets.all(Dimensions.width15),
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: Appcolors.warning, width: 3),
            ),
          ),
          child: Text(
            'Note: The details you select above will be displayed only for this export.',
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.8,
              color: context.colors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPreview() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Dimensions.width15),
      decoration: BoxDecoration(
        color: context.colors.surfaceLight,
        borderRadius: BorderRadius.circular(Dimensions.radius15),
      ),
      child: Column(
        children: [
          Text(
            'PREVIEW',
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.75,
              fontWeight: FontWeight.w700,
              color: context.colors.textSecondary,
              letterSpacing: 1,
            ),
          ),
          SizedBox(height: Dimensions.height10),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(Dimensions.width20),
            decoration: BoxDecoration(
              color: context.colors.card,
              borderRadius: BorderRadius.circular(Dimensions.radius15),
              border: Border.all(color: context.colors.border),
            ),
            child: Column(
              children: [
                if (_organizationName)
                  Text(
                    'Own Store',
                    style: TextStyle(
                      fontSize: Dimensions.font16 * 0.8,
                      color: context.colors.textSecondary,
                    ),
                  ),
                if (_reportBasis) ...[
                  SizedBox(height: Dimensions.height10 / 2),
                  Text(
                    'Basis: ${widget.reportBasis}',
                    style: TextStyle(
                      fontSize: Dimensions.font16,
                      fontWeight: FontWeight.w700,
                      color: context.colors.textPrimary,
                    ),
                  ),
                ],
                SizedBox(height: Dimensions.height15),
                // Mock lines
                for (int i = 0; i < 6; i++) ...[
                  Container(
                    width: double.infinity,
                    height: 1,
                    margin: EdgeInsets.only(bottom: Dimensions.height10),
                    color: context.colors.border,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: Dimensions.height10 / 2),
      child: Text(
        text,
        style: TextStyle(
          fontSize: Dimensions.font16 * 0.85,
          fontWeight: FontWeight.w600,
          color: context.colors.textPrimary,
        ),
      ),
    );
  }

  Widget _textField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      style: TextStyle(fontSize: Dimensions.font16 * 0.85),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: context.colors.textTertiary),
        filled: true,
        fillColor: context.colors.surfaceLight,
        contentPadding: EdgeInsets.symmetric(
          horizontal: Dimensions.width15,
          vertical: Dimensions.height10,
        ),
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
          borderSide: BorderSide(color: Appcolors.primary, width: 1.5),
        ),
      ),
    );
  }

  Widget _checkboxTile(
    String label,
    bool value,
    ValueChanged<bool?> onChanged,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: Dimensions.height10 / 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 24,
            height: 24,
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
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
    );
  }

  Widget _radioTile(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: Dimensions.height10 / 2),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: Radio<String>(
              value: value,
              groupValue: _language,
              onChanged: (v) => setState(() => _language = v!),
              activeColor: Appcolors.primary,
            ),
          ),
          SizedBox(width: Dimensions.width10),
          Text(
            label,
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.85,
              color: context.colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _orientationRadio(String value) {
    return Row(
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Radio<String>(
            value: value,
            groupValue: _orientation,
            onChanged: (v) => setState(() => _orientation = v!),
            activeColor: Appcolors.primary,
          ),
        ),
        SizedBox(width: Dimensions.width10 / 2),
        Text(
          value,
          style: TextStyle(
            fontSize: Dimensions.font16 * 0.85,
            color: context.colors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildLayoutDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.width15),
      decoration: BoxDecoration(
        border: Border.all(color: context.colors.border),
        borderRadius: BorderRadius.circular(Dimensions.radius15),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: context.colors.textSecondary,
          ),
          style: TextStyle(
            fontSize: Dimensions.font16 * 0.85,
            color: context.colors.textPrimary,
          ),
          dropdownColor: context.colors.card,
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _marginField(
    String label,
    double value,
    ValueChanged<String> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: Dimensions.font16 * 0.75,
            color: context.colors.textSecondary,
          ),
        ),
        SizedBox(height: Dimensions.height10 / 3),
        TextField(
          controller: TextEditingController(text: value.toString()),
          keyboardType: TextInputType.number,
          onChanged: onChanged,
          style: TextStyle(fontSize: Dimensions.font16 * 0.85),
          decoration: InputDecoration(
            filled: true,
            fillColor: context.colors.surfaceLight,
            contentPadding: EdgeInsets.symmetric(
              horizontal: Dimensions.width15,
              vertical: Dimensions.height10,
            ),
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
              borderSide: BorderSide(color: Appcolors.primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
