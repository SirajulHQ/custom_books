import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/features/inventory_adjustments/models/inventory_adjustments_model.dart';
import 'package:custom_books/features/inventory_adjustments/viewmodels/inventory_adjustments_list_viewmodel.dart';
import 'package:flutter/material.dart';

class InventoryAdjustmentDetailController extends ChangeNotifier {
  final _vm = InventoryAdjustmentsListViewModel();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  InventoryAdjustment? _adjustment;
  InventoryAdjustment? get adjustment => _adjustment;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// Seed with the list item so the UI can render immediately while the
  /// full detail loads.
  void seed(InventoryAdjustment adjustment) {
    _adjustment = adjustment;
  }

  Future<void> load(String adjustmentId) async {
    _isLoading = true;
    notifyListeners();
    await fetch(adjustmentId);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetch(String adjustmentId) async {
    final resp = await _vm.fetchAdjustmentDetail(adjustmentId);
    final int? status = resp?['_statusCode'] as int?;
    if (resp != null &&
        resp['success'] == true &&
        status != null &&
        status >= 200 &&
        status < 300) {
      _errorMessage = null;
      final data = resp['data'] as Map<String, dynamic>?;
      if (data != null) {
        _adjustment = InventoryAdjustment.fromJson(data);
      }
    } else {
      _errorMessage =
          (resp?['message'] ??
                  'Could not load adjustment details. Please try again.')
              .toString();
      appLog(
        '⚠️ Adjustment detail fetch failed (status: $status)',
        name: 'InventoryAdjustmentDetailController',
      );
    }
  }
}
