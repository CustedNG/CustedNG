import 'package:custed2/core/util/save_image.dart';
import 'package:custed2/data/providers/cet_avatar_provider.dart';
import 'package:custed2/ui/theme.dart';
import 'package:custed2/ui/widgets/dark_mode_filter.dart';
import 'package:custed2/ui/widgets/navbar/navbar.dart';
import 'package:custed2/ui/widgets/navbar/navbar_text.dart';
import 'package:custed2/ui/widgets/placeholder/placeholder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CetAvatarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavBar.material(
          context: context,
          middle: NavbarText('四六级照片')),
      body: Container(
        child: SafeArea(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 40),
                    _buildContent(context),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final cetAvatar = Provider.of<CetAvatarProvider>(context);
    if (cetAvatar.isBusy) return PlaceholderWidget(isActive: true);
    if (cetAvatar.avatar == null) return PlaceholderWidget(text: '无数据');
    return _buildAvatar(context);
  }

  Widget _buildAvatar(BuildContext context) {
    final cetAvatar = Provider.of<CetAvatarProvider>(context);

    return Column(
      children: <Widget>[
        Container(
          width: 240,
          height: 320,
          child: DarkModeFilter(child: Image.memory(cetAvatar.avatar)),
          decoration: BoxDecoration(
            border:
                isDark(context) ? null : Border.all(color: Color(0xFFBBBBBB)),
          ),
        ),
        SizedBox(height: 40),
        CupertinoButton.filled(
          onPressed: () => saveImageToGallery(cetAvatar.avatar),
          child: Text(
            '保存到相册',
            style: TextStyle(color: CupertinoColors.white),
          ),
        )
      ],
    );
  }
}
