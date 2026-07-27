import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/features/home/models/action_item_model.dart';
import 'package:flutter/material.dart';

class QuickActionsGridWidget extends StatelessWidget {
  const QuickActionsGridWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      ActionItemModel(Icons.person_add_alt_1_rounded, 'Customer', Appcolors.primary),
      ActionItemModel(Icons.note_add_rounded, 'Invoice', Appcolors.primaryLight),
      ActionItemModel(Icons.assignment_rounded, 'Bill', Appcolors.accent),
      ActionItemModel(Icons.shopping_bag_rounded, 'Expense', Appcolors.warn),
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
            ),
          ),
          SizedBox(height: Dimensions.height15),
          Wrap(
            spacing: Dimensions.width10,
            runSpacing: Dimensions.height15,
            children: items.map((item) {
              return SizedBox(
                width:
                    (Dimensions.screenWidth -
                        Dimensions.width20 * 2 -
                        Dimensions.width15 * 2 -
                        Dimensions.width10 * 3) /
                    4,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(Dimensions.width15 * 0.7),
                      decoration: BoxDecoration(
                        color: item.color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(
                          Dimensions.radius15,
                        ),
                      ),
                      child: Icon(
                        item.icon,
                        size: Dimensions.iconSize24 - 4,
                        color: item.color,
                      ),
                    ),
                    SizedBox(height: Dimensions.height10 / 2),
                    Text(
                      item.label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: Dimensions.font16 * 0.7,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}