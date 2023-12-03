///Mike 2019/12/19
import 'dart:convert';
import 'dart:math';

import 'package:beering/public.dart';
import 'package:beering/utils/date_util.dart';
import 'package:decimal/decimal.dart';
import 'package:hex/hex.dart';

extension ListEx<E> on List<E> {
  static List<T> generateArray<T>(int minValue, int maxValue, int interval) {
    List<T> result = [];

    for (int i = minValue; i <= maxValue; i += interval) {
      if (T == int) {
        result.add(i as T);
      } else if (T == String) {
        result.add(i.toString() as T);
      }
    }

    return result;
  }

  String get jsonString {
    return jsonEncode(this);
  }

  void removeAll() => this.clear();

  List<T> myMap<T>(T Function(E element) convert) {
    List<T> list = [];
    this.forEach((element) {
      final result = convert(element);
      if (result != null) {
        list.add(result);
      }
    });
    return list;
  }

  List<E> peek(void Function(E value) consume) {
    this.forEach((element) {
      consume(element);
    });
    return this;
  }

  List<T> myMapWithIndex<T>(T Function(E element, int index) convert) {
    List<T> list = [];
    int index = 0;
    this.forEach((element) {
      final result = convert(element, index);
      if (result != null) {
        list.add(result);
      }
      index += 1;
    });
    return list;
  }

  Future<List<T>> futureMapWithIndex<T>(
      Future<T> Function(E element, int index) convert) async {
    List<T> list = [];
    int index = 0;
    for (var element in this) {
      final result = await convert(element, index);
      if (result != null) {
        list.add(result);
      }
      index += 1;
    }
    return list;
  }

  List<E> get randomSorted {
    List<E> target = [];
    List<int> indexes = this.myMapWithIndex((value, index) => index);
    for (int index = 0; index < this.length; index++) {
      int random = Random().nextInt(indexes.length);
      int targetIndex = indexes[random];
      target.add(this[targetIndex]);
      indexes.removeAt(random);
    }
    return target;
  }

  ///Insert a new element between array elements
  void insertBetweenElements(E Function(int index) map) {
    if (this.length > 1) {
      final lll = this.length - 1;
      for (var i = 0; i < lll; ++i) {
        final v = map(i);
        this.insert(2 * i + 1, v);
      }
    }
  }

  List<E> joinedByElements(E Function(int index) map) {
    if (this.length > 1) {
      final lll = this.length - 1;
      for (var i = 0; i < lll; ++i) {
        final v = map(i);
        this.insert(2 * i + 1, v);
      }
    }
    return this;
  }

//  String get jsonString {
//    return converter.jsonEncode(this);
//  }

  List<E> limit(int count) {
    return this.sublist(0, min(count, length));
  }

  E? tryFindFirstWhile(bool Function(E) test) {
    E? result;
    for (final o in this) {
      if (test(o)) {
        result = o;
        break;
      }
    }
    return result;
  }

  E? get trySingle {
    try {
      return single;
    } catch (e) {
      return null;
    }
  }

  E? get tryFirst {
    try {
      return first;
    } catch (e) {
      return null;
    }
  }

  E? get tryLast {
    try {
      return last;
    } catch (e) {
      return null;
    }
  }

  static List<String> generateHeightArr(KUnitsType unit) {
    if (unit == KUnitsType.metric) {
      return generateArray<String>(50, 228, 1);
    }

    return generateArray<String>(20, 90, 1);
  }

  static List<String> generateWeightArr(KUnitsType unit) {
    if (unit == KUnitsType.metric) {
      return generateArray<String>(30, 228, 1);
    }
    return generateArray<String>(66, 503, 1);
  }

  static List<String> generateHeartRateMaxArr() {
    return ListEx.generateArray<String>(91, 180, 1);
  }

  static List<String> generateHeartRateMinArr() {
    return ListEx.generateArray<String>(20, 90, 1);
  }

  static List<String> generateHeartRateAutoTestInterval() {
    return ["5", "30", "60"];
  }

  static List<String> generateBloodOxygenAutoTestInterval() {
    return ["5", "30", "60"];
  }

  static double averageNum(List data) {
    Decimal result = sumVal(data);
    return getPercent(
        current: result.toDouble(),
        all: data.length.toDouble(),
        isHaveMin: false);
  }

  static T maxVal<T extends num>(List<T> data) {
    return data.reduce((a, b) => a > b ? a : b);
  }

  static T minVal<T extends num>(List<T> data) {
    return data.reduce((a, b) => a < b ? a : b);
  }

  static Decimal sumVal(List data) {
    Decimal value = Decimal.zero;
    for (var element in data) {
      value = value + Decimal.parse(element.toString());
    }
    return value;
  }

  static stepsValue(List e) {
    return ((e[0] & 0xff) |
        ((e[1] & 0xff) << 8) |
        ((e[2] & 0xff) << 16) |
        ((e[3] & 0xff) << 24));
  }

  static List<String> getFiveMinuteIntervals() {
    final DateTime startDate = DateTime(2023, 9, 21, 0, 0); // 开始时间00:00
    final DateTime endDate = DateTime(2023, 9, 22, 0, 0); // 结束时间00:00

    List<String> intervals = [];
    DateTime currentTime = startDate;

    while (currentTime.isBefore(endDate) ||
        currentTime.isAtSameMomentAs(endDate)) {
      intervals.add(DateUtil.formatDate(currentTime, format: "HH:mm"));
      currentTime = currentTime.add(Duration(minutes: 5));
    }

    return intervals;
  }
}
