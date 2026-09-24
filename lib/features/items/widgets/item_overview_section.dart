import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/widgets/bottom_sheet_drag_handle.dart';
import 'package:custom_books/core/widgets/empty_state_widget.dart';
import 'package:custom_books/core/widgets/form_widgets.dart';
import 'package:custom_books/features/items/widgets/item_image_picker.dart';
import 'package:custom_books/features/items/widgets/selection_dropdown_field.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// Overview card for the add/edit item page.
///
/// Owns the item type selection, image picker, name/SKU/unit fields, the GTIN
/// picker (including its search bottom sheet) and the excise-product checkbox.
class ItemOverviewSection extends StatefulWidget {
  final String itemType;
  final ValueChanged<String> onItemTypeChanged;

  final XFile? itemImage;
  final ValueChanged<XFile?> onImagePicked;
  final VoidCallback onImageRemoved;

  final TextEditingController itemNameController;
  final TextEditingController skuController;
  final TextEditingController unitController;

  final List<String> gtinOptions;
  final String selectedGtin;
  final ValueChanged<String> onGtinSelected;

  final bool isExciseProduct;
  final ValueChanged<bool> onExciseProductChanged;

  const ItemOverviewSection({
    super.key,
    required this.itemType,
    required this.onItemTypeChanged,
    required this.itemImage,
    required this.onImagePicked,
    required this.onImageRemoved,
    required this.itemNameController,
    required this.skuController,
    required this.unitController,
    required this.gtinOptions,
    required this.selectedGtin,
    required this.onGtinSelected,
    required this.isExciseProduct,
    required this.onExciseProductChanged,
  });

  @override
  State<ItemOverviewSection> createState() => _ItemOverviewSectionState();
}

class _ItemOverviewSectionState extends State<ItemOverviewSection> {
  final TextEditingController _gtinSearchController = TextEditingController();

