import 'dart:io';

import 'package:beering/ble/ble_manager.dart';

int _maxLen = 4000;

void vmPrint(final dynamic message, [int? level]) {
  _printLog(message);
  if (level == KBLEManager.logevel) {
    KBLEManager.logController.add(message.toString());
  }
}

void _printLog(Object object) {
  String da = object.toString();
  if (Platform.isAndroid) {
    print(da);
  } else {
    print(da);
  }
}
