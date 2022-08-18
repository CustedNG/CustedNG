import 'package:custed2/core/open.dart';
import 'package:custed2/core/provider/provider_base.dart';
import 'package:custed2/data/models/custed_config.dart';
import 'package:custed2/data/providers/app_provider.dart';
import 'package:custed2/data/store/banner_store.dart';
import 'package:custed2/locator.dart';

class BannerProvider extends ProviderBase {
  CustedConfigBanner _banner;
  String get bannerUrl => _banner?.imgUrl;

  Future<void> init() async {
    await loadLocalData();
    await update();
  }

  Future<void> loadLocalData() async {
    final bannerStore = await locator.getAsync<BannerStore>();
    final banner = bannerStore.fetch();

    if (banner == null) return;
    setBanner(banner);
  }

  Future<void> update() async {
    final banner = await locator<AppProvider>().config?.banner;
    if (banner == null) return;

    final bannerStore = await locator.getAsync<BannerStore>();
    bannerStore.put(banner);
    setBanner(banner);
  }

  void setBanner(CustedConfigBanner banner) {
    setState(() => _banner = banner);
  }

  void execAction() {
    if (_banner == null) return;
    if (_banner.actionUrl == null) return;
    openUrl(_banner.actionUrl);
  }
}
