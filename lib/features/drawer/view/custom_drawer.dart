import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/features/drawer/models/drawer_item.dart';
import 'package:flutter/material.dart';

class DrawerView extends StatefulWidget {
  const DrawerView({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
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
                _buildDrawerMenuItem(
                  DrawerItem(
                    icon: Icons.home_rounded,
                    title: 'Home',
                    isSelected: true,
                  ),
                ),

                // Items
                _buildDrawerMenuItem(
                  DrawerItem(icon: Icons.shopping_bag_rounded, title: 'Items'),
                ),

                // Inventory (Expandable)
                _buildExpandableMenuItem(
                  'Inventory',
                  Icons.inventory_2_rounded,
                  ['Inventory Adjustments', 'Item Groups'],
                ),

                // Banking
                _buildDrawerMenuItem(
                  DrawerItem(
                    icon: Icons.account_balance_rounded,
                    title: 'Banking',
                  ),
                ),

                // Sales (Expandable)
                _buildExpandableMenuItem('Sales', Icons.shopping_cart_rounded, [
                  'Customers',
                  'Quotes',
                  'Sales Orders',
                  'Delivery Challans',
                  'Invoices',
                  'Payments Received',
                  'Recurring Invoices',
                  'Credit Notes',
                ]),

                // Purchases (Expandable)
                _buildExpandableMenuItem(
                  'Purchases',
                  Icons.shopping_basket_rounded,
                  [
                    'Vendors',
                    'Expenses',
                    'Purchase Orders',
                    'Bills',
                    'Payments Made',
                    'Vendor Credits',
                  ],
                ),

                // Time Tracking (Expandable)
                _buildExpandableMenuItem(
                  'Time Tracking',
                  Icons.access_time_rounded,
                  ['Projects', 'Time Entries', 'Timer'],
                ),

                // Accountant (Expandable)
                _buildExpandableMenuItem('Accountant', Icons.person_rounded, [
                  'Manual Journals',
                ]),

                // Documents (Expandable)
                _buildExpandableMenuItem('Documents', Icons.folder_rounded, [
                  'Inbox',
                  'All Files',
                  'Folders',
                ]),

                // Reports
                _buildDrawerMenuItem(
                  DrawerItem(icon: Icons.bar_chart_rounded, title: 'Reports'),
                ),

                // Settings
                _buildDrawerMenuItem(
                  DrawerItem(icon: Icons.settings_rounded, title: 'Settings'),
                ),

                SizedBox(height: Dimensions.height20),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(Dimensions.width20),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: const Color(0xFFE2E8F0), width: 1),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildFooterButton(
                        Icons.dark_mode_rounded,
                        'Dark Mode',
                        false,
                      ),
                    ),
                    SizedBox(width: Dimensions.width10),
                    Expanded(
                      child: _buildFooterButton(
                        Icons.logout_rounded,
                        'Logout',
                        true,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Dimensions.height15),
                Text(
                  'Version 1.0.0',
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.7,
                    color: Colors.black38,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableMenuItem(
    String title,
    IconData icon,
    List<String> subItems,
  ) {
    final isExpanded = _expandedSections[title] ?? false;

    return Column(
      children: [
        ListTile(
          leading: Container(
            width: Dimensions.height45 * 0.9,
            height: Dimensions.height45 * 0.9,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(Dimensions.radius15),
            ),
            child: Icon(
              icon,
              size: Dimensions.iconSize24 * 0.9,
              color: Colors.black54,
            ),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.9,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          trailing: Icon(
            isExpanded
                ? Icons.keyboard_arrow_up_rounded
                : Icons.keyboard_arrow_down_rounded,
            size: Dimensions.iconSize24,
            color: Colors.black54,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: Dimensions.width20,
            vertical: Dimensions.height10 / 4,
          ),
          onTap: () {
            setState(() {
              _expandedSections[title] = !isExpanded;
            });
          },
        ),
        if (isExpanded)
          ...subItems.map(
            (subItem) => ListTile(
              leading: SizedBox(width: Dimensions.height45 * 0.9),
              title: Padding(
                padding: EdgeInsets.only(left: Dimensions.width10),
                child: Text(
                  subItem,
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.85,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87,
                  ),
                ),
              ),
              dense: true,
              contentPadding: EdgeInsets.symmetric(
                horizontal: Dimensions.width20,
                vertical: 0,
              ),
              onTap: () {
                Navigator.pop(context);
                // Handle sub-item navigation
              },
            ),
          ),
      ],
    );
  }

  Widget _buildDrawerMenuItem(DrawerItem item) {
    return ListTile(
      leading: Container(
        width: Dimensions.height45 * 0.9,
        height: Dimensions.height45 * 0.9,
        decoration: BoxDecoration(
          color: item.isSelected
              ? Appcolors.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(Dimensions.radius15),
        ),
        child: Icon(
          item.icon,
          size: Dimensions.iconSize24 * 0.9,
          color: item.isSelected ? Appcolors.primary : Colors.black54,
        ),
      ),
      title: Text(
        item.title,
        style: TextStyle(
          fontSize: Dimensions.font16 * 0.9,
          fontWeight: item.isSelected ? FontWeight.w700 : FontWeight.w500,
          color: item.isSelected ? Appcolors.primary : Colors.black87,
        ),
      ),
      selected: item.isSelected,
      selectedTileColor: Appcolors.primary.withValues(alpha: 0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimensions.radius15),
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: Dimensions.width20,
        vertical: Dimensions.height10 / 4,
      ),
      onTap: () {
        Navigator.pop(context);
        // Handle navigation
      },
    );
  }

  Widget _buildFooterButton(IconData icon, String label, bool isDanger) {
    return GestureDetector(
      onTap: () {
        // Handle action
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: Dimensions.height10),
        decoration: BoxDecoration(
          color: isDanger
              ? Appcolors.warn.withValues(alpha: 0.1)
              : Colors.black.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(Dimensions.radius15),
          border: Border.all(
            color: isDanger
                ? Appcolors.warn.withValues(alpha: 0.2)
                : Colors.black.withValues(alpha: 0.1),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: Dimensions.iconSize24 * 0.85,
              color: isDanger ? Appcolors.warn : Colors.black54,
            ),
            SizedBox(height: Dimensions.height10 / 2),
            Text(
              label,
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.7,
                fontWeight: FontWeight.w600,
                color: isDanger ? Appcolors.warn : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
