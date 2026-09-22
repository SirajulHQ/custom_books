import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/features/home/models/update_item_model.dart';
import 'package:custom_books/features/home/viewmodels/updates_viewmodel.dart';
import 'package:flutter/material.dart';

class UpdatesController extends ChangeNotifier {
  final _vm = UpdatesViewModel();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<UpdateItemModel>? _updates;
  List<UpdateItemModel>? get updates => _updates;

  int get unreadCount => _updates?.where((u) => !u.isRead).length ?? 0;

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();
    await fetch();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetch() async {
    final resp = await _vm.fetch();
    final int? status = resp?['_statusCode'] as int?;
    if (resp != null && status != null && status >= 200 && status < 300) {
      final raw = _extractList(resp['data']);
      _updates = raw
          .map((e) => UpdateItemModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      appLog(
        '⚠️ Updates fetch failed (status: $status)',
        name: 'UpdatesController',
      );
    }
  }

  List<dynamic> _extractList(dynamic data) {
    if (data is List) return data;
    if (data is Map) {
      for (final key in ['items', 'updates', 'support', 'results', 'data']) {
        final v = data[key];
        if (v is List) return v;
      }
    }
    return [];
  }
}
