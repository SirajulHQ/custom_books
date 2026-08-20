import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/features/drawer/views/custom_drawer.dart';
import 'package:custom_books/features/customers/models/customer_model.dart';
import 'package:custom_books/features/customers/widgets/customer_page_widgets/customer_card_widget.dart';
import 'package:custom_books/features/customers/widgets/customer_page_widgets/customer_filter_sheet.dart';
import 'package:custom_books/features/customers/widgets/customer_page_widgets/customer_sort_sheet.dart';
import 'package:custom_books/features/customers/widgets/customer_page_widgets/customer_more_options_sheet.dart';
import 'package:custom_books/features/customers/views/add_customer_page.dart';
import 'package:flutter/material.dart';

class CustomersPage extends StatefulWidget {
  const CustomersPage({super.key});

  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  String _selectedFilter = 'Active Customers';
  bool _searchOpen = false;
  final _searchController = TextEditingController();

  String _sortField = 'Name';
  bool _sortAsc = true;

  final List<String> _allFilterOptions = [
    'All Customers',
    'Active Customers',
    'CRM Customers',
    'Duplicate Customers',
    'Inactive Customers',
    'Customer Portal Enabled',
    'Customer Portal Disabled',
    'Overdue Customers',
    'Unpaid Customers',
    'Associated with Payment Options',
  ];

