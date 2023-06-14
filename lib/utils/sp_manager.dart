import 'package:http/retry.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'console_logger.dart';

class SPManager {
  static SharedPreferences? _sp;
  static SharedPreferences get sp {
    return _sp!;
  }

  static spInit(SharedPreferences sp) {
    _sp = sp;
  }
}
