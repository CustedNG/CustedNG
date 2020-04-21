import 'package:custed2/core/open.dart';
import 'package:custed2/data/models/custed_link.dart';
import 'package:json_annotation/json_annotation.dart';

part 'custed_action.g.dart';

@JsonSerializable()
class CustedAction {
  CustedAction();

  CustedLink link;

  factory CustedAction.fromJson(Map<String, dynamic> json) =>
      _$CustedActionFromJson(json);

  Map<String, dynamic> toJson() => _$CustedActionToJson(this);

  exec() {
    if (link != null) {
      openUrl(link.href);
    }
  }

  @override
  String toString() {
    return 'CustedAction<>';
  }
}
