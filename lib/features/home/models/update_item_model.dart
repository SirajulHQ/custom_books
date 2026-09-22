class UpdateItemModel {
  final String title;
  final String description;
  final String time; // relative_time from API
  final String icon; // e.g. "party_popper", "wrench", "calendar", "credit_card"
  final String type; // e.g. "feature", "maintenance", "reminder", "integration"
  final bool isRead;

  UpdateItemModel({
    required this.title,
    required this.description,
    required this.time,
    this.icon = '',
    this.type = '',
    this.isRead = false,
  });

  factory UpdateItemModel.fromJson(Map<String, dynamic> json) {
    return UpdateItemModel(
      title: json['title'] as String? ?? '',
      description:
          json['description'] as String? ?? json['body'] as String? ?? '',
      // API field is "relative_time", fall back to "time" then "created_at"
      time:
          json['relative_time'] as String? ??
          json['time'] as String? ??
          json['created_at'] as String? ??
          '',
      icon: json['icon'] as String? ?? '',
      type: json['type'] as String? ?? '',
      isRead: json['is_read'] as bool? ?? true,
    );
  }
}