  @override
  void initState() {
    super.initState();
    appLog('🎯 CustomersPage initialized', name: 'CustomersPage');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Dummy data based on the image
  final List<CustomerModel> _customers = [
    CustomerModel(
      id: '1',
      name: 'Amal',
      receivables: 315.00,
      unusedCredits: 0.00,
      isActive: true,
    ),
    CustomerModel(
      id: '2',
      name: 'nabeel',
      email: 'nabeelkari18@gmail.com',
      receivables: 0.00,
      unusedCredits: 0.00,
      isActive: true,
    ),
    CustomerModel(
      id: '3',
      name: 'Nandhu',
      receivables: 3430.00,
      unusedCredits: 1210.00,
      isActive: true,
    ),
    CustomerModel(
      id: '4',
      name: 'Parthiv Ajith',
      receivables: 0.00,
      unusedCredits: 0.00,
      isActive: true,
    ),
    CustomerModel(
      id: '5',
      name: 'Parthiv Ajith',
      receivables: 0.00,
      unusedCredits: 1000.00,
      isActive: true,
    ),
    CustomerModel(
      id: '6',
      name: 'Parthiv2 Ajith2',
      receivables: 0.00,
      unusedCredits: 0.00,
      isActive: true,
    ),
  ];

  List<CustomerModel> get _filteredCustomers {
    var list = _customers;

    // Apply filter
    if (_selectedFilter == 'Active Customers') {
      list = list.where((customer) => customer.isActive).toList();
    } else if (_selectedFilter == 'Inactive Customers') {
      list = list.where((customer) => !customer.isActive).toList();
    } else if (_selectedFilter == 'Overdue Customers') {
      list = list.where((customer) => customer.receivables > 0).toList();
    } else if (_selectedFilter == 'Unpaid Customers') {
      list = list.where((customer) => customer.receivables > 0).toList();
    } else if (_selectedFilter == 'Duplicate Customers') {
      final nameCount = <String, int>{};
      for (final c in list) {
        final key = c.name.trim().toLowerCase();
        nameCount[key] = (nameCount[key] ?? 0) + 1;
      }
      list = list
          .where((c) => (nameCount[c.name.trim().toLowerCase()] ?? 0) > 1)
          .toList();
    }

    // Apply search
    final query = _searchController.text.trim().toLowerCase();
    if (query.isNotEmpty) {
      list = list.where((customer) {
        return customer.name.toLowerCase().contains(query) ||
            (customer.email?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    // Apply sort
    list = [...list];
    list.sort((a, b) {
      int cmp;
      switch (_sortField) {
        case 'Receivables':
          cmp = a.receivables.compareTo(b.receivables);
          break;
        case 'Unused Credits':
          cmp = a.unusedCredits.compareTo(b.unusedCredits);
          break;
        case 'Name':
        default:
          cmp = a.name.toLowerCase().compareTo(b.name.toLowerCase());
      }
      return _sortAsc ? cmp : -cmp;
    });

    return list;
  }

  void _showMoreOptions() {
    appLog('⋮ More options tapped', name: 'CustomersPage');
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => CustomerMoreOptionsSheet(
        onRefresh: () {
          setState(() {});
          ToastificationHelper.showSuccess(context, 'Customers refreshed.');
        },
        onImport: () => ToastificationHelper.showInfo(
          context,
          'Importing customers is coming soon.',
        ),
        onExport: () => ToastificationHelper.showInfo(
          context,
          'Exporting customers is coming soon.',
        ),
      ),
    );
  }

  void _showSortSheet() {
    appLog('🔀 Opening sort sheet', name: 'CustomersPage');
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => CustomerSortSheet(
        selectedField: _sortField,
        ascending: _sortAsc,
        onApply: (field, ascending) {
          setState(() {
            _sortField = field;
            _sortAsc = ascending;
          });
        },
      ),
    );
  }

  void _showFilterBottomSheet() {
    appLog('📋 Opening filter bottom sheet', name: 'CustomersPage');
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => CustomerFilterSheet(
        selectedFilter: _selectedFilter,
        filterOptions: _allFilterOptions,
        onSelected: (filter) {
          appLog('✅ Filter selected: $filter', name: 'CustomersPage');
          setState(() {
            _selectedFilter = filter;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    appLog('🏗️ Building CustomersPage', name: 'CustomersPage');
    return Scaffold(
      backgroundColor: context.colors.background,
      drawer: const DrawerView(currentRoute: 'customers'),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // App Bar
            CustomSliverAppBar(
              title: 'Customers',
              subtitle: '${_filteredCustomers.length} customers',
              leadingType: AppBarLeadingType.menu,
              actions: [
                AppBarIconButton(
                  icon: _searchOpen
                      ? Icons.close_rounded
                      : Icons.search_rounded,
                  color: AppColors.primary,
                  onPressed: () {
                    appLog('🔍 Search tapped', name: 'CustomersPage');
                    setState(() {
                      _searchOpen = !_searchOpen;
                      if (!_searchOpen) _searchController.clear();
                    });
                  },
                ),
                SizedBox(width: Dimensions.width10),
                AppBarIconButton(
                  icon: Icons.more_vert_rounded,
                  color: context.colors.textSecondary,
                  onPressed: _showMoreOptions,
                ),
                SizedBox(width: Dimensions.width20),
              ],
            ),

            // Search Field
            if (_searchOpen) SliverToBoxAdapter(child: _buildSearchField()),

            // Filter Segment Control
            SliverToBoxAdapter(child: _buildFilterSegment()),

            // Customers List
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
              sliver: _filteredCustomers.isEmpty
                  ? SliverToBoxAdapter(child: _buildEmptyState())
                  : SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: Dimensions.height15),
                          child: CustomerCardWidget(
                            customer: _filteredCustomers[index],
                          ),
                        );
                      }, childCount: _filteredCustomers.length),
                    ),
            ),

            SliverToBoxAdapter(child: SizedBox(height: Dimensions.height30)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          appLog('➕ Add Customer FAB tapped', name: 'CustomersPage');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddCustomerPage()),
          );
        },
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radius20),
        ),
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: Dimensions.iconSize24 * 1.2,
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        Dimensions.width20,
        0,
        Dimensions.width20,
        Dimensions.height15,
      ),
      child: TextField(
        controller: _searchController,
        autofocus: true,
        onChanged: (_) => setState(() {}),
        style: TextStyle(fontSize: Dimensions.font16 * 0.85),
        decoration: InputDecoration(
          hintText: 'Search by name or email',
          hintStyle: TextStyle(color: context.colors.textTertiary),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: context.colors.textTertiary,
          ),
          filled: true,
          fillColor: context.colors.card,
          contentPadding: EdgeInsets.symmetric(vertical: Dimensions.height10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Dimensions.radius15),
            borderSide: BorderSide(color: context.colors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Dimensions.radius15),
            borderSide: BorderSide(color: context.colors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Dimensions.radius15),
            borderSide: BorderSide(color: AppColors.primary, width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterSegment() {
    // Simplify the display text by removing "Customers" suffix if present
    String displayText = _selectedFilter.replaceAll(' Customers', '');

    return Padding(
      padding: EdgeInsets.fromLTRB(
        Dimensions.width20,
        0,
        Dimensions.width20,
        Dimensions.height15,
      ),
      child: Container(
        padding: EdgeInsets.all(Dimensions.width10 / 2),
        decoration: BoxDecoration(
          color: context.colors.surfaceLight,
          borderRadius: BorderRadius.circular(Dimensions.radius30),
        ),
        child: Row(
          children: [
            // Filter dropdown button
            Expanded(
              child: GestureDetector(
                onTap: () {
                  appLog('🔽 Filter dropdown tapped', name: 'CustomersPage');
                  _showFilterBottomSheet();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: Dimensions.height10),
                  decoration: BoxDecoration(
                    color: context.colors.card,
                    borderRadius: BorderRadius.circular(Dimensions.radius30),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        blurRadius: Dimensions.radius15 * 0.53,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        displayText,
                        style: TextStyle(
                          fontSize: Dimensions.font16 * 0.8,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.3,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(width: Dimensions.width10 / 2),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: Dimensions.iconSize16,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(width: Dimensions.width10 * 0.8),

            // Sort button
            GestureDetector(
              onTap: _showSortSheet,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.width15,
                  vertical: Dimensions.height10,
                ),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(Dimensions.radius30),
                ),
                child: Icon(
                  Icons.sort_rounded,
                  size: Dimensions.iconSize20,
                  color: context.colors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(Dimensions.width30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(Dimensions.width30),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.people_outline_rounded,
                size: Dimensions.height45 * 1.5,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: Dimensions.height20),
            Text(
              'No customers found',
              style: TextStyle(
                fontSize: Dimensions.font20,
                fontWeight: FontWeight.w700,
                color: context.colors.textPrimary,
              ),
            ),
            SizedBox(height: Dimensions.height10),
            Text(
              'Tap the + button to add your first customer',
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.85,
                color: context.colors.textTertiary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
