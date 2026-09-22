class SupportTopicModel {
  final String label;
  final String? path;

  SupportTopicModel({required this.label, this.path});

  factory SupportTopicModel.fromJson(Map<String, dynamic> json) {
    return SupportTopicModel(
      label: json['label'] as String? ?? '',
      path: json['path'] as String?,
    );
  }
}

class SupportCategoryModel {
  final String title;
  final String description;
  final String icon;
  final List<SupportTopicModel> items;

  SupportCategoryModel({
    required this.title,
    required this.description,
    required this.icon,
    required this.items,
  });

  factory SupportCategoryModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List<dynamic>? ?? [];
    return SupportCategoryModel(
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      icon: json['icon'] as String? ?? '',
      items: rawItems
          .map((e) => SupportTopicModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class SupportDataModel {
  final String heading;
  final String subheading;
  final List<SupportCategoryModel> categories;
  final String contactHeading;
  final String contactButtonLabel;

  SupportDataModel({
    required this.heading,
    required this.subheading,
    required this.categories,
    required this.contactHeading,
    required this.contactButtonLabel,
  });

  factory SupportDataModel.fromJson(Map<String, dynamic> json) {
    final rawCats = json['categories'] as List<dynamic>? ?? [];
    final contact = json['contact'] as Map<String, dynamic>? ?? {};
    return SupportDataModel(
      heading: json['heading'] as String? ?? 'How can we help you?',
      subheading: json['subheading'] as String? ??
          'Find answers to common questions or contact support',
      categories: rawCats
          .map((e) => SupportCategoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      contactHeading: contact['heading'] as String? ?? 'Still need help?',
      contactButtonLabel:
          contact['button_label'] as String? ?? 'Contact Support',
    );
  }
}