  @override
  void dispose() {
    _gtinSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormCard(
      borderRadius: Dimensions.radius20,
      showShadow: true,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Item Type',
                    style: TextStyle(
                      fontSize: Dimensions.font16 * 0.9,
                      fontWeight: FontWeight.w700,
                      color: context.colors.textPrimary,
                    ),
                  ),
                  SizedBox(height: Dimensions.height10),
                  Container(
                    decoration: BoxDecoration(
                      color: context.colors.surfaceLight,
                      borderRadius: BorderRadius.circular(
                        Dimensions.radius15 / 2,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.width10,
                      vertical: Dimensions.height10 / 2,
                    ),
                    child: Column(
                      children: [
                        _buildRadioOption('Goods', Icons.inventory_2_outlined),
                        _buildRadioOption(
                          'Service',
                          Icons.home_repair_service_outlined,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: Dimensions.width15),
            Expanded(
              flex: 2,
              child: ItemImagePicker(
                image: widget.itemImage,
                onImagePicked: widget.onImagePicked,
                onRemove: widget.onImageRemoved,
              ),
            ),
          ],
        ),
        SizedBox(height: Dimensions.height20),
        Divider(height: 1, color: context.colors.border),
        SizedBox(height: Dimensions.height20),
        _buildTextField(
          'Item Name',
          widget.itemNameController,
          isRequired: true,
          icon: Icons.inventory_outlined,
        ),
        SizedBox(height: Dimensions.height20),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                'SKU',
                widget.skuController,
                hasInfo: true,
                hasScan: true,
                icon: Icons.qr_code_2_outlined,
              ),
            ),
            SizedBox(width: Dimensions.width15),
            Expanded(
              child: _buildTextField(
                'Unit',
                widget.unitController,
                hint: 'e.g., pcs, kg, box',
                icon: Icons.straighten_outlined,
              ),
            ),
          ],
        ),
        SizedBox(height: Dimensions.height20),
        GestureDetector(
          onTap: _showGtinSearchSheet,
          child: SelectionDropdownField(
            label: 'GTIN',
            value: widget.selectedGtin,
          ),
        ),
        SizedBox(height: Dimensions.height15),
        _buildCheckbox(
          'It is an excise product',
          widget.isExciseProduct,
          (value) => widget.onExciseProductChanged(value ?? false),
        ),
      ],
    );
  }

  Widget _buildRadioOption(String label, IconData icon) {
    final isSelected = widget.itemType == label;
    return GestureDetector(
      onTap: () {
        widget.onItemTypeChanged(label);
        appLog('📝 Item type changed to: $label', name: 'ItemOverviewSection');
      },
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.all(Dimensions.width10),
            child: Container(
              width: Dimensions.height20,
              height: Dimensions.height20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : context.colors.textTertiary,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: Dimensions.height10,
                        height: Dimensions.height10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary,
                        ),
                      ),
                    )
                  : null,
            ),
          ),
          Icon(
            icon,
            size: Dimensions.iconSize16,
            color: context.colors.textSecondary,
          ),
          SizedBox(width: Dimensions.width10 / 2),
          Text(
            label,
            style: TextStyle(
              fontSize: Dimensions.font16,
              color: context.colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController? controller, {
    bool isRequired = false,
    bool hasInfo = false,
    bool hasScan = false,
    bool hasAdd = false,
    String? hint,
    String? prefix,
    IconData? icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: Dimensions.iconSize16, color: AppColors.primary),
              SizedBox(width: Dimensions.width10 / 2),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.85,
                fontWeight: FontWeight.w600,
                color: context.colors.textPrimary,
              ),
            ),
            if (isRequired)
              Text(
                ' *',
                style: TextStyle(
                  fontSize: Dimensions.font16 * 0.85,
                  fontWeight: FontWeight.w700,
                  color: AppColors.error,
                ),
              ),
            if (hasInfo) ...[
              SizedBox(width: Dimensions.width10 / 2),
              Icon(
                Icons.info_outline,
                size: Dimensions.iconSize16 * 0.9,
                color: context.colors.textTertiary,
              ),
            ],
          ],
        ),
        SizedBox(height: Dimensions.height10 * 0.7),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: TextStyle(
            fontSize: Dimensions.font16,
            fontWeight: FontWeight.w500,
            color: context.colors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            prefixText: prefix != null ? '$prefix ' : null,
            prefixStyle: TextStyle(
              fontSize: Dimensions.font16,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
            hintStyle: TextStyle(
              fontSize: Dimensions.font16,
              color: context.colors.textTertiary,
            ),
            suffixIcon: hasScan
                ? Icon(
                    Icons.qr_code_scanner,
                    color: AppColors.primary,
                    size: Dimensions.iconSize24 * 0.9,
                  )
                : hasAdd
                ? Icon(
                    Icons.add_circle_outline,
                    color: AppColors.primary,
                    size: Dimensions.iconSize24 * 0.9,
                  )
                : null,
            filled: true,
            fillColor: context.colors.surfaceLight,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius15),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius15),
              borderSide: BorderSide(color: context.colors.border, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius15),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: Dimensions.width15,
              vertical: Dimensions.height15,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckbox(String label, bool value, Function(bool?) onChanged) {
    return Row(
      children: [
        SizedBox(
          width: Dimensions.iconSize24,
          height: Dimensions.iconSize24,
          child: Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius15 * 0.27),
            ),
          ),
        ),
        SizedBox(width: Dimensions.width10),
        Text(
          label,
          style: TextStyle(
            fontSize: Dimensions.font16,
            color: context.colors.textPrimary,
          ),
        ),
      ],
    );
  }

  void _showGtinSearchSheet() {
    _gtinSearchController.clear();

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
          ),
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(sheetContext).size.height * 0.75,
            ),
            decoration: BoxDecoration(
              color: context.colors.card,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(Dimensions.radius20),
              ),
            ),
            child: StatefulBuilder(
              builder: (context, setSheetState) {
                final query = _gtinSearchController.text.trim().toLowerCase();
                final results = query.isEmpty
                    ? widget.gtinOptions
                    : widget.gtinOptions
                          .where((g) => g.toLowerCase().contains(query))
                          .toList();

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const BottomSheetDragHandle(),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.width20,
                      ),
                      child: Text(
                        'GTIN',
                        style: TextStyle(
                          fontSize: Dimensions.font20,
                          fontWeight: FontWeight.w800,
                          color: context.colors.textPrimary,
                        ),
                      ),
                    ),
                    SizedBox(height: Dimensions.height15),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.width20,
                      ),
                      child: TextField(
                        controller: _gtinSearchController,
                        autofocus: true,
                        onChanged: (_) => setSheetState(() {}),
                        style: TextStyle(
                          fontSize: Dimensions.font16,
                          color: context.colors.textPrimary,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search',
                          prefixIcon: Icon(
                            Icons.search,
                            color: context.colors.textSecondary,
                            size: Dimensions.iconSize24 * 0.9,
                          ),
                          hintStyle: TextStyle(
                            fontSize: Dimensions.font16,
                            color: context.colors.textTertiary,
                          ),
                          filled: true,
                          fillColor: context.colors.surfaceLight,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              Dimensions.radius15,
                            ),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              Dimensions.radius15,
                            ),
                            borderSide: BorderSide(
                              color: context.colors.border,
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              Dimensions.radius15,
                            ),
                            borderSide: BorderSide(
                              color: AppColors.primary,
                              width: 2,
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: Dimensions.width15,
                            vertical: Dimensions.height15,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: Dimensions.height15),
                    Flexible(
                      child: results.isEmpty
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: Dimensions.height30,
                              ),
                              child: const EmptyStateWidget(
                                icon: Icons.inventory_2_outlined,
                                title: 'No result found',
                                subtitle: '',
                              ),
                            )
                          : ListView(
                              shrinkWrap: true,
                              padding: EdgeInsets.only(
                                bottom: Dimensions.height20,
                              ),
                              children: results.map((gtin) {
                                final isSelected = gtin == widget.selectedGtin;
                                return ListTile(
                                  leading: Icon(
                                    isSelected
                                        ? Icons.radio_button_checked_rounded
                                        : Icons.radio_button_off_rounded,
                                    color: isSelected
                                        ? AppColors.primary
                                        : context.colors.textSecondary,
                                  ),
                                  title: Text(
                                    gtin,
                                    style: TextStyle(
                                      fontSize: Dimensions.font16 * 0.9,
                                      fontWeight: isSelected
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                      color: context.colors.textPrimary,
                                    ),
                                  ),
                                  onTap: () {
                                    widget.onGtinSelected(gtin);
                                    appLog(
                                      '🏷️ GTIN selected: $gtin',
                                      name: 'ItemOverviewSection',
                                    );
                                    Navigator.pop(sheetContext);
                                  },
                                );
                              }).toList(),
                            ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
