import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/widgets/custom_add_button.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/features/settings/views/taxes/new_tax_page.dart';
import 'package:custom_books/features/settings/views/taxes/new_tax_group_page.dart';
import 'package:flutter/material.dart';

class TaxRatesPage extends StatefulWidget {
  const TaxRatesPage({super.key});

  @override
  State<TaxRatesPage> createState() => _TaxRatesPageState();
}

class _TaxRatesPageState extends State<TaxRatesPage> {
  final List<_TaxRateItem> _taxRates = [
    _TaxRateItem(name: 'VAT', rate: 5.0, isDefault: true),
    _TaxRateItem(name: 'Zero Rate', rate: 0.0, isDefault: false),
  ];

  bool _showFabMenu = false;

  @override
  void initState() {
    super.initState();
    appLog('📊 TaxRatesPage initialized', name: 'TaxRates');
  }

  void _toggleFabMenu() {
    setState(() => _showFabMenu = !_showFabMenu);
  }

  void _addNewTax() {
    setState(() => _showFabMenu = false);
    appLog('➕ New Tax tapped', name: 'TaxRates');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const NewTaxPage()),
    );
  }

  void _addNewTaxGroup() {
    setState(() => _showFabMenu = false);
    appLog('➕ New Tax Group tapped', name: 'TaxRates');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const NewTaxGroupPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);

    return Scaffold(
      backgroundColor: context.colors.background,
      floatingActionButton: _buildFab(),
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                const CustomSliverAppBar(
                  title: 'Tax Rates',
                  leadingType: AppBarLeadingType.back,
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final tax = _taxRates[index];
                    return Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.width20,
                            vertical: Dimensions.height15,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Text(
                                      tax.name,
                                      style: TextStyle(
                                        fontSize: Dimensions.font16,
                                        fontWeight: FontWeight.w600,
                                        color: Appcolors.primary,
                                      ),
                                    ),
                                    if (tax.isDefault) ...[
                                      Text(
                                        ' - ',
                                        style: TextStyle(
                                          fontSize: Dimensions.font16 * 0.85,
                                          color: context.colors.textSecondary,
                                        ),
                                      ),
                                      Text(
                                        'Default Tax',
                                        style: TextStyle(
                                          fontSize: Dimensions.font16 * 0.85,
                                          color: context.colors.textTertiary,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              Text(
                                '${tax.rate.toStringAsFixed(1)}%',
                                style: TextStyle(
                                  fontSize: Dimensions.font16,
                                  fontWeight: FontWeight.w600,
                                  color: context.colors.textPrimary,
                                ),
                              ),
                            ],
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
                  }, childCount: _taxRates.length),
                ),
              ],
            ),

            // FAB Menu Overlay
            if (_showFabMenu)
              GestureDetector(
                onTap: _toggleFabMenu,
                child: Container(
                  color: Colors.black.withValues(alpha: 0.4),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: Dimensions.width20,
                        bottom: Dimensions.height45 * 2,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _buildFabMenuItem(
                            label: 'New Tax Group',
                            color: Appcolors.warning,
                            icon: Icons.folder_outlined,
                            onTap: _addNewTaxGroup,
                          ),
                          SizedBox(height: Dimensions.height10),
                          _buildFabMenuItem(
                            label: 'New Tax',
                            color: Appcolors.ok,
                            icon: Icons.percent_rounded,
                            onTap: _addNewTax,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFab() {
    return CustomAddButton(
      onPressed: _toggleFabMenu,
      icon: _showFabMenu ? Icons.close : Icons.add_rounded,
    );
  }

  Widget _buildFabMenuItem({
    required String label,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.9,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          SizedBox(width: Dimensions.width10),
          Container(
            width: Dimensions.height45,
            height: Dimensions.height45,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(Dimensions.radius15),
            ),
            child: Icon(icon, color: Colors.white, size: Dimensions.iconSize24),
          ),
        ],
      ),
    );
  }
}

class _TaxRateItem {
  final String name;
  final double rate;
  final bool isDefault;

  _TaxRateItem({
    required this.name,
    required this.rate,
    required this.isDefault,
  });
}
