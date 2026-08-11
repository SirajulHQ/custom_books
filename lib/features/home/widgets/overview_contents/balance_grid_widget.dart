// -------- Balances Grid Widget --------
import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/features/home/models/balance_tile_model.dart';
import 'package:custom_books/features/home/widgets/payables_sheet.dart';
import 'package:custom_books/features/home/widgets/receivables_sheet.dart';
import 'package:custom_books/features/invoices/views/invoices_page.dart';
import 'package:custom_books/features/bills/views/bills_page.dart';
import 'package:flutter/material.dart';

class BalancesGridWidget extends StatelessWidget {
  const BalancesGridWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final tiles = [
      BalanceTileModel(
        'Receivables',
        '₹5,886.00',
        Icons.call_received_rounded,
        Appcolors.primary,
      ),
      BalanceTileModel(
        'Payables',
        '₹0.00',
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

    // Tab index: 0 = Receivables, 1 = Payables, null = no sheet
    final tapHandlers = <VoidCallback?>[
      () => showReceivablesSheet(context),
      () => showPayablesSheet(context),
      () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const InvoicesPage(initialTab: 2)),
      ),
      () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const BillsPage(initialTab: 2)),
      ),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: Dimensions.height15,
      crossAxisSpacing: Dimensions.width15,
      childAspectRatio: 1.5,
      children: List.generate(
        tiles.length,
        (i) => BalanceTile(data: tiles[i], onTap: tapHandlers[i]),
      ),
    );
  }
}

// -------- Balance Tile Widget --------
class BalanceTile extends StatelessWidget {
  final BalanceTileModel data;
  final VoidCallback? onTap;

  const BalanceTile({super.key, required this.data, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(Dimensions.width15),
        decoration: BoxDecoration(
          color: context.colors.card,
          borderRadius: BorderRadius.circular(Dimensions.radius20),
          border: Border.all(color: context.colors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(Dimensions.width10 * 0.6),
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
                if (onTap != null)
                  Icon(
                    Icons.chevron_right_rounded,
                    size: Dimensions.iconSize16,
                    color: context.colors.textTertiary,
                  ),
              ],
            ),
            Text(
              data.value,
              style: TextStyle(
                fontSize: Dimensions.font20,
                fontWeight: FontWeight.w800,
                color: context.colors.textPrimary,
              ),
            ),
            Text(
              data.label,
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.75,
                color: context.colors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
