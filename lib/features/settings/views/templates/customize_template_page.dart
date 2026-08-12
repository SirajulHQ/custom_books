import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/features/settings/views/templates/template_preview_colors.dart';
import 'package:flutter/material.dart';

class CustomizeTemplatePage extends StatefulWidget {
  final String templateType;
  final String templateName;

  const CustomizeTemplatePage({
    super.key,
    required this.templateType,
    this.templateName = 'Standard Template',
  });

  @override
  State<CustomizeTemplatePage> createState() => _CustomizeTemplatePageState();
}

class _CustomizeTemplatePageState extends State<CustomizeTemplatePage> {
  late String _templateName;
  int _selectedThemeIndex = 0;
  String? _bankDetails;
  String? _signatureLabel;

  final List<Color> _themeColors = [
    const Color(0xFF0D47A1), // Blue
    const Color(0xFF2E7D32), // Green
    const Color(0xFF212121), // Black
    const Color(0xFFC62828), // Red
    const Color(0xFF6A1B9A), // Purple
    const Color(0xFFE65100), // Orange
  ];

  @override
  void initState() {
    super.initState();
    _templateName = widget.templateName;
    appLog(
      '🎨 CustomizeTemplatePage initialized: ${widget.templateType}',
      name: 'CustomizeTemplate',
    );
  }

  Color get _activeThemeColor => _themeColors[_selectedThemeIndex];

  String _getDocumentTitle() {
    switch (widget.templateType) {
      case 'invoices':
        return 'TAX INVOICE';
      case 'quotes':
        return 'ESTIMATE';
      case 'sales_orders':
        return 'SALES ORDER';
      case 'purchase_orders':
        return 'PURCHASE ORDER';
      case 'credit_notes':
        return 'CREDIT NOTE';
      case 'delivery_challans':
        return 'DELIVERY CHALLAN';
      default:
        return 'DOCUMENT';
    }
  }

