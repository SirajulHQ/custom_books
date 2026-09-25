import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/features/inventory_adjustments/models/inventory_adjustments_model.dart';
import 'package:custom_books/features/inventory_adjustments/models/line_item_model.dart';
import 'package:custom_books/features/inventory_adjustments/viewmodels/inventory_adjustment_form_viewmodel.dart';
import 'package:flutter/material.dart';

class InventoryAdjustmentFormController extends ChangeNotifier {
  final _vm = InventoryAdjustmentFormViewModel();

  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  InventoryAdjustment? _created;
  InventoryAdjustment? get created => _created;

  /// Builds the request body and POSTs a new adjustment.
  /// Returns the created [InventoryAdjustment] on success, otherwise null.
  Future<InventoryAdjustment?> create({
    required ModeOfAdjustment mode,
    required String reason,
    required DateTime date,
    required String adjustedByName,
    String? referenceNumber,
    String? description,
    String? account,
    required List<LineItem> lines,
    String status = 'draft',
  }) async {
    _isSubmitting = true;
    _errorMessage = null;
    notifyListeners();

    final body = <String, dynamic>{
      'adjustment_type': mode == ModeOfAdjustment.value ? 'value' : 'quantity',
      'reason': reason,
      'date': _formatDate(date),
      'status': status,
      'adjusted_by_name': adjustedByName,
      if (referenceNumber != null && referenceNumber.trim().isNotEmpty)
        'reference_number': referenceNumber.trim(),
      if (description != null && description.trim().isNotEmpty)
        'description': description.trim(),
      if (account != null && account.trim().isNotEmpty) 'account': account,
      'lines': lines
          .map(
            (l) => <String, dynamic>{
              'item_id': l.itemId,
              'quantity_adjusted': l.quantityAdjusted.toString(),
              'rate': l.costPrice.toStringAsFixed(2),
            },
          )
          .toList(),
    };

    final resp = await _vm.createAdjustment(body);
    final int? status0 = resp?['_statusCode'] as int?;

    InventoryAdjustment? result;
    if (resp != null &&
        resp['success'] == true &&
        status0 != null &&
        status0 >= 200 &&
        status0 < 300) {
      final data = resp['data'] as Map<String, dynamic>?;
      if (data != null) {
        result = InventoryAdjustment.fromJson(data);
      }
      _created = result;
    } else {
      _errorMessage =
          (resp?['message'] ??
                  'Could not create the adjustment. Please try again.')
              .toString();
      appLog(
        '⚠️ Create adjustment failed (status: $status0)',
        name: 'InventoryAdjustmentFormController',
      );
    }

    _isSubmitting = false;
    notifyListeners();
    return result;
  }

  String _formatDate(DateTime d) {
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '${d.year}-$m-$day';
  }
}
