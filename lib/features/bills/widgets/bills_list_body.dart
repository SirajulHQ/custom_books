import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/widgets/empty_state_widget.dart';
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
      return const EmptyStateWidget(
        icon: Icons.description_outlined,
        title: 'No bills found',
        subtitle: 'Tap the + button to record a new bill.',
      );
    }

    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      child: ListView.builder(
        padding: EdgeInsets.fromLTRB(
          Dimensions.width20,
          0,
          Dimensions.width20,
          Dimensions.listBottomSpace,
        ),
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        itemCount: bills.length,
        itemBuilder: (context, index) => BillTile(bill: bills[index]),
      ),
    );
  }
}
