import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:flutter/material.dart';

class UpdatesContentWidget extends StatelessWidget {
  const UpdatesContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          SizedBox(height: Dimensions.height15),

          AnnouncementCardWidget(
            title: 'New Feature: Automated Invoicing',
            description:
                'Save time with our new automated invoicing system. Schedule recurring invoices and never miss a payment.',
            time: '2 hours ago',
            icon: Icons.celebration_rounded,
            color: AppColors.primaryLight,
          ),

          SizedBox(height: Dimensions.height15),

          AnnouncementCardWidget(
            title: 'System Maintenance Scheduled',
            description:
                'We will be performing system maintenance on Saturday, 8 PM - 10 PM. Services may be temporarily unavailable.',
            time: '1 day ago',
            icon: Icons.build_rounded,
            color: const Color(0xFFF59E0B),
          ),

          SizedBox(height: Dimensions.height15),

          AnnouncementCardWidget(
            title: 'Tax Season Reminder',
            description:
                'Tax season is approaching. Ensure all your financial records are up to date and consult with your accountant.',
            time: '3 days ago',
            icon: Icons.calendar_today_rounded,
            color: AppColors.ok,
          ),

          SizedBox(height: Dimensions.height15),

          AnnouncementCardWidget(
            title: 'New Payment Gateway Integration',
            description:
                'We have added support for multiple payment gateways. Check settings to configure your preferred options.',
            time: '1 week ago',
            icon: Icons.payment_rounded,
            color: AppColors.accent,
          ),

          SizedBox(height: Dimensions.height30),
        ]),
      ),
    );
  }
}

class AnnouncementCardWidget extends StatelessWidget {
  final String title;
  final String description;
  final String time;
  final IconData icon;
  final Color color;

  const AnnouncementCardWidget({
    super.key,
    required this.title,
    required this.description,
    required this.time,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Dimensions.width20),
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: BorderRadius.circular(Dimensions.radius20),
        border: Border.all(color: context.colors.border),
        boxShadow: [
          BoxShadow(
            color: context.colors.border.withValues(alpha: 0.5),
            blurRadius: Dimensions.radius15 * 0.53,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: Dimensions.height45,
            height: Dimensions.height45,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(Dimensions.radius15),
            ),
            child: Icon(icon, color: color, size: Dimensions.iconSize24),
          ),
          SizedBox(width: Dimensions.width15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 1.05,
                    fontWeight: FontWeight.w700,
                    color: context.colors.textPrimary,
                  ),
                ),
                SizedBox(height: Dimensions.height10 / 2),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.9,
                    color: context.colors.textSecondary,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: Dimensions.height10),
                Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: Dimensions.iconSize16 * 0.9,
                      color: context.colors.textTertiary,
                    ),
                    SizedBox(width: Dimensions.width10 / 2),
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: Dimensions.font16 * 0.75,
                        color: context.colors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
