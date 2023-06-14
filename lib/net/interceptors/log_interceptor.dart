import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:focusring/utils/console_logger.dart';
import '../../extensions/ListEx.dart';
import '../../extensions/MapEx.dart';

class LogsInterceptors extends InterceptorsWrapper {
  int? printLevel;
  LogsInterceptors(this.printLevel);

  @override
  onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (kDebugMode) {
      vmPrint("proxy:$proxy", printLevel);
      vmPrint("[${options.method}]Request url[${this.hashCode}]:${options.uri}",
          printLevel);
      vmPrint('Request headers: ' + (options.headers.jsonString), printLevel);
      if (options.data is Map) {
        final map = Map.of(options.data);
        final p = map.jsonString;
        vmPrint('Request params: ' + p, printLevel);
      } else if (options.data is List) {
        final List list = List.of(options.data, growable: false);
        vmPrint('Request params: ' + list.jsonString, printLevel);
      } else if (options.data is FormData) {
        FormData data = options.data;
        final str = () {
          String str = "FormData:\n";
          str += "fields:";
          data.fields.forEach((element) {
            str += "\n${element.key}:${element.value}";
          });
          str += "\nfiles:";
          data.files.forEach((element) {
            str += "\n${element.key}:${{
              "filename": element.value.filename,
              "length": element.value.length
            }}";
          });
          return str;
        }();
        vmPrint('Request params: ' + str, printLevel);
      } else if (options.data != null) {
        vmPrint('Request params: ' + options.data.toString(), printLevel);
      }
    }
    handler.next(options);
  }

  @override
  onResponse(Response response, ResponseInterceptorHandler handler) async {
    if (kDebugMode) {
      // vmPrint('Response params[' + this.hashCode.toString() + ']: ');
      vmPrint(
          'Response params[' +
              response.realUri.toString() +
              ']: ' +
              response.toString(),
          printLevel);
    }
    handler.next(response); // continue
  }

  @override
  onError(DioException err, ErrorInterceptorHandler handler) async {
    if (kDebugMode) {
      Logger().wtf(err.requestOptions.uri);
      Logger().wtf('Request exception: ${err.toString()}');
    }
    handler.next(err); // continue;
  }
}
