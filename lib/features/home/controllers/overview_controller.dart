import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/features/home/models/dashboard_overview_model.dart';
import 'package:custom_books/features/home/viewmodels/dashboard_overview_viewmodel.dart';
import 'package:flutter/material.dart';

/// Manages the dashboard "overview" (balances + banking strip) section.
class OverviewController extends ChangeNotifier {
  final _vm = DashboardOverviewViewModel();

  DashboardOverviewModel? _overview;
  DashboardOverviewModel? get overview => _overview;

  Future<void> fetch() async {
    final resp = await _vm.fetch();
    final int? status = resp?['_statusCode'] as int?;
    if (resp != null && status != null && status >= 200 && status < 300) {
      final data = resp['data'] as Map<String, dynamic>? ?? resp;
      _overview = DashboardOverviewModel.fromJson(data);
    } else {
      appLog(
        '⚠️ Overview fetch failed (status: $status)',
        name: 'OverviewController',
      );
    }
  }
}
