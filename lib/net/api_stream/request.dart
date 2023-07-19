import 'package:focusring/extensions/MapEx.dart';

import '../../utils/cahce_manager.dart';

const int httpSendTimeoutInterval = 30;
const int httpReceiveTimeoutInterval = 30;

enum VMMethod {
  GET,
  POST,
}

extension VMMethodEX on VMMethod {
  String get methodString {
    return ["get", "post"][index];
  }
}

class VMRequest {
  VMMethod vmMethod = VMMethod.GET;
  String path = '';
  String contentType = 'application/json; charset=utf-8';
  Map<String, dynamic>? queryParams;
  dynamic httpBody;
  int get sendTimeoutInterval => httpSendTimeoutInterval * 1000;
  int get receiveTimeoutInterval => httpReceiveTimeoutInterval * 1000;
  //String oauthToken;
  Map<String, String>? requestHeaders;

  bool canQueryCache = false;

  bool needAccessToken = false;

  String? queryPageKey;
  String get queryKey => path + ((queryParams ?? {}).jsonString);

  @override
  String toString() {
    // TODO: implement toString
    return 'method ${vmMethod.methodString} ,path $path queryParams $queryParams';
  }

  Future<Map<String, dynamic>?> queryCache() async {
    if (canQueryCache == false) {
      return Future.value(null);
    }
    var data = await VMCacheManager.query(queryKey);
    return data;
  }

  Future saveCache(dynamic value) async {
    if (value == null) {
      return;
    }

    if (canQueryCache == false) {
      return null;
    }
    if (queryPageKey != null && queryParams != null) {
      int page = queryParams!.intFor(queryPageKey!) ?? 0;
      if (page != 1) {
        return null;
      }
    }
    return VMCacheManager.refresh(queryKey, value);
  }
}
