import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/features/settings/preferences/general_preferences_page.dart';
import 'package:custom_books/features/settings/preferences/customers_vendors_preferences_page.dart';
import 'package:custom_books/features/settings/preferences/item_settings_page.dart';
import 'package:custom_books/features/settings/preferences/quotes_settings_page.dart';
import 'package:custom_books/features/settings/preferences/invoice_settings_page.dart';
import 'package:custom_books/features/settings/preferences/credit_notes_settings_page.dart';
import 'package:custom_books/features/settings/preferences/sales_orders_settings_page.dart';
import 'package:custom_books/features/settings/preferences/expense_settings_page.dart';
import 'package:custom_books/features/settings/preferences/bills_settings_page.dart';
import 'package:custom_books/features/settings/preferences/purchase_orders_settings_page.dart';
import 'package:custom_books/features/settings/preferences/vendor_portal_settings_page.dart';
import 'package:flutter/material.dart';

class PreferencesPage extends StatefulWidget {
  const PreferencesPage({super.key});

  @override
  State<PreferencesPage> createState() => _PreferencesPageState();
}

class _PreferencesPageState extends State<PreferencesPage> {
  @override
  void initState() {
    super.initState();
    appLog('🎛️ PreferencesPage initialized', name: 'Preferences');
  }

  final List<_PreferenceItem> _preferenceItems = [
    _PreferenceItem(label: 'General', route: 'general'),
    _PreferenceItem(label: 'Customers And Vendors', route: 'customers_vendors'),
    _PreferenceItem(label: 'Items', route: 'items'),
    _PreferenceItem(label: 'Quotes', route: 'quotes'),
    _PreferenceItem(label: 'Invoices', route: 'invoices'),
    _PreferenceItem(label: 'Credit Notes', route: 'credit_notes'),
    _PreferenceItem(label: 'Sales Orders', route: 'sales_orders'),
    _PreferenceItem(label: 'Expenses', route: 'expenses'),
    _PreferenceItem(label: 'Bills', route: 'bills'),
    _PreferenceItem(label: 'Purchase Orders', route: 'purchase_orders'),
    _PreferenceItem(label: 'Vendor Portal', route: 'vendor_portal'),
  ];

  void _navigateTo(String route) {
    appLog('📂 Preference "$route" tapped', name: 'Preferences');
    Widget? page;
    switch (route) {
      case 'general':
        page = const GeneralPreferencesPage();
        break;
      case 'customers_vendors':
        page = const CustomersVendorsPreferencesPage();
        break;
      case 'items':
        page = const ItemSettingsPage();
        break;
      case 'quotes':
        page = const QuotesSettingsPage();
        break;
      case 'invoices':
        page = const InvoiceSettingsPage();
        break;
      case 'credit_notes':
        page = const CreditNotesSettingsPage();
        break;
      case 'sales_orders':
        page = const SalesOrdersSettingsPage();
        break;
      case 'expenses':
        page = const ExpenseSettingsPage();
        break;
      case 'bills':
        page = const BillsSettingsPage();
        break;
      case 'purchase_orders':
        page = const PurchaseOrdersSettingsPage();
        break;
      case 'vendor_portal':
        page = const VendorPortalSettingsPage();
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
              title: 'Preferences',
              leadingType: AppBarLeadingType.back,
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final item = _preferenceItems[index];
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
              }, childCount: _preferenceItems.length),
            ),
          ],
        ),
      ),
    );
  }
}

class _PreferenceItem {
  final String label;
  final String route;

  _PreferenceItem({required this.label, required this.route});
}
