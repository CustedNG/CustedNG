import 'package:json_annotation/json_annotation.dart';

part 'custed_link.g.dart';

@JsonSerializable()
class CustedLink {
  CustedLink();

  String href;
  String target;

  factory CustedLink.fromJson(Map<String, dynamic> json) =>
      _$CustedLinkFromJson(json);

  Map<String, dynamic> toJson() => _$CustedLinkToJson(this);

  @override
  String toString() {
    return 'CustedLink<$href@$target>';
  }
}
