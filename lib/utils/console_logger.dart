import 'dart:io';

int _maxLen = 4000;

void vmPrint(final dynamic message, [int? level]) {
  _printLog(message);
}

void _printLog(Object object) {
  String da = object.toString();
  if (Platform.isAndroid) {
    print(da);
  } else {
    print(da);
  }
}
