import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/features/inventory_adjustments/models/adjustment_comment_model.dart';
import 'package:custom_books/features/inventory_adjustments/viewmodels/adjustment_comments_viewmodel.dart';
import 'package:flutter/material.dart';

class AdjustmentCommentsController extends ChangeNotifier {
  AdjustmentCommentsController(this.adjustmentId);

  final String adjustmentId;
  final _vm = AdjustmentCommentsViewModel();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

  List<AdjustmentComment> _comments = [];
  List<AdjustmentComment> get comments => List.unmodifiable(_comments);

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();

    final resp = await _vm.fetchComments(adjustmentId);
    final int? status = resp?['_statusCode'] as int?;
    if (_isOk(resp, status)) {
      _errorMessage = null;
      _comments = _parseList(resp!['data']);
    } else {
      _errorMessage =
          (resp?['message'] ?? 'Could not load comments. Please try again.')
              .toString();
      appLog(
        '⚠️ Comments fetch failed (status: $status)',
        name: 'AdjustmentCommentsController',
      );
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Posts a new comment and refreshes the list on success.
  Future<bool> submit(String text) async {
    final comment = text.trim();
    if (comment.isEmpty || _isSubmitting) return false;

    _isSubmitting = true;
    notifyListeners();

    final resp = await _vm.addComment(adjustmentId, comment);
    final int? status = resp?['_statusCode'] as int?;
    final ok = _isOk(resp, status);

    if (ok) {
      _errorMessage = null;
      await _reloadAfterSubmit();
    } else {
      _errorMessage =
          (resp?['message'] ?? 'Could not add comment. Please try again.')
              .toString();
      appLog(
        '⚠️ Add comment failed (status: $status)',
        name: 'AdjustmentCommentsController',
      );
    }

    _isSubmitting = false;
    notifyListeners();
    return ok;
  }

  Future<void> _reloadAfterSubmit() async {
    final resp = await _vm.fetchComments(adjustmentId);
    final int? status = resp?['_statusCode'] as int?;
    if (_isOk(resp, status)) {
      _comments = _parseList(resp!['data']);
    }
  }

  bool _isOk(Map<String, dynamic>? resp, int? status) {
    return resp != null &&
        resp['success'] == true &&
        status != null &&
        status >= 200 &&
        status < 300;
  }

  /// The list may arrive as `data.results`, or `data` may itself be a list.
  List<AdjustmentComment> _parseList(dynamic data) {
    List<dynamic> raw;
    if (data is List) {
      raw = data;
    } else if (data is Map<String, dynamic>) {
      raw = (data['results'] as List<dynamic>?) ?? const [];
    } else {
      raw = const [];
    }
    return raw
        .whereType<Map<String, dynamic>>()
        .map(AdjustmentComment.fromJson)
        .toList();
  }
}
