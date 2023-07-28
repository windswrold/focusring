import 'dart:convert';
import 'dart:typed_data';

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
}
