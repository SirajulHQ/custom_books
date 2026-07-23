import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/features/banking/models/bank_account.dart';
import 'package:flutter/material.dart';

class ActiveAccountItem extends StatelessWidget {
  final BankAccount account;

  const ActiveAccountItem({super.key, required this.account});

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'bank':
        return Icons.account_balance_rounded;
      case 'cash':
        return Icons.money_rounded;
      case 'undeposited':
        return Icons.attach_money_rounded;
      default:
        return Icons.account_balance_wallet_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: Dimensions.height15),
      padding: EdgeInsets.all(Dimensions.width20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Dimensions.radius15),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(Dimensions.width10),
                decoration: BoxDecoration(
                  color: Appcolors.textSecondary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(
                    Dimensions.radius15 * 0.7,
                  ),
                ),
                child: Icon(
                  _getIconData(account.icon),
                  color: Appcolors.textPrimary,
                  size: Dimensions.iconSize24,
                ),
              ),
              SizedBox(width: Dimensions.width15),
              Text(
                account.name,
                style: TextStyle(
                  fontSize: Dimensions.font20 * 0.85,
                  color: Appcolors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: Dimensions.height20),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Amount In Zoho Books',
                      style: TextStyle(
                        fontSize: Dimensions.font16 * 0.7,
                        color: Appcolors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: Dimensions.height10 / 2),
                    Text(
                      '₹${account.amountInZohoBooks.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: Dimensions.font20 * 0.85,
                        color: Appcolors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: Dimensions.width10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Amount In Bank',
                      style: TextStyle(
                        fontSize: Dimensions.font16 * 0.7,
                        color: Appcolors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: Dimensions.height10 / 2),
                    Text(
                      '₹${account.amountInBank.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: Dimensions.font20 * 0.85,
                        color: Appcolors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
