import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/date_formatter.dart';
import 'package:custom_books/core/widgets/document_list_tile.dart';
import 'package:custom_books/core/widgets/status_chip.dart';
import 'package:custom_books/features/bills/models/bill_model.dart';
import 'package:custom_books/features/bills/views/bill_details_page.dart';
import 'package:flutter/material.dart';

class BillTile extends StatelessWidget {
  final BillModel bill;

  const BillTile({super.key, required this.bill});

  @override
  Widget build(BuildContext context) {
    return DocumentListTile(
      leadingIcon: Icons.description_outlined,
      leadingColor: AppColors.primary,
      primaryText: bill.vendorName,
      date: formatDate(bill.billDate),
      documentNumber: bill.billNumber,
      subDate: 'Due ${formatDate(bill.dueDate)}',
      statusWidget: StatusChip(
        color: bill.status.color,
        label: bill.status.label,
      ),
      amount: '₹${bill.total.toStringAsFixed(2)}',
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => BillDetailsPage(bill: bill)),
      ),
    );
  }
}
