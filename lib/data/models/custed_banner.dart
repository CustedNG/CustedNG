import 'package:custed2/data/models/custed_action.dart';
import 'package:custed2/data/models/custed_file.dart';
import 'package:json_annotation/json_annotation.dart';

part 'custed_banner.g.dart';

@JsonSerializable()
class CustedBanner {
  CustedBanner();

  CustedAction action;
  CustedFile image;

  factory CustedBanner.fromJson(Map<String, dynamic> json) =>
      _$CustedBannerFromJson(json);

  Map<String, dynamic> toJson() => _$CustedBannerToJson(this);

  @override
  String toString() {
    return 'CustedBanner<${image.url}>';
  }
}
