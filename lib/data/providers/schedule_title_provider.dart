import 'package:custed2/core/provider/provider_base.dart';

class ScheduleTitleProvider extends ProviderBase {
  bool showWeekInTitle = false;

  setShowWeekInTitle(bool value) {
    setState(() => showWeekInTitle = value);
  }
}
