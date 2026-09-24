import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/date_formatter.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/image_helper.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/core/widgets/confirmation_dialog.dart';
import 'package:custom_books/core/widgets/custom_back_appbar.dart';
import 'package:custom_books/core/widgets/more_options_sheet.dart';
import 'package:custom_books/features/items/controllers/item_detail_controller.dart';
import 'package:custom_books/features/items/controllers/item_form_controller.dart';
import 'package:custom_books/features/items/models/item_model.dart';
import 'package:custom_books/features/items/views/add_edit_item_page.dart';
import 'package:custom_books/features/items/views/adjust_stock_page.dart';
import 'package:flutter/material.dart';
import 'package:custom_books/core/widgets/skeletons/skeletons.dart';

class ItemDetailsPage extends StatefulWidget {
  final ItemModel item;

  const ItemDetailsPage({super.key, required this.item});

  @override
  State<ItemDetailsPage> createState() => _ItemDetailsPageState();
}

class _ItemDetailsPageState extends State<ItemDetailsPage>
    with SingleTickerProviderStateMixin {
  final ItemDetailController _controller = ItemDetailController();
  final ItemFormController _formController = ItemFormController();

  late final TabController _tabController;

  bool _isLoading = true;

  bool _didChange = false;

  late ItemModel item = widget.item;

  String _txnType = 'Quotes';
  static const List<String> _txnTypes = [
    'Quotes',
    'Invoices',
    'Sales Orders',
    'Purchase Orders',
    'Bills',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _load();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _controller.dispose();
    _formController.dispose();
    super.dispose();
  }

  String _money(double value) => 'AED${value.toStringAsFixed(2)}';

  String get _unitSuffix =>
      (item.unit != null && item.unit!.isNotEmpty) ? ' per ${item.unit}' : '';

  Future<void> _cloneItem() async {
    final created = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => AddEditItemPage(cloneFrom: item)),
    );
    if (created == true && mounted) {
      _didChange = true;
      ToastificationHelper.showSuccess(context, 'Item cloned successfully.');
    }
  }

  Future<void> _deleteItem() async {
    final ok = await _formController.delete(item.id);
    if (!mounted) return;
    if (ok) {
      ToastificationHelper.showSuccess(context, 'Item deleted successfully.');
      Navigator.pop(context, true);
    } else {
      ToastificationHelper.showError(
        context,
        _formController.errorMessage ?? 'Could not delete the item.',
      );
    }
  }

  Future<void> _setActive(bool active) async {
    final ok = await _formController.update(item.id, {
      'status': active ? 'active' : 'inactive',
    });
    if (!mounted) return;
    if (ok) {
      _didChange = true;
      ToastificationHelper.showSuccess(
        context,
        active ? 'Item marked as active.' : 'Item marked as inactive.',
      );
      _load();
    } else {
      ToastificationHelper.showError(
        context,
        _formController.errorMessage ?? 'Could not update the item status.',
      );
    }
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);
    await _controller.load(widget.item.id);
    if (!mounted) return;
    setState(() {
      final fetched = _controller.item;
      if (fetched != null) item = fetched;
      _isLoading = false;
    });
    if (_controller.errorMessage != null) {
      ToastificationHelper.showError(context, _controller.errorMessage!);
    }
  }

  Future<void> _editItem() async {
    final updated = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => AddEditItemPage(existing: item)),
    );
    if (updated == true && mounted) {
      _didChange = true;
      _load();
    }
  }

  void _showMoreOptions() {
    MoreOptionsSheet.show(
      context,
      sectionLabel: 'ITEM ACTIONS',
      items: [
        MoreOptionsItem(
          icon: Icons.tune_rounded,
          title: 'Adjust Stock',
          subtitle: 'Update the quantity on hand',
          onTap: _adjustStock,
        ),
        MoreOptionsItem(
          icon: Icons.copy_rounded,
          title: 'Clone',
          subtitle: 'Create a copy of this item',
          onTap: _cloneItem,
        ),
        MoreOptionsItem(
          icon: item.isActive
              ? Icons.toggle_off_outlined
              : Icons.toggle_on_outlined,
          title: item.isActive ? 'Mark as Inactive' : 'Mark as Active',
          subtitle: item.isActive
              ? 'Hide this item from active lists'
              : 'Restore this item to active',
          onTap: () => _setActive(!item.isActive),
        ),
        MoreOptionsItem(
          icon: Icons.delete_outline_rounded,
          title: 'Delete',
          subtitle: 'Permanently remove this item',
          onTap: _confirmDelete,
        ),
      ],
    );
  }

  Future<void> _adjustStock() async {
    final adjusted = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => AdjustStockPage(item: item)),
    );
    if (adjusted == true && mounted) {
      _didChange = true;
      _load();
    }
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showConfirmationDialog(
      context,
      title: 'Delete Item',
      message:
          'Are you sure you want to delete this item? This action cannot be undone.',
    );
    if (!mounted) return;
    if (confirmed) _deleteItem();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) Navigator.pop(context, _didChange);
      },
      child: Scaffold(
        backgroundColor: context.colors.background,
        appBar: CustomBackAppBar(
          title: 'Item',
          backgroundColor: context.colors.card,
          onLeadingPressed: () => Navigator.pop(context, _didChange),
          actions: [
            IconButton(
              icon: Icon(
                Icons.edit_outlined,
                color: context.colors.textSecondary,
                size: Dimensions.iconSize24 - 2,
              ),
              onPressed: _editItem,
            ),
            IconButton(
              icon: Icon(
                Icons.more_vert_rounded,
                color: context.colors.textSecondary,
                size: Dimensions.iconSize24 - 2,
              ),
              onPressed: _showMoreOptions,
            ),
            SizedBox(width: Dimensions.width10 / 2),
          ],
        ),
        body: SafeArea(
          child: _isLoading
              ? const DetailsPageSkeleton()
              : Column(
                  children: [
                    _buildHeader(),
                    SizedBox(height: Dimensions.height15),
                    _buildTabs(),
                    SizedBox(height: Dimensions.height15),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildDetailsTab(),
                          _buildTransactionsTab(),
                          _buildHistoryTab(),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Dimensions.width20),
      decoration: BoxDecoration(
        color: context.colors.card,
        boxShadow: [
          BoxShadow(
            color: const Color(0x08000000),
            blurRadius: Dimensions.radius15 * 0.53,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TextStyle(
                    fontSize: Dimensions.font20 * 1.1,
                    fontWeight: FontWeight.w800,
                    color: context.colors.textPrimary,
                  ),
                ),
                SizedBox(height: Dimensions.height15),
                _headerPrice('Selling Price', item.salesPrice),
                SizedBox(height: Dimensions.height10),
                _headerPrice('Purchase Cost', item.purchasePrice),
              ],
            ),
          ),
          SizedBox(width: Dimensions.width15),
          Container(
            width: Dimensions.height45 * 2,
            height: Dimensions.height45 * 2,
            decoration: BoxDecoration(
              color: context.colors.surfaceLight,
              borderRadius: BorderRadius.circular(Dimensions.radius15),
            ),
            clipBehavior: Clip.antiAlias,
            child: item.imageUrl != null
                ? ImageHelper.buildImage(
                    item.imageUrl!,
                    fit: BoxFit.cover,
                    errorWidget: _placeholderIcon(),
                  )
                : _placeholderIcon(),
          ),
        ],
      ),
    );
  }

  Widget _headerPrice(String label, double value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: Dimensions.font16 * 0.78,
            color: context.colors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: Dimensions.height10 / 4),
        RichText(
          text: TextSpan(
            text: _money(value),
            style: TextStyle(
              fontSize: Dimensions.font20 * 0.95,
              fontWeight: FontWeight.w700,
              color: context.colors.textPrimary,
            ),
            children: [
              if (_unitSuffix.isNotEmpty)
                TextSpan(
                  text: _unitSuffix,
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.85,
                    fontWeight: FontWeight.w500,
                    color: context.colors.textSecondary,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _placeholderIcon() {
    return Icon(
      Icons.image_outlined,
      size: Dimensions.iconSize24 * 1.6,
      color: context.colors.textTertiary,
    );
  }

  Widget _buildTabs() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: Dimensions.width20),
      decoration: BoxDecoration(
        color: context.colors.surfaceLight,
        borderRadius: BorderRadius.circular(Dimensions.radius30),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
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
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: AppColors.primary,
        unselectedLabelColor: context.colors.textSecondary,
        labelStyle: TextStyle(
          fontSize: Dimensions.font16 * 0.72,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.3,
        ),
        dividerColor: Colors.transparent,
        padding: EdgeInsets.all(Dimensions.width10 / 2),
        tabs: const [
          Tab(text: 'DETAILS'),
          Tab(text: 'TRANSACTIONS'),
          Tab(text: 'HISTORY'),
        ],
      ),
    );
  }

  Widget _buildDetailsTab() {
    return ListView(
      padding: EdgeInsets.all(Dimensions.width20),
      physics: const BouncingScrollPhysics(),
      children: [
        _sectionCard(
          icon: Icons.insights_outlined,
          title: 'Stock Summary',
          trailing: Icon(
            Icons.info_outline_rounded,
            size: Dimensions.iconSize16 + 2,
            color: context.colors.textTertiary,
          ),
          child: _buildStockSummary(),
        ),
        SizedBox(height: Dimensions.height15),
        _sectionCard(
          icon: Icons.assessment_outlined,
          title: 'Stock Status',
          child: _buildStockStatus(),
        ),
        SizedBox(height: Dimensions.height15),
        _sectionCard(
          icon: Icons.sell_outlined,
          title: 'Sales & Purchase Information',
          child: _buildSalesPurchaseGrid(),
        ),
        SizedBox(height: Dimensions.height15),
        _sectionCard(
          icon: Icons.grid_view_rounded,
          title: 'More Information',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _infoField('Item Type', _itemTypeLabel()),
              _infoField('SKU', item.sku, placeholder: 'No SKU'),
              _infoField('Tax', item.tax, placeholder: 'None'),
              _infoField('Created Source', 'User'),
              _infoField('Opening Stock', _openingStockLabel(), isLast: true),
            ],
          ),
        ),
        SizedBox(height: Dimensions.height30),
      ],
    );
  }

  Widget _buildSalesPurchaseGrid() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radius15),
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        children: [
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _gridCell(
                    'Selling Price',
                    _money(item.salesPrice),
                    subtitle: _unitSuffix.trim().isEmpty
                        ? null
                        : _unitSuffix.trim(),
                  ),
                ),
                VerticalDivider(width: 1, color: context.colors.border),
                Expanded(
                  child: _gridCell(
                    'Purchase Cost',
                    _money(item.purchasePrice),
                    subtitle: _unitSuffix.trim().isEmpty
                        ? null
                        : _unitSuffix.trim(),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: context.colors.border),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _gridCell(
                    'Sales Account',
                    item.salesAccount ?? 'Sales',
                  ),
                ),
                VerticalDivider(width: 1, color: context.colors.border),
                Expanded(
                  child: _gridCell(
                    'Purchase Account',
                    item.purchaseAccount ?? 'Cost of Goods Sold',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _gridCell(String label, String value, {String? subtitle}) {
    return Padding(
      padding: EdgeInsets.all(Dimensions.width15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.8,
              color: context.colors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: Dimensions.height10 / 2),
          Text(
            value,
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.95,
              fontWeight: FontWeight.w700,
              color: context.colors.textPrimary,
            ),
          ),
          if (subtitle != null) ...[
            SizedBox(height: Dimensions.height10 / 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.75,
                color: context.colors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _infoField(
    String label,
    String? value, {
    String placeholder = '—',
    bool isLast = false,
  }) {
    final hasValue = value != null && value.isNotEmpty;
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : Dimensions.height20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.8,
              color: context.colors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: Dimensions.height10 / 2.5),
          Text(
            hasValue ? value : placeholder,
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.95,
              fontWeight: FontWeight.w600,
              color: hasValue
                  ? context.colors.textPrimary
                  : context.colors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  String _openingStockLabel() {
    final stock = item.openingStock ?? 0;
    return stock == stock.roundToDouble()
        ? stock.toStringAsFixed(0)
        : stock.toStringAsFixed(2);
  }

  String _itemTypeLabel() {
    final sales = item.salesEnabled ?? true;
    final purchase = item.purchaseEnabled ?? true;
    if (sales && purchase) return 'Sales and Purchase Items';
    if (sales) return 'Sales Items';
    if (purchase) return 'Purchase Items';
    return _titleCase(item.itemType) ?? 'Item';
  }

  Widget _buildTransactionsTab() {
    final txns = _dummyTransactions();
    return Column(
      children: [
        Container(
          color: context.colors.surfaceLight,
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.width20,
            vertical: Dimensions.height15,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: _showTxnTypeSheet,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _txnType,
                            style: TextStyle(
                              fontSize: Dimensions.font16 * 1.05,
                              fontWeight: FontWeight.w800,
                              color: context.colors.textPrimary,
                            ),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: context.colors.textPrimary,
                            size: Dimensions.iconSize24 - 2,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: Dimensions.height10 / 3),
                    Text(
                      'Total Count',
                      style: TextStyle(
                        fontSize: Dimensions.font16 * 0.78,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              _squareIconButton(Icons.filter_alt_outlined, () {
                ToastificationHelper.showInfo(
                  context,
                  'Filtering transactions is coming soon.',
                );
              }),
              SizedBox(width: Dimensions.width10),
              _squareIconButton(Icons.swap_vert_rounded, () {
                ToastificationHelper.showInfo(
                  context,
                  'Sorting transactions is coming soon.',
                );
              }),
            ],
          ),
        ),
        Expanded(
          child: txns.isEmpty
              ? _emptyState(
                  Icons.receipt_long_outlined,
                  'No transactions',
                  'Transactions for this item will appear here.',
                )
              : ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: txns.length,
                  separatorBuilder: (_, _) =>
                      Divider(height: 1, color: context.colors.border),
                  itemBuilder: (_, i) => _transactionRow(txns[i]),
                ),
        ),
      ],
    );
  }

  Widget _squareIconButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      borderRadius: BorderRadius.circular(Dimensions.radius15 / 2),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(Dimensions.width10),
        decoration: BoxDecoration(
          color: context.colors.card,
          borderRadius: BorderRadius.circular(Dimensions.radius15 / 2),
          border: Border.all(color: context.colors.border),
        ),
        child: Icon(
          icon,
          size: Dimensions.iconSize24 - 4,
          color: context.colors.textSecondary,
        ),
      ),
    );
  }

  Widget _transactionRow(_Txn txn) {
    return Container(
      color: context.colors.card,
      padding: EdgeInsets.all(Dimensions.width20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  txn.party,
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.95,
                    fontWeight: FontWeight.w800,
                    color: context.colors.textPrimary,
                  ),
                ),
                SizedBox(height: Dimensions.height10 / 3),
                Text(
                  txn.number,
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.8,
                    color: context.colors.textSecondary,
                  ),
                ),
                SizedBox(height: Dimensions.height10 / 4),
                Text(
                  formatDate(txn.date),
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.78,
                    color: context.colors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _money(txn.amount),
                style: TextStyle(
                  fontSize: Dimensions.font16 * 0.95,
                  fontWeight: FontWeight.w800,
                  color: context.colors.textPrimary,
                ),
              ),
              SizedBox(height: Dimensions.height10 / 3),
              Text(
                '${txn.quantity.toStringAsFixed(2)} * ${_money(txn.rate)}',
                style: TextStyle(
                  fontSize: Dimensions.font16 * 0.78,
                  color: context.colors.textSecondary,
                ),
              ),
              SizedBox(height: Dimensions.height10 / 4),
              Text(
                txn.status,
                style: TextStyle(
                  fontSize: Dimensions.font16 * 0.75,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showTxnTypeSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Container(
        decoration: BoxDecoration(
          color: context.colors.card,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(Dimensions.radius20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: Dimensions.height15),
            ..._txnTypes.map((t) {
              final selected = t == _txnType;
              return ListTile(
                leading: Icon(
                  selected
                      ? Icons.radio_button_checked_rounded
                      : Icons.radio_button_off_rounded,
                  color: selected
                      ? AppColors.primary
                      : context.colors.textSecondary,
                ),
                title: Text(
                  t,
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.9,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    color: context.colors.textPrimary,
                  ),
                ),
                onTap: () {
                  setState(() => _txnType = t);
                  Navigator.pop(sheetContext);
                },
              );
            }),
            SizedBox(height: Dimensions.height20),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryTab() {
    final events = _historyEvents();
    return ListView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.width20,
        vertical: Dimensions.height20,
      ),
      physics: const BouncingScrollPhysics(),
      itemCount: events.length,
      itemBuilder: (_, i) => _timelineTile(
        events[i],
        isFirst: i == 0,
        isLast: i == events.length - 1,
      ),
    );
  }

  Widget _timelineTile(
    _HistoryEvent event, {
    required bool isFirst,
    required bool isLast,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: Dimensions.iconSize16,
                height: Dimensions.iconSize16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: context.colors.card,
                  border: Border.all(color: AppColors.primary, width: 2),
                ),
              ),
              Expanded(
                child: Container(
                  width: 2,
                  color: isLast ? Colors.transparent : context.colors.border,
                ),
              ),
            ],
          ),
          SizedBox(width: Dimensions.width15),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: Dimensions.height30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.action,
                    style: TextStyle(
                      fontSize: Dimensions.font16 * 0.95,
                      fontWeight: FontWeight.w700,
                      color: context.colors.textPrimary,
                    ),
                  ),
                  SizedBox(height: Dimensions.height10 / 3),
                  Row(
                    children: [
                      Text(
                        event.by,
                        style: TextStyle(
                          fontSize: Dimensions.font16 * 0.8,
                          color: context.colors.textSecondary,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.width10,
                        ),
                        child: Text(
                          '|',
                          style: TextStyle(color: context.colors.textTertiary),
                        ),
                      ),
                      Text(
                        formatDateTime(event.at),
                        style: TextStyle(
                          fontSize: Dimensions.font16 * 0.8,
                          color: context.colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState(IconData icon, String title, String subtitle) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(Dimensions.width20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(Dimensions.width20),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.07),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: Dimensions.iconSize24 * 2,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: Dimensions.height20),
            Text(
              title,
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.95,
                fontWeight: FontWeight.w700,
                color: context.colors.textPrimary,
              ),
            ),
            SizedBox(height: Dimensions.height10),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.8,
                color: context.colors.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionCard({
    required IconData icon,
    required String title,
    required Widget child,
    Widget? trailing,
  }) {
    return Container(
      padding: EdgeInsets.all(Dimensions.width20),
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: BorderRadius.circular(Dimensions.radius15),
        boxShadow: [
          BoxShadow(
            color: const Color(0x08000000),
            blurRadius: Dimensions.radius15 * 0.53,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: Dimensions.iconSize24 - 4,
                color: AppColors.primary,
              ),
              SizedBox(width: Dimensions.width10),
              Text(
                title,
                style: TextStyle(
                  fontSize: Dimensions.font16 * 0.95,
                  fontWeight: FontWeight.w800,
                  color: context.colors.textPrimary,
                ),
              ),
              if (trailing != null) ...[
                SizedBox(width: Dimensions.width10 / 2),
                trailing,
              ],
            ],
          ),
          SizedBox(height: Dimensions.height20),
          child,
        ],
      ),
    );
  }

  Widget _buildStockSummary() {
    final stockOnHand = item.openingStock ?? 51;
    const committedStock = 21.0;
    final availableForSale = stockOnHand - committedStock;
    return Column(
      children: [
        _stockRow('Stock on Hand', stockOnHand),
        SizedBox(height: Dimensions.height15),
        _stockRow('Committed Stock', committedStock),
        SizedBox(height: Dimensions.height15),
        _stockRow('Available for Sale', availableForSale),
      ],
    );
  }

  Widget _stockRow(String label, double value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: Dimensions.font16 * 0.88,
            color: context.colors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value.toStringAsFixed(2),
          style: TextStyle(
            fontSize: Dimensions.font16 * 0.95,
            fontWeight: FontWeight.w800,
            color: context.colors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildStockStatus() {
    return Row(
      children: [
        Expanded(child: _stockStatusCell('11', 'To be Invoiced')),
        Expanded(child: _stockStatusCell('0', 'To be Billed')),
      ],
    );
  }

  Widget _stockStatusCell(String qty, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              qty,
              style: TextStyle(
                fontSize: Dimensions.font20 * 0.95,
                fontWeight: FontWeight.w800,
                color: context.colors.textPrimary,
              ),
            ),
            SizedBox(width: Dimensions.width10 / 2),
            Text(
              'Qty',
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.8,
                color: context.colors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: Dimensions.height10 / 3),
        Text(
          label,
          style: TextStyle(
            fontSize: Dimensions.font16 * 0.82,
            color: context.colors.textSecondary,
          ),
        ),
      ],
    );
  }

  String? _titleCase(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    return value
        .trim()
        .split(RegExp(r'\s+'))
        .map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}')
        .join(' ');
  }

  List<_Txn> _dummyTransactions() {
    return [
      _Txn(
        party: 'nabeel',
        number: 'QT-000001',
        date: DateTime(2026, 7, 2),
        amount: item.salesPrice,
        quantity: 1,
        rate: item.salesPrice,
        status: 'SENT',
      ),
    ];
  }

  List<_HistoryEvent> _historyEvents() {
    final created = item.createdAt ?? DateTime(2026, 6, 3, 17, 27);
    final updated = item.updatedAt ?? DateTime(2026, 6, 10, 19, 16);
    return [
      _HistoryEvent(action: 'created by', by: 'Parthiv p', at: created),
      _HistoryEvent(
        action: 'updated by',
        by: 'Parthiv p',
        at: created.add(const Duration(hours: 2, minutes: 17)),
      ),
      _HistoryEvent(action: 'updated by', by: 'Parthiv p', at: updated),
    ];
  }
}

class _Txn {
  final String party;
  final String number;
  final DateTime date;
  final double amount;
  final double quantity;
  final double rate;
  final String status;

  const _Txn({
    required this.party,
    required this.number,
    required this.date,
    required this.amount,
    required this.quantity,
    required this.rate,
    required this.status,
  });
}

class _HistoryEvent {
  final String action;
  final String by;
  final DateTime at;

  const _HistoryEvent({
    required this.action,
    required this.by,
    required this.at,
  });
}
