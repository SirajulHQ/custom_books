import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/features/inventory_adjustments/models/inventory_adjustments_model.dart';
import 'package:custom_books/features/inventory_adjustments/viewmodels/inventory_adjustments_list_viewmodel.dart';
import 'package:flutter/material.dart';

class InventoryAdjustmentsListController extends ChangeNotifier {
  final _vm = InventoryAdjustmentsListViewModel();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<InventoryAdjustment> _adjustments = [];
  List<InventoryAdjustment> get adjustments =>
      List.unmodifiable(_adjustments);

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> load({String? filter, String? sortBy, String? sortOrder}) async {
    _isLoading = true;
    notifyListeners();
    await fetch(filter: filter, sortBy: sortBy, sortOrder: sortOrder);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetch({
    String? filter,
    String? sortBy,
    String? sortOrder,
  }) async {
    final resp = await _vm.fetchAdjustments(
      filter: filter,
      sortBy: sortBy,
      sortOrder: sortOrder,
    );
    final int? status = resp?['_statusCode'] as int?;
    if (resp != null &&
        resp['success'] == true &&
        status != null &&
        status >= 200 &&
        status < 300) {
      _errorMessage = null;
      final data = resp['data'] as Map<String, dynamic>?;
      final raw = (data?['results'] as List<dynamic>?) ?? [];
      _adjustments = raw
          .whereType<Map<String, dynamic>>()
          .map(InventoryAdjustment.fromJson)
          .toList();
    } else {
      _errorMessage =
          (resp?['message'] ??
                  'Could not load adjustments. Please try again.')
              .toString();
      appLog(
        '⚠️ Adjustments fetch failed (status: $status)',
        name: 'InventoryAdjustmentsListController',
      );
    }
  }
}
