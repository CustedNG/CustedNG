import 'package:custed2/data/providers/banner_provider.dart';
import 'package:custed2/ui/home_tab/home_card.dart';
import 'package:custed2/core/utils.dart';
import 'package:custed2/ui/widgets/dark_mode_filter.dart';
import 'package:flutter/material.dart';
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
    if (bannerUrl == null) return SizedBox();

    return GestureDetector(
      onTap: () => bannerProvider.execAction(),
      child: MyImage(bannerUrl),
    );
  }
}
