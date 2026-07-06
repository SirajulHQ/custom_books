// -------- Balances Grid Widget --------
import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/features/home/models/balance_tile_model.dart';
import 'package:flutter/material.dart';

class BalancesGridWidget extends StatelessWidget {
  const BalancesGridWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final tiles = [
      BalanceTileModel(
        'Receivables',
        'AED5,886.00',
        Icons.call_received_rounded,
        Appcolors.primary,
      ),
      BalanceTileModel(
        'Payables',
        'AED0.00',
        Icons.call_made_rounded,
        Appcolors.accent,
      ),
      BalanceTileModel(
        'Overdue Invoices',
        '6',
        Icons.error_outline_rounded,
        Appcolors.warn,
      ),
      BalanceTileModel(
        'Overdue Bills',
        '0',
        Icons.check_circle_outline_rounded,
        Appcolors.ok,
      ),
    ];
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: Dimensions.height15,
      crossAxisSpacing: Dimensions.width15,
      childAspectRatio: 1.5,
      children: tiles.map((t) => BalanceTile(data: t)).toList(),
    );
  }
}

// -------- Balance Tile Widget --------
class BalanceTile extends StatelessWidget {
  final BalanceTileModel data;

  const BalanceTile({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Dimensions.width15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Dimensions.radius20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: data.color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              data.icon,
              size: Dimensions.iconSize16,
              color: data.color,
            ),
          ),
          Text(
            data.value,
            style: TextStyle(
              fontSize: Dimensions.font20,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF0F172A),
            ),
          ),
          Text(
            data.label,
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.75,
              color: Colors.black54,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}