import 'dart:convert';

import 'package:custed2/locator.dart';
import 'package:custed2/service/custed_service.dart';

class RemoteConfigService {
  static final _minUpdateInterval = Duration(minutes: 3);

  DateTime _lastUpdate;

  Map<dynamic, dynamic> _cachedData;

  var _isUpdating = false;

  Future<void> reloadData() async {
    final custed = locator.get<CustedService>();
    final config = await custed.getRemoteConfigJson();
    final data = json.decode(config);

    if (data is Map) {
      _cachedData = data;
      _lastUpdate = DateTime.now();
    }
  }

  Future<void> reloadDataIfNeeded() async {
    if (_isUpdating) {
      return;
    }

    if (_lastUpdate != null &&
        DateTime.now().difference(_lastUpdate) < _minUpdateInterval) {
      return;
    }

    try {
      _isUpdating = true;
      await reloadData();
    } catch (e) {
      rethrow;
    } finally {
      _isUpdating = false;
    }
  }

  Future<T> fetch<T>(String key, T fallback) async {
    await reloadDataIfNeeded();
    return fetchWithoutUpdate(key, fallback);
  }

  T fetchSync<T>(String key, T fallback) {
    reloadDataIfNeeded();
    return fetchWithoutUpdate(key, fallback);
  }

  T fetchWithoutUpdate<T>(String key, T fallback) {
    if (_cachedData == null) {
      return fallback;
    }

    final data = _cachedData[key];

    if (data is T) {
      return data;
    }

    return fallback;
  }
}
