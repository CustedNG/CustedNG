import 'package:custed2/core/open.dart';
import 'package:custed2/data/providers/app_provider.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/ui/home_tab/home_card.dart';
import 'package:custed2/core/util/utils.dart';
import 'package:custed2/ui/widgets/dark_mode_filter.dart';
import 'package:flutter/material.dart';

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
    final banner = locator<AppProvider>().banner;
    final bannerUrl = banner?.imgUrl;
    if (bannerUrl == null) return SizedBox();

    return GestureDetector(
      onTap: () => openUrl(banner.actionUrl),
      child: MyImage(bannerUrl),
    );
  }
}
