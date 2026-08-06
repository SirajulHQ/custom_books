import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/features/bills/views/add_bill_page.dart';
import 'package:custom_books/features/customers/views/add_customer_page.dart';
import 'package:custom_books/features/expenses/views/add_expense_page.dart';
import 'package:custom_books/features/home/models/action_item_model.dart';
import 'package:custom_books/features/invoices/views/new_invoice_page.dart';
import 'package:flutter/material.dart';

class QuickActionsGridWidget extends StatelessWidget {
  const QuickActionsGridWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      ActionItemModel(
        Icons.person_add_alt_1_rounded,
        'Customer',
        Appcolors.primary,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddCustomerPage()),
        ),
      ),
      ActionItemModel(
        Icons.note_add_rounded,
        'Invoice',
        Appcolors.primaryLight,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const NewInvoicePage()),
        ),
      ),
      ActionItemModel(
        Icons.assignment_rounded,
        'Bill',
        Appcolors.accent,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddBillPage()),
        ),
      ),
      ActionItemModel(
        Icons.shopping_bag_rounded,
        'Expense',
        Appcolors.warn,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddExpensePage()),
        ),
      ),
    ];

    return Container(
      padding: EdgeInsets.all(Dimensions.width15),
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: BorderRadius.circular(Dimensions.radius20),
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: Dimensions.font16,
              fontWeight: FontWeight.w800,
              color: context.colors.textPrimary,
            ),
          ),
          SizedBox(height: Dimensions.height15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items.map((item) => _ActionTile(item: item)).toList(),
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final ActionItemModel item;

  const _ActionTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: item.onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(Dimensions.width15 * 0.8),
            decoration: BoxDecoration(
              color: item.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(Dimensions.radius15),
            ),
            child: Icon(
              item.icon,
              size: Dimensions.iconSize24,
              color: item.color,
            ),
          ),
          SizedBox(height: Dimensions.height10 * 0.6),
          Text(
            "New\n${item.label}",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.72,
              fontWeight: FontWeight.w700,
              color: context.colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
