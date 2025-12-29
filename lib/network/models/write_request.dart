/// AI 写作请求模型
class WriteRequest {
  final String text;
  final String mode; // polish / expand / continue / rewrite / shorten
  final String model; // openai / deepseek
  final String lang; // zh / en

  WriteRequest({
    required this.text,
    required this.mode,
    required this.model,
    required this.lang,
  });

  Map<String, dynamic> toJson() {
    return {
      "text": text,
      "mode": mode,
      "model": model,
      "lang": lang,
    };
  }
}

