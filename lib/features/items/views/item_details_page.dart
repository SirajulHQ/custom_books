import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/image_helper.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/features/items/models/item_model.dart';
import 'package:custom_books/features/items/views/add_item_page.dart';
import 'package:flutter/material.dart';
import 'package:custom_books/core/widgets/skeletons/skeletons.dart';

class ItemDetailsPage extends StatefulWidget {
  final ItemModel item;

  const ItemDetailsPage({super.key, required this.item});

  @override
  State<ItemDetailsPage> createState() => _ItemDetailsPageState();
}

class _ItemDetailsPageState extends State<ItemDetailsPage> {
  bool _isLoading = true;

  ItemModel get item => widget.item;

  @override
  void initState() {
    super.initState();
    _load();
  }

  /// Simulates fetching details so the shimmer skeleton is shown briefly.
  Future<void> _load() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    onLeadingPressed: () => Navigator.pop(context),
                    actions: [
                      AppBarIconButton(
                        icon: Icons.edit_outlined,
                        color: AppColors.primary,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AddItemPage(existing: item),
                            ),
                          );
                        },
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
                        SizedBox(height: Dimensions.height30),
                      ]),
                    ),
                  ),
                ],
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
            icon: Icons.toggle_on_outlined,
            label: 'Status',
            value: item.isActive ? 'Active' : 'Inactive',
          ),
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
