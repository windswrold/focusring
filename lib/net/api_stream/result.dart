import 'package:beering/extensions/StringEx.dart';
import 'package:beering/net/api_stream/request.dart';
import '../../extensions/MapEx.dart';

enum VMResultType { none, cancelled, connectionError, apiFailed, successful }

class VMResult {
  final VMResultType type;
  final Map? responseHeaders;
  final dynamic responseBody;
  final int? statusCode;
  final String? errorMessage;
  final bool isTimeout;
  final VMRequest? request;

  VMResult(this.type, this.responseBody, this.statusCode, this.request,
      {this.errorMessage, this.responseHeaders, this.isTimeout = false});

  Map? get mapBody {
    if (responseBody is String) {
      final String t = responseBody!;
      return t.jsonMap;
    } else if (responseBody is Map) {
      return Map.of(responseBody);
    } else {
      return null;
    }
  }

  Map? get mapResult {
    return mapBody?.mapFor('result');
  }

  List<dynamic>? get listResult {
    return mapBody?.listFor('result');
  }

  String? get stringResult {
    return mapBody?.stringFor('result');
  }

  int? get intResult {
    return mapBody?.intFor('result');
  }

  int? get code {
    return mapBody?.intFor('code');
  }

  String? get error {
    switch (type) {
      case VMResultType.connectionError:
      case VMResultType.apiFailed:
        return errorMessage ?? "serversException";
      case VMResultType.successful:
      case VMResultType.none:
      case VMResultType.cancelled:
        return null;
    }
  }
}
