import 'package:after_layout/after_layout.dart';
import 'package:custed2/core/open.dart';
import 'package:custed2/data/providers/user_provider.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/service/mysso_service.dart';
import 'package:custed2/service/wrdvpn_service.dart';
import 'package:flutter/cupertino.dart';

Future<void> openIecard(BuildContext context) async {
  final open = await showCupertinoDialog(
    context: context,
    builder: (context) => OpenOrNotDialog(),
  );

  if (open != true) {
    return;
  }

  showCupertinoDialog(
    context: context,
    builder: (context) => OpenIecardDialog(),
  );
}

class OpenOrNotDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      content: Text('即将在浏览器中打开'),
      actions: [
        CupertinoDialogAction(
          child: Text('取消'),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        CupertinoDialogAction(
          isDefaultAction: true,
          child: Text('确定'),
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    );
  }
}

class OpenIecardDialog extends StatefulWidget {
  @override
  _OpenIecardDialogState createState() => _OpenIecardDialogState();
}

class _OpenIecardDialogState extends State<OpenIecardDialog>
    with AfterLayoutMixin {
  var _canceled = false;
  var _failed = false;

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      content: _failed ? Text('加载失败') : CupertinoActivityIndicator(),
      actions: [
        CupertinoDialogAction(
          child: Text(_failed ? '关闭' : '取消'),
          onPressed: () {
            _canceled = true;
            quit();
          },
        ),
      ],
    );
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    try {
      await openIecard();
    } catch (e) {
      setState(() {
        _failed = true;
      });
    }
  }

  Future<void> openIecard() async {
    final user = locator<UserProvider>();
    if (!user.loggedIn) {
      if (_canceled) {
        return;
      }

      quit();
      openUrl(
        'http://iecard.cust.edu.cn:8080/ias/prelogin?sysid=FWDT',
      );
      return;
    }

    final ticket = await MyssoService().getTicketForIecard();

    if (_canceled) {
      return;
    }

    final iecardUrl =
        'http://iecard.cust.edu.cn:8080/ias/prelogin?sysid=FWDT&ticket=$ticket';

    // final url = await WrdvpnService().getBypassUrl(iecardUrl);

    // if (_canceled) {
    //   return;
    // }

    quit();
    openUrl(iecardUrl);
  }

  void quit() {
    if (mounted) {
      Navigator.of(context).pop();
    }
  }
}
