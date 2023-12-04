import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:beering/public.dart';

extension StringEx on String {
  List<T>? jsonList<T>() {
    final value = jsonDecode(this);
    //
    if (value is List<T>) {
      return value;
//    } else if (value is List && T is Map) {
//      return value.myMap<T>((ele) {
//        final v2 = Map.from(ele);
//        return v2 as T;
//      });
    } else if (value is Iterable<T>) {
      return List<T>.from(value);
    } else if (value is List) {
      List value2 = value;
      List<T> value3 = [];
      for (final e in value2) {
        if (e is T || e == null) {
          value3.add(e);
        } else {
          return null;
        }
      }
      return value3;
    }
    return null;
  }

  Map<String, dynamic>? get jsonMap {
    try {
      final value = jsonDecode(this);
      if (value is Map<String, dynamic>) return value;
    } catch (e) {}
    return null;
  }

  bool hasSuffix(String suffix) {
    if (suffix.length > this.length) {
      return false;
    }
    final suffix2 = this.substring(this.length - suffix.length, suffix.length);
    return suffix2 == suffix;
  }

  static bool _hasSuffix(String str, String suffix) {
    if (suffix.length > str.length) {
      return false;
    }
    final suffix2 = str.substring(str.length - suffix.length, str.length);
    return suffix2 == suffix;
  }

  String fractionZeroSuffixRemoved() {
    if (this.split('.').length == 2) {
      return StringEx._fractionZeroSuffixRemoved(this);
    } else {
      return this;
    }
  }

  static String _fractionZeroSuffixRemoved(String str) {
    if (!StringEx._hasSuffix(str, '0')) {
      if (StringEx._hasSuffix(str, '.')) {
        str = str.substring(0, str.length - 1);
      }
      return str;
    }
    return StringEx._fractionZeroSuffixRemoved(
        str.substring(0, str.length - 1));
  }

  int? get intValue {
    try {
      return int.tryParse(this);
    } catch (error) {
      return null;
    }
  }

  double? get doubleValue {
    try {
      return double.tryParse(this);
    } catch (error) {
      return null;
    }
  }

  String replaceMedium(final int head, final int tail, final String replace) {
    if (length < head + tail + 1) return this;
    return substring(0, head) + replace + substring(length - tail, length);
  }

  bool isValidPhoneNumber() {
    final RegExp regex = RegExp(r'^1[3-9]\d{9}$');
    return regex.hasMatch(this);
  }

  String formatHexStringAsMac() {
    StringBuffer formattedMac = StringBuffer();

    for (int i = 0; i < this.length; i += 2) {
      formattedMac.write(this.substring(i, i + 2));

      if (i < this.length - 2) {
        formattedMac.write(':');
      }
    }

    return formattedMac.toString().toUpperCase();
  }

  String reversePairs() {
    List<String> pairs = [];
    for (int i = 0; i < length; i += 2) {
      if (i + 1 < length) {
        pairs.add(substring(i, i + 2));
      } else {
        pairs.add(substring(i));
      }
    }
    return pairs.reversed.join('');
  }

  int compare(String str1, String str2) {
    List<String> strInt1 = str1.trim().split(".");
    List<String> strInt2 = str2.trim().split(".");
    int maxLen = max(strInt1.length, strInt2.length);
    for (var i = 0; i < maxLen; i++) {
      int a = 0;
      int b = 0;
      if (i < strInt1.length) {
        a = int.tryParse(strInt1[i])!;
      }
      if (i < strInt2.length) {
        b = int.tryParse(strInt2[i])!;
      }
      if (a > b) {
        vmPrint("比对结果  1");
        return 1;
      } else if (a == b) {
        continue;
      } else {
        vmPrint("比对结果  -1");
        return -1;
      }
    }
    vmPrint("比对结果  0");
    return 0;
  }
}
