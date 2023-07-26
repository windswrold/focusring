import 'package:dio/dio.dart';
import 'package:focusring/public.dart';
import 'package:focusring/utils/localeManager.dart';

class BaseInterceptor extends InterceptorsWrapper {
  final Dio _dio;
  BaseInterceptor(this._dio);

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout) _dio.close(force: true);
    handler.next(err);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    
    
    // TODO: implement onRequest
    options.headers.addAll({
      'Accept-Language': getLocaleKey(Get.deviceLocale ?? fallbackLocale),
    });
    handler.next(options);
  }
}
