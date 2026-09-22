import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/features/home/models/bank_entry_model.dart';
import 'package:custom_books/features/home/models/dashboard_overview_model.dart';
import 'package:flutter/material.dart';

class BankingStripWidget extends StatelessWidget {
  final DashboardOverviewModel? data;

  const BankingStripWidget({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    final entries = [
      BankEntryModel(
        'Bank Balance',
        data != null ? '${data!.currencySymbol}${data!.bankBalance}' : '—',
        Icons.account_balance_rounded,
      ),
      BankEntryModel(
        'Cash In Hand',
        data != null ? '${data!.currencySymbol}${data!.cashInHand}' : '—',
        Icons.wallet_rounded,
      ),
    ];
    return SizedBox(
      height: Dimensions.height45 * 2.3,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < entries.length; i++) ...[
            if (i > 0) SizedBox(width: Dimensions.width15),
            Expanded(child: _BankTile(entry: entries[i])),
          ],
        ],
      ),
    );
  }
}

class _BankTile extends StatelessWidget {
  final BankEntryModel entry;

  const _BankTile({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Dimensions.width15),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
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
            entry.icon,
            color: Colors.white,
            size: Dimensions.iconSize24 - 4,
          ),
          Text(
            entry.value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
              fontSize: Dimensions.font20,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            entry.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white70,
              fontSize: Dimensions.font16 * 0.8,
            ),
          ),
        ],
      ),
    );
  }
}
