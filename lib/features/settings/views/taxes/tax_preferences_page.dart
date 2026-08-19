import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/core/widgets/form_widgets.dart';
import 'package:flutter/material.dart';

class TaxPreferencesPage extends StatefulWidget {
  const TaxPreferencesPage({super.key});

  @override
  State<TaxPreferencesPage> createState() => _TaxPreferencesPageState();
}

class _TaxPreferencesPageState extends State<TaxPreferencesPage> {
  bool _profitMarginScheme = false;

  @override
  void initState() {
    super.initState();
    appLog('🎯 TaxPreferencesPage initialized', name: 'TaxPreferences');
  }

  void _save() {
    appLog('💾 Save Tax Preferences', name: 'TaxPreferences');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            CustomSliverAppBar(
              title: 'Tax Preferences',
              leadingType: AppBarLeadingType.back,
              actions: [
                AppBarElevatedButton(label: 'SAVE', onPressed: _save),
                SizedBox(width: Dimensions.width20),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(Dimensions.width15),
                child: FormCard(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Profit Margin Scheme',
                            style: TextStyle(
                              fontSize: Dimensions.font16,
                              fontWeight: FontWeight.w700,
                              color: context.colors.textPrimary,
                            ),
                          ),
                        ),
                        Switch(
                          value: _profitMarginScheme,
                          onChanged: (val) =>
                              setState(() => _profitMarginScheme = val),
                          activeThumbColor: AppColors.primary,
                        ),
                      ],
                    ),
                    SizedBox(height: Dimensions.height10),
                    Text(
                      'The Profit Margin Scheme allows you to calculate VAT based on the profit margin rather than the selling price. This is to avoid double taxation on goods that are specified in the VAT regulations.',
                      style: TextStyle(
                        fontSize: Dimensions.font16 * 0.8,
                        color: context.colors.textSecondary,
                        height: 1.5,
                      ),
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
}
