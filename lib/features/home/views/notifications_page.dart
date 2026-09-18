import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/widgets/skeletons/skeletons.dart';
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
      color: AppColors.primary,
      isRead: false,
    ),
    NotificationItem(
      title: 'Invoice INV-000023 is overdue.',
      subtitle: 'Overdue invoice',
      time: '01 Jul 2026 09:00 AM',
      icon: Icons.error_outline_rounded,
      color: AppColors.warn,
      isRead: false,
    ),
    NotificationItem(
      title: 'Payment of ₹1,200 received from sara.',
      subtitle: 'Payment received',
      time: '30 Jun 2026 04:15 PM',
      icon: Icons.check_circle_outline_rounded,
      color: AppColors.ok,
      isRead: true,
    ),
    NotificationItem(
      title: 'Bill BILL-000011 is due in 3 days.',
      subtitle: 'Upcoming bill',
      time: '29 Jun 2026 11:30 AM',
      icon: Icons.schedule_rounded,
      color: AppColors.warning,
      isRead: true,
    ),
    NotificationItem(
      title: 'ahmed has accepted your quote QT-000002.',
      subtitle: 'Quote accepted',
      time: '27 Jun 2026 03:10 PM',
      icon: Icons.thumb_up_alt_outlined,
      color: AppColors.success,
      isRead: true,
    ),
  ];

  bool get _hasUnread => _notifications.any((n) => !n.isRead);

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  /// Simulates fetching data so the shimmer skeleton is shown briefly.
  Future<void> _load() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
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
              onPressed: () {
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
              },
              child: Text(
                'Mark all read',
                style: TextStyle(
                  fontSize: Dimensions.font16 * 0.85,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
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
      body: _isLoading
          ? const DocumentListSkeleton()
          : _notifications.isEmpty
          ? Center(
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
            )
          : ListView.separated(
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.width20,
                vertical: Dimensions.height20,
              ),
              itemCount: _notifications.length,
              separatorBuilder: (_, _) => SizedBox(height: Dimensions.height10),
              itemBuilder: (_, i) => Container(
                padding: EdgeInsets.all(Dimensions.width15),
                decoration: BoxDecoration(
                  color: _notifications[i].isRead
                      ? context.colors.card
                      : _notifications[i].color.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(Dimensions.radius15),
                  border: Border.all(
                    color: _notifications[i].isRead
                        ? context.colors.border
                        : _notifications[i].color.withValues(alpha: 0.25),
                    width: _notifications[i].isRead ? 1 : 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: context.colors.border.withValues(alpha: 0.5),
                      blurRadius: Dimensions.radius15 * 0.4,
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
                        color: _notifications[i].color.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _notifications[i].icon,
                        color: _notifications[i].color,
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
                            _notifications[i].title,
                            style: TextStyle(
                              fontSize: Dimensions.font16 * 0.92,
                              fontWeight: _notifications[i].isRead
                                  ? FontWeight.w500
                                  : FontWeight.w700,
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
                                _notifications[i].time,
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
                    if (!_notifications[i].isRead)
                      Padding(
                        padding: EdgeInsets.only(left: Dimensions.width10 / 2),
                        child: Container(
                          width: Dimensions.width10 * 0.8,
                          height: Dimensions.height10 * 0.8,
                          decoration: BoxDecoration(
                            color: _notifications[i].color,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
    );
  }
}
