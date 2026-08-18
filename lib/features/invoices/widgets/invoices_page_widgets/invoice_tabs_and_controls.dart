import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/features/invoices/models/invoice_model.dart';
import 'package:flutter/material.dart';

class InvoiceTabsAndControls extends StatelessWidget {
  final int selectedTab;
  final ValueChanged<int> onTabSelected;
  final InvoiceStatus? statusFilter;
  final VoidCallback onFilterTap;
  final VoidCallback onSortTap;

  const InvoiceTabsAndControls({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
    required this.statusFilter,
    required this.onFilterTap,
    required this.onSortTap,
  });

  static const _tabs = ['All', 'Draft', 'Overdue', 'Paid'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        Dimensions.width20,
        Dimensions.height10 / 2,
        Dimensions.width20,
        Dimensions.height15,
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(Dimensions.height10 * 0.4),
              decoration: BoxDecoration(
                color: context.colors.surfaceLight,
                borderRadius: BorderRadius.circular(Dimensions.radius30),
              ),
              child: Row(
                children: [
                  for (int i = 0; i < _tabs.length; i++)
                    _tabButton(context, _tabs[i], i),
                ],
              ),
            ),
          ),
          SizedBox(width: Dimensions.width10),
          InkWell(
            borderRadius: BorderRadius.circular(Dimensions.radius15),
            onTap: onFilterTap,
            child: _controlBadge(
              statusFilter == null
                  ? Icons.filter_list_rounded
                  : Icons.filter_alt_rounded,
              active: statusFilter != null,
            ),
          ),
          SizedBox(width: Dimensions.width10 / 2),
          InkWell(
            borderRadius: BorderRadius.circular(Dimensions.radius15),
            onTap: onSortTap,
            child: _controlBadge(Icons.swap_vert_rounded),
          ),
        ],
      ),
    );
  }

  Widget _tabButton(BuildContext context, String label, int index) {
    final selected = selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTabSelected(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: EdgeInsets.symmetric(vertical: Dimensions.height10),
          decoration: BoxDecoration(
            color: selected ? context.colors.card : Colors.transparent,
            borderRadius: BorderRadius.circular(Dimensions.radius30),
            border: selected
                ? Border.all(
                    color: Appcolors.primary.withValues(alpha: 0.3),
                    width: 1.5,
                  )
                : null,
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: Appcolors.primary.withValues(alpha: 0.08),
                      blurRadius: Dimensions.radius15 * 0.53,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.68,
              fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
              color: selected
                  ? Appcolors.primary
                  : context.colors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _controlBadge(IconData icon, {bool active = false}) {
    return Container(
      width: Dimensions.height45 * 0.9,
      height: Dimensions.height45 * 0.9,
      decoration: BoxDecoration(
        color: (active ? Appcolors.accent : Appcolors.primary).withValues(
          alpha: 0.1,
        ),
        borderRadius: BorderRadius.circular(Dimensions.radius15),
      ),
      child: Icon(
        icon,
        size: Dimensions.iconSize24 - 4,
        color: active ? Appcolors.accent : Appcolors.primary,
      ),
    );
  }
}