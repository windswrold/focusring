import 'package:focusring/public.dart';
import 'package:focusring/utils/localeManager.dart';
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

  static const String _systemlanguageSET = 'systemLANGUAGE_SET';

  static String getAppLanguage() {
    String? value = _sp!.getString(_systemlanguageSET);
    return value ?? getLocaleKey(fallbackLocale);
  }

  static void setAppLanguage(Locale value) {
    _sp!.setString(_systemlanguageSET, getLocaleKey(value));
  }
}
