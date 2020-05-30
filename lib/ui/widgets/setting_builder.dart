import 'package:custed2/core/store/presistent_store.dart';
import 'package:flutter/widgets.dart';

class SettingBuilder<T> extends StatelessWidget {
  SettingBuilder({this.setting, this.builder});

  final StoreProperty<T> setting;
  final Widget Function(BuildContext, T) builder;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: setting.listenable(),
      builder: (context, value, _) {
        return builder(context, value);
      },
    );
  }
}
