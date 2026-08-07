import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/features/settings/views/templates/template_detail_page.dart';
import 'package:flutter/material.dart';

class TemplatesPage extends StatefulWidget {
  const TemplatesPage({super.key});

  @override
  State<TemplatesPage> createState() => _TemplatesPageState();
}

class _TemplatesPageState extends State<TemplatesPage> {
  final List<_TemplateCategory> _categories = [
    _TemplateCategory(label: 'Invoices', type: 'invoices'),
    _TemplateCategory(label: 'Quotes', type: 'quotes'),
    _TemplateCategory(label: 'Sales Orders', type: 'sales_orders'),
    _TemplateCategory(label: 'Purchase Orders', type: 'purchase_orders'),
    _TemplateCategory(label: 'Credit Notes', type: 'credit_notes'),
    _TemplateCategory(label: 'Delivery Challans', type: 'delivery_challans'),
  ];

  @override
  void initState() {
    super.initState();
    appLog('📄 TemplatesPage initialized', name: 'Templates');
  }

  void _navigateTo(_TemplateCategory category) {
    appLog('📂 Template "${category.label}" tapped', name: 'Templates');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TemplateDetailPage(
          title: '${category.label} Template',
          templateType: category.type,
        ),
      ),
    );
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
            const CustomSliverAppBar(
              title: 'Templates',
              leadingType: AppBarLeadingType.back,
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final category = _categories[index];
                return Column(
                  children: [
                    InkWell(
                      onTap: () => _navigateTo(category),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.width20,
                          vertical: Dimensions.height20,
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            category.label,
                            style: TextStyle(
                              fontSize: Dimensions.font16,
                              fontWeight: FontWeight.w500,
                              color: context.colors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Divider(
                      height: 1,
                      color: context.colors.border,
                      indent: Dimensions.width20,
                      endIndent: Dimensions.width20,
                    ),
                  ],
                );
              }, childCount: _categories.length),
            ),
          ],
        ),
      ),
    );
  }
}

class _TemplateCategory {
  final String label;
  final String type;

  _TemplateCategory({required this.label, required this.type});
}
