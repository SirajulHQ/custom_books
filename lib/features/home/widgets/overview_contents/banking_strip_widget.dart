import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/features/home/models/bank_entry_model.dart';
import 'package:flutter/material.dart';

class BankingStripWidget extends StatelessWidget {
  const BankingStripWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final entries = [
      BankEntryModel('Bank Balance', '₹306.73', Icons.account_balance_rounded),
      BankEntryModel('Cash In Hand', '₹6,135.00', Icons.wallet_rounded),
    ];
    return SizedBox(
      height: Dimensions.height45 * 2.3,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: entries.length,
        separatorBuilder: (_, index) => SizedBox(width: Dimensions.width15),
        itemBuilder: (context, i) {
          final e = entries[i];
          return Container(
            width: Dimensions.screenWidth * 0.55,
            padding: EdgeInsets.all(Dimensions.width15),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Appcolors.primary, Appcolors.primaryLight],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(Dimensions.radius20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  e.icon,
                  color: Colors.white,
                  size: Dimensions.iconSize24 - 4,
                ),
                Text(
                  e.value,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Dimensions.font20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  e.label,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: Dimensions.font16 * 0.8,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}