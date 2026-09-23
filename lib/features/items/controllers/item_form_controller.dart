import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/features/items/models/item_model.dart';
import 'package:custom_books/features/items/viewmodels/item_form_viewmodel.dart';
import 'package:flutter/material.dart';

/// Drives the add/edit item form: creating and updating items.
class ItemFormController extends ChangeNotifier {
  final _vm = ItemFormViewModel();

  bool _isSaving = false;
  bool get isSaving => _isSaving;

  ItemModel? _savedItem;
  ItemModel? get savedItem => _savedItem;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> create(Map<String, dynamic> body) async {
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();
    final ok = _handle(await _vm.createItem(body), 'create');
    _isSaving = false;
    notifyListeners();
    return ok;
  }

  Future<bool> update(String itemId, Map<String, dynamic> body) async {
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();
    final ok = _handle(await _vm.updateItem(itemId, body), 'update');
    _isSaving = false;
    notifyListeners();
    return ok;
  }

  Future<bool> delete(String itemId) async {
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();

    final resp = await _vm.deleteItem(itemId);
    final int? status = resp?['_statusCode'] as int?;
    // A delete succeeds on any 2xx; the body may be empty (204) or a
    // `{success: true}` envelope, so we don't require the `success` flag.
    final bool ok =
        resp != null &&
        status != null &&
        status >= 200 &&
        status < 300 &&
        resp['success'] != false;

    if (ok) {
      appLog('✅ Item delete succeeded', name: 'ItemFormController');
    } else {
      _errorMessage = _extractError(resp, 'delete');
      appLog(
        '⚠️ Item delete failed (status: $status): $_errorMessage',
        name: 'ItemFormController',
      );
    }

    _isSaving = false;
    notifyListeners();
    return ok;
  }

  bool _handle(Map<String, dynamic>? resp, String action) {
    final int? status = resp?['_statusCode'] as int?;
    if (resp != null &&
        resp['success'] == true &&
        status != null &&
        status >= 200 &&
        status < 300) {
      final data = resp['data'] as Map<String, dynamic>?;
      if (data != null) _savedItem = ItemModel.fromJson(data);
      appLog('✅ Item $action succeeded', name: 'ItemFormController');
      return true;
    }
    _errorMessage = _extractError(resp, action);
    appLog(
      '⚠️ Item $action failed (status: $status): $_errorMessage',
      name: 'ItemFormController',
    );
    return false;
  }

  String _extractError(Map<String, dynamic>? resp, String action) {
    if (resp == null) {
      return 'Could not reach the server. Check your connection and try again.';
    }
    final errors = resp['errors'];
    if (errors is Map && errors.isNotEmpty) {
      final parts = <String>[];
      errors.forEach((field, messages) {
        if (messages is List && messages.isNotEmpty) {
          parts.add(messages.first.toString());
        } else if (messages != null) {
          parts.add(messages.toString());
        }
      });
      if (parts.isNotEmpty) return parts.join('\n');
    }
    return (resp['message'] ?? 'Could not $action item. Please try again.')
        .toString();
  }
}
