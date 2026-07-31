import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/apptheme/theme_controller.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/features/drawer/models/drawer_item.dart';
import 'package:custom_books/features/drawer/widgets/drawer_menu_item.dart';
import 'package:custom_books/features/drawer/widgets/expandable_menu_item.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/features/drawer/widgets/footer_button.dart';
import 'package:custom_books/features/items/view/items_page.dart';
import 'package:custom_books/features/inventory_adjustments/view/inventory_adjustments_page.dart';
import 'package:custom_books/features/banking/view/banking_page.dart';
import 'package:custom_books/features/customers/view/customers_page.dart';
import 'package:custom_books/features/quotes/view/quotes_page.dart';
import 'package:custom_books/features/sales_orders/view/sales_orders_page.dart';
import 'package:custom_books/features/delivery_challans/view/delivery_challans_page.dart';
import 'package:custom_books/features/invoices/view/invoices_page.dart';
import 'package:custom_books/features/payments_received/view/payments_received_page.dart';
import 'package:custom_books/features/recurring_invoices/view/recurring_invoices_page.dart';
import 'package:custom_books/features/credit_notes/view/credit_notes_page.dart';
import 'package:custom_books/features/vendors/view/vendors_page.dart';
import 'package:custom_books/features/expenses/view/expenses_page.dart';
import 'package:custom_books/features/purchase_orders/view/purchase_orders_page.dart';
import 'package:custom_books/features/bills/view/bills_page.dart';
import 'package:custom_books/features/payments_made/view/payments_made_page.dart';
import 'package:custom_books/features/vendor_credits/view/vendor_credits_page.dart';
import 'package:custom_books/features/projects/view/projects_page.dart';
import 'package:custom_books/features/time_entries/view/time_entries_page.dart';
import 'package:custom_books/features/timer/view/timer_page.dart';
import 'package:custom_books/features/manual_journals/view/manual_journals_page.dart';
import 'package:custom_books/features/documents/view/documents_inbox_page.dart';
import 'package:custom_books/features/documents/view/all_files_page.dart';
import 'package:custom_books/features/documents/view/folders_page.dart';
import 'package:flutter/material.dart';

class DrawerView extends StatefulWidget {
  final String? currentRoute;

  const DrawerView({super.key, this.currentRoute});

  @override
  State<DrawerView> createState() => _DrawerViewState();
}

class _DrawerViewState extends State<DrawerView> {
  // Track expanded sections
  final Map<String, bool> _expandedSections = {
    'Inventory': false,
    'Sales': false,
    'Purchases': false,
    'Time Tracking': false,
    'Accountant': false,
    'Documents': false,
  };

  void _navigateToTopLevel(Widget page) {
    final navigator = Navigator.of(context);
    navigator.pop();
    navigator.pushAndRemoveUntil<void>(
      MaterialPageRoute<void>(builder: (_) => page),
      (route) => route.isFirst,
    );
  }

  void _navigateToHome() {
    final navigator = Navigator.of(context);
    navigator.pop();
    navigator.popUntil((route) => route.isFirst);
  }

