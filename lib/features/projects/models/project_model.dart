enum ProjectStatus { active, onHold, completed, cancelled }

extension ProjectStatusLabel on ProjectStatus {
  String get label => switch (this) {
    ProjectStatus.active => 'ACTIVE',
    ProjectStatus.onHold => 'ON HOLD',
    ProjectStatus.completed => 'COMPLETED',
    ProjectStatus.cancelled => 'CANCELLED',
  };
}

enum BillingMethod {
  fixedCost,
  basedOnProjectHours,
  basedOnStaffHours,
  basedOnTaskHours,
}

extension BillingMethodLabel on BillingMethod {
  String get label => switch (this) {
    BillingMethod.fixedCost => 'Fixed Cost for Project',
    BillingMethod.basedOnProjectHours => 'Based on Project Hours',
    BillingMethod.basedOnStaffHours => 'Based on Staff Hours',
    BillingMethod.basedOnTaskHours => 'Based on Task Hours',
  };
}

enum ProjectSortField { createdTime, projectName, customerName, rate }

extension ProjectSortFieldLabel on ProjectSortField {
  String get label => switch (this) {
    ProjectSortField.createdTime => 'Created Time',
    ProjectSortField.projectName => 'Project Name',
    ProjectSortField.customerName => 'Customer Name',
    ProjectSortField.rate => 'Rate',
  };
}

enum SortDirection { ascending, descending }

class ProjectModel {
  final String id;
  final String projectName;
  final String customerName;
  final ProjectStatus status;
  final BillingMethod billingMethod;
  final double rate;
  final double budgetHours;
  final double loggedHours;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProjectModel({
    required this.id,
    required this.projectName,
    required this.customerName,
    this.status = ProjectStatus.active,
    this.billingMethod = BillingMethod.fixedCost,
    this.rate = 0,
    this.budgetHours = 0,
    this.loggedHours = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  double get amount =>
      billingMethod == BillingMethod.fixedCost ? rate : rate * loggedHours;

  ProjectModel copyWith({
    String? id,
    String? projectName,
    String? customerName,
    ProjectStatus? status,
    BillingMethod? billingMethod,
    double? rate,
    double? budgetHours,
    double? loggedHours,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      projectName: projectName ?? this.projectName,
      customerName: customerName ?? this.customerName,
      status: status ?? this.status,
      billingMethod: billingMethod ?? this.billingMethod,
      rate: rate ?? this.rate,
      budgetHours: budgetHours ?? this.budgetHours,
      loggedHours: loggedHours ?? this.loggedHours,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}
