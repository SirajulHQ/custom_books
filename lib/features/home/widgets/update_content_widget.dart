import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/features/home/models/update_item_model.dart';
import 'package:flutter/material.dart';

class UpdatesContentWidget extends StatelessWidget {

  final List<UpdateItemModel>? updates;

  const UpdatesContentWidget({super.key, this.updates});

  static IconData _iconFor(String key, String type) {
    switch (key) {
      case 'party_popper':
      case 'celebration':
        return Icons.celebration_rounded;
      case 'wrench':
      case 'build':
        return Icons.build_rounded;
      case 'calendar':
      case 'event':
        return Icons.calendar_today_rounded;
      case 'credit_card':
      case 'payment':
        return Icons.payment_rounded;
      case 'info':
        return Icons.info_outline_rounded;
      case 'warning':
        return Icons.warning_amber_rounded;
      default:

        switch (type) {
          case 'feature':
            return Icons.celebration_rounded;
          case 'maintenance':
            return Icons.build_rounded;
          case 'reminder':
            return Icons.calendar_today_rounded;
          case 'integration':
            return Icons.payment_rounded;
          default:
            return Icons.notifications_rounded;
        }
    }
  }

  static Color _colorFor(String type, int idx) {
    switch (type) {
      case 'feature':
        return AppColors.primaryLight;
      case 'maintenance':
        return const Color(0xFFF59E0B);
      case 'reminder':
        return AppColors.ok;
      case 'integration':
        return AppColors.accent;
      default:
        return _fallbackColors[idx % _fallbackColors.length];
    }
  }

  static const _fallbackColors = [
    AppColors.primaryLight,
    Color(0xFFF59E0B),
    AppColors.ok,
    AppColors.accent,
  ];

  @override
  Widget build(BuildContext context) {

    if (updates == null) {
      return SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
        sliver: SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(top: Dimensions.height30),
            child: Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
                strokeWidth: 2,
              ),
            ),
          ),
        ),
      );
    }

    if (updates!.isEmpty) {
      return SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
        sliver: SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(top: Dimensions.height30 * 2),
            child: Column(
              children: [
                Icon(
                  Icons.notifications_none_rounded,
                  size: Dimensions.iconSize24 * 2.5,
                  color: context.colors.textTertiary,
                ),
                SizedBox(height: Dimensions.height15),
                Text(
                  'No updates yet',
                  style: TextStyle(
                    fontSize: Dimensions.font20,
                    fontWeight: FontWeight.w700,
                    color: context.colors.textPrimary,
                  ),
                ),
                SizedBox(height: Dimensions.height10),
                Text(
                  'Check back later for announcements\nand feature updates.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.9,
                    color: context.colors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          SizedBox(height: Dimensions.height15),
          ...updates!.asMap().entries.map((entry) {
            final item = entry.value;
            final color = _colorFor(item.type, entry.key);
            final icon = _iconFor(item.icon, item.type);
            return Padding(
              padding: EdgeInsets.only(bottom: Dimensions.height15),
              child: AnnouncementCardWidget(
                title: item.title,
                description: item.description,
                time: item.time,
                icon: icon,
                color: color,
                isRead: item.isRead,
              ),
            );
          }),
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
  final bool isRead;

  const AnnouncementCardWidget({
    super.key,
    required this.title,
    required this.description,
    required this.time,
    required this.icon,
    required this.color,
    this.isRead = true,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(Dimensions.width20),
          decoration: BoxDecoration(
            color: context.colors.card,
            borderRadius: BorderRadius.circular(Dimensions.radius20),
            border: Border.all(
              color: !isRead
                  ? color.withValues(alpha: 0.35)
                  : context.colors.border,
            ),
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
        ),

        if (!isRead)
          Positioned(
            top: Dimensions.height10,
            right: Dimensions.width10,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }
}
