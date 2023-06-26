import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

const bool inProduction = kReleaseMode;
final bool isAndroid = Platform.isAndroid;
final bool isIOS = Platform.isIOS;
const String assetsImages = './assets/images/';

const kDesignSize = Size(375, 812);

const fontFamilyRoboto = 'Roboto';

enum KHealthDataType {
  STEPS, //步数
  DISTANCE, //里程
  CALORIES_BURNED, //运动消耗
  SLEEP, //睡眠
  HEART_RATE, //心率
  BLOOD_OXYGEN, //血氧饱和度
  EMOTION, //情绪
  STRESS, //压力
  BODY_TEMPERATURE, //体温
  FEMALE_HEALTH, //女性健康
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
  return Size(painter.width, painter.height);
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
