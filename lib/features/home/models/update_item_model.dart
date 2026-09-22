class UpdateItemModel {
  final String title;
  final String description;
  final String time;
  final String icon;
  final String type;
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
