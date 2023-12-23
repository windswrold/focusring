import 'dart:math';
import 'dart:typed_data';

import 'package:beering/app/data/user_info.dart';
import 'package:beering/app/modules/app_view/controllers/app_view_controller.dart';
import 'package:beering/ble/ble_manager.dart';
import 'package:beering/db/database_config.dart';
import 'package:beering/public.dart';
import 'package:beering/utils/date_util.dart';
import 'package:beering/utils/hex_util.dart';
import 'package:beering/utils/json_util.dart';
import 'package:beering/views/charts/home_card/model/home_card_x.dart';
import 'package:decimal/decimal.dart';
import 'package:floor/floor.dart';

import '../../const/event_bus_class.dart';
import '../../views/charts/radio_gauge_chart/model/radio_gauge_chart_model.dart';

const String tableName = 'bloodOxygenData_v2';

@Entity(tableName: tableName, primaryKeys: ["appUserId", "createTime"])
class BloodOxygenData {
  int? appUserId;
  String? mac;
  String? createTime;
  int? averageHeartRate; //自己计算这一天的平均值
  int? max; //自己计算当天最高
  int? min; //自己计算当天最低
  String? bloodArray;

  BloodOxygenData({
    this.appUserId,
    this.mac,
    this.createTime,
    this.bloodArray,
    this.averageHeartRate,
    this.max,
    this.min,
  });

  factory BloodOxygenData.fromJson(Map<String, dynamic> json) =>
      BloodOxygenData(
        appUserId: json["appUserId"],
        mac: json["mac"],
        createTime: json["createTime"],
        bloodArray: json["bloodOxygen"],
        averageHeartRate: json["averageHeartRate"],
        max: json["max"],
        min: json["min"],
      );

  Map<String, dynamic> toJson() => {
        "appUserId": appUserId,
        "mac": mac,
        "createTime": createTime,
        "bloodOxygen": bloodArray,
      };

  static Future<List<BloodOxygenData>> queryUserAll(
    int appUserId,
    String createTime,
    String nextTime,
  ) async {
    final db = await DataBaseConfig.openDataBase();
    final datas =
        await db?.bloodDao.queryUserAll(appUserId, createTime, nextTime);
    return datas ?? [];
  }

  static Future<void> insertTokens(List<BloodOxygenData> models) async {
    final db = await DataBaseConfig.openDataBase();
    return await db?.bloodDao.insertTokens(models);
  }
}

const String tableName2 = 'heartRateData_v2';

@Entity(tableName: tableName2, primaryKeys: ["appUserId", "createTime"])
class HeartRateData {
  int? appUserId;
  String? mac;
  String? createTime;
  int? averageHeartRate; //这一天的平均值
  int? max; //自己计算当天最高
  int? min; //自己计算当天最低
  String? heartArray;

  ///心率的原始数据

  HeartRateData({
    this.appUserId,
    this.mac,
    this.createTime,
    this.averageHeartRate,
    this.heartArray,
    this.max,
    this.min,
  });

  factory HeartRateData.fromJson(Map<String, dynamic> json) => HeartRateData(
        appUserId: json["appUserId"],
        mac: json["mac"],
        createTime: json["createTime"],
        heartArray: json["heartArray"],
        averageHeartRate: json["averageHeartRate"],
        max: json["max"],
        min: json["min"],
      );

  Map<String, dynamic> toJson() => {
        "appUserId": appUserId,
        "mac": mac,
        "createTime": createTime,
        "averageHeartRate": averageHeartRate,
        "heartArray": heartArray,
      };

  static Future<List<HeartRateData>> queryUserAll(
    int appUserId,
    String createTime,
    String nextTime,
  ) async {
    final db = await DataBaseConfig.openDataBase();
    final datas =
        (await db?.heartDao.queryUserAll(appUserId, createTime, nextTime)) ??
            [];
    return datas;
  }

  static Future<void> insertTokens(List<HeartRateData> models) async {
    final db = await DataBaseConfig.openDataBase();
    return await db?.heartDao.insertTokens(models);
  }

  List<RadioGaugeChartData> calPercent() {
    List datas = JsonUtil.getObj(heartArray) ?? [];
    if (datas.isEmpty) {
      return RadioGaugeChartData.getDefaultHeartGaugeData();
    }
    int all = datas.length;
    Map<KHeartRateStatusType, double> intervalCounts = {};
    for (var element in datas) {
      KHeartRateStatusType type = KHeartRateStatusEX.getExerciseState(element);
      double count = (intervalCounts[type] ?? 0);
      count += 1;
      intervalCounts[type] = count;
    }
    List<RadioGaugeChartData> charts = [];
    for (var e in KHeartRateStatusType.values) {
      RadioGaugeChartData a = RadioGaugeChartData(
        title: e.getStatusDesc() + e.getStateCondition(),
        color: e.getStatusColor(),
        allStr: all.toString(),
        currentStr: (intervalCounts[e] ?? 0).toString(),
      );
      charts.add(a);
    }

    vmPrint("intervalCounts $all  $intervalCounts", KBLEManager.logevel);

    return charts;
  }
}

