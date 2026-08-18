import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:flutter/material.dart';

class CreditNoteCard extends StatelessWidget {
  final dynamic note;
  final Color statusColor;
  final String Function(String) formatDate;

  const CreditNoteCard({
    super.key,
    required this.note,
    required this.statusColor,
    required this.formatDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Dimensions.width20),
      decoration: BoxDecoration(
        color: context.colors.card,
        boxShadow: [
          BoxShadow(
            color: const Color(0x08000000),
            blurRadius: Dimensions.radius15 * 0.53,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Date',
                style: TextStyle(
                  fontSize: Dimensions.font16 * 0.7,
                  color: context.colors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),

              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.width10 + 2,
                  vertical: Dimensions.height10 * 0.5,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(
                    Dimensions.radius30,
                  ),
                ),
                child: Text(
                  note.status.label,
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.62,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: Dimensions.height10 / 2.5),

          Text(
            formatDate(note.creditNoteDate),
            style: TextStyle(
              fontSize: Dimensions.font20 * 0.95,
              fontWeight: FontWeight.w800,
              color: context.colors.textPrimary,
            ),
          ),

          SizedBox(height: Dimensions.height20),

          Text(
            note.customerName,
            style: TextStyle(
              fontSize: Dimensions.font20 * 0.95,
              fontWeight: FontWeight.w800,
              color: context.colors.textPrimary,
            ),
          ),

          SizedBox(height: Dimensions.height10 / 2.5),

          Text(
            note.creditNoteNumber,
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.85,
              color: context.colors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}