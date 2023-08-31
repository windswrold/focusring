import 'package:flutter_device_identifier/flutter_device_identifier.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:beering/app/data/user_info.dart';
import 'package:beering/public.dart';
import 'package:beering/utils/json_util.dart';
import 'package:beering/utils/localeManager.dart';
import 'package:beering/utils/permission.dart';
import 'package:http/retry.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
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

  static const String _getPhoneID = '_getPhoneID';

  static Future<String> getPhoneID() async {
    FlutterSecureStorage flutterSecureStorage = const FlutterSecureStorage();
    String? value = await flutterSecureStorage.read(key: _getPhoneID);
    final uuid = const Uuid().v4();

    try {
      if (isAndroid) {
        value = await FlutterDeviceIdentifier.androidID;
      }
      vmPrint("imei $value");
    } catch (e) {
      vmPrint(e.toString());
    }
    value ??= uuid;
    flutterSecureStorage.write(key: _getPhoneID, value: value);
    return value;
  }

  static const String _globalUser = '_globalUser';

  static UserInfoModel? getGlobalUser() {
    var userJson = sp.getString(_globalUser);
    if (userJson != null) {
      return UserInfoModel.fromJson(JsonUtil.getObj(userJson));
    }
    return null;
  }

  static void setGlobalUser(UserInfoModel user) async {
    var json = JsonUtil.encodeObj(user.toJson());

    await sp.setString(_globalUser, json!);
  }

  static const String _firstInstall = '_firstInstall';

  static bool getInstallStatus() {
    var a = sp.getBool(_firstInstall);
    return a ?? false;
  }

  static void setInstallStatus() async {
    await sp.setBool(_firstInstall, true);
  }
}
