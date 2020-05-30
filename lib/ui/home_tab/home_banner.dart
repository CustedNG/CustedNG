import 'package:custed2/data/providers/banner_provider.dart';
import 'package:custed2/ui/home_tab/home_card.dart';
import 'package:custed2/ui/widgets/dark_mode_filter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Icons;
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:provider/provider.dart';

class HomeBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HomeCard(
      content: AspectRatio(
        aspectRatio: 1250 / 540,
        child: DarkModeFilter(
          child: _buildImage(context),
        ),
      ),
      padding: 0,
    );
  }

  Widget _buildImage(BuildContext context) {
    final bannerProvider = Provider.of<BannerProvider>(context);
    final bannerUrl = bannerProvider.bannerUrl;
    if (bannerUrl == null) return Container();

    return GestureDetector(
      onTap: () => bannerProvider.execAction(),
      child: TransitionToImage(
        image: AdvancedNetworkImage(
          bannerUrl,
          loadedCallback: () => print('Banner loaded.'),
          loadFailedCallback: () => print('Banner failed to load.'),
          useDiskCache: true,
          cacheRule: CacheRule(maxAge: Duration(days: 15)),
        ),
        loadingWidgetBuilder: (_, double progress, __) {
          return CupertinoActivityIndicator();
        },
        fit: BoxFit.cover,
        placeholder: const Icon(Icons.refresh),
        duration: Duration(milliseconds: 300),
        enableRefresh: true,
      ),
    );
  }
}
