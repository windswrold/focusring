import 'package:dio/dio.dart';

class MSHTTPHeaderInterceptor extends InterceptorsWrapper {
  @override
  Future onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    handler.next(options);
  }
}
