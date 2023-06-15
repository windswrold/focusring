import 'package:dio/dio.dart';

class BaseInterceptor extends Interceptor {
  final Dio _dio;
  BaseInterceptor(this._dio);

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout) _dio.close(force: true);
    handler.next(err);
  }
}
