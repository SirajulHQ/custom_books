import 'package:custom_books/core/utils/app_logger.dart';
import 'package:flutter/material.dart';

import '../viewmodels/states_viewmodel.dart';

/// Loads and holds the list of states for a selected country.
///
/// Countries the backend knows about return a list of states shown in a
/// dropdown. Countries without a state list (`success: false`) fall back to
/// free-form text entry, signalled by [supportsStates] being false.
class StatesController extends ChangeNotifier {
  final StatesViewModel _viewmodel = StatesViewModel();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<String> _states = const [];
  List<String> get states => _states;

  /// The ISO-2 country code the current [states] belong to.
  String? _loadedCountry;
  String? get loadedCountry => _loadedCountry;

  /// True once a lookup has completed and the backend returned a state list.
  /// False means the country has no predefined states (use free-form entry).
  bool _supportsStates = false;
  bool get supportsStates => _supportsStates;

  /// Human-readable reason the last lookup failed (null on success).
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// Guards against a stale response overwriting a newer one when the user
  /// switches countries quickly.
  int _requestId = 0;

  /// Fetches states for [country]. Skips the network call when the requested
  /// country's states are already loaded.
  Future<void> loadStates(String country) async {
    final normalized = country.trim().toLowerCase();
    if (_loadedCountry == normalized && (_states.isNotEmpty || _supportsStates)) {
      return;
    }

    final int requestId = ++_requestId;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final response = await _viewmodel.fetchStates(country: normalized);

    // A newer request started while this one was in flight — discard it.
    if (requestId != _requestId) return;

    if (response == null) {
      _states = const [];
      _supportsStates = false;
      _loadedCountry = normalized;
      _errorMessage =
          'Could not load states. Check your connection and try again.';
      appLog('⚠️ States load failed (network)', name: 'StatesController');
    } else if (response['success'] == true) {
      final data = response['data'];
      final rawStates = (data is Map) ? data['states'] : null;
      _states = (rawStates is List)
          ? rawStates.map((e) => e.toString()).toList()
          : const [];
      _supportsStates = _states.isNotEmpty;
      _loadedCountry = normalized;
    } else {
      // e.g. "Unsupported country." — no predefined list, use free-form entry.
      _states = const [];
      _supportsStates = false;
      _loadedCountry = normalized;
      appLog(
        'ℹ️ No state list for "$normalized": ${response['message']}',
        name: 'StatesController',
      );
    }

    _isLoading = false;
    notifyListeners();
  }
}
