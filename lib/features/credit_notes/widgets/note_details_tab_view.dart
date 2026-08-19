import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/widgets/detail_row.dart';
import 'package:flutter/material.dart';

class NoteDetailsTabView extends StatelessWidget {
  final TabController tabController;
  final dynamic note;

  const NoteDetailsTabView({
    super.key,
    required this.tabController,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TabBarView(
        controller: tabController,
        children: [
          _buildDetailsTab(context),
          _buildHistoryTab(context),
        ],
      ),
    );
  }

  Widget _buildDetailsTab(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.width20,
      ),
      physics: const BouncingScrollPhysics(),
      children: [
        Container(
          padding: EdgeInsets.all(Dimensions.width20),
          decoration: BoxDecoration(
            color: context.colors.card,
            borderRadius: BorderRadius.circular(
              Dimensions.radius15,
            ),
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
              DetailRow(
                label: 'Reference#:',
                value: note.referenceNumber.isEmpty
                    ? '-'
                    : note.referenceNumber,
              ),

              SizedBox(height: Dimensions.height15),

              DetailRow(
                label: 'Amount:',
                value: '₹${note.total.toStringAsFixed(2)}',
              ),
            ],
          ),
        ),

        SizedBox(height: Dimensions.height30),
      ],
    );
  }

  Widget _buildHistoryTab(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(Dimensions.width20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(Dimensions.width20),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.07),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.history_rounded,
                size: Dimensions.iconSize24 * 2,
                color: AppColors.primary,
              ),
            ),

            SizedBox(height: Dimensions.height20),

            Text(
              'No comments or history yet',
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.95,
                fontWeight: FontWeight.w700,
                color: context.colors.textPrimary,
              ),
            ),

            SizedBox(height: Dimensions.height10),

            Text(
              'Comments and activity history\nwill appear here',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.8,
                color: context.colors.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}