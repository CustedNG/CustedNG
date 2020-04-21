import 'package:custed2/core/provider/provider_base.dart';
import 'package:custed2/data/models/custed_banner.dart';
import 'package:custed2/data/store/banner_store.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/service/custed_service.dart';

class BannerProvider extends ProviderBase {
  CustedBanner _banner;
  String get bannerUrl => CustedService.getFileUrl(_banner?.image);

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
    final banner = await locator<CustedService>().getBanner();
    if (banner == null) return;

    final bannerStore = await locator.getAsync<BannerStore>();
    bannerStore.put(banner);
    setBanner(banner);
  }

  void setBanner(CustedBanner banner) {
    setState(() => _banner = banner);
  }

  void execAction() {
    if (_banner == null) return;
    if (_banner.action == null) return;
    _banner.action.exec();
  }
}
