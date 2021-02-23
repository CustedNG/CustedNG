import 'dart:convert';

import 'package:custed2/core/store/persistent_store.dart';
import 'package:custed2/data/models/custed_banner.dart';

class BannerStore with PersistentStore<String> {
  @override
  final boxName = 'banner';

  void put(CustedBanner banner) {
    this.box.put('banner', jsonEncode(banner));
  }

  CustedBanner fetch() {
    final data = this.box.get('banner');
    if (data == null) return null;

    return CustedBanner.fromJson(jsonDecode(data));
  }
}
