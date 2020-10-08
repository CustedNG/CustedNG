import 'package:custed2/core/open.dart';
import 'package:custed2/data/providers/banner_provider.dart';
import 'package:custed2/ui/home_tab/home_card.dart';
import 'package:custed2/ui/widgets/dark_mode_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:flutter_banner_swiper/flutter_banner_swiper.dart';
import 'package:provider/provider.dart';

class HomeBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HomeCard(
      content: DarkModeFilter(
        child: _buildBanner(context),
      ),
      padding: 0,
    );
  }

  Widget _buildBanner(BuildContext context) {
    final bannerProvider = Provider.of<BannerProvider>(context);
    final bannerUrl = bannerProvider.bannerUrl;
    if (bannerUrl == null) return Container();
    List<String> urlList = [bannerUrl, 'https://cat.lolli.tech/banner.png'];
    int urlListLength = urlList.length;

    return BannerSwiper(
      height: 125,
      width: 54,
      length: urlListLength,
      spaceMode: false,
      getwidget: (index) => GestureDetector(
        onTap: () => index % urlListLength == 0
            ? bannerProvider.execAction()
            : openUrl('https://cat.lolli.tech/banner.html'),
        child: TransitionToImage(
          image: AdvancedNetworkImage(
            urlList[index % urlListLength],
            loadedCallback: () => print('Banner$index loaded.'),
            loadFailedCallback: () => print('Banner failed to load.'),
            useDiskCache: true,
            cacheRule: CacheRule(maxAge: Duration(days: index % urlListLength == 0 ? 15 : 3)),
          ),
          loadingWidgetBuilder: (_, double progress, __) {
            return Center(child: CircularProgressIndicator());
          },
          fit: BoxFit.cover,
          placeholder: const Icon(Icons.refresh),
          duration: Duration(milliseconds: 777),
          enableRefresh: true,
        ),
      ),
    );
  }
}
