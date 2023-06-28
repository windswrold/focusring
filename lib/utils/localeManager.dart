import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Locale toLocale(String key) {
  final arr = key.split('_');
  return Locale(arr[0], arr[1]);
}

String getLocaleKey(Locale locale) {
  return '${locale.languageCode}_${locale.countryCode}';
}

const fallbackLocale = Locale('zh', 'CN');

/** 
English,
简体中文,
繁体中文,
西班牙语，
意大利语，
法语，
德语，
俄语，
葡萄牙语，
乌克兰语，
波兰语，
土耳其语，
捷克语
*/

