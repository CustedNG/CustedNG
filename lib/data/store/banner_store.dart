import 'dart:convert';

import 'package:custed2/core/store/persistent_store.dart';
import 'package:custed2/data/models/custed_config.dart';

class BannerStore with PersistentStore<String> {
  @override
  final boxName = 'banner';

  void put(CustedConfigBanner banner) {
    this.box.put('banner', json.encode(banner));
  }

  CustedConfigBanner fetch() {
    final data = this.box.get('banner');
    if (data == null) return null;

    return CustedConfigBanner.fromJson(json.decode(data));
  }
}