const String tableName3 = 'stepData_v3';

@Entity(tableName: tableName3, primaryKeys: ["appUserId", "createTime"])
class StepData {
  int? appUserId;
  String? mac;
  String? createTime;
  String? steps; //总步数

  String? dataArrs; //步数的数据源

  String? max; //当天最大步数

  StepData(
      {this.appUserId,
      this.mac,
      this.createTime,
      this.steps,
      this.max,
      // this.distance,
      // this.calorie,
      // this.dataForHour,
      this.dataArrs});

  factory StepData.fromJson(Map<String, dynamic> json) => StepData(
      appUserId: json["appUserId"],
      mac: json["mac"],
      createTime: json["createTime"],
      steps: json["steps"],
      // distance: json["distance"],
      // calorie: json["calorie"],
      // dataForHour: json["dataForHour"],
      dataArrs: json["dataForHour"]);

  Map<String, dynamic> toJson() => {
        "appUserId": appUserId,
        "mac": mac,
        "createTime": createTime,
        "steps": steps,
        "max":max,
        // "distance": distance,
        // "calorie": calorie,
        "dataForHour": dataArrs,
      };

  static Future<List<StepData>> queryUserAll(
    int appUserId,
    String createTime,
    String nextTime,
  ) async {
    final db = await DataBaseConfig.openDataBase();
    final datas =
        await db?.stepDao.queryUserAll(appUserId, createTime, nextTime);
    return datas ?? [];
  }

  static Future<void> insertTokens(List<StepData> models) async {
    final db = await DataBaseConfig.openDataBase();
    return await db?.stepDao.insertTokens(models);
  }
}

const String tableName4 = 'TempData_v2';

@Entity(tableName: tableName4, primaryKeys: ["appUserId", "createTime"])
class TempData {
  int? appUserId;
  String? mac;
  String? createTime;
  int? temperature;
  String? average; //自己计算这一天的平均值
  String? max; //自己计算当天最高
  String? min; //自己计算当天最低
  String? dataArray;

  TempData({
    this.appUserId,
    this.mac,
    this.createTime,
    this.temperature,
    this.average,
    this.dataArray,
    this.max,
    this.min,
  });

  factory TempData.fromJson(Map<String, dynamic> json) => TempData(
        appUserId: json["appUserId"],
        mac: json["mac"],
        createTime: json["createTime"],
        temperature: json["temperature"],
      );

  Map<String, dynamic> toJson() => {
        "appUserId": appUserId,
        "mac": mac,
        "createTime": createTime,
        "temperature": temperature,
        "average": average,
        "min": min,
        "max": max,
      };

  static Future<List<TempData>> queryUserAll(
    int appUserId,
    String createTime,
    String nextTime,
  ) async {
    final db = await DataBaseConfig.openDataBase();
    final datas =
        await db?.tempDap.queryUserAll(appUserId, createTime, nextTime);
    return datas ?? [];
  }

  static Future<bool> esistData(int appUserId, String createTime) async {
    final db = await DataBaseConfig.openDataBase();
    final List<Map<String, Object?>> datas = await db?.database.rawQuery(
            "select * from $tableName4  where appUserId= ? and createTime = ? ",
            [appUserId, createTime]) ??
        [];
    return datas.isEmpty ? false : true;
  }

  static Future insertTokens(List<TempData> models) async {
    final db = await DataBaseConfig.openDataBase();
    return await db?.tempDap.insertTokens(models);
  }
}

const String tableName5 = 'SleepData_V2';

@Entity(tableName: tableName5, primaryKeys: ["appUserId", "createTime"])
class SleepData {
  int? appUserId;
  String? mac;
  String? createTime;

  int? start_Sleep; //入睡时间
  int? end_Sleep; //起床时间

  int? awake_time; //计算每一天的清醒时间
  int? light_sleep_time; //计算某一天的浅睡时间
  int? deep_sleep_time; //计算深睡时间
  String? dataArray; //睡眠分布

  SleepData({
    this.appUserId,
    this.mac,
    this.createTime,
    this.start_Sleep,
    this.end_Sleep,
    this.awake_time,
    this.light_sleep_time,
    this.deep_sleep_time,
    this.dataArray,
  });

  factory SleepData.fromJson(Map<String, dynamic> json) => SleepData(
        appUserId: json["appUserId"],
        mac: json["mac"],
        createTime: json["createTime"],
      );

