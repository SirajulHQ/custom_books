import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/features/purchase_orders/models/purchase_order_model.dart';
import 'package:flutter/material.dart';

class PurchaseOrderFilterSheet extends StatelessWidget {
  final PurchaseOrderStatus? selectedStatus;
  final ValueChanged<PurchaseOrderStatus?> onSelected;

  const PurchaseOrderFilterSheet({
    super.key,
    required this.selectedStatus,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(Dimensions.width20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Filter by Status', style: TextStyle(fontSize: Dimensions.font20 * 0.85, fontWeight: FontWeight.w800, color: context.colors.textPrimary)),
            SizedBox(height: Dimensions.height15),
            _FilterOption(label: 'All Statuses', isSelected: selectedStatus == null, onTap: () { onSelected(null); Navigator.pop(context); }),
            for (final status in PurchaseOrderStatus.values)
              _FilterOption(label: status.label, isSelected: selectedStatus == status, onTap: () { onSelected(status); Navigator.pop(context); }),
            SizedBox(height: Dimensions.height10),
          ],
        ),
      ),
    );
  }
}

class _FilterOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const _FilterOption({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(Dimensions.radius15),
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: Dimensions.height10 / 2),
        padding: EdgeInsets.symmetric(horizontal: Dimensions.width15, vertical: Dimensions.height10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.08) : context.colors.surfaceLight,
          borderRadius: BorderRadius.circular(Dimensions.radius15),
          border: Border.all(color: isSelected ? AppColors.primary : context.colors.border),
        ),
        child: Row(
          children: [
            Icon(isSelected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded, size: Dimensions.iconSize16 + 2, color: isSelected ? AppColors.primary : context.colors.textTertiary),
            SizedBox(width: Dimensions.width10),
            Text(label, style: TextStyle(fontSize: Dimensions.font16 * 0.8, fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500, color: context.colors.textPrimary)),
          ],
        ),
      ),
    );
  }
}
