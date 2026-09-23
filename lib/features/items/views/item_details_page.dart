import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/image_helper.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/core/widgets/confirmation_dialog.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
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

class _ItemDetailsPageState extends State<ItemDetailsPage> {
  final ItemDetailController _controller = ItemDetailController();
  final ItemFormController _formController = ItemFormController();

  bool _isLoading = true;

  /// Set when the item is edited from this page, so the list can refresh when
  /// the user navigates back.
  bool _didChange = false;

  /// Starts with the item passed from the list, then gets replaced by the
  /// full detail fetched from the API.
  late ItemModel item = widget.item;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _controller.dispose();
    _formController.dispose();
    super.dispose();
  }

  /// Opens the add form prefilled from this item to create a copy.
  Future<void> _cloneItem() async {
    final created = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => AddEditItemPage(cloneFrom: item)),
    );
    if (created == true && mounted) {
      // A new item was created; the list should refresh on back.
      _didChange = true;
      ToastificationHelper.showSuccess(context, 'Item cloned successfully.');
    }
  }

  /// Deletes the item via the API and returns to the list on success.
  Future<void> _deleteItem() async {
    final ok = await _formController.delete(item.id);
    if (!mounted) return;
    if (ok) {
      ToastificationHelper.showSuccess(context, 'Item deleted successfully.');
      // Pop back to the list with `true` so it refreshes.
      Navigator.pop(context, true);
    } else {
      ToastificationHelper.showError(
        context,
        _formController.errorMessage ?? 'Could not delete the item.',
      );
    }
  }

  /// Toggles the item's active status via the update API.
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

  /// Fetches the full item details from the API.
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

  /// Opens the "more options" bottom sheet for this item.
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
        body: SafeArea(
          child: _isLoading
              ? const DetailsPageSkeleton(
                  headerStyle: DetailsHeaderStyle.avatar,
                  showTabs: false,
                )
              : CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    CustomSliverAppBar(
                      title: item.name,
                      leadingType: AppBarLeadingType.back,
                      onLeadingPressed: () =>
                          Navigator.pop(context, _didChange),
                      actions: [
                        AppBarIconButton(
                          icon: Icons.edit_outlined,
                          color: AppColors.primary,
                          onPressed: () async {
                            final updated = await Navigator.push<bool>(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AddEditItemPage(existing: item),
                              ),
                            );
                            // Re-fetch the details so the page reflects the edit,
                            // and remember to refresh the list on back.
                            if (updated == true && mounted) {
                              _didChange = true;
                              _load();
                            }
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
                    SliverToBoxAdapter(child: _buildHeaderSection(context)),
                    SliverPadding(
                      padding: EdgeInsets.all(Dimensions.width20),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          _buildPricingSection(context),
                          SizedBox(height: Dimensions.height15),
                          _buildDetailsSection(context),
                          SizedBox(height: Dimensions.height15),
                          _buildAccountsSection(context),
                          SizedBox(height: Dimensions.height30),
                        ]),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Dimensions.width20),
      decoration: BoxDecoration(
        color: context.colors.card,
        border: Border(
          bottom: BorderSide(color: context.colors.border, width: 1),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Item image / placeholder
          Container(
            width: Dimensions.height45 * 1.8,
            height: Dimensions.height45 * 1.8,
            decoration: BoxDecoration(
              color: context.colors.surfaceLight,
              borderRadius: BorderRadius.circular(Dimensions.radius15),
            ),
            child: item.imageUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(Dimensions.radius15),
                    child: ImageHelper.buildImage(
                      item.imageUrl!,
                      fit: BoxFit.cover,
                      errorWidget: _buildPlaceholderIcon(context),
                    ),
                  )
                : _buildPlaceholderIcon(context),
          ),
          SizedBox(width: Dimensions.width15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TextStyle(
                    fontSize: Dimensions.font20,
                    fontWeight: FontWeight.w800,
                    color: context.colors.textPrimary,
                  ),
                ),
                if (item.sku != null) ...[
                  SizedBox(height: Dimensions.height10 / 2),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.width10,
                      vertical: Dimensions.height10 / 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(
                        Dimensions.radius15 / 2,
                      ),
                    ),
                    child: Text(
                      'SKU: ${item.sku}',
                      style: TextStyle(
                        fontSize: Dimensions.font16 * 0.7,
                        fontWeight: FontWeight.w600,
                        color: AppColors.accent,
                      ),
                    ),
                  ),
                ],
                SizedBox(height: Dimensions.height10),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.width10 * 1.2,
                    vertical: Dimensions.height10 * 0.5,
                  ),
                  decoration: BoxDecoration(
                    color: (item.isActive ? AppColors.success : AppColors.error)
                        .withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(Dimensions.radius30),
                  ),
                  child: Text(
                    item.isActive ? 'ACTIVE' : 'INACTIVE',
                    style: TextStyle(
                      fontSize: Dimensions.font16 * 0.62,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.6,
                      color: item.isActive
                          ? AppColors.success
                          : AppColors.error,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Dimensions.width20),
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: BorderRadius.circular(Dimensions.radius15),
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PRICING',
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.7,
              fontWeight: FontWeight.w700,
              color: context.colors.textTertiary,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: Dimensions.height20),
          Row(
            children: [
              Expanded(
                child: _buildPriceBox(
                  context,
                  'Sales Price',
                  '₹${item.salesPrice.toStringAsFixed(2)}',
                  AppColors.ok,
                  Icons.call_made_rounded,
                ),
              ),
              SizedBox(width: Dimensions.width10),
              Expanded(
                child: _buildPriceBox(
                  context,
                  'Purchase Price',
                  '₹${item.purchasePrice.toStringAsFixed(2)}',
                  AppColors.primary,
                  Icons.call_received_rounded,
                ),
              ),
            ],
          ),
          SizedBox(height: Dimensions.height15),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.width15,
              vertical: Dimensions.height10,
            ),
            decoration: BoxDecoration(
              color: (item.profit >= 0 ? AppColors.success : AppColors.error)
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(Dimensions.radius15 / 2),
            ),
            child: Row(
              children: [
                Icon(
                  item.profit >= 0
                      ? Icons.trending_up_rounded
                      : Icons.trending_down_rounded,
                  size: Dimensions.iconSize24 * 0.9,
                  color: item.profit >= 0 ? AppColors.success : AppColors.error,
                ),
                SizedBox(width: Dimensions.width10),
                Text(
                  item.profit >= 0 ? 'Profit per unit' : 'Loss per unit',
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.85,
                    fontWeight: FontWeight.w600,
                    color: context.colors.textSecondary,
                  ),
                ),
                const Spacer(),
                Text(
                  '${item.profit >= 0 ? '+' : ''}₹${item.profitDisplay}',
                  style: TextStyle(
                    fontSize: Dimensions.font16,
                    fontWeight: FontWeight.w800,
                    color: item.profit >= 0
                        ? AppColors.success
                        : AppColors.error,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Dimensions.width20),
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: BorderRadius.circular(Dimensions.radius15),
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ITEM DETAILS',
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.7,
              fontWeight: FontWeight.w700,
              color: context.colors.textTertiary,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: Dimensions.height20),
          _buildDetailRow(
            context,
            icon: Icons.inventory_2_outlined,
            label: 'Item Name',
            value: item.name,
          ),
          SizedBox(height: Dimensions.height20),
          _buildDetailRow(
            context,
            icon: Icons.qr_code_2_outlined,
            label: 'SKU',
            value: item.sku,
            placeholder: 'No SKU',
          ),
          SizedBox(height: Dimensions.height20),
          _buildDetailRow(
            context,
            icon: Icons.category_outlined,
            label: 'Item Type',
            value: _titleCase(item.itemType),
          ),
          SizedBox(height: Dimensions.height20),
          _buildDetailRow(
            context,
            icon: Icons.straighten_outlined,
            label: 'Unit',
            value: item.unit,
            placeholder: 'Not set',
          ),
          SizedBox(height: Dimensions.height20),
          _buildDetailRow(
            context,
            icon: Icons.trending_up_outlined,
            label: 'Margin',
            value: item.margin != null
                ? '${item.margin!.toStringAsFixed(2)}%'
                : null,
            placeholder: '—',
          ),
          SizedBox(height: Dimensions.height20),
          _buildDetailRow(
            context,
            icon: Icons.inventory_outlined,
            label: 'Track Inventory',
            value: item.trackInventory == null
                ? null
                : (item.trackInventory! ? 'Yes' : 'No'),
          ),
          if (item.trackInventory == true) ...[
            SizedBox(height: Dimensions.height20),
            _buildDetailRow(
              context,
              icon: Icons.calculate_outlined,
              label: 'Valuation Method',
              value: item.valuationMethod?.toUpperCase(),
              placeholder: 'Not set',
            ),
          ],
          SizedBox(height: Dimensions.height20),
          _buildDetailRow(
            context,
            icon: Icons.toggle_on_outlined,
            label: 'Status',
            value: item.isActive ? 'Active' : 'Inactive',
          ),
        ],
      ),
    );
  }

  Widget _buildAccountsSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Dimensions.width20),
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: BorderRadius.circular(Dimensions.radius15),
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SALES & PURCHASE',
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.7,
              fontWeight: FontWeight.w700,
              color: context.colors.textTertiary,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: Dimensions.height20),
          _buildDetailRow(
            context,
            icon: Icons.call_made_rounded,
            label: 'Sales Account',
            value: item.salesEnabled == false
                ? 'Sales disabled'
                : item.salesAccount,
            placeholder: 'Not set',
          ),
          if (item.salesDescription != null) ...[
            SizedBox(height: Dimensions.height20),
            _buildDetailRow(
              context,
              icon: Icons.notes_rounded,
              label: 'Sales Description',
              value: item.salesDescription,
            ),
          ],
          SizedBox(height: Dimensions.height20),
          _buildDetailRow(
            context,
            icon: Icons.call_received_rounded,
            label: 'Purchase Account',
            value: item.purchaseEnabled == false
                ? 'Purchase disabled'
                : item.purchaseAccount,
            placeholder: 'Not set',
          ),
          if (item.purchaseDescription != null) ...[
            SizedBox(height: Dimensions.height20),
            _buildDetailRow(
              context,
              icon: Icons.notes_rounded,
              label: 'Purchase Description',
              value: item.purchaseDescription,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    String? value,
    String placeholder = '—',
  }) {
    final hasValue = value != null && value.isNotEmpty;
    return Row(
      children: [
        Container(
          width: Dimensions.height45,
          height: Dimensions.height45,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(Dimensions.radius15 / 1.5),
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: Dimensions.iconSize24,
          ),
        ),
        SizedBox(width: Dimensions.width15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: Dimensions.font16 * 0.9,
                  fontWeight: FontWeight.w700,
                  color: context.colors.textPrimary,
                ),
              ),
              SizedBox(height: Dimensions.height10 / 3),
              Text(
                hasValue ? value : placeholder,
                style: TextStyle(
                  fontSize: Dimensions.font16 * 0.8,
                  color: hasValue
                      ? context.colors.textSecondary
                      : context.colors.textTertiary,
                  fontWeight: hasValue ? FontWeight.w500 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Capitalises the first letter of each word (e.g. "goods" -> "Goods").
  String? _titleCase(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    return value
        .trim()
        .split(RegExp(r'\s+'))
        .map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}')
        .join(' ');
  }

  Widget _buildPlaceholderIcon(BuildContext context) {
    return Icon(
      Icons.image_outlined,
      size: Dimensions.iconSize24 * 1.5,
      color: context.colors.textTertiary,
    );
  }

  Widget _buildPriceBox(
    BuildContext context,
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: EdgeInsets.all(Dimensions.width10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(Dimensions.radius15 / 2),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: Dimensions.iconSize16 * 0.8, color: color),
              SizedBox(width: Dimensions.width10 / 3),
              Text(
                label,
                style: TextStyle(
                  fontSize: Dimensions.font16 * 0.65,
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: Dimensions.height10 / 3),
          Text(
            value,
            style: TextStyle(
              fontSize: Dimensions.font16,
              fontWeight: FontWeight.w700,
              color: context.colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
