import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/features/items/models/item_model.dart';
import 'package:custom_books/features/items/viewmodels/items_viewmodel.dart';
import 'package:flutter/material.dart';

class ItemsController extends ChangeNotifier {
  final ItemsViewModel _viewmodel = ItemsViewModel();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<ItemModel> _items = [];
  List<ItemModel> get items => List.unmodifiable(_items);

  /// Human-readable reason the last fetch failed (null on success).
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// Loads items from the API and updates [items].
  ///
  /// Returns `true` on success. On failure [errorMessage] describes why so the
  /// view can surface it.
  Future<bool> loadItems() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final response = await _viewmodel.fetchItems();

    final int? status = response?['_statusCode'] as int?;
    final bool ok =
        response != null &&
        response['success'] == true &&
        status != null &&
        status >= 200 &&
        status < 300;

    if (!ok) {
      _errorMessage = _extractErrorMessage(response);
      appLog(
        '⚠️ Loading items failed: $_errorMessage',
        name: 'ItemsController',
      );
      _isLoading = false;
      notifyListeners();
      return false;
    }

    _items = _parseItems(response);
    appLog('✅ Loaded ${_items.length} items', name: 'ItemsController');

    _isLoading = false;
    notifyListeners();
    return true;
  }

  /// Extracts the `data.results` array and maps it to [ItemModel]s.
  List<ItemModel> _parseItems(Map<String, dynamic>? response) {
    final data = response?['data'];
    if (data is! Map) return [];

    final results = data['results'];
    if (results is! List) return [];

    return results
        .whereType<Map<String, dynamic>>()
        .map(ItemModel.fromJson)
        .toList();
  }

  /// Whether a create request is currently in flight.
  bool _isSaving = false;
  bool get isSaving => _isSaving;

  /// The item returned by the last successful create (null otherwise).
  ItemModel? _createdItem;
  ItemModel? get createdItem => _createdItem;

  /// The item returned by the last successful update (null otherwise).
  ItemModel? _updatedItem;
  ItemModel? get updatedItem => _updatedItem;

  /// Creates a new item via the API.
  ///
  /// Returns `true` on success. On failure [errorMessage] describes why. On
  /// success the new item is parsed into [createdItem] and prepended to
  /// [items] so the list reflects it without a full reload.
  Future<bool> createItem(Map<String, dynamic> body) async {
    _isSaving = true;
    _errorMessage = null;
    _createdItem = null;
    notifyListeners();

    final response = await _viewmodel.createItem(body);

    final int? status = response?['_statusCode'] as int?;
    final bool ok =
        response != null &&
        response['success'] == true &&
        status != null &&
        status >= 200 &&
        status < 300;

    if (!ok) {
      _errorMessage = _extractCreateError(response);
      appLog(
        '⚠️ Creating item failed: $_errorMessage',
        name: 'ItemsController',
      );
      _isSaving = false;
      notifyListeners();
      return false;
    }

    final data = response['data'];
    if (data is Map<String, dynamic>) {
      _createdItem = ItemModel.fromJson(data);
      _items = [_createdItem!, ..._items];
    }
    appLog('✅ Item created: ${_createdItem?.name}', name: 'ItemsController');

    _isSaving = false;
    notifyListeners();
    return true;
  }

  /// Updates an existing item via the API.
  ///
  /// Returns `true` on success. On failure [errorMessage] describes why. On
  /// success the returned item is parsed into [updatedItem] and replaces the
  /// matching entry in [items].
  Future<bool> updateItem(String itemId, Map<String, dynamic> body) async {
    _isSaving = true;
    _errorMessage = null;
    _updatedItem = null;
    notifyListeners();

    final response = await _viewmodel.updateItem(itemId, body);

    final int? status = response?['_statusCode'] as int?;
    final bool ok =
        response != null &&
        response['success'] == true &&
        status != null &&
        status >= 200 &&
        status < 300;

    if (!ok) {
      _errorMessage = _extractCreateError(response);
      appLog(
        '⚠️ Updating item failed: $_errorMessage',
        name: 'ItemsController',
      );
      _isSaving = false;
      notifyListeners();
      return false;
    }

    final data = response['data'];
    if (data is Map<String, dynamic>) {
      _updatedItem = ItemModel.fromJson(data);
      final idx = _items.indexWhere((it) => it.id == _updatedItem!.id);
      if (idx >= 0) {
        _items = [..._items]..[idx] = _updatedItem!;
      }
    }
    appLog('✅ Item updated: ${_updatedItem?.name}', name: 'ItemsController');

    _isSaving = false;
    notifyListeners();
    return true;
  }

  String _extractErrorMessage(Map<String, dynamic>? response) {
    if (response == null) {
      return 'Could not reach the server. Check your connection and try again.';
    }
    return (response['message'] ?? 'Could not load items. Please try again.')
        .toString();
  }

  /// Builds a readable error from a failed create response. The backend may
  /// return field-level `errors` on validation failures, which we prefer over
  /// the generic top-level message.
  String _extractCreateError(Map<String, dynamic>? response) {
    if (response == null) {
      return 'Could not reach the server. Check your connection and try again.';
    }

    final errors = response['errors'];
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

    return (response['message'] ?? 'Could not create item. Please try again.')
        .toString();
  }
}
