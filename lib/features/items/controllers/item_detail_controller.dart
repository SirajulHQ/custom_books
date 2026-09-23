import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/features/items/models/item_model.dart';
import 'package:custom_books/features/items/viewmodels/item_detail_viewmodel.dart';
import 'package:flutter/material.dart';

class ItemDetailController extends ChangeNotifier {
  final _vm = ItemDetailViewModel();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  ItemModel? _item;
  ItemModel? get item => _item;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> load(String itemId) async {
    _isLoading = true;
    notifyListeners();
    await fetch(itemId);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetch(String itemId) async {
    final resp = await _vm.fetchItem(itemId);
    final int? status = resp?['_statusCode'] as int?;
    if (resp != null &&
        resp['success'] == true &&
        status != null &&
        status >= 200 &&
        status < 300) {
      _errorMessage = null;
      final data = resp['data'] as Map<String, dynamic>?;
      if (data != null) _item = ItemModel.fromJson(data);
    } else {
      _errorMessage =
          (resp?['message'] ?? 'Could not load item details. Please try again.')
              .toString();
      appLog(
        '⚠️ Item detail fetch failed (status: $status)',
        name: 'ItemDetailController',
      );
    }
  }
}
