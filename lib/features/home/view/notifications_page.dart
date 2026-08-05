import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:flutter/material.dart';

// ── Notification data model ───────────────────────────────────────────────────
class NotificationItem {
  final String title;
  final String subtitle;
  final String time;
  final IconData icon;
  final Color color;
  final bool isRead;

  const NotificationItem({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.icon,
    required this.color,
    this.isRead = false,
  });
}

// ── Notifications Page ────────────────────────────────────────────────────────
class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  // Sample notifications — replace with real data source later
  final List<NotificationItem> _notifications = [
    NotificationItem(
      title: 'nabeel has viewed your quote QT-000001.',
      subtitle: 'Quote viewed',
      time: '02 Jul 2026 02:41 PM',
      icon: Icons.visibility_outlined,
      color: Appcolors.primary,
      isRead: false,
    ),
    NotificationItem(
      title: 'Invoice INV-000023 is overdue.',
      subtitle: 'Overdue invoice',
      time: '01 Jul 2026 09:00 AM',
      icon: Icons.error_outline_rounded,
      color: Appcolors.warn,
      isRead: false,
    ),
    NotificationItem(
      title: 'Payment of AED 1,200 received from sara.',
      subtitle: 'Payment received',
      time: '30 Jun 2026 04:15 PM',
      icon: Icons.check_circle_outline_rounded,
      color: Appcolors.ok,
      isRead: true,
    ),
    NotificationItem(
      title: 'Bill BILL-000011 is due in 3 days.',
      subtitle: 'Upcoming bill',
      time: '29 Jun 2026 11:30 AM',
      icon: Icons.schedule_rounded,
      color: Appcolors.warning,
      isRead: true,
    ),
    NotificationItem(
      title: 'ahmed has accepted your quote QT-000002.',
      subtitle: 'Quote accepted',
      time: '27 Jun 2026 03:10 PM',
      icon: Icons.thumb_up_alt_outlined,
      color: Appcolors.success,
      isRead: true,
    ),
  ];

  bool get _hasUnread => _notifications.any((n) => !n.isRead);

  void _markAllRead() {
    setState(() {
      _notifications.replaceRange(
        0,
        _notifications.length,
        _notifications.map(
          (n) => NotificationItem(
            title: n.title,
            subtitle: n.subtitle,
            time: n.time,
            icon: n.icon,
            color: n.color,
            isRead: true,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: context.colors.card,
        elevation: 0,
        surfaceTintColor: context.colors.card,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: context.colors.textPrimary,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Notifications',
          style: TextStyle(
            fontSize: Dimensions.font20,
            fontWeight: FontWeight.w800,
            color: context.colors.textPrimary,
          ),
        ),
        actions: [
          if (_hasUnread)
            TextButton(
              onPressed: _markAllRead,
              child: Text(
                'Mark all read',
                style: TextStyle(
                  fontSize: Dimensions.font16 * 0.85,
                  fontWeight: FontWeight.w600,
                  color: Appcolors.primary,
                ),
              ),
            ),
          SizedBox(width: Dimensions.width10 / 2),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, color: context.colors.border),
        ),
      ),
      body: _notifications.isEmpty
          ? _buildEmptyState(context)
          : ListView.separated(
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.width20,
                vertical: Dimensions.height20,
              ),
              itemCount: _notifications.length,
              separatorBuilder: (_, __) =>
                  SizedBox(height: Dimensions.height10),
              itemBuilder: (_, i) => _NotificationCard(item: _notifications[i]),
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: Dimensions.iconSize24 * 2.5,
            color: context.colors.textTertiary,
          ),
          SizedBox(height: Dimensions.height20),
          Text(
            'You\'re all caught up',
            style: TextStyle(
              fontSize: Dimensions.font20,
              fontWeight: FontWeight.w700,
              color: context.colors.textPrimary,
            ),
          ),
          SizedBox(height: Dimensions.height10 / 2),
          Text(
            'New alerts about invoices, payments and\nreminders will show up here.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.85,
              color: context.colors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Single notification card ───────────────────────────────────────────────────
class _NotificationCard extends StatelessWidget {
  final NotificationItem item;

  const _NotificationCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Dimensions.width15),
      decoration: BoxDecoration(
        color: item.isRead
            ? context.colors.card
            : item.color.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(Dimensions.radius15),
        border: Border.all(
          color: item.isRead
              ? context.colors.border
              : item.color.withValues(alpha: 0.25),
          width: item.isRead ? 1 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon badge
          Container(
            width: Dimensions.iconSize24 * 1.75,
            height: Dimensions.iconSize24 * 1.75,
            decoration: BoxDecoration(
              color: item.color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              item.icon,
              color: item.color,
              size: Dimensions.iconSize24,
            ),
          ),
          SizedBox(width: Dimensions.width15),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.92,
                    fontWeight: item.isRead ? FontWeight.w500 : FontWeight.w700,
                    color: context.colors.textPrimary,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: Dimensions.height10 / 2),
                Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: Dimensions.iconSize16 * 0.85,
                      color: context.colors.textTertiary,
                    ),
                    SizedBox(width: Dimensions.width10 / 3),
                    Text(
                      item.time,
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
          // Unread dot
          if (!item.isRead)
            Padding(
              padding: EdgeInsets.only(left: Dimensions.width10 / 2),
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: item.color,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
