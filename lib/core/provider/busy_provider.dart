import 'dart:async';

import 'package:custed2/core/provider/provider_base.dart';

class BusyProvider extends ProviderBase {
  bool _isBusy = false;
  bool get isBusy => _isBusy;

  setBusyState([bool isBusy = true]) {
    _isBusy = isBusy;
    notifyListeners();
  }

  FutureOr<T> busyRun<T>(FutureOr<T> func()) async {
    setBusyState(true);
    try {
      return await Future.sync(func);
    } catch (e) {
      rethrow;
    } finally {
      setBusyState(false);
    }
  }
}
