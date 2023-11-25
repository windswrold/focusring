import 'dart:async';
import 'dart:typed_data';
import 'package:beering/const/constant.dart';
import 'package:beering/utils/sp_manager.dart';

import '../../utils/console_logger.dart';
import '../interceptors/base_interceptor.dart';
import '../../extensions/MapEx.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import '../../extensions/ListEx.dart';
import '../../extensions/StringEx.dart';
import 'result.dart';
import 'request.dart';
import 'api_stream.dart';
import 'network.dart';
import '../interceptors/log_interceptor.dart';
import 'package:dio/io.dart';

typedef CustomResponseAnalysis = Future<void> Function(
    VMRequest request,
    Options options,
    Response<dynamic>? response,
    DioException? DioException,
    void Function(VMResultType, [String? error]) onAnalysis);

class VMApi {
  static const bool EnableUserProxy = true;
  static const bool shouldLoadInvalidSSLCertificates = true;

  final VMNetwork network;
  final CustomResponseAnalysis? customAnalysis;

  VMApi({this.network = const VMNetwork(), this.customAnalysis});

  static Dio makeDio({
    required String? proxy,
    int? printLevel = 9999,
  }) {
    final dio = Dio();
    dio.interceptors.addAll([
      BaseInterceptor(dio),
      LogsInterceptors(printLevel),
    ]);
    if (inProduction == false) {
      if (EnableUserProxy) {
        _setProxy(dio, proxy ?? 'DIRECT');
      } else {
        _setProxy(dio, 'DIRECT');
      }
    }

    return dio;
  }

  static void _setProxy(Dio dio, [String? proxy]) {
    const String fingerprint =
        'ee5ce1dfa7a53657c545c62b65802e4272878dabd65c0aadcf85783ebb0b4d5c';

    dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        // Don't trust any certificate just because their root cert is trusted.
        final HttpClient client =
            HttpClient(context: SecurityContext(withTrustedRoots: false));
        // You can test the intermediate / root cert here. We just ignore it.
        client.badCertificateCallback = (cert, host, port) => true;
        client.findProxy = (Uri url) => "PROXY 192.168.0.104:8888";
        return client;
      },
      validateCertificate: (cert, host, port) {
        return true;
      },
    );
  }

  Future<VMResult> _request(
    VMRequest request, {
    CancelToken? cancelToken,
    required VMApiStream? apiStream,
    required VMProgressCallback? onSendProgress,
    required VMProgressCallback? onReceiveProgress,
  }) async {
    Response<dynamic>? response;
    VMResultType type = VMResultType.successful;
    DioException? dioException;
    String? errorMessage;
    dynamic responseBody;
    const String errorKey = 'error';
    const String codeKey = 'code';

    Options options = Options(
      method: request.vmMethod.methodString,
      sendTimeout: Duration(milliseconds: request.sendTimeoutInterval),
      receiveTimeout: Duration(milliseconds: request.receiveTimeoutInterval),
      contentType: request.contentType,
      headers: request.requestHeaders ?? {},
    );

    bool isNetworkDisconnected = false;
    Completer<VMResult> completer = new Completer();
    bool completerCompleted = false;

    if (request.needAccessToken == true) {
      var user = SPManager.getGlobalUser();

      final token = user?.accessToken ?? "";

      options.headers?.addAll({"accessToken": token});
    }

    await Future.delayed(const Duration(milliseconds: 1));
    String proxy = 'DIRECT';
    Dio? dio;
    /** The timeout mechanism of dio[3.0.10] is invalid, mentioned in the github issue */

    ///Timeout mechanism [dio's timeout mechanism is invalid in some versions, so deploy manually]
    final s = request.sendTimeoutInterval + request.receiveTimeoutInterval;
    final timeoutDuration = Duration(milliseconds: s);
    Future.delayed(timeoutDuration).then((value) {
      if (apiStream?.isFinished == true) return;
      dio?.close(force: true);
      apiStream?.isFinished = true;
      completerCompleted = true;
      completer.complete(VMResult(
          VMResultType.connectionError, null, -1, request,
          responseHeaders: null, errorMessage: 'Timeout', isTimeout: true));
    });

    if (EnableUserProxy) {
      proxy = await VMNetwork.getSystemProxy;
    }

    try {
      dio = makeDio(proxy: proxy, printLevel: network.printLevel);
      response = await dio.request<dynamic>(
        network.urlWithSuffix(request.path),
        data: request.httpBody,
        queryParameters: request.queryParams,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } catch (error) {
      if (error is DioException) {
        dioException = error;
      }
      final temp = dioException?.response;
      if (temp is Response<dynamic>) {
        response = temp;
      }
      errorMessage = dioException?.message;
      if (dioException?.error is SocketException) {
        SocketException error2 = dioException?.error as SocketException;
        switch (error2.osError?.errorCode) {
          case 51:
            isNetworkDisconnected = true;
            break;
          default:
            break;
        }
      }
    }
    apiStream?.isFinished = true;
    responseBody = response?.data;
    if (response?.statusCode == 200 && response?.data is Map) {
      type = VMResultType.successful;
    } else if (response?.data is String) {
      errorMessage = (response?.data as String).jsonMap?.stringFor(errorKey);
      if (response!.statusCode != 200) {
        type = VMResultType.apiFailed;
      }
    } else {
      type = VMResultType.connectionError;
      if (dioException?.type == DioExceptionType.connectionTimeout ||
          dioException?.type == DioExceptionType.sendTimeout ||
          dioException?.type == DioExceptionType.receiveTimeout) {
        errorMessage = "timedOut";
      } else {
        if (isNetworkDisconnected) {
          errorMessage = "networkError";
        } else {
          errorMessage = "serversException";
        }
      }
    }

    if (customAnalysis != null) {
      await customAnalysis!(request, options, response, dioException,
          (VMResultType resultType, [String? error2]) {
        type = resultType;
        errorMessage = error2 ?? "serversException";
      });
    }

    if (!completerCompleted) {
      await request.saveCache(responseBody);
      completer.complete(VMResult(
          type, responseBody, response?.statusCode, request,
          responseHeaders: response?.headers.map, errorMessage: errorMessage));
    }

    final value = await completer.future;
    return value;
  }

  VMApiStream<VMResult> request<T>({VMRequest? re}) {
    re ??= VMRequest();
    final token = CancelToken();
    final as = VMApiStream<VMResult>();
    as.queryCache(re);
    as.setFuture(_request(
      re,
      cancelToken: token,
      apiStream: as,
      onReceiveProgress: as.onReceiveProgress,
      onSendProgress: as.onSendProgress,
    ));
    as.dioCancelToken = token;
    return as;
  }

  Future<Response> dioUpload(String url, String filePath,
      {Map<String, String> headers = const {},
      Map<String, String> body = const {},
      Function? progressCallback}) async {
    Map<String, dynamic> data = Map.of(body);
    //print(basename(filePath));
    data[''] = await MultipartFile.fromFile(
      filePath,
    );
    FormData formData = FormData.fromMap(data); //form data上传文件
    Dio dio = new Dio();
    CancelToken cancelToken = CancelToken();
    Response resp = await dio.post(url, data: formData,
        onSendProgress: (int count, int data) {
      vmPrint("onSendProgress $count $data");
      if (progressCallback != null) {
        progressCallback(count, data, cancelToken);
      }
    });
    if (resp.statusCode == 200) {
      return resp.data;
    } else {
      throw new Exception("网络访问错误");
    }
  }
}
