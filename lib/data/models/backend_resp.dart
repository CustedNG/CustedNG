class BackendResp {
/*
{
  "code": -1,
  "message": "",
  "data": {}
} 
*/

  int code;
  String message;
  dynamic data;

  BackendResp({
    this.code,
    this.message,
    this.data,
  });

  BackendResp.fromJson(Map<String, dynamic> json) {
    code = json['code']?.toInt();
    message = json['message']?.toString();
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    if (data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }

  bool get failed => code != -1;
}
