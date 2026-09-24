import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/features/items/models/item_model.dart';
import 'package:custom_books/features/items/viewmodels/items_list_viewmodel.dart';
import 'package:flutter/material.dart';

class ItemsListController extends ChangeNotifier {
  final _vm = ItemsListViewModel();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<ItemModel> _items = [];
  List<ItemModel> get items => List.unmodifiable(_items);

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
    final resp = await _vm.fetchItems(
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
      _items = raw
          .whereType<Map<String, dynamic>>()
          .map(ItemModel.fromJson)
          .toList();
    } else {
      _errorMessage =
          (resp?['message'] ?? 'Could not load items. Please try again.')
              .toString();
      appLog(
        '⚠️ Items fetch failed (status: $status)',
        name: 'ItemsListController',
      );
    }
  }
}
