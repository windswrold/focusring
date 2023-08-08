import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:focusring/app/data/device_info.dart';
import 'package:focusring/app/data/user_info.dart';
import 'package:focusring/utils/console_logger.dart';
import 'package:focusring/utils/sp_manager.dart';
import 'package:focusring/views/base/base_pageview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../public.dart';

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
  // interval,
  awake,
  lightSleep,
  deepSleep,
}

enum KHeartRateStatus {
  /// 极限状态
  extreme,

  /// 无氧状态
  anaerobic,

  /// 心肺状态
  cardiovascular,

  /// 燃脂状态
  fatBurning,

  /// 减压状态
  relaxation,

  /// 静息状态
  resting,
}

enum KEMOTIONStatus {
  /// 积极的情绪
  positive,

  /// 平和的情绪
  neutral,

  /// 消极的情绪
  negative,
}

enum KStressStatus {
  /// 正常范围 (0~29)
  normal,

  /// 轻度范围 (30~59)
  mild,

  /// 中度范围 (60~79)
  moderate,

  /// 重度范围 (80~100)
  severe,
}

enum KFemmaleStatus {
  ///正常
  normal,
  //经期预测
  yuce,
  //安全期
  anquanqi,
  //月经期
  yujinqi,
}

enum KUnits { metric, imperial }

enum KTempUnits { celsius, fahrenheit }

enum KSex { man, woman }

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

Widget getAppBar(String title) {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    leadingWidth: 40.w,
    leading: KBasePageView.getBack(() {
      Get.back();
    }),
    centerTitle: true,
    title: Text(
      title,
      style: Get.textTheme.titleLarge,
      textAlign: TextAlign.left,
    ),
  );
}

int getSystemType() {
  return isIOS ? 1 : 2;
}

bool compareUUID(String a, String b) {
  a = a.toLowerCase().replaceAll("-", "");
  b = b.toLowerCase().replaceAll("-", "");
  vmPrint("a $a b $b");

  HWToast.showSucText(text: "比对 id\n$a\napp: $b\n结果 ${a == b}");
  return a == b;
}

class GlobalValues {
  static MSDeviceInfo deviceInfo = MSDeviceInfo();

  static Future<void> init() async {
    if (Platform.isAndroid) {
      final AndroidDeviceInfo and = await DeviceInfoPlugin().androidInfo;
      // deviceInfo.imei = and.deviceInfo;
      // deviceInfo.machine = and.device;
      // deviceInfo.system = 'Android' + (and.version.release ?? '');
      // deviceInfo.appType = 'Android';

      vmPrint("and " + and.data.toString());
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