  Map<String, dynamic> toJson() => {
        "appUserId": appUserId,
        "mac": mac,
        "createTime": createTime,
        "dataArray": dataArray,
        "start_Sleep": start_Sleep,
        "end_Sleep": end_Sleep,
        "awake_time": awake_time,
        "light_sleep_time": light_sleep_time,
        "deep_sleep_time": deep_sleep_time,
        "awake_time": awake_time,
      };

  String formatDateMs(int time) {
    return DateUtil.formatDateMs(time * 1000, format: DateFormats.h_m);
  }

  String getSleepTime() {
    try {
      Duration difference = getSleepDuration();
      int hours = difference.inHours;
      int minutes = difference.inMinutes.remainder(60);
      double decimalHours = hours + (minutes / 60);
      return decimalHours.toStringAsFixed(1);
    } catch (e) {
      vmPrint("getSleepTime $e", KBLEManager.logevel);
      return "0";
    }
  }

  Duration getSleepDuration() {
    try {
      DateTime dateTime1 =
          DateTime.fromMillisecondsSinceEpoch((start_Sleep ?? 0) * 1000);
      DateTime dateTime2 =
          DateTime.fromMillisecondsSinceEpoch((end_Sleep ?? 0) * 1000);
      Duration difference = dateTime2.difference(dateTime1);
      return difference;
    } catch (e) {
      vmPrint("getSleepTime $e", KBLEManager.logevel);
      return Duration.zero;
    }
  }

  static Future<List<SleepData>> queryUserAll(
    int appUserId,
    String createTime,
    String nextTime,
  ) async {
    final db = await DataBaseConfig.openDataBase();
    final datas =
        await db?.sleepDao.queryUserAll(appUserId, createTime, nextTime);
    return datas ?? [];
  }

  static Future insertTokens(List<SleepData> models) async {
    final db = await DataBaseConfig.openDataBase();
    return await db?.sleepDao.insertTokens(models);
  }

  List<SleepDataGenterData> getSleepGenterData() {
    List params = JsonUtil.getObj(dataArray) ?? [];
    return params.map((e) => SleepDataGenterData.fromJson(e)).toList();
  }
}

class SleepDataGenterData {
  int startTimestamp;
  int sleepDuration;
  KSleepStatusType type;
  double percent;

  SleepDataGenterData({
    required this.startTimestamp,
    required this.sleepDuration,
    required this.type,
    required this.percent,
  });

  factory SleepDataGenterData.fromJson(Map json) => SleepDataGenterData(
      startTimestamp: json["startTimestamp"],
      sleepDuration: json["sleepDuration"],
      type: KSleepStatusType.values[json["type"]],
      percent: json["percent"]);

  Map<String, dynamic> toJson() => {
        "startTimestamp": startTimestamp,
        "sleepDuration": sleepDuration,
        "type": type.index,
        "percent": percent,
      };
}

class FemalePeriodData {
  int? appUserId;
  String? mac;
  String? createTime;
  int? periodState;

  FemalePeriodData({
    this.appUserId,
    this.mac,
    this.createTime,
    this.periodState,
  });

  factory FemalePeriodData.fromJson(Map<String, dynamic> json) =>
      FemalePeriodData(
        appUserId: json["appUserId"],
        mac: json["mac"],
        createTime: json["createTime"],
        periodState: json["periodState"],
      );

  Map<String, dynamic> toJson() => {
        "appUserId": appUserId,
        "mac": mac,
        "createTime": createTime,
        "periodState": periodState,
      };
}

class EmotionData {
  int? appUserId;
  String? mac;
  String? createTime;
  String? emotion;
  String? dataForHour;

  EmotionData({
    this.appUserId,
    this.mac,
    this.createTime,
    this.emotion,
    this.dataForHour,
  });

  factory EmotionData.fromJson(Map<String, dynamic> json) => EmotionData(
        appUserId: json["appUserId"],
        mac: json["mac"],
        createTime: json["createTime"],
        emotion: json["emotion"],
        dataForHour: json["dataForHour"],
      );

  Map<String, dynamic> toJson() => {
        "appUserId": appUserId,
        "mac": mac,
        "createTime": createTime,
        "emotion": emotion,
        "dataForHour": dataForHour,
      };
}

class PressureData {
  int? appUserId;
  String? mac;
  String? createTime;
  int? pressure;
  String? dataForHour;

  PressureData({
    this.appUserId,
    this.mac,
    this.createTime,
    this.pressure,
    this.dataForHour,
  });

  factory PressureData.fromJson(Map<String, dynamic> json) => PressureData(
        appUserId: json["appUserId"],
        mac: json["mac"],
        createTime: json["createTime"],
        pressure: json["pressure"],
        dataForHour: json["dataForHour"],
      );

  Map<String, dynamic> toJson() => {
        "appUserId": appUserId,
        "mac": mac,
        "createTime": createTime,
        "pressure": pressure,
        "dataForHour": dataForHour,
      };
}
