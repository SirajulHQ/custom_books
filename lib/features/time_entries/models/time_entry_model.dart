enum TimeEntryStatus { billable, nonBillable }

extension TimeEntryStatusLabel on TimeEntryStatus {
  String get label => switch (this) {
    TimeEntryStatus.billable => 'BILLABLE',
    TimeEntryStatus.nonBillable => 'NON-BILLABLE',
  };
}

enum TimeEntrySortField { createdTime, date, projectName, duration }

extension TimeEntrySortFieldLabel on TimeEntrySortField {
  String get label => switch (this) {
    TimeEntrySortField.createdTime => 'Created Time',
    TimeEntrySortField.date => 'Date',
    TimeEntrySortField.projectName => 'Project Name',
    TimeEntrySortField.duration => 'Duration',
  };
}

enum SortDirection { ascending, descending }

class TimeEntryModel {
  final String id;
  final String projectName;
  final String taskName;
  final String userName;
  final DateTime logDate;
  final int durationMinutes;
  final bool isBillable;
  final String notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TimeEntryModel({
    required this.id,
    required this.projectName,
    required this.taskName,
    required this.userName,
    required this.logDate,
    this.durationMinutes = 0,
    this.isBillable = true,
    this.notes = '',
    required this.createdAt,
    required this.updatedAt,
  });

  TimeEntryStatus get status =>
      isBillable ? TimeEntryStatus.billable : TimeEntryStatus.nonBillable;

  String get durationLabel {
    final h = durationMinutes ~/ 60;
    final m = durationMinutes % 60;
    return '${h}h ${m}m';
  }

  TimeEntryModel copyWith({
    String? id,
    String? projectName,
    String? taskName,
    String? userName,
    DateTime? logDate,
    int? durationMinutes,
    bool? isBillable,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TimeEntryModel(
      id: id ?? this.id,
      projectName: projectName ?? this.projectName,
      taskName: taskName ?? this.taskName,
      userName: userName ?? this.userName,
      logDate: logDate ?? this.logDate,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      isBillable: isBillable ?? this.isBillable,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}