  /// Navigates to a top-level sub-item page, or just closes the drawer if the
  /// user is already on that page.
  void _navigateToSub(String route, Widget page) {
    if (widget.currentRoute == route) {
      appLog(
        '⚠️ Already on $route page, just closing drawer',
        name: 'DrawerNavigation',
      );
      Navigator.pop(context);
      return;
    }
    appLog('📍 Navigating to $route...', name: 'DrawerNavigation');
    _navigateToTopLevel(page);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: context.colors.card,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(
              Dimensions.width20,
              MediaQuery.of(context).padding.top + Dimensions.height15,
              Dimensions.width20,
              Dimensions.height20,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Appcolors.primary, Appcolors.primaryLight],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: Dimensions.height45 * 1.5,
                  height: Dimensions.height45 * 1.5,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                      width: 3,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'OS',
                      style: TextStyle(
                        fontSize: Dimensions.font26,
                        fontWeight: FontWeight.w900,
                        color: Appcolors.primary,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: Dimensions.height15),
                Text(
                  'Own Store',
                  style: TextStyle(
                    fontSize: Dimensions.font20 * 1.1,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: Dimensions.height10 / 2),
                Text(
                  'admin@ownstore.com',
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.85,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
                SizedBox(height: Dimensions.height15),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.width15,
                    vertical: Dimensions.height10 / 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(Dimensions.radius30),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.business_center_rounded,
                        size: Dimensions.iconSize16,
                        color: Colors.white,
                      ),
                      SizedBox(width: Dimensions.width10 / 2),
                      Text(
                        'Business Plan',
                        style: TextStyle(
                          fontSize: Dimensions.font16 * 0.75,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // Home
                DrawerMenuItem(
                  item: DrawerItem(
                    icon: Icons.home_rounded,
                    title: 'Home',
                    isSelected: widget.currentRoute == 'home',
                  ),
                  onCustomTap: () {
                    appLog('🏠 Home button tapped', name: 'DrawerNavigation');

                    // If already on Home page, just close the drawer
                    if (widget.currentRoute == 'home') {
                      appLog(
                        '⚠️ Already on Home page, just closing drawer',
                        name: 'DrawerNavigation',
                      );
                      Navigator.pop(context);
                      return;
                    }

                    appLog(
                      '📍 Navigating to HomePage...',
                      name: 'DrawerNavigation',
                    );
                    _navigateToHome();
                  },
                ),

                // Items
                DrawerMenuItem(
                  item: DrawerItem(
                    icon: Icons.shopping_bag_rounded,
                    title: 'Items',
                    isSelected: widget.currentRoute == 'items',
                  ),
                  onCustomTap: () {
                    appLog('🛍️ Items button tapped', name: 'DrawerNavigation');

                    // If already on Items page, just close the drawer
                    if (widget.currentRoute == 'items') {
                      appLog(
                        '⚠️ Already on Items page, just closing drawer',
                        name: 'DrawerNavigation',
                      );
                      Navigator.pop(context);
                      return;
                    }

                    appLog(
                      '📍 Navigating to ItemsPage...',
                      name: 'DrawerNavigation',
                    );
                    _navigateToTopLevel(const ItemsPage());
                  },
                ),

                // Inventory (Expandable)
                ExpandableMenuItem(
                  title: 'Inventory',
                  icon: Icons.inventory_2_rounded,
                  subItems: const ['Inventory Adjustments'],
                  isExpanded: _expandedSections['Inventory'] ?? false,
                  onTap: () {
                    appLog(
                      '📦 Inventory section tapped',
                      name: 'DrawerNavigation',
                    );
                    _toggleSection('Inventory');
                  },
                  onSubItemTap: (subItem) {
                    appLog(
                      '📦 Inventory subitem tapped: $subItem',
                      name: 'DrawerNavigation',
                    );

                    if (subItem == 'Inventory Adjustments') {
                      // If already on Inventory Adjustments page, just close the drawer
                      if (widget.currentRoute == 'inventory_adjustments') {
                        appLog(
                          '⚠️ Already on Inventory Adjustments page, just closing drawer',
                          name: 'DrawerNavigation',
                        );
                        Navigator.pop(context);
                        return;
                      }

                      appLog(
                        '📍 Navigating to InventoryAdjustmentsPage...',
                        name: 'DrawerNavigation',
                      );
                      _navigateToTopLevel(const InventoryAdjustmentsPage());
                    }
                  },
                ),

                // Banking
                DrawerMenuItem(
                  item: DrawerItem(
                    icon: Icons.account_balance_rounded,
                    title: 'Banking',
                    isSelected: widget.currentRoute == 'banking',
                  ),
                  onCustomTap: () {
                    appLog(
                      '🏦 Banking button tapped',
                      name: 'DrawerNavigation',
                    );

                    // If already on Banking page, just close the drawer
                    if (widget.currentRoute == 'banking') {
                      appLog(
                        '⚠️ Already on Banking page, just closing drawer',
                        name: 'DrawerNavigation',
                      );
                      Navigator.pop(context);
                      return;
                    }

                    appLog(
                      '📍 Navigating to BankingPage...',
                      name: 'DrawerNavigation',
                    );
                    _navigateToTopLevel(const BankingPage());
                  },
                ),

                // Sales (Expandable)
                ExpandableMenuItem(
                  title: 'Sales',
                  icon: Icons.shopping_cart_rounded,
                  subItems: const [
                    'Customers',
                    'Quotes',
                    'Sales Orders',
                    'Delivery Challans',
                    'Invoices',
                    'Payments Received',
                    'Recurring Invoices',
                    'Credit Notes',
                  ],
                  isExpanded: _expandedSections['Sales'] ?? false,
                  onTap: () {
                    appLog('🛒 Sales section tapped', name: 'DrawerNavigation');
                    _toggleSection('Sales');
                  },
                  onSubItemTap: (subItem) {
                    appLog(
                      '🛒 Sales subitem tapped: $subItem',
                      name: 'DrawerNavigation',
                    );

                    if (subItem == 'Customers') {
                      // If already on Customers page, just close the drawer
                      if (widget.currentRoute == 'customers') {
                        appLog(
                          '⚠️ Already on Customers page, just closing drawer',
                          name: 'DrawerNavigation',
                        );
                        Navigator.pop(context);
                        return;
                      }

                      appLog(
                        '📍 Navigating to CustomersPage...',
                        name: 'DrawerNavigation',
                      );
                      _navigateToTopLevel(const CustomersPage());
                    } else if (subItem == 'Quotes') {
                      if (widget.currentRoute == 'quotes') {
                        Navigator.pop(context);
                        return;
                      }

                      appLog(
                        '📍 Navigating to QuotesPage...',
                        name: 'DrawerNavigation',
                      );
                      _navigateToTopLevel(const QuotesPage());
                    } else if (subItem == 'Sales Orders') {
                      if (widget.currentRoute == 'sales_orders') {
                        Navigator.pop(context);
                        return;
                      }

                      appLog(
                        '📍 Navigating to SalesOrdersPage...',
                        name: 'DrawerNavigation',
                      );
                      _navigateToTopLevel(const SalesOrdersPage());
                    } else if (subItem == 'Delivery Challans') {
                      _navigateToSub(
                        'delivery_challans',
                        const DeliveryChallansPage(),
                      );
                    } else if (subItem == 'Invoices') {
                      _navigateToSub('invoices', const InvoicesPage());
                    } else if (subItem == 'Payments Received') {
                      _navigateToSub(
                        'payments_received',
                        const PaymentsReceivedPage(),
                      );
                    } else if (subItem == 'Recurring Invoices') {
                      _navigateToSub(
                        'recurring_invoices',
                        const RecurringInvoicesPage(),
                      );
                    } else if (subItem == 'Credit Notes') {
                      _navigateToSub('credit_notes', const CreditNotesPage());
                    }
                  },
                ),

                // Purchases (Expandable)
                ExpandableMenuItem(
                  title: 'Purchases',
                  icon: Icons.shopping_basket_rounded,
                  subItems: const [
                    'Vendors',
                    'Expenses',
                    'Purchase Orders',
                    'Bills',
                    'Payments Made',
                    'Vendor Credits',
                  ],
                  isExpanded: _expandedSections['Purchases'] ?? false,
                  onTap: () {
                    appLog(
                      '🧺 Purchases section tapped',
                      name: 'DrawerNavigation',
                    );
                    _toggleSection('Purchases');
                  },
                  onSubItemTap: (subItem) {
                    appLog(
                      '🧺 Purchases subitem tapped: $subItem',
                      name: 'DrawerNavigation',
                    );

                    if (subItem == 'Vendors') {
                      _navigateToSub('vendors', const VendorsPage());
                    } else if (subItem == 'Expenses') {
                      _navigateToSub('expenses', const ExpensesPage());
                    } else if (subItem == 'Purchase Orders') {
                      _navigateToSub(
                        'purchase_orders',
                        const PurchaseOrdersPage(),
                      );
                    } else if (subItem == 'Bills') {
                      _navigateToSub('bills', const BillsPage());
                    } else if (subItem == 'Payments Made') {
                      _navigateToSub('payments_made', const PaymentsMadePage());
                    } else if (subItem == 'Vendor Credits') {
                      _navigateToSub(
                        'vendor_credits',
                        const VendorCreditsPage(),
                      );
                    }
                  },
                ),

                // Time Tracking (Expandable)
                ExpandableMenuItem(
                  title: 'Time Tracking',
                  icon: Icons.access_time_rounded,
                  subItems: const ['Projects', 'Time Entries', 'Timer'],
                  isExpanded: _expandedSections['Time Tracking'] ?? false,
                  onTap: () {
                    appLog(
                      '⏰ Time Tracking section tapped',
                      name: 'DrawerNavigation',
                    );
                    _toggleSection('Time Tracking');
                  },
                  onSubItemTap: (subItem) {
                    appLog(
                      '⏰ Time Tracking subitem tapped: $subItem',
                      name: 'DrawerNavigation',
                    );

                    if (subItem == 'Projects') {
                      _navigateToSub('projects', const ProjectsPage());
                    } else if (subItem == 'Time Entries') {
                      _navigateToSub('time_entries', const TimeEntriesPage());
                    } else if (subItem == 'Timer') {
                      _navigateToSub('timer', const TimerPage());
                    }
                  },
                ),

                // Accountant (Expandable)
                ExpandableMenuItem(
                  title: 'Accountant',
                  icon: Icons.person_rounded,
                  subItems: const ['Manual Journals'],
                  isExpanded: _expandedSections['Accountant'] ?? false,
                  onTap: () {
                    appLog(
                      '👤 Accountant section tapped',
                      name: 'DrawerNavigation',
                    );
                    _toggleSection('Accountant');
                  },
                  onSubItemTap: (subItem) {
                    appLog(
                      '👤 Accountant subitem tapped: $subItem',
                      name: 'DrawerNavigation',
                    );

                    if (subItem == 'Manual Journals') {
                      _navigateToSub(
                        'manual_journals',
                        const ManualJournalsPage(),
                      );
                    }
                  },
                ),

                // Documents (Expandable)
                ExpandableMenuItem(
                  title: 'Documents',
                  icon: Icons.folder_rounded,
                  subItems: const ['Inbox', 'All Files', 'Folders'],
                  isExpanded: _expandedSections['Documents'] ?? false,
                  onTap: () {
                    appLog(
                      '📁 Documents section tapped',
                      name: 'DrawerNavigation',
                    );
                    _toggleSection('Documents');
                  },
                  onSubItemTap: (subItem) {
                    appLog(
                      '📁 Documents subitem tapped: $subItem',
                      name: 'DrawerNavigation',
                    );

                    if (subItem == 'Inbox') {
                      _navigateToSub(
                        'documents_inbox',
                        const DocumentsInboxPage(),
                      );
                    } else if (subItem == 'All Files') {
                      _navigateToSub('all_files', const AllFilesPage());
                    } else if (subItem == 'Folders') {
                      _navigateToSub('folders', const FoldersPage());
                    }
                  },
                ),

                // Reports
                DrawerMenuItem(
                  item: DrawerItem(
                    icon: Icons.bar_chart_rounded,
                    title: 'Reports',
                  ),
                  onCustomTap: () {
                    appLog(
                      '📊 Reports button tapped',
                      name: 'DrawerNavigation',
                    );
                    Navigator.pop(context);
                  },
                ),

                // Settings
                DrawerMenuItem(
                  item: DrawerItem(
                    icon: Icons.settings_rounded,
                    title: 'Settings',
                  ),
                  onCustomTap: () {
                    appLog(
                      '⚙️ Settings button tapped',
                      name: 'DrawerNavigation',
                    );
                    Navigator.pop(context);
                  },
                ),

                SizedBox(height: Dimensions.height20),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(Dimensions.width20),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: context.colors.border, width: 1),
              ),
            ),
            child: Column(
              children: [
                ValueListenableBuilder<ThemeMode>(
                  valueListenable: ThemeController.instance.mode,
                  builder: (context, mode, _) {
                    final bool isDark = mode == ThemeMode.dark;
                    return Row(
                      children: [
                        Expanded(
                          child: FooterButton(
                            icon: isDark
                                ? Icons.light_mode_rounded
                                : Icons.dark_mode_rounded,
                            label: isDark ? 'Light Mode' : 'Dark Mode',
                            isDanger: false,
                            onTap: () {
                              appLog(
                                '🌗 Theme toggled -> ${isDark ? 'light' : 'dark'}',
                                name: 'DrawerNavigation',
                              );
                              ThemeController.instance.toggle();
                            },
                          ),
                        ),
                        SizedBox(width: Dimensions.width10),
                        Expanded(
                          child: FooterButton(
                            icon: Icons.logout_rounded,
                            label: 'Logout',
                            isDanger: true,
                            onTap: () {
                              appLog(
                                '🚪 Logout button tapped',
                                name: 'DrawerNavigation',
                              );
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(height: Dimensions.height15),
                Text(
                  'Version 1.0.0',
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.7,
                    color: context.colors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _toggleSection(String section) {
    setState(() {
      _expandedSections[section] = !(_expandedSections[section] ?? false);
    });
  }
}
