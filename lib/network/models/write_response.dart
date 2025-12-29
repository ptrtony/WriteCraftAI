/// AI 写作响应模型
class WriteResponse {
  final int code;
  final String result;

  WriteResponse({
    required this.code,
    required this.result,
  });

  factory WriteResponse.fromJson(Map<String, dynamic> json) {
    return WriteResponse(
      code: json["code"] as int,
      result: json["data"]["result"] as String,
    );
  }

  /// 检查是否成功
  bool get isSuccess => code == 0;
}

