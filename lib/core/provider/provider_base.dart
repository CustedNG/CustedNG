import 'package:custed2/core/provider/provider_state.dart';
import 'package:flutter/widgets.dart';

class ProviderBase with ChangeNotifier {
  ProviderState _state = ProviderState.idle;

  ProviderState get state => _state;

  void setState([ProviderState viewState = ProviderState.idle]) {
    _state = viewState;
    notifyListeners();
  }

  Future<void> run(businessLogic(ProviderBase provider)) async {
    setState(ProviderState.busy);

    try {
      final result = businessLogic(this);
      if (result is Future) {
        await result;
      }
    } catch (e) {
      rethrow;
    } finally {
      setState(ProviderState.idle);
    }
  }
}
