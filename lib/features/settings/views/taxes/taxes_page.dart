import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/features/settings/views/taxes/tax_rates_page.dart';
import 'package:custom_books/features/settings/views/taxes/tax_settings_page.dart';
import 'package:custom_books/features/settings/views/taxes/tax_preferences_page.dart';
import 'package:flutter/material.dart';

class TaxesPage extends StatefulWidget {
  const TaxesPage({super.key});

  @override
  State<TaxesPage> createState() => _TaxesPageState();
}

class _TaxesPageState extends State<TaxesPage> {
  final List<_TaxMenuItem> _menuItems = [
    _TaxMenuItem(label: 'Tax Rates', route: 'tax_rates'),
    _TaxMenuItem(label: 'Tax Settings', route: 'tax_settings'),
    _TaxMenuItem(label: 'Tax Preferences', route: 'tax_preferences'),
  ];

  @override
  void initState() {
    super.initState();
    appLog('💰 TaxesPage initialized', name: 'Taxes');
  }

  void _navigateTo(String route) {
    appLog('📂 Tax "$route" tapped', name: 'Taxes');
    Widget? page;
    switch (route) {
      case 'tax_rates':
        page = const TaxRatesPage();
        break;
      case 'tax_settings':
        page = const TaxSettingsPage();
        break;
      case 'tax_preferences':
        page = const TaxPreferencesPage();
        break;
      default:
        return;
    }
    Navigator.push(context, MaterialPageRoute(builder: (_) => page!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            const CustomSliverAppBar(
              title: 'Taxes',
              leadingType: AppBarLeadingType.back,
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final item = _menuItems[index];
                return Column(
                  children: [
                    InkWell(
                      onTap: () => _navigateTo(item.route),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.width20,
                          vertical: Dimensions.height20,
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            item.label,
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
              }, childCount: _menuItems.length),
            ),
          ],
        ),
      ),
    );
  }
}

class _TaxMenuItem {
  final String label;
  final String route;

  _TaxMenuItem({required this.label, required this.route});
}
