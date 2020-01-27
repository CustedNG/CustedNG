import 'package:custed2/res/image_res.dart';
import 'package:custed2/ui/home_tab/home_card.dart';
import 'package:flutter/cupertino.dart';

class HomeBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HomeCard(
      content: AspectRatio(
        aspectRatio: 1250 / 540,
        child: Image(image: ImageRes.defaultBanner),
      ),
      padding: 0,
    );
  }
}
