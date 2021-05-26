import 'data.dart';

class JwEmptyRoom {
  int state;
  dynamic message;
  Data data;

  JwEmptyRoom({
    this.state,
    this.message,
    this.data,
  });

  factory JwEmptyRoom.fromJson(Map<String, dynamic> json) {
    return JwEmptyRoom(
      state: json['state'] as int,
      message: json['message'],
      data: json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'state': state,
      'message': message,
      'data': data?.toJson(),
    };
  }
}
