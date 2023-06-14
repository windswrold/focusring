import 'package:flutter/widgets.dart';

extension StateExtension on State {
  void safeSetState(VoidCallback callBack) {
    if (!mounted) return;
    setState(callBack);
  }
}
