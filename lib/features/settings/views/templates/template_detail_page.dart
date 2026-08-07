import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
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
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Appcolors.warning,
                                    borderRadius: BorderRadius.circular(4),
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
    return Container(
      padding: EdgeInsets.all(Dimensions.width15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Dimensions.radius15 / 2),
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Company Logo placeholder
              Container(
                width: Dimensions.height45,
                height: Dimensions.height45,
                decoration: BoxDecoration(
                  color: Appcolors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(Dimensions.radius15 / 2),
                ),
                child: Icon(
                  Icons.business,
                  color: Appcolors.primary,
                  size: Dimensions.iconSize24,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _getTemplateTitle(),
                    style: TextStyle(
                      fontSize: Dimensions.font16 * 0.9,
                      fontWeight: FontWeight.w800,
                      color: Appcolors.primary,
                    ),
                  ),
                  Text(
                    '#DOC-001',
                    style: TextStyle(
                      fontSize: Dimensions.font16 * 0.6,
                      color: context.colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: Dimensions.height15),

          // Separator
          Divider(color: context.colors.border),
          SizedBox(height: Dimensions.height10),

          // Billing Info
          Text(
            'Bill To:',
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.6,
              color: context.colors.textTertiary,
            ),
          ),
          Text(
            'Customer Name',
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.7,
              fontWeight: FontWeight.w600,
              color: context.colors.textPrimary,
            ),
          ),
          SizedBox(height: Dimensions.height10),

          // Table Header
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.width10,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: Appcolors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'Item',
                    style: TextStyle(
                      fontSize: Dimensions.font16 * 0.55,
                      fontWeight: FontWeight.w600,
                      color: Appcolors.primary,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Qty',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: Dimensions.font16 * 0.55,
                      fontWeight: FontWeight.w600,
                      color: Appcolors.primary,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Rate',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: Dimensions.font16 * 0.55,
                      fontWeight: FontWeight.w600,
                      color: Appcolors.primary,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Amount',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: Dimensions.font16 * 0.55,
                      fontWeight: FontWeight.w600,
                      color: Appcolors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Table Row
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.width10,
              vertical: 6,
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'Sample Item',
                    style: TextStyle(
                      fontSize: Dimensions.font16 * 0.55,
                      color: context.colors.textPrimary,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    '1.00',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: Dimensions.font16 * 0.55,
                      color: context.colors.textPrimary,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    '300.00',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: Dimensions.font16 * 0.55,
                      color: context.colors.textPrimary,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    '300.00',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: Dimensions.font16 * 0.55,
                      color: context.colors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Divider(color: context.colors.border),

          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Total   ',
                style: TextStyle(
                  fontSize: Dimensions.font16 * 0.6,
                  fontWeight: FontWeight.w600,
                  color: context.colors.textPrimary,
                ),
              ),
              Text(
                'Rs.630.00',
                style: TextStyle(
                  fontSize: Dimensions.font16 * 0.6,
                  fontWeight: FontWeight.w700,
                  color: Appcolors.primary,
                ),
              ),
            ],
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
                          bottom: 4,
                          right: 4,
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: const BoxDecoration(
                              color: Appcolors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 14,
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
