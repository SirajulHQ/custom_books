import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/widgets/custom_add_button.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/features/settings/views/currencies/new_currency_page.dart';
import 'package:custom_books/core/widgets/skeletons/skeletons.dart';
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

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
    appLog('💱 CurrenciesPage initialized', name: 'Currencies');
  }

  /// Simulates fetching data so the shimmer skeleton is shown briefly.
  Future<void> _load() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _isLoading = false);
  }

  void _addCurrency() {
    appLog('➕ New Currency tapped', name: 'Currencies');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const NewCurrencyPage()),
    );
  }

  void _sortCurrencies({required bool byName}) {
    setState(() {
      _currencies.sort((a, b) {
        // Keep base currency pinned to the top.
        if (a.isBase != b.isBase) return a.isBase ? -1 : 1;
        return byName
            ? a.name.toLowerCase().compareTo(b.name.toLowerCase())
            : a.code.compareTo(b.code);
      });
    });
  }

  void _showPageOptions() {
    appLog('⋯ Currencies page options', name: 'Currencies');
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        return SafeArea(
          top: false,
          child: Container(
            decoration: BoxDecoration(
              color: context.colors.card,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(Dimensions.radius20),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.width20,
                    vertical: Dimensions.height15,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'More Options',
                        style: TextStyle(
                          fontSize: Dimensions.font20,
                          fontWeight: FontWeight.bold,
                          color: context.colors.textPrimary,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(sheetContext),
                        child: Icon(
                          Icons.close_rounded,
                          size: Dimensions.iconSize24,
                          color: context.colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(height: 1, color: context.colors.border),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(
                    Dimensions.width20,
                    Dimensions.height20,
                    Dimensions.width20,
                    Dimensions.height10,
                  ),
                  child: Text(
                    'CURRENCY ACTIONS',
                    style: TextStyle(
                      fontSize: Dimensions.font16 * 0.7,
                      fontWeight: FontWeight.w600,
                      color: context.colors.textTertiary,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
                  child: Column(
                    children: [
                      _buildOption(
                        sheetContext,
                        icon: Icons.sort_by_alpha_rounded,
                        title: 'Sort by Currency Code',
                        subtitle: 'Arrange currencies alphabetically by code',
                        onTap: () => _sortCurrencies(byName: false),
                      ),
                      SizedBox(height: Dimensions.height10),
                      _buildOption(
                        sheetContext,
                        icon: Icons.sort_rounded,
                        title: 'Sort by Currency Name',
                        subtitle: 'Arrange currencies alphabetically by name',
                        onTap: () => _sortCurrencies(byName: true),
                      ),
                      SizedBox(height: Dimensions.height10),
                      _buildOption(
                        sheetContext,
                        icon: Icons.add_rounded,
                        title: 'Add New Currency',
                        subtitle: 'Add a new currency to your organisation',
                        onTap: _addCurrency,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: Dimensions.height20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOption(
    BuildContext sheetContext, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Builder(
      builder: (context) => InkWell(
        borderRadius: BorderRadius.circular(Dimensions.radius15),
        onTap: () {
          Navigator.pop(sheetContext);
          onTap();
        },
        child: Container(
          padding: EdgeInsets.all(Dimensions.width15),
          decoration: BoxDecoration(
            color: context.colors.card,
            borderRadius: BorderRadius.circular(Dimensions.radius15),
            border: Border.all(color: context.colors.border),
          ),
          child: Row(
            children: [
              Container(
                width: Dimensions.height45 * 0.9,
                height: Dimensions.height45 * 0.9,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(Dimensions.radius15 - 3),
                ),
                child: Icon(
                  icon,
                  size: Dimensions.iconSize24 - 4,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(width: Dimensions.width15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: Dimensions.font16 * 0.9,
                        fontWeight: FontWeight.w700,
                        color: context.colors.textPrimary,
                      ),
                    ),
                    SizedBox(height: Dimensions.height10 / 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: Dimensions.font16 * 0.7,
                        color: context.colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: Dimensions.iconSize24 - 4,
                color: context.colors.textTertiary,
              ),
            ],
          ),
        ),
      ),
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
                leading: Icon(Icons.delete_outline, color: AppColors.warn),
                title: Text('Delete', style: TextStyle(color: AppColors.warn)),
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
                  onPressed: _showPageOptions,
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
                    color: AppColors.warning.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(Dimensions.radius15),
                    border: Border.all(
                      color: AppColors.warning.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_rounded,
                        size: Dimensions.iconSize24,
                        color: AppColors.warning,
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
                                  color: AppColors.primary,
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
            if (_isLoading)
              const SliverToBoxAdapter(child: SettingsListSkeleton())
            else
              SliverPadding(
                padding: EdgeInsets.only(bottom: Dimensions.listBottomSpace),
                sliver: SliverList(
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
                                    vertical: Dimensions.height10 * 0.2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.ok.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(
                                      Dimensions.radius15,
                                    ),
                                  ),
                                  child: Text(
                                    'BASE CURRENCY',
                                    style: TextStyle(
                                      fontSize: Dimensions.font16 * 0.6,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.ok,
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