  void _editTemplateName() {
    final controller = TextEditingController(text: _templateName);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Template Name'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Enter template name',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                setState(() => _templateName = controller.text.trim());
              }
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _addBankDetails() {
    final bankNameCtrl = TextEditingController();
    final accountCtrl = TextEditingController();
    final ifscCtrl = TextEditingController();
    final branchCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Dimensions.radius20),
        ),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: Dimensions.width20,
          right: Dimensions.width20,
          top: Dimensions.height20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + Dimensions.height20,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: Dimensions.width30 * 1.5,
                  height: 4,
                  margin: EdgeInsets.only(bottom: Dimensions.height15),
                  decoration: BoxDecoration(
                    color: context.colors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                'Add Bank Details',
                style: TextStyle(
                  fontSize: Dimensions.font20,
                  fontWeight: FontWeight.w700,
                  color: context.colors.textPrimary,
                ),
              ),
              SizedBox(height: Dimensions.height20),
              _buildTextField(bankNameCtrl, 'Bank Name'),
              SizedBox(height: Dimensions.height15),
              _buildTextField(accountCtrl, 'Account Number'),
              SizedBox(height: Dimensions.height15),
              _buildTextField(ifscCtrl, 'IFSC / SWIFT Code'),
              SizedBox(height: Dimensions.height15),
              _buildTextField(branchCtrl, 'Branch'),
              SizedBox(height: Dimensions.height20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    setState(() {
                      _bankDetails =
                          '${bankNameCtrl.text} - ${accountCtrl.text}';
                    });
                    Navigator.pop(ctx);
                    appLog('🏦 Bank details added', name: 'CustomizeTemplate');
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: Appcolors.primary,
                    padding: EdgeInsets.symmetric(
                      vertical: Dimensions.height15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Dimensions.radius15),
                    ),
                  ),
                  child: const Text('Save Bank Details'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _editSignature() {
    final signatureCtrl = TextEditingController(text: _signatureLabel ?? '');
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Dimensions.radius20),
        ),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: Dimensions.width20,
          right: Dimensions.width20,
          top: Dimensions.height20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + Dimensions.height20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: Dimensions.width30 * 1.5,
                height: 4,
                margin: EdgeInsets.only(bottom: Dimensions.height15),
                decoration: BoxDecoration(
                  color: context.colors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(
              'Edit Signature',
              style: TextStyle(
                fontSize: Dimensions.font20,
                fontWeight: FontWeight.w700,
                color: context.colors.textPrimary,
              ),
            ),
            SizedBox(height: Dimensions.height20),
            _buildTextField(signatureCtrl, 'Authorized Signatory Name'),
            SizedBox(height: Dimensions.height15),
            Text(
              'Signature will appear at the bottom of the PDF',
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.8,
                color: context.colors.textTertiary,
              ),
            ),
            SizedBox(height: Dimensions.height20),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  setState(() {
                    _signatureLabel = signatureCtrl.text.trim().isEmpty
                        ? null
                        : signatureCtrl.text.trim();
                  });
                  Navigator.pop(ctx);
                  appLog('✍️ Signature updated', name: 'CustomizeTemplate');
                },
                style: FilledButton.styleFrom(
                  backgroundColor: Appcolors.primary,
                  padding: EdgeInsets.symmetric(vertical: Dimensions.height15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Dimensions.radius15),
                  ),
                ),
                child: const Text('Save Signature'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimensions.radius15),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimensions.radius15),
          borderSide: const BorderSide(color: Appcolors.primary, width: 1.5),
        ),
      ),
    );
  }

  void _saveTemplate() {
    appLog(
      '💾 Save template: $_templateName, theme: $_selectedThemeIndex',
      name: 'CustomizeTemplate',
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Template saved successfully'),
        backgroundColor: Appcolors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radius15),
        ),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);

    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  const CustomSliverAppBar(
                    title: 'Customize Template',
                    leadingType: AppBarLeadingType.back,
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.width20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header Card with Template Name & Theme
                          _buildHeaderCard(),
                          SizedBox(height: Dimensions.height20),
                          // PDF Preview
                          _buildPdfPreview(),
                          SizedBox(height: Dimensions.height20),
                          // Action Buttons
                          _buildActionButtons(),
                          SizedBox(height: Dimensions.height30),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Bottom bar with Save button
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        Dimensions.width20,
        Dimensions.height15,
        Dimensions.width20,
        Dimensions.height15,
      ),
      decoration: BoxDecoration(
        color: context.colors.card,
        border: Border(
          top: BorderSide(color: context.colors.border, width: 0.5),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        height: Dimensions.height52,
        child: FilledButton(
          onPressed: _saveTemplate,
          style: FilledButton.styleFrom(
            backgroundColor: Appcolors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius15),
            ),
          ),
          child: Text(
            'Save Template',
            style: TextStyle(
              fontSize: Dimensions.font16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: EdgeInsets.all(Dimensions.width15),
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: BorderRadius.circular(Dimensions.radius15),
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Template name row
          Row(
            children: [
              Icon(
                Icons.description_outlined,
                size: Dimensions.iconSize20,
                color: Appcolors.primary,
              ),
              SizedBox(width: Dimensions.width10 * 0.8),
              Text(
                'Template',
                style: TextStyle(
                  fontSize: Dimensions.font16 * 0.8,
                  color: context.colors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: Dimensions.height10 * 0.6),
          // Template name with edit button
          GestureDetector(
            onTap: _editTemplateName,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _templateName,
                    style: TextStyle(
                      fontSize: Dimensions.font16 * 1.15,
                      fontWeight: FontWeight.w700,
                      color: context.colors.textPrimary,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(Dimensions.width10 * 0.6),
                  decoration: BoxDecoration(
                    color: Appcolors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(
                      Dimensions.radius15 * 0.5,
                    ),
                  ),
                  child: Icon(
                    Icons.edit_outlined,
                    size: Dimensions.iconSize16,
                    color: Appcolors.primary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: Dimensions.height15),
          // Divider
          Divider(color: context.colors.border, height: 1),
          SizedBox(height: Dimensions.height15),
          // Theme section
          Row(
            children: [
              Icon(
                Icons.palette_outlined,
                size: Dimensions.iconSize20,
                color: Appcolors.primary,
              ),
              SizedBox(width: Dimensions.width10 * 0.8),
              Text(
                'Theme',
                style: TextStyle(
                  fontSize: Dimensions.font16 * 0.8,
                  color: context.colors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: Dimensions.height10),
          // Theme color circles
          Row(
            children: List.generate(_themeColors.length, (index) {
              final isSelected = index == _selectedThemeIndex;
              final size = Dimensions.height30;
              return GestureDetector(
                onTap: () {
                  setState(() => _selectedThemeIndex = index);
                  appLog(
                    '🎨 Theme color changed: $index',
                    name: 'CustomizeTemplate',
                  );
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: EdgeInsets.only(
                    right: index < _themeColors.length - 1
                        ? Dimensions.width10
                        : 0,
                  ),
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    color: _themeColors[index],
                    shape: BoxShape.circle,
                    border: isSelected
                        ? Border.all(color: context.colors.background, width: 3)
                        : null,
                    boxShadow: [
                      if (isSelected)
                        BoxShadow(
                          color: _themeColors[index].withValues(alpha: 0.5),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: isSelected
                      ? Icon(
                          Icons.check,
                          size: Dimensions.iconSize16 * 0.9,
                          color: Colors.white,
                        )
                      : null,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildPdfPreview() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: BorderRadius.circular(Dimensions.radius15),
        border: Border.all(color: context.colors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Dimensions.radius15),
        child: Column(
          children: [
            // Preview label
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.width15,
                vertical: Dimensions.height10 * 0.8,
              ),
              decoration: BoxDecoration(
                color: _activeThemeColor.withValues(alpha: 0.06),
                border: Border(
                  bottom: BorderSide(color: context.colors.border, width: 0.5),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.visibility_outlined,
                    size: Dimensions.iconSize16,
                    color: _activeThemeColor,
                  ),
                  SizedBox(width: Dimensions.width10 * 0.6),
                  Text(
                    'Preview',
                    style: TextStyle(
                      fontSize: Dimensions.font16 * 0.78,
                      fontWeight: FontWeight.w600,
                      color: _activeThemeColor,
                    ),
                  ),
                ],
              ),
            ),
            // Invoice content
            Padding(
              padding: EdgeInsets.all(Dimensions.width10),
              child: _buildInvoiceContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInvoiceContent() {
    final themeColor = _activeThemeColor;

    return Container(
      padding: EdgeInsets.all(Dimensions.width15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Dimensions.radius15 * 0.5),
        border: Border.all(color: TemplatePreviewColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Company header
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Company',
                      style: TextStyle(
                        fontSize: Dimensions.font16 * 0.72,
                        fontWeight: FontWeight.w700,
                        color: TemplatePreviewColors.heading,
                      ),
                    ),
                    SizedBox(height: Dimensions.height10 * 0.3),
                    Text(
                      'Dubai\nUnited Arab Emirates\nTRN 100123456700003\n9967484826\nmisellaneous4825@gmail.com',
                      style: TextStyle(
                        fontSize: Dimensions.font16 * 0.52,
                        color: TemplatePreviewColors.body,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _getDocumentTitle(),
                      style: TextStyle(
                        fontSize: Dimensions.font16 * 0.85,
                        fontWeight: FontWeight.w800,
                        color: themeColor,
                      ),
                    ),
                    SizedBox(height: Dimensions.height10 * 0.2),
                    Text(
                      '# INV-17',
                      style: TextStyle(
                        fontSize: Dimensions.font16 * 0.55,
                        color: TemplatePreviewColors.label,
                      ),
                    ),
                    SizedBox(height: Dimensions.height10 * 0.3),
                    Text(
                      'AED562.75',
                      style: TextStyle(
                        fontSize: Dimensions.font16 * 0.62,
                        fontWeight: FontWeight.w700,
                        color: themeColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: Dimensions.height15),

          // Bill To & Invoice Info
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bill To',
                      style: TextStyle(
                        fontSize: Dimensions.font16 * 0.5,
                        fontWeight: FontWeight.w600,
                        color: TemplatePreviewColors.label,
                      ),
                    ),
                    SizedBox(height: Dimensions.height10 * 0.2),
                    Text(
                      'Jack & Joe Trading\nBox No. 576\nDubai\n94588 Dubai\nEmirates',
                      style: TextStyle(
                        fontSize: Dimensions.font16 * 0.52,
                        color: TemplatePreviewColors.medium,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildInfoRow('Invoice Date:', '11 Aug 2026'),
                    _buildInfoRow('Terms:', 'Due on Receipt'),
                    _buildInfoRow('Due Date:', '11 Aug 2026'),
                    _buildInfoRow('Order #:', 'SO-17'),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: Dimensions.height10),

          // Subject
          Text(
            'Subject:',
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.5,
              fontWeight: FontWeight.w600,
              color: TemplatePreviewColors.label,
            ),
          ),
          Text(
            'Description',
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.5,
              color: TemplatePreviewColors.body,
            ),
          ),
          SizedBox(height: Dimensions.height10),

          // Table Header
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.width10 * 0.5,
              vertical: Dimensions.height10 * 0.5,
            ),
            decoration: BoxDecoration(
              color: themeColor,
              borderRadius: BorderRadius.circular(3),
            ),
            child: Row(
              children: [
                _tableHeaderCell('#', flex: 1),
                _tableHeaderCell('Item & Description', flex: 5),
                _tableHeaderCell('Qty', flex: 2),
                _tableHeaderCell('Rate', flex: 2),
                _tableHeaderCell('Tax', flex: 2),
                _tableHeaderCell('Amount', flex: 2),
              ],
            ),
          ),

          // Table Rows
          _buildItemRow(
            '1',
            'Brochure Design\nElectronic Design (Layout + Color)',
            '1.00',
            '300.00',
            '21.60',
            '356.30',
          ),
          _buildItemRow(
            '2',
            'Web Design Package/Template - Basic\nEstimate Theme...',
            '1.00',
            '250.00',
            '11.75',
            '288.80',
          ),
          _buildItemRow(
            '3',
            'Print Ad - Basic - Color\nPrint Ad 1/4 page Color',
            '1.00',
            '80.00',
            '19.00',
            '99.60',
          ),

          SizedBox(height: Dimensions.height10 * 0.5),
          Divider(color: Colors.grey.shade200, height: 1),
          SizedBox(height: Dimensions.height10 * 0.5),

          // Totals section
          _buildTotalLine('Sub Total', '0.00', '630.00', '52.75', '756.60'),
          SizedBox(height: Dimensions.height10 * 0.3),
          Divider(color: Colors.grey.shade200, height: 1),
          SizedBox(height: Dimensions.height10 * 0.5),

          // Summary totals
          _buildSummaryRow('Total', 'AED 642.75', isBold: true),
          _buildSummaryRow(
            'Payment Retention',
            '(-) 18.00',
            valueColor: themeColor,
          ),
          _buildSummaryRow(
            'Payment Made',
            '(-) 100.00',
            valueColor: Appcolors.warn,
          ),
          SizedBox(height: Dimensions.height10 * 0.3),
          // Balance Due highlighted
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.width10 * 0.8,
              vertical: Dimensions.height10 * 0.5,
            ),
            decoration: BoxDecoration(
              color: themeColor.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(3),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Balance Due',
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.55,
                    fontWeight: FontWeight.w700,
                    color: TemplatePreviewColors.heading,
                  ),
                ),
                Text(
                  'AED 62.75',
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.55,
                    fontWeight: FontWeight.w700,
                    color: themeColor,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: Dimensions.height15),

          // Tax Summary section
          Text(
            'Tax Summary',
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.58,
              fontWeight: FontWeight.w700,
              color: TemplatePreviewColors.heading,
            ),
          ),
          SizedBox(height: Dimensions.height10 * 0.5),
          // Tax table header
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.width10 * 0.5,
              vertical: Dimensions.height10 * 0.35,
            ),
            decoration: BoxDecoration(
              color: themeColor.withValues(alpha: 0.07),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'Tax Details',
                    style: TextStyle(
                      fontSize: Dimensions.font16 * 0.48,
                      fontWeight: FontWeight.w600,
                      color: themeColor,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Taxable Amount (AED)',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: Dimensions.font16 * 0.48,
                      fontWeight: FontWeight.w600,
                      color: themeColor,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Tax Amount (AED)',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: Dimensions.font16 * 0.48,
                      fontWeight: FontWeight.w600,
                      color: themeColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          _buildTaxRow('Sample Tax1 (4.10%)', '516.00', '21.80'),
          _buildTaxRow('Sample Tax2 (3.00%)', '390.00', '11.75'),
          Divider(color: Colors.grey.shade200, height: 1),
          _buildTaxRow('Total', 'AED906.00', 'AED 32.75', isBold: true),
          SizedBox(height: Dimensions.height15),

          // Notes
          Text(
            'Notes',
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.58,
              fontWeight: FontWeight.w700,
              color: TemplatePreviewColors.heading,
            ),
          ),
          SizedBox(height: Dimensions.height10 * 0.2),
          Text(
            'Thanks for your business.',
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.5,
              fontStyle: FontStyle.italic,
              color: TemplatePreviewColors.body,
            ),
          ),
          SizedBox(height: Dimensions.height10),

          // Terms & Conditions
          Text(
            'Terms & Conditions',
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.58,
              fontWeight: FontWeight.w700,
              color: TemplatePreviewColors.heading,
            ),
          ),
          SizedBox(height: Dimensions.height10 * 0.2),
          Text(
            'Your company\'s Terms and Conditions will be displayed here. You can edit in the more "settings page under settings".',
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.48,
              color: TemplatePreviewColors.body,
              height: 1.4,
            ),
          ),
          SizedBox(height: Dimensions.height15),

          // Bank Details (if added)
          if (_bankDetails != null) ...[
            Divider(color: Colors.grey.shade200, height: 1),
            SizedBox(height: Dimensions.height10 * 0.8),
            Text(
              'Bank Details',
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.58,
                fontWeight: FontWeight.w700,
                color: TemplatePreviewColors.heading,
              ),
            ),
            SizedBox(height: Dimensions.height10 * 0.2),
            Text(
              _bankDetails!,
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.5,
                color: TemplatePreviewColors.body,
              ),
            ),
            SizedBox(height: Dimensions.height10),
          ],

          // Signature (if added)
          if (_signatureLabel != null) ...[
            Divider(color: Colors.grey.shade200, height: 1),
            SizedBox(height: Dimensions.height10 * 0.8),
            Align(
              alignment: Alignment.centerRight,
              child: Column(
                children: [
                  // Signature line
                  Container(
                    width: Dimensions.height45 * 2.2,
                    height: 1,
                    color: TemplatePreviewColors.divider,
                    margin: EdgeInsets.only(bottom: Dimensions.height10 * 0.5),
                  ),
                  Text(
                    _signatureLabel!,
                    style: TextStyle(
                      fontSize: Dimensions.font16 * 0.52,
                      fontWeight: FontWeight.w500,
                      color: TemplatePreviewColors.medium,
                    ),
                  ),
                  Text(
                    'Authorized Signatory',
                    style: TextStyle(
                      fontSize: Dimensions.font16 * 0.45,
                      color: TemplatePreviewColors.label,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ─── Helper Widgets ──────────────────────────────────────────────────────

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: Dimensions.height10 * 0.25),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label ',
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.48,
              color: TemplatePreviewColors.label,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.48,
              fontWeight: FontWeight.w500,
              color: TemplatePreviewColors.medium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tableHeaderCell(String text, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: TextStyle(
          fontSize: Dimensions.font16 * 0.43,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildItemRow(
    String index,
    String item,
    String qty,
    String rate,
    String tax,
    String amount,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.width10 * 0.5,
        vertical: Dimensions.height10 * 0.5,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade100, width: 0.5),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _tableCell(index, flex: 1),
          Expanded(
            flex: 5,
            child: Text(
              item,
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.43,
                color: TemplatePreviewColors.medium,
                height: 1.4,
              ),
            ),
          ),
          _tableCell(qty, flex: 2),
          _tableCell(rate, flex: 2),
          _tableCell(tax, flex: 2),
          _tableCell(amount, flex: 2),
        ],
      ),
    );
  }

  Widget _tableCell(String text, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: TextStyle(
          fontSize: Dimensions.font16 * 0.43,
          color: TemplatePreviewColors.medium,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildTotalLine(
    String label,
    String discount,
    String taxable,
    String tax,
    String amount,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.width10 * 0.5,
        vertical: Dimensions.height10 * 0.3,
      ),
      child: Row(
        children: [
          const Spacer(flex: 6),
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.45,
                fontWeight: FontWeight.w600,
                color: TemplatePreviewColors.body,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          _tableCell(discount, flex: 2),
          _tableCell(taxable, flex: 2),
          _tableCell(tax, flex: 2),
          _tableCell(amount, flex: 2),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    bool isBold = false,
    Color? valueColor,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Dimensions.height10 * 0.2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.52,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
              color: TemplatePreviewColors.body,
            ),
          ),
          SizedBox(width: Dimensions.width20),
          SizedBox(
            width: Dimensions.width30 * 3,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.52,
                fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
                color: valueColor ?? TemplatePreviewColors.heading,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaxRow(
    String label,
    String taxable,
    String taxAmount, {
    bool isBold = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.width10 * 0.5,
        vertical: Dimensions.height10 * 0.3,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.48,
                fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
                color: TemplatePreviewColors.medium,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              taxable,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.48,
                fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
                color: TemplatePreviewColors.medium,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              taxAmount,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.48,
                fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
                color: TemplatePreviewColors.medium,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: _buildActionChip(
            icon: Icons.account_balance_outlined,
            label: 'Add Bank Details',
            onTap: _addBankDetails,
          ),
        ),
        SizedBox(width: Dimensions.width15),
        Expanded(
          child: _buildActionChip(
            icon: Icons.draw_outlined,
            label: 'Edit Signature',
            onTap: _editSignature,
          ),
        ),
      ],
    );
  }

  Widget _buildActionChip({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: context.colors.card,
      borderRadius: BorderRadius.circular(Dimensions.radius15),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Dimensions.radius15),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.width15,
            vertical: Dimensions.height15,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radius15),
            border: Border.all(color: context.colors.border),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: Dimensions.height30,
                height: Dimensions.height30,
                decoration: BoxDecoration(
                  color: Appcolors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: Dimensions.iconSize16,
                  color: Appcolors.primary,
                ),
              ),
              SizedBox(width: Dimensions.width10 * 0.8),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.82,
                    fontWeight: FontWeight.w600,
                    color: context.colors.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
