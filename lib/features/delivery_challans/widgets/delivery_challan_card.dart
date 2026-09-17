import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/date_formatter.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/widgets/document_list_tile.dart';
import 'package:custom_books/core/widgets/status_chip.dart';
import 'package:custom_books/features/delivery_challans/models/delivery_challan_model.dart';
import 'package:custom_books/features/delivery_challans/views/delivery_challan_details_page.dart';
import 'package:flutter/material.dart';

class DeliveryChallanCard extends StatelessWidget {
  final DeliveryChallanModel challan;

  const DeliveryChallanCard({super.key, required this.challan});

  @override
  Widget build(BuildContext context) {
    return DocumentListTile(
      leadingIcon: Icons.local_shipping_outlined,
      leadingColor: AppColors.primary,
      primaryText: challan.customerName,
      date: formatDate(challan.challanDate),
      documentNumber: challan.challanNumber,
      statusWidget: StatusChip(
        color: challan.status.color,
        label: challan.status.label,
      ),
      trailingBadge: _ChallanTypeBadge(type: challan.type),
      amount: '₹${challan.total.toStringAsFixed(2)}',
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DeliveryChallanDetailsPage(challan: challan),
        ),
      ),
    );
  }
}

class _ChallanTypeBadge extends StatelessWidget {
  final String type;

  const _ChallanTypeBadge({required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.width10 * 0.7,
        vertical: Dimensions.height10 * 0.2,
      ),
      decoration: BoxDecoration(
        color: context.colors.surfaceLight,
        borderRadius: BorderRadius.circular(Dimensions.radius30),
      ),
      child: Text(
        type,
        style: TextStyle(
          fontSize: Dimensions.font16 * 0.6,
          color: context.colors.textSecondary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
