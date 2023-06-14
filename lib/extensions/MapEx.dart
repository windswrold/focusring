import 'dart:convert';

extension MapEx<K, V> on Map<K, V> {
  String get jsonString {
    return jsonEncode(this);
  }

  String? stringFor(String key) {
    final value = this[key];
    if (value == null) {
      return null;
    }
    if (value is String) {
      return value;
    } else {
      return "$value";
    }
  }

  int? intFor(String key, {int? radix}) {
    final value = this[key];
    if (value is int) {
      return value;
    } else if (value is String) {
      return int.tryParse(value.replaceFirst("0x", ""), radix: radix);
    } else {
      return null;
    }
  }

  num? numFor(String key) {
    final value = this[key];
    if (value is num) {
      return value;
    } else {
      return null;
    }
  }

  double? doubleFor(String key) {
    final value = this[key];
    if (value is double) {
      return value;
    } else if (value is int) {
      return value.toDouble();
    } else {
      return null;
    }
  }

  Map<K, V>? mapFor<K, V>(String key) {
    final value = this[key];
    if (value is Map<K, V>) {
      return value;
    } else {
      return null;
    }
  }

  List<T>? listFor<T>(String key) {
    final value = this[key];
    if (value is List<T>) {
      return value;
    } else if (value is Iterable<T>) {
      Iterable<T> value2 = value;
      return value2.toList();
    } else if (value is Iterable) {
//      vmPrint("value:${value.runtimeType}");
//      vmPrint("T:$T");
      List<T> value3 = [];
      for (final e in value) {
//        vmPrint("e:${e.runtimeType}");
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

  bool? boolFor(String key) {
    final value = this[key];
    if (value is bool) {
      return value;
    } else if (value is int) {
      if (value == 1)
        return true;
      else if (value == 0) return false;
      return true;
    } else {
      return null;
    }
  }

//  String get jsonString {
//    return converter.jsonEncode(this);
//  }

//  List<T> modelsFor<T extends JSONDeserializable>(String key) {
//    final value = this[key];
//    if (value is List<Map>) {
//      List<Map> list = value;
//      return list.myMap<T>((ele) {
//        Type type = T;
//        return ;
//      });
//    } else {
//      return [];
//    }
//  }

  Map<K, V> recursivelyRemoveNullItems() {
    final List<K> _keys = [];
    this.forEach((key, value) {
      if (value == null)
        _keys.add(key);
      else if (value is Map) {
        final Map t = value;
        // this[key] = t.recursivelyRemoveNullItems() as V;
        t.recursivelyRemoveNullItems();
      }
    });
    _keys.forEach(this.remove);
    return this;
  }
}
