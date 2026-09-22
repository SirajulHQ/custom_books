import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/features/home/models/support_item_model.dart';
import 'package:custom_books/features/home/viewmodels/support_viewmodel.dart';
import 'package:flutter/material.dart';

class SupportController extends ChangeNotifier {
  final _vm = SupportViewModel();

  SupportDataModel? _support;
  SupportDataModel? get support => _support;

  Future<void> load() async {
    await fetch();
    notifyListeners();
  }

  Future<void> fetch() async {
    final resp = await _vm.fetch();
    final int? status = resp?['_statusCode'] as int?;
    if (resp != null && status != null && status >= 200 && status < 300) {
      final data = resp['data'] as Map<String, dynamic>?;
      if (data != null) {
        _support = SupportDataModel.fromJson(data);
      }
    } else {
      appLog(
        '⚠️ Support fetch failed (status: $status)',
        name: 'SupportController',
      );
    }
  }
}
