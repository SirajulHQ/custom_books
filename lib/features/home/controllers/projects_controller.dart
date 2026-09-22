import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/features/home/models/dashboard_project_model.dart';
import 'package:custom_books/features/home/viewmodels/dashboard_projects_viewmodel.dart';
import 'package:flutter/material.dart';

class ProjectsController extends ChangeNotifier {
  final _vm = DashboardProjectsViewModel();

  DashboardProjectModel? _projects;
  DashboardProjectModel? get projects => _projects;

  Future<void> fetch() async {
    final resp = await _vm.fetch();
    final int? status = resp?['_statusCode'] as int?;
    if (resp != null && status != null && status >= 200 && status < 300) {
      final data = resp['data'] as Map<String, dynamic>? ?? resp;
      _projects = DashboardProjectModel.fromJson(data);
    } else {
      appLog(
        '⚠️ Projects fetch failed (status: $status)',
        name: 'ProjectsController',
      );
    }
  }
}
