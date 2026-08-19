import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/features/bills/models/bill_model.dart';
import 'package:custom_books/features/bills/widgets/bill_tile.dart';
import 'package:flutter/material.dart';

class BillsListBody extends StatelessWidget {
  final List<BillModel> bills;
  final VoidCallback onRefresh;

  const BillsListBody({
    super.key,
    required this.bills,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (bills.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: Dimensions.height45 * 1.6,
                height: Dimensions.height45 * 1.6,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.description_outlined,
                  size: Dimensions.iconSize24 * 1.3,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: Dimensions.height15),
              Text(
                'No bills found',
                style: TextStyle(
                  fontSize: Dimensions.font16,
                  fontWeight: FontWeight.w700,
                  color: context.colors.textPrimary,
                ),
              ),
              SizedBox(height: Dimensions.height10 / 2),
              Text(
                'Tap the + button to record a new bill.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: Dimensions.font16 * 0.75,
                  color: context.colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        itemCount: bills.length,
        itemBuilder: (context, index) => BillTile(bill: bills[index]),
      ),
    );
  }
}
