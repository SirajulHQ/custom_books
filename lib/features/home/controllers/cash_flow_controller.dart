import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/features/home/models/cash_flow_point_model.dart';
import 'package:custom_books/features/home/viewmodels/cash_flow_viewmodel.dart';
import 'package:flutter/material.dart';

class CashFlowController extends ChangeNotifier {
  final _vm = CashFlowViewModel();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<CashFlowPoint> _cashFlow = [];
  List<CashFlowPoint> get cashFlow => _cashFlow;

  List<String> _periods = ['this_fiscal_year'];
  List<String> get periods => _periods;

  String _asOnLabel = '';
  String get asOnLabel => _asOnLabel;

  String _currency = 'INR';
  String get currency => _currency;

  Future<void> load({required String period}) async {
    _isLoading = true;
    notifyListeners();
    await fetch(period: period);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetch({required String period}) async {
    final resp = await _vm.fetch(period: period);
    final int? status = resp?['_statusCode'] as int?;
    if (resp != null && status != null && status >= 200 && status < 300) {
      final data = resp['data'] as Map<String, dynamic>?;
      final raw = (data?['months'] as List<dynamic>?) ?? [];
      _cashFlow = raw
          .map((e) => CashFlowPoint.fromJson(e as Map<String, dynamic>))
          .toList();
      _asOnLabel = data?['as_on_label'] as String? ?? '';
      _currency = data?['currency'] as String? ?? 'INR';
      _periods =
          (data?['available_periods'] as List<dynamic>?)
              ?.map((e) => (e as Map)['value'] as String? ?? '')
              .where((s) => s.isNotEmpty)
              .toList() ??
          ['this_fiscal_year'];
    } else {
      appLog(
        '⚠️ Cash flow fetch failed (status: $status)',
        name: 'CashFlowController',
      );
    }
  }
}
