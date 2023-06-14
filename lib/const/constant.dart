import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vmeta3v2/utils/date_util.dart';

const bool inProduction = kReleaseMode;
final bool isAndroid = Platform.isAndroid;
final bool isIOS = Platform.isIOS;
const String assetsImages = './assets/images/';

const kDesignSize = Size(320, 570);

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
    var name = 'data_${DateUtil.getNowDateMs()}.$pathType';
    String documentsPath = "${dir.path}/";
    File file = File('$documentsPath$name');
    file.writeAsBytesSync(buffer);
    return file;
  } catch (e) {
    throw e;
  }
}
