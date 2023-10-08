import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Locale toLocale(String key) {
  final arr = key.split('_');
  return Locale(arr[0], arr[1]);
}

String getLocaleKey(Locale locale) {
  return '${locale.languageCode}_${locale.countryCode}';
}

const fallbackLocale = Locale('en', 'US');

/** 
日语,
简体中文,
英语
德语，
法语，
意大利语，
西班牙语，
荷兰语
波兰语，
葡萄牙语， 巴西
葡萄牙语，葡萄牙
罗马尼亚
捷克语,
丹麦
*/

