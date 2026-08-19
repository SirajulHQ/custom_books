import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OpeningScreenPage extends StatefulWidget {
  const OpeningScreenPage({super.key});

  @override
  State<OpeningScreenPage> createState() => _OpeningScreenPageState();
}

class _OpeningScreenPageState extends State<OpeningScreenPage> {
  static const String _prefsKey = 'opening_screen';

  String _selected = 'Home';

  final List<_ScreenOption> _options = [
    _ScreenOption(icon: Icons.home_rounded, label: 'Home'),
    _ScreenOption(icon: Icons.people_outline_rounded, label: 'Customers'),
    _ScreenOption(icon: Icons.receipt_long_rounded, label: 'Invoices'),
    _ScreenOption(icon: Icons.shopping_bag_outlined, label: 'Items'),
    _ScreenOption(icon: Icons.request_quote_outlined, label: 'Quotes'),
    _ScreenOption(icon: Icons.local_shipping_outlined, label: 'Sales Orders'),
    _ScreenOption(icon: Icons.store_outlined, label: 'Vendors'),
    _ScreenOption(icon: Icons.receipt_outlined, label: 'Bills'),
    _ScreenOption(icon: Icons.bar_chart_rounded, label: 'Reports'),
    _ScreenOption(icon: Icons.settings_outlined, label: 'Settings'),
  ];

  @override
  void initState() {
    super.initState();
    _loadPreference();
  }

  Future<void> _loadPreference() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_prefsKey);
    if (saved != null && mounted) {
      setState(() => _selected = saved);
    }
  }

  Future<void> _savePreference(String value) async {
    appLog('📱 Opening screen changed to: $value', name: 'OpeningScreen');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, value);
    if (mounted) {
      setState(() => _selected = value);
    }
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
              title: 'Opening Screen',
              leadingType: AppBarLeadingType.back,
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  Dimensions.width20,
                  Dimensions.height15,
                  Dimensions.width20,
                  Dimensions.height20,
                ),
                child: Text(
                  'Choose the screen that opens when you launch the app.',
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.85,
                    color: context.colors.textSecondary,
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final option = _options[index];
                  final isSelected = option.label == _selected;
                  return Padding(
                    padding: EdgeInsets.only(bottom: Dimensions.height10),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(Dimensions.radius15),
                      onTap: () => _savePreference(option.label),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.width15,
                          vertical: Dimensions.height15,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary.withValues(alpha: 0.06)
                              : context.colors.card,
                          borderRadius: BorderRadius.circular(
                            Dimensions.radius15,
                          ),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : context.colors.border,
                            width: isSelected ? 1.5 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              option.icon,
                              size: Dimensions.iconSize24,
                              color: isSelected
                                  ? AppColors.primary
                                  : context.colors.textSecondary,
                            ),
                            SizedBox(width: Dimensions.width15),
                            Expanded(
                              child: Text(
                                option.label,
                                style: TextStyle(
                                  fontSize: Dimensions.font16 * 0.9,
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  color: isSelected
                                      ? AppColors.primary
                                      : context.colors.textPrimary,
                                ),
                              ),
                            ),
                            if (isSelected)
                              Icon(
                                Icons.check_circle_rounded,
                                size: Dimensions.iconSize24,
                                color: AppColors.primary,
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                }, childCount: _options.length),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScreenOption {
  final IconData icon;
  final String label;

  const _ScreenOption({required this.icon, required this.label});
}
