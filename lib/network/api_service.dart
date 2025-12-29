import 'package:dio/dio.dart';
import 'dio_client.dart';
import 'models/write_request.dart';
import 'models/write_response.dart';

/// API 服务类
/// 封装所有 API 接口
class ApiService {
  final Dio _dio = DioClient().dio;

  /// AI 写作接口
  /// 
  /// [request] 写作请求参数
  /// 
  /// 返回 [WriteResponse] 写作响应结果
  /// 
  /// 抛出 [DioException] 网络异常
  Future<WriteResponse> write(WriteRequest request) async {
    try {
      final response = await _dio.post(
        "/api/v1/write",
        data: request.toJson(),
      );

      return WriteResponse.fromJson(response.data);
    } on DioException {
      // 重新抛出 DioException，让调用方处理
      rethrow;
    } catch (e) {
      // 其他未知错误
      throw DioException(
        requestOptions: RequestOptions(path: "/api/v1/write"),
        error: e,
        type: DioExceptionType.unknown,
      );
    }
  }
}

