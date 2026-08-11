import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/features/settings/views/templates/customize_template_page.dart';
import 'package:flutter/material.dart';

class TemplateDetailPage extends StatefulWidget {
  final String title;
  final String templateType;

  const TemplateDetailPage({
    super.key,
    required this.title,
    required this.templateType,
  });

  @override
  State<TemplateDetailPage> createState() => _TemplateDetailPageState();
}

class _TemplateDetailPageState extends State<TemplateDetailPage> {
  int _selectedTemplateIndex = 0;

  @override
  void initState() {
    super.initState();
    appLog(
      '📄 TemplateDetailPage initialized: ${widget.title}',
      name: 'TemplateDetail',
    );
  }

  String _getTemplateTitle() {
    switch (widget.templateType) {
      case 'invoices':
        return 'INVOICE';
      case 'quotes':
        return 'ESTIMATE';
      case 'sales_orders':
        return 'SALES ORDER';
      case 'purchase_orders':
        return 'PURCHASE ORDER';
      case 'credit_notes':
        return 'CREDIT NOTE';
      case 'delivery_challans':
        return 'Delivery Challan';
      default:
        return 'DOCUMENT';
    }
  }

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);

    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            CustomSliverAppBar(
              title: widget.title,
              leadingType: AppBarLeadingType.back,
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(Dimensions.width15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section Title
                    Text(
                      'Standard Template',
                      style: TextStyle(
                        fontSize: Dimensions.font16 * 1.1,
                        fontWeight: FontWeight.w700,
                        color: context.colors.textPrimary,
                      ),
                    ),
                    SizedBox(height: Dimensions.height15),

                    // Template Preview Card
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: context.colors.card,
                        borderRadius: BorderRadius.circular(
                          Dimensions.radius15,
                        ),
                        border: Border.all(color: context.colors.border),
                      ),
                      child: Column(
                        children: [
                          // Template Preview
                          Stack(
                            children: [
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(Dimensions.width20),
                                child: _buildTemplatePreview(),
                              ),
                              // DEFAULT badge
                              Positioned(
                                top: Dimensions.height10,
                                right: Dimensions.width15,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: Dimensions.width10,
                                    vertical: Dimensions.height10 * 0.4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Appcolors.warning,
                                    borderRadius: BorderRadius.circular(
                                      Dimensions.radius15 * 0.27,
                                    ),
                                  ),
                                  child: Text(
                                    'DEFAULT',
                                    style: TextStyle(
                                      fontSize: Dimensions.font16 * 0.65,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Customize Button
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: Dimensions.height20,
                            ),
                            child: OutlinedButton.icon(
                              onPressed: () {
                                appLog(
                                  '🎨 Customize template tapped',
                                  name: 'TemplateDetail',
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CustomizeTemplatePage(
                                      templateType: widget.templateType,
                                      templateName: 'Standard Template',
                                    ),
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.settings_outlined,
                                size: Dimensions.iconSize16,
                              ),
                              label: const Text('Customize'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Appcolors.primary,
                                side: const BorderSide(
                                  color: Appcolors.primary,
                                  width: 1.5,
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: Dimensions.width20,
                                  vertical: Dimensions.height10,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    Dimensions.radius30,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: Dimensions.height20),

                    // Choose Template Section
                    Text(
                      'Choose Template',
                      style: TextStyle(
                        fontSize: Dimensions.font16 * 1.1,
                        fontWeight: FontWeight.w700,
                        color: context.colors.textPrimary,
                      ),
                    ),
                    SizedBox(height: Dimensions.height15),

                    // Template Grid
                    Row(
                      children: [
                        // Add Template
                        _buildTemplateGridItem(isAdd: true, index: -1),
                        SizedBox(width: Dimensions.width15),
                        // Standard Template
                        _buildTemplateGridItem(
                          isAdd: false,
                          label: 'Standard',
                          index: 0,
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
    );
  }

  Widget _buildTemplatePreview() {
    const themeColor = Appcolors.primary;

    return Container(
      padding: EdgeInsets.all(Dimensions.width15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Dimensions.radius15 * 0.5),
        border: Border.all(color: const Color(0xFFEEF2F6)),
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
                        color: const Color(0xFF1A202C),
                      ),
                    ),
                    SizedBox(height: Dimensions.height10 * 0.3),
                    Text(
                      'Dubai\nUnited Arab Emirates\nTRN 100123456700003\n9967484826\nmisellaneous4825@gmail.com',
                      style: TextStyle(
                        fontSize: Dimensions.font16 * 0.52,
                        color: const Color(0xFF4A5568),
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
                      _getTemplateTitle(),
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
                        color: const Color(0xFF718096),
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
                        color: const Color(0xFF718096),
                      ),
                    ),
                    SizedBox(height: Dimensions.height10 * 0.2),
                    Text(
                      'Jack & Joe Trading\nBox No. 576\nDubai\n94588 Dubai\nEmirates',
                      style: TextStyle(
                        fontSize: Dimensions.font16 * 0.52,
                        color: const Color(0xFF2D3748),
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
                    _previewInfoRow('Invoice Date:', '11 Aug 2026'),
                    _previewInfoRow('Terms:', 'Due on Receipt'),
                    _previewInfoRow('Due Date:', '11 Aug 2026'),
                    _previewInfoRow('Order #:', 'SO-17'),
                  ],
                ),
              ),
            ],
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
                _previewHeaderCell('#', flex: 1),
                _previewHeaderCell('Item & Description', flex: 5),
                _previewHeaderCell('Qty', flex: 2),
                _previewHeaderCell('Rate', flex: 2),
                _previewHeaderCell('Tax', flex: 2),
                _previewHeaderCell('Amount', flex: 2),
              ],
            ),
          ),

          // Table Rows
          _previewItemRow(
            '1',
            'Brochure Design',
            '1.00',
            '300.00',
            '21.60',
            '356.30',
          ),
          _previewItemRow(
            '2',
            'Web Design Package',
            '1.00',
            '250.00',
            '11.75',
            '288.80',
          ),
          _previewItemRow(
            '3',
            'Print Ad - Basic',
            '1.00',
            '80.00',
            '19.00',
            '99.60',
          ),

          SizedBox(height: Dimensions.height10 * 0.5),
          Divider(color: Colors.grey.shade200, height: 1),
          SizedBox(height: Dimensions.height10 * 0.5),

          // Summary totals
          _previewSummaryRow('Total', 'AED 642.75', isBold: true),
          _previewSummaryRow(
            'Payment Retention',
            '(-) 18.00',
            valueColor: themeColor,
          ),
          _previewSummaryRow(
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
                    color: const Color(0xFF1A202C),
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

          // Notes
          Text(
            'Notes',
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.58,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A202C),
            ),
          ),
          SizedBox(height: Dimensions.height10 * 0.2),
          Text(
            'Thanks for your business.',
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.5,
              fontStyle: FontStyle.italic,
              color: const Color(0xFF4A5568),
            ),
          ),
          SizedBox(height: Dimensions.height10),

          // Terms & Conditions
          Text(
            'Terms & Conditions',
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.58,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A202C),
            ),
          ),
          SizedBox(height: Dimensions.height10 * 0.2),
          Text(
            'Your company\'s Terms and Conditions will be displayed here.',
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.48,
              color: const Color(0xFF4A5568),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _previewInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: Dimensions.height10 * 0.25),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label ',
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.48,
              color: const Color(0xFF718096),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.48,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF2D3748),
            ),
          ),
        ],
      ),
    );
  }

  Widget _previewHeaderCell(String text, {required int flex}) {
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

  Widget _previewItemRow(
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
          _previewCell(index, flex: 1),
          Expanded(
            flex: 5,
            child: Text(
              item,
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.43,
                color: const Color(0xFF2D3748),
                height: 1.4,
              ),
            ),
          ),
          _previewCell(qty, flex: 2),
          _previewCell(rate, flex: 2),
          _previewCell(tax, flex: 2),
          _previewCell(amount, flex: 2),
        ],
      ),
    );
  }

  Widget _previewCell(String text, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: TextStyle(
          fontSize: Dimensions.font16 * 0.43,
          color: const Color(0xFF2D3748),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _previewSummaryRow(
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
              color: const Color(0xFF4A5568),
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
                color: valueColor ?? const Color(0xFF1A202C),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemplateGridItem({
    required bool isAdd,
    required int index,
    String? label,
  }) {
    final isSelected = !isAdd && index == _selectedTemplateIndex;

    return GestureDetector(
      onTap: () {
        if (isAdd) {
          appLog('➕ Add template tapped', name: 'TemplateDetail');
        } else {
          setState(() => _selectedTemplateIndex = index);
        }
      },
      child: Column(
        children: [
          Container(
            width: Dimensions.height45 * 2,
            height: Dimensions.height45 * 2.5,
            decoration: BoxDecoration(
              color: isAdd ? context.colors.surfaceLight : context.colors.card,
              borderRadius: BorderRadius.circular(Dimensions.radius15),
              border: Border.all(
                color: isSelected ? Appcolors.primary : context.colors.border,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: isAdd
                ? Icon(
                    Icons.add,
                    size: Dimensions.iconSize24 * 1.5,
                    color: context.colors.textSecondary,
                  )
                : Stack(
                    children: [
                      Center(
                        child: Icon(
                          Icons.description_outlined,
                          size: Dimensions.iconSize24,
                          color: context.colors.textTertiary,
                        ),
                      ),
                      if (isSelected)
                        Positioned(
                          bottom: Dimensions.height10 * 0.4,
                          right: Dimensions.width10 * 0.4,
                          child: Container(
                            width: Dimensions.iconSize20,
                            height: Dimensions.iconSize20,
                            decoration: const BoxDecoration(
                              color: Appcolors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                              size: Dimensions.iconSize16 * 0.875,
                            ),
                          ),
                        ),
                    ],
                  ),
          ),
          SizedBox(height: Dimensions.height10 / 2),
          Text(
            isAdd ? 'Add' : (label ?? 'Template'),
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.75,
              color: context.colors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
