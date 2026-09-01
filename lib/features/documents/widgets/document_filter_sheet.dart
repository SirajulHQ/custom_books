import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/features/documents/models/document_model.dart';
import 'package:flutter/material.dart';

class DocumentFilterSheet extends StatelessWidget {
  final DocumentType? selectedType;
  final ValueChanged<DocumentType?> onSelected;

  const DocumentFilterSheet({
    super.key,
    required this.selectedType,
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
            Text('Filter by Type', style: TextStyle(fontSize: Dimensions.font20 * 0.85, fontWeight: FontWeight.w800, color: context.colors.textPrimary)),
            SizedBox(height: Dimensions.height15),
            _FilterOption(label: 'All Types', icon: Icons.apps_rounded, isSelected: selectedType == null, onTap: () { onSelected(null); Navigator.pop(context); }),
            for (final type in DocumentType.values)
              _FilterOption(label: type.label, icon: type.iconData, isSelected: selectedType == type, onTap: () { onSelected(type); Navigator.pop(context); }),
            SizedBox(height: Dimensions.height10),
          ],
        ),
      ),
    );
  }
}

class _FilterOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  const _FilterOption({required this.label, required this.icon, required this.isSelected, required this.onTap});

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
            Icon(icon, size: Dimensions.iconSize16, color: isSelected ? AppColors.primary : context.colors.textSecondary),
            SizedBox(width: Dimensions.width10 / 2),
            Text(label, style: TextStyle(fontSize: Dimensions.font16 * 0.8, fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500, color: context.colors.textPrimary)),
          ],
        ),
      ),
    );
  }
}
