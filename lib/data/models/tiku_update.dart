class TikuUpdate {
/*
{
  "newest": 33,
  "android": "https://v2.custed.lolli.tech/res/tiku/apk/33.apk",
  "ios": "https://",
  "min": 30,
  "changelog": ""
} 
*/

  /// 最新版本号
  int newest;

  /// Android最新版本下载地址
  String android;

  /// iOS App Store链接
  String ios;

  /// 最小版本，低于此版本会强制提醒升级
  int min;

  /// 当前最新版本的更新日志
  String changelog;

  TikuUpdate({
    this.newest,
    this.android,
    this.ios,
    this.min,
    this.changelog,
  });
  TikuUpdate.fromJson(Map<String, dynamic> json) {
    newest = json["newest"]?.toInt();
    android = json["android"].toString();
    ios = json["ios"].toString();
    min = json["min"].toInt();
    changelog = json["changelog"].toString();
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["newest"] = newest;
    data["android"] = android;
    data["ios"] = ios;
    data["min"] = min;
    data["changelog"] = changelog;
    return data;
  }
}
