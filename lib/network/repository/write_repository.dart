import '../api_service.dart';
import '../models/write_request.dart';
import '../../models/write_mode.dart';
import '../../models/ai_model.dart';
import '../../models/language.dart';

/// 写作仓库类
/// 业务层封装，处理业务逻辑
class WriteRepository {
  final ApiService _api = ApiService();

  /// 生成 AI 写作结果
  /// 
  /// [text] 原始文本
  /// [mode] 写作模式
  /// [model] AI 模型
  /// [lang] 语言
  /// 
  /// 返回 AI 生成的结果文本
  /// 
  /// 抛出异常时由调用方处理
  Future<String> generate({
    required String text,
    required WriteMode mode,
    required AIModel model,
    required Language lang,
  }) async {
    final request = WriteRequest(
      text: text,
      mode: mode.value,
      model: model.value,
      lang: lang.code,
    );

    final response = await _api.write(request);

    if (response.isSuccess) {
      return response.result;
    } else {
      throw Exception('API返回错误: code=${response.code}');
    }
  }
}

