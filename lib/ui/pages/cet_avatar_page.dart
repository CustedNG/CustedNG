import 'package:custed2/core/util/save_image.dart';
import 'package:custed2/data/providers/cet_avatar_provider.dart';
import 'package:custed2/ui/widgets/placeholder/placeholder.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class CetAvatarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Container(
        child: SafeArea(
          child: CustomScrollView(
            slivers: <Widget>[
              CupertinoSliverNavigationBar(
                largeTitle: Text('四六级照片'),
              ),
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
          child: Image.memory(cetAvatar.avatar),
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xFFBBBBBB)),
          ),
        ),
        SizedBox(height: 40),
        CupertinoButton.filled(
          onPressed: () => saveImageToGallery(cetAvatar.avatar),
          child: Text('保存到相册'),
        )
      ],
    );
  }
}
