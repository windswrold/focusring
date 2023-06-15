import 'package:native_flutter_proxy/native_proxy_reader.dart';

import '../../utils/console_logger.dart';

class VMNetwork {
  final String? prefix;
  final int? printLevel;

  const VMNetwork({this.prefix, this.printLevel});

  String urlWithSuffix(String suffix) {
    if (suffix.startsWith("/")) {
      suffix = suffix.substring(1);
    }
    final p = prefix;
    if (p == null || p.isEmpty) return suffix;
    String prefix2 = p;
    if (!prefix2.endsWith('/')) {
      prefix2 = prefix2 + '/';
    }
    String str = prefix2 + suffix;
    return str;
  }

  static Future<String> get getSystemProxy async {
    String? host;
    int? port;
    bool enabled = false;
    try {
      ProxySetting settings = await NativeProxyReader.proxySetting;
      enabled = settings.enabled;
      host = settings.host;
      port = settings.port;
    } catch (e) {
      vmPrint(e);
    }
    if (!enabled) {
      return "DIRECT";
    }
    return "PROXY $host:$port";
  }
}
