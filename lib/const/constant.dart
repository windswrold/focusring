import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:focusring/app/data/device_info.dart';
import 'package:focusring/utils/console_logger.dart';
import 'package:focusring/utils/sp_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

const bool inProduction = kReleaseMode;
final bool isAndroid = Platform.isAndroid;
final bool isIOS = Platform.isIOS;
const String assetsImages = './assets/images/';

const kDesignSize = Size(375, 812);

const fontFamilyRoboto = 'Roboto';

enum KHealthDataType {
  STEPS, //步数
  LiCheng, //运动里程
  CALORIES_BURNED, //消耗
  SLEEP, //睡眠
  HEART_RATE, //心率
  BLOOD_OXYGEN, //血氧饱和度
  EMOTION, //情绪
  STRESS, //压力
  BODY_TEMPERATURE, //体温
  FEMALE_HEALTH, //女性健康
}

enum KState { idle, loading, success, fail }

enum KReportType { day, week, moneth }

enum KSleepStatus {
  interval,
  awake,
  lightSleep,
  deepSleep,
}

Size calculateTextSize(
  String value,
  double fontSize,
  FontWeight fontWeight,
  double maxWidth,
  int? maxLines,
  BuildContext context,
) {
  TextPainter painter = TextPainter(
    locale: Localizations.localeOf(context),
    maxLines: maxLines,
    textDirection: TextDirection.ltr,
    text: TextSpan(
      text: value,
      style: TextStyle(
        fontWeight: fontWeight,
        fontSize: fontSize,
      ),
    ),
  );
  painter.layout(maxWidth: maxWidth);
  var a = Size(painter.width, painter.height);
  vmPrint(a);
  return a;
}

Future<File> getAppFile() async {
  Directory? documentsDir;
  if (isAndroid) {
    documentsDir = await getExternalStorageDirectory();
  } else {
    documentsDir = await getApplicationDocumentsDirectory();
  }
  String documentsPath = documentsDir!.absolute.path;
  File file = File(documentsPath);
  return file;
}

Future<File> saveFileData(
    {required String content, required String pathType}) async {
  try {
    final buffer = utf8.encode(content);
    final dir = await getAppFile();
    var name = 'data_${DateTime.now()}.$pathType';
    String documentsPath = "${dir.path}/";
    File file = File('$documentsPath$name');
    file.writeAsBytesSync(buffer);
    return file;
  } catch (e) {
    throw e;
  }
}

const AppViewControllerTag = "AppViewControllerTag";

class GlobalValues {
  static MSDeviceInfo deviceInfo = MSDeviceInfo();

  static Future<void> init() async {
    if (Platform.isAndroid) {
      final AndroidDeviceInfo and = await DeviceInfoPlugin().androidInfo;
      deviceInfo.imei = and.id;
      deviceInfo.machine = and.device;
      deviceInfo.system = 'Android' + (and.version.release ?? '');
      deviceInfo.appType = 'Android';

      vmPrint("and " + and.toString());
    } else if (Platform.isIOS) {
      final IosDeviceInfo iOS = await DeviceInfoPlugin().iosInfo;
      deviceInfo.imei = iOS.identifierForVendor;
      deviceInfo.machine = iOS.utsname.machine;
      deviceInfo.system = (iOS.systemName ?? '') + (iOS.systemVersion ?? '');
      deviceInfo.appType = 'iOS';
      vmPrint("ios " + iOS.toString());
    }
    final info = await PackageInfo.fromPlatform();
    deviceInfo.appInfo = info;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    SPManager.spInit(prefs);
    vmPrint("pack " + info.toString());
  }
}
