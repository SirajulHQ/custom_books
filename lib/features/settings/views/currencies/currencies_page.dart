import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/widgets/custom_add_button.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/features/settings/views/currencies/new_currency_page.dart';
import 'package:flutter/material.dart';

class CurrenciesPage extends StatefulWidget {
  const CurrenciesPage({super.key});

  @override
  State<CurrenciesPage> createState() => _CurrenciesPageState();
}

class _CurrenciesPageState extends State<CurrenciesPage> {
  final List<_CurrencyItem> _currencies = [
    _CurrencyItem(code: 'INR', name: 'Indian Rupee', isBase: true),
    _CurrencyItem(code: 'AED', name: 'UAE Dirham'),
    _CurrencyItem(code: 'AUD', name: 'Australian Dollar'),
    _CurrencyItem(code: 'BND', name: 'Brunei Dollar'),
    _CurrencyItem(code: 'CAD', name: 'Canadian Dollar'),
    _CurrencyItem(code: 'CNY', name: 'Yuan Renminbi'),
    _CurrencyItem(code: 'EUR', name: 'Euro'),
    _CurrencyItem(code: 'GBP', name: 'Pound Sterling'),
    _CurrencyItem(code: 'JPY', name: 'Japanese Yen'),
    _CurrencyItem(code: 'SAR', name: 'Saudi Riyal'),
    _CurrencyItem(code: 'USD', name: 'United States Dollar'),
    _CurrencyItem(code: 'ZAR', name: 'South African Rand'),
  ];

  @override
  void initState() {
    super.initState();
    appLog('💱 CurrenciesPage initialized', name: 'Currencies');
  }

  void _addCurrency() {
    appLog('➕ New Currency tapped', name: 'Currencies');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const NewCurrencyPage()),
    );
  }

  void _showCurrencyOptions(_CurrencyItem currency) {
    appLog('⋯ Options for ${currency.code}', name: 'Currencies');
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: context.colors.card,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Edit'),
              onTap: () {
                Navigator.pop(ctx);
              },
            ),
            if (!currency.isBase)
              ListTile(
                leading: Icon(Icons.delete_outline, color: Appcolors.warn),
                title: Text('Delete', style: TextStyle(color: Appcolors.warn)),
                onTap: () {
                  Navigator.pop(ctx);
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);

    return Scaffold(
      backgroundColor: context.colors.background,
      floatingActionButton: CustomAddButton(onPressed: _addCurrency),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            CustomSliverAppBar(
              title: 'Currencies',
              leadingType: AppBarLeadingType.back,
              actions: [
                AppBarIconButton(
                  icon: Icons.more_vert_rounded,
                  onPressed: () {},
                ),
                SizedBox(width: Dimensions.width10),
              ],
            ),

            // Warning Banner
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.width20,
                  vertical: Dimensions.height10,
                ),
                child: Container(
                  padding: EdgeInsets.all(Dimensions.width15),
                  decoration: BoxDecoration(
                    color: Appcolors.warning.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(Dimensions.radius15),
                    border: Border.all(
                      color: Appcolors.warning.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_rounded,
                        size: Dimensions.iconSize24,
                        color: Appcolors.warning,
                      ),
                      SizedBox(width: Dimensions.width10),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            text:
                                'Caution: According to FTA rules, you\'re required to use the exchange rates recommended by the ',
                            style: TextStyle(
                              fontSize: Dimensions.font16 * 0.8,
                              color: context.colors.textPrimary,
                              height: 1.4,
                            ),
                            children: [
                              TextSpan(
                                text: 'Central Bank Of Uae',
                                style: TextStyle(
                                  color: Appcolors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const TextSpan(text: ' for VAT-transactions.'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Currency List
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final currency = _currencies[index];
                return Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: Dimensions.width20,
                        vertical: Dimensions.height10 / 2,
                      ),
                      title: Row(
                        children: [
                          Text(
                            currency.code,
                            style: TextStyle(
                              fontSize: Dimensions.font16,
                              fontWeight: FontWeight.w700,
                              color: context.colors.textPrimary,
                            ),
                          ),
                          if (currency.isBase) ...[
                            SizedBox(width: Dimensions.width10),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: Dimensions.width10,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Appcolors.ok.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(
                                  Dimensions.radius15,
                                ),
                              ),
                              child: Text(
                                'BASE CURRENCY',
                                style: TextStyle(
                                  fontSize: Dimensions.font16 * 0.6,
                                  fontWeight: FontWeight.w700,
                                  color: Appcolors.ok,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      subtitle: Text(
                        currency.name,
                        style: TextStyle(
                          fontSize: Dimensions.font16 * 0.8,
                          color: context.colors.textSecondary,
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.more_horiz_rounded,
                          color: context.colors.textSecondary,
                        ),
                        onPressed: () => _showCurrencyOptions(currency),
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
              }, childCount: _currencies.length),
            ),
          ],
        ),
      ),
    );
  }
}

class _CurrencyItem {
  final String code;
  final String name;
  final bool isBase;

  _CurrencyItem({required this.code, required this.name, this.isBase = false});
}
