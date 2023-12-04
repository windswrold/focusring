import 'dart:io';

import 'package:beering/ble/ble_manager.dart';
import 'package:beering/public.dart';

int _maxLen = 4000;

void vmPrint(final dynamic message, [int? level]) {
  _printLog(message);
  if (level == KBLEManager.logevel) {
    KBLEManager.logController.add(message.toString());
    GlobalValues.logger?.i(message);
  }
}

void _printLog(Object object) {
  String da = object.toString();
  if (inProduction == true) {
    return;
  }
  if (da.length <= _maxLen) {
    debugPrint(da);
    return;
  }
  while (da.isNotEmpty) {
    if (da.length > _maxLen) {
      debugPrint('${da.substring(0, _maxLen)}');
      da = da.substring(_maxLen, da.length);
    } else {
      debugPrint(da);
      da = '';
    }
  }
}
