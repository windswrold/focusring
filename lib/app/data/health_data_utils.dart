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
        all: all.toDouble(),
        current: (intervalCounts[e] ?? 0),
      );
      charts.add(a);
    }

    vmPrint("intervalCounts $all  $intervalCounts", KBLEManager.logevel);

    return charts;
  }
}

const String tableName3 = 'stepData_v2';

@Entity(tableName: tableName3, primaryKeys: ["appUserId", "createTime"])
class StepData {
  int? appUserId;
  String? mac;
  String? createTime;
  String? steps;

  ///总步数
  String? distance;

  ///总里程
  String? calorie;

  ///总消耗
  // String? dataForHour;
  String? dataArrs; //步数的数据源

  StepData(
      {this.appUserId,
      this.mac,
      this.createTime,
      this.steps,
      this.distance,
      this.calorie,
      // this.dataForHour,
      this.dataArrs});

  factory StepData.fromJson(Map<String, dynamic> json) => StepData(
      appUserId: json["appUserId"],
      mac: json["mac"],
      createTime: json["createTime"],
      steps: json["steps"],
      distance: json["distance"],
      calorie: json["calorie"],
      // dataForHour: json["dataForHour"],
      dataArrs: json["dataForHour"]);

  Map<String, dynamic> toJson() => {
        "appUserId": appUserId,
        "mac": mac,
        "createTime": createTime,
        "steps": steps,
        "distance": distance,
        "calorie": calorie,
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

class SleepData {
  int? appUserId;
  String? mac;
  String? createTime;

  String? start_Sleep; //开始
  String? end_Sleep; //结束
  String? sleepDuration; //睡眠时长
  String? sleep_score; //睡眠评分

  String? awake_time; //清醒时间
  String? light_sleep_time; //浅睡时间
  String? deep_sleep_time; //深睡时间

  int? sleep_distribution_data_list_count; //睡眠段数
  String? sleep_distribution_data_list; //睡眠分布

  SleepData({
    this.appUserId,
    this.mac,
    this.createTime,
    this.start_Sleep,
    this.end_Sleep,
    this.sleepDuration,
    this.sleep_score,
    this.awake_time,
    this.light_sleep_time,
    this.deep_sleep_time,
    this.sleep_distribution_data_list_count,
    this.sleep_distribution_data_list,
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

class HealthDataUtils {
  List<BloodOxygenData>? bloodOxygenData;
  List<FemalePeriodData>? femalePeriodData;
  List<HeartRateData>? heartRateData;
  List<SleepData>? sleepData;
  List<TempData>? tempData;
  List<StepData>? stepData;
  List<EmotionData>? emotionData;
  List<PressureData>? pressureData;

  HealthDataUtils({
    this.bloodOxygenData,
    this.femalePeriodData,
    this.heartRateData,
    this.sleepData,
    this.tempData,
    this.stepData,
    this.emotionData,
    this.pressureData,
  });

  factory HealthDataUtils.fromJson(Map<String, dynamic> json) =>
      HealthDataUtils(
        bloodOxygenData: (json["bloodOxygenData"] as List)
            .map((i) => BloodOxygenData.fromJson(i))
            .toList(),
        femalePeriodData: (json["femalePeriodData"] as List)
            .map((i) => FemalePeriodData.fromJson(i))
            .toList(),
        heartRateData: (json["heartRateData"] as List)
            .map((i) => HeartRateData.fromJson(i))
            .toList(),
        sleepData: (json["sleepData"] as List)
            .map((i) => SleepData.fromJson(i))
            .toList(),
        tempData: (json["tempData"] as List)
            .map((i) => TempData.fromJson(i))
            .toList(),
        stepData: (json["stepData"] as List)
            .map((i) => StepData.fromJson(i))
            .toList(),
        emotionData: (json["emotionData"] as List)
            .map((i) => EmotionData.fromJson(i))
            .toList(),
        pressureData: (json["pressureData"] as List)
            .map((i) => PressureData.fromJson(i))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        "bloodOxygenData": bloodOxygenData?.map((x) => x.toJson()).toList(),
        "femalePeriodData": femalePeriodData?.map((x) => x.toJson()).toList(),
        "heartRateData": heartRateData?.map((x) => x.toJson()).toList(),
        "sleepData": sleepData?.map((x) => x.toJson()).toList(),
        "tempData": tempData?.map((x) => x.toJson()).toList(),
        "stepData": stepData?.map((x) => x.toJson()).toList(),
        "emotionData": emotionData?.map((x) => x.toJson()).toList(),
        "pressureData": pressureData?.map((x) => x.toJson()).toList(),
      };

  static void queryHealthData({
    required KHealthDataType types,
    required KReportType reportType,
    required DateTime? currentTime,
    required void Function(List datas, List<List<KChartCellData>>? cellDttas)
        callBackData,
  }) async {
    currentTime ??= DateTime.now();
    try {
      int userid = SPManager.getGlobalUser()!.id!;
      String create = "";
      String nextTime = create;
      if (reportType == KReportType.day) {
        create = getZeroDateTime(now: currentTime);
        nextTime = getLastDateTime(now: currentTime);
      } else if (reportType == KReportType.week) {
        create =
            getZeroDateTime(now: currentTime.subtract(const Duration(days: 6)));
        nextTime = getLastDateTime(now: currentTime);
      } else if (reportType == KReportType.moneth) {
        create = getZeroDateTime(
            now: DateTime(currentTime.year, currentTime.month, 1));
        nextTime = getLastDateTime(
            now: DateTime(currentTime.year, currentTime.month + 1, 1)
                .subtract(const Duration(days: 1)));
      }

      vmPrint("create $create  nextTime $nextTime reportType $reportType",
          KBLEManager.logevel);

      ///如果多天数据，则取每一天的平均值进行画点拆分
      if (types == KHealthDataType.HEART_RATE) {
        List<HeartRateData> datas =
            await HeartRateData.queryUserAll(userid, create, nextTime);
        List<KChartCellData> cellDatas = [];

        if (reportType == KReportType.day) {
          final results = generateDay(
            createTime: datas.tryFirst?.createTime ?? "",
            data: datas.tryFirst?.heartArray ?? "",
            type: types,
            reportType: reportType,
          );
          cellDatas.addAll(results);
        } else {
          for (var i = 0; i < datas.length; i++) {
            final e = datas[i];
            final cell = KChartCellData(
                x: _getFormatX(e.createTime),
                yor_low: (e.min ?? 0),
                high: e.max ?? 0,
                averageNum: e.averageHeartRate ?? 0,
                color: types.getTypeMainColor());
            cellDatas.add(cell);
          }
        }

        callBackData(datas, datas.isEmpty ? null : [cellDatas]);
      } else if (types == KHealthDataType.BLOOD_OXYGEN) {
        List<BloodOxygenData> datas =
            await BloodOxygenData.queryUserAll(userid, create, nextTime);

        List<KChartCellData> cellDatas = [];
        if (reportType == KReportType.day) {
          final results = generateDay(
            createTime: datas.tryFirst?.createTime ?? "",
            data: datas.tryFirst?.bloodArray ?? "",
            type: types,
            reportType: reportType,
          );
          cellDatas.addAll(results);
        } else {
          for (var i = 0; i < datas.length; i++) {
            final e = datas[i];
            final cell = KChartCellData(
                x: _getFormatX(e.createTime),
                yor_low: (e.min ?? 0),
                high: e.max ?? 0,
                averageNum: e.averageHeartRate ?? 0,
                color: types.getTypeMainColor());
            cellDatas.add(cell);
          }
        }
        callBackData(datas, datas.isEmpty ? null : [cellDatas]);
      } else if (types == KHealthDataType.STEPS ||
          types == KHealthDataType.LiCheng ||
          types == KHealthDataType.CALORIES_BURNED) {
        List<StepData> datas =
            await StepData.queryUserAll(userid, create, nextTime);

        List<KChartCellData> cellDatas = [];
        if (reportType == KReportType.day) {
          final results = generateDay(
            createTime: datas.tryFirst?.createTime ?? "",
            data: datas.tryFirst?.dataArrs ?? "",
            type: types,
            reportType: reportType,
          );
          cellDatas.addAll(results);
        } else {
          for (var i = 0; i < datas.length; i++) {
            final e = datas[i];

            String value = (types == KHealthDataType.STEPS)
                ? (e.steps ?? "0")
                : types == KHealthDataType.LiCheng
                    ? (e.distance ?? "0")
                    : (e.calorie ?? "0");
            Decimal num = Decimal.tryParse(value) ?? Decimal.zero;
            final cell = KChartCellData(
                x: _getFormatX(e.createTime),
                yor_low: num.toDouble(),
                color: types.getTypeMainColor());
            cellDatas.add(cell);
          }
        }
        callBackData(datas, datas.isEmpty ? null : [cellDatas]);
      } else if (types == KHealthDataType.BODY_TEMPERATURE) {
        List<TempData> datas =
            await TempData.queryUserAll(userid, create, nextTime);

        List<KChartCellData> cellDatas = [];
        if (reportType == KReportType.day) {
          final results = generateDay(
            createTime: datas.tryFirst?.createTime ?? "",
            data: datas.tryFirst?.dataArray ?? "",
            type: types,
            reportType: reportType,
          );
          cellDatas.addAll(results);
        } else {
          for (var i = 0; i < datas.length; i++) {
            final e = datas[i];
            final cell = KChartCellData(
                x: _getFormatX(e.createTime),
                yor_low:
                    (Decimal.tryParse(e.min ?? "0") ?? Decimal.zero).toDouble(),
                high:
                    (Decimal.tryParse(e.max ?? "0") ?? Decimal.zero).toDouble(),
                averageNum: (Decimal.tryParse(e.average ?? "0") ?? Decimal.zero)
                    .toDouble(),
                color: types.getTypeMainColor());
            cellDatas.add(cell);
          }
        }
        callBackData(datas, datas.isEmpty ? null : [cellDatas]);
      } else {
        var data = List.generate(
          30,
          (index) => KChartCellData(
            x: index.toString(),
            yor_low: 0,
            state: KSleepStatusType.values[Random.secure().nextInt(3)],
            color: types.getTypeMainColor(),
          ),
        );
        await Future.delayed(Duration(seconds: 1));
        callBackData([], null);
      }
    } catch (e) {
      // HWToast.showErrText(text: "读取失败 ${e}");
    }
  }

  static void insertHealthBleData(
      {required List<int> datas,
      required bool isContainTime,
      required KHealthDataType type}) async {
    try {
      int userid = SPManager.getGlobalUser()!.id!;
      isContainTime = true;
      String mac = "";
      if (type == KHealthDataType.BLOOD_OXYGEN) {
        await _insertBloodOxygen(userid,
            mac: mac, isContainTime: isContainTime, datas: datas);
      } else if (type == KHealthDataType.HEART_RATE) {
        await _insertHEARTRATE(userid,
            mac: mac, isContainTime: isContainTime, datas: datas);
      } else if (type == KHealthDataType.STEPS) {
        await _insertSteps(userid,
            mac: mac, isContainTime: isContainTime, datas: datas);
      } else if (type == KHealthDataType.SLEEP) {
        await _insertSleep(userid,
            mac: mac, isContainTime: isContainTime, datas: datas);
      }

      // HWToast.showSucText(text: "构造成功，已存数据库");
    } catch (e) {
      // HWToast.showErrText(text: "构造失败，${e.toString()}");
      vmPrint("insertHealthBleData $e", KBLEManager.logevel);
    }
  }

  static Future _insertBloodOxygen(
    int userid, {
    required String mac,
    required bool isContainTime,
    required List<int> datas,
  }) {
    final model = BloodOxygenData(appUserId: userid, mac: mac);

    List<int> results = [];
    if (isContainTime == true) {
      int year = (datas[1] << 8) + datas[0];
      int month = datas[2];
      int day = datas[3];
      model.createTime = DateUtil.formatDate(DateTime(year, month, day, 0, 0),
          format: DateFormats.full);
      results = datas.sublist(4);
    } else {
      model.createTime = getZeroDateTime();
      results = datas;
    }
    model.bloodArray = JsonUtil.encodeObj(results);
    model.averageHeartRate = ListEx.averageNum(results).toInt();
    model.max = ListEx.maxVal(results).toInt();
    model.min = ListEx.minVal(results).toInt();

    vmPrint("插入的血氧数据 ${results.length} ${JsonUtil.encodeObj(model.toJson())}",
        KBLEManager.logevel);

    return BloodOxygenData.insertTokens([model]);
  }

  static Future _insertHEARTRATE(
    int userid, {
    required String mac,
    required bool isContainTime,
    required List<int> datas,
  }) {
    List<int> results = [];
    final model = HeartRateData(
      appUserId: userid,
      mac: mac,
    );
    if (isContainTime == true) {
      int year = (datas[1] << 8) + datas[0];
      int month = datas[2];
      int day = datas[3];
      model.createTime = DateUtil.formatDate(DateTime(year, month, day, 0, 0),
          format: DateFormats.full);
      results = datas.sublist(4);
    } else {
      model.createTime = getZeroDateTime();
      results = datas;
    }
    model.heartArray = JsonUtil.encodeObj(results);
    model.averageHeartRate = ListEx.averageNum(results).toInt();
    model.max = ListEx.maxVal(results).toInt();
    model.min = ListEx.minVal(results).toInt();
    vmPrint(
        "插入的心率数据${JsonUtil.encodeObj(model.toJson())}", KBLEManager.logevel);

    return HeartRateData.insertTokens([model]);
  }

  static Future _insertSleep(
    int userid, {
    required String mac,
    required bool isContainTime,
    required List<int> datas,
  }) {
    List<int> results = [];

    if (isContainTime == true) {
      int year = (datas[1] << 8) + datas[0];
      int month = datas[2];
      int day = datas[3];
      results = datas.sublist(4);
    } else {
      results = datas;
    }

    String data = HEXUtil.encode(results);
    List<int> aaa = HEXUtil.decode(data);

    var buffer = Uint8List.fromList(aaa);
    var byteData = ByteData.sublistView(buffer);
    int offset = 0;
    int year = byteData.getUint16(offset, Endian.little);
    offset += 2;
    int month = byteData.getUint8(offset++);
    int day = byteData.getUint8(offset++);
    // int hour = byteData.getUint8(offset++);
    // int minute = byteData.getUint8(offset++);
    // int second = byteData.getUint8(offset++);

    final time = DateTime(year, month, day);

    vmPrint("时间 $time", KBLEManager.logevel);

    int startSleepTimestamp = byteData.getUint32(offset, Endian.little);
    offset += 4;

    int endSleepTimestamp = byteData.getUint32(offset, Endian.little);
    offset += 4;

    int sleepDuration = byteData.getUint16(offset, Endian.little);
    offset += 2;

    vmPrint(
        "startSleepTimestamp $startSleepTimestamp endSleepTimestamp $endSleepTimestamp sleepDuration $sleepDuration",
        KBLEManager.logevel);

    int sleepScore = byteData.getUint8(offset++);
    int awakeTime = byteData.getUint16(offset, Endian.little);
    offset += 2;

    int awakeTimePercentage = byteData.getUint8(offset++);
    int lightSleepTime = byteData.getUint16(offset, Endian.little);
    offset += 2;

    int lightSleepTimePercentage = byteData.getUint16(offset, Endian.little);
    offset += 2;

    int deepSleepTime = byteData.getUint16(offset, Endian.little);
    offset += 2;

    int deepSleepTimePercentage = byteData.getUint16(offset, Endian.little);
    offset += 2;

    int rapidEyeMovementTime = byteData.getUint16(offset, Endian.little);
    offset += 2;

    int rapidEyeMovementTimePercentage =
        byteData.getUint16(offset, Endian.little);
    offset += 2;

    vmPrint(
        "sleepScore $sleepScore , awakeTime $awakeTime awakeTimePercentage awakeTimePercentage $awakeTimePercentage lightSleepTime $lightSleepTime",
        KBLEManager.logevel);

    vmPrint(
        "lightSleepTimePercentage $lightSleepTimePercentage  deepSleepTime $deepSleepTime",
        KBLEManager.logevel);

    vmPrint(
        "offset $offset deepSleepTimePercentage $deepSleepTimePercentage  rapidEyeMovementTime $rapidEyeMovementTime rapidEyeMovementTimePercentage $rapidEyeMovementTimePercentage",
        KBLEManager.logevel);

    offset = 40 - 4;
    int sleepDistributionDataListCount = byteData.getUint8(offset);
    vmPrint(
        "sleepDistributionDataListCount $offset $sleepDistributionDataListCount",
        KBLEManager.logevel);
    offset += 4;
    for (int i = 0; i < sleepDistributionDataListCount; i++) {
      //秒时间 处理的
      int startTimestamp = byteData.getUint32(offset, Endian.little);
      offset += 4;

      int sleepDuration = byteData.getUint16(offset, Endian.little);
      offset += 2;

      int type = byteData.getUint8(offset);

      offset += 2;

      vmPrint(
          "${DateTime.fromMillisecondsSinceEpoch(startTimestamp)} offset $offset startTimestamp $startTimestamp sleepDuration $sleepDuration type $type",
          KBLEManager.logevel);
    }

    int sleepType = byteData.getUint8(offset++);

    vmPrint("sleepType $sleepType", KBLEManager.logevel);

    return Future.value();
  }

  ///顺便计算里程跟能量消耗
  static Future _insertSteps(
    int userid, {
    required String mac,
    required bool isContainTime,
    required List<int> datas,
  }) async {
    List<int> results = [];
    final model = StepData(
      appUserId: userid,
      mac: mac,
    );
    if (isContainTime == true) {
      int year = (datas[1] << 8) + datas[0];
      int month = datas[2];
      int day = datas[3];
      model.createTime = DateUtil.formatDate(DateTime(year, month, day),
          format: DateFormats.full);
      results = datas.sublist(4);
    } else {
      model.createTime = getZeroDateTime();
      results = datas;
    }

    UserInfoModel? user = SPManager.getGlobalUser();
    if (user == null) {
      return;
    }
    final hight = user.calMetricHeight();
    final weight = user.calMetricWeight();

    Decimal allSteps = Decimal.zero;
    for (int i = 0; i < results.length; i += 4) {
      int end = (i + 4 > results.length) ? results.length : i + 4;
      List e = results.sublist(i, end);
      allSteps += Decimal.parse(ListEx.stepsValue(e).toString());
    }
    model.steps = allSteps.toStringAsFixed(2);
    model.distance =
        calculate_distance_steps(allSteps.toBigInt().toInt(), hight)
            .toStringAsFixed(2);
    model.calorie =
        calculate_kcal_steps(allSteps.toBigInt().toInt(), weight, hight)
            .toStringAsFixed(2);
    model.dataArrs = JsonUtil.encodeObj(results);
    StepData.insertTokens([model]);
    vmPrint(
        "插入的步数数据${JsonUtil.encodeObj(model.toJson())}", KBLEManager.logevel);
    TempData temp = TempData(
      appUserId: userid,
      mac: mac,
    );
    temp.createTime = model.createTime;

    bool isOk = await TempData.esistData(userid, temp.createTime ?? "");
    if (isOk == true) {
      vmPrint("已经随机生成了${temp.createTime}的温度数据", KBLEManager.logevel);
      return;
    }

    //24个点
    List<double> tempsVal =
        List.generate(24, (index) => calculate_Temp()).toList();
    temp.dataArray = JsonUtil.encodeObj(tempsVal);
    temp.average = ListEx.averageNum(tempsVal).toStringAsFixed(2);
    temp.max = ListEx.maxVal(tempsVal).toStringAsFixed(2);
    temp.min = ListEx.minVal(tempsVal).toStringAsFixed(2);
    vmPrint("插入的温度数据${JsonUtil.encodeObj(temp.toJson())}", KBLEManager.logevel);
    return TempData.insertTokens([temp]);
  }

  static List<KChartCellData> generateDay(
      {required KReportType reportType,
      required String createTime,
      required String data,
      required KHealthDataType type}) {
    List<KChartCellData> cellDatas = [];
    DateTime? time = DateUtil.getDateTime(createTime);
    List dataArr = JsonUtil.getObj(data) ?? [];

    if (type == KHealthDataType.BLOOD_OXYGEN ||
        type == KHealthDataType.HEART_RATE) {
      for (var i = 0; i < dataArr.length; i++) {
        DateTime? dur;
        if (type == KHealthDataType.BLOOD_OXYGEN ||
            type == KHealthDataType.HEART_RATE) {
          dur = time?.add(Duration(
              minutes: i * (type == KHealthDataType.HEART_RATE ? 5 : 5)));
        }
        final e = dataArr[i];
        cellDatas.add(
          KChartCellData(
            x: DateUtil.formatDate(dur, format: DateFormats.h_m),
            yor_low: e,
            color: type.getTypeMainColor(),
          ),
        );
      }
    } else if (type == KHealthDataType.STEPS ||
        type == KHealthDataType.LiCheng ||
        type == KHealthDataType.CALORIES_BURNED) {
      for (int i = 0; i < dataArr.length; i += 4) {
        DateTime? dur;
        dur = time?.add(Duration(hours: i ~/ 4));
        int end = (i + 4 > dataArr.length) ? dataArr.length : i + 4;
        List e = dataArr.sublist(i, end);
        var num = ListEx.stepsValue(e);

        //卡路里
        UserInfoModel? user = SPManager.getGlobalUser();
        int? hight = user?.calMetricHeight();
        int? weight = user?.calMetricWeight();
        if (type == KHealthDataType.LiCheng) {
          num = calculate_distance_steps(num, hight!);
          vmPrint("LiCheng  $num");
        }

        if (type == KHealthDataType.CALORIES_BURNED) {
          num = calculate_kcal_steps(num, weight!, hight!);
        }

        cellDatas.add(
          KChartCellData(
            x: DateUtil.formatDate(dur, format: DateFormats.h_m),
            yor_low: num,
            color: type.getTypeMainColor(),
          ),
        );
      }
    } else if (type == KHealthDataType.BODY_TEMPERATURE) {
      for (var i = 0; i < dataArr.length; i++) {
        DateTime? dur;
        dur = time?.add(Duration(hours: i));
        final e = dataArr[i];
        cellDatas.add(
          KChartCellData(
            x: DateUtil.formatDate(dur, format: DateFormats.h_m),
            yor_low: e,
            color: type.getTypeMainColor(),
          ),
        );
      }
    }

    return cellDatas;
  }

  static String getOnTrackballTitle(
      {required KReportType type,
      required KHealthDataType currentType,
      required List<List<KChartCellData>> dataSource,
      required int index}) {
    String text = "-";

    if (currentType == KHealthDataType.SLEEP) {
      // chartTipValue.value = "${item.x}:${item.y} steps";
      text = "-";
    } else {
      KChartCellData? item = dataSource.tryFirst?[index];
      if (item == null) {
        return "";
      }
      if (type == KReportType.day) {
        text = "${item.x} ${item.yor_low}${currentType.getSymbol()}";
      } else {
        if (currentType == KHealthDataType.HEART_RATE) {
          //平均数
          text =
              "${item.x} ${currentType.getDisplayName(isReportSmallTotal: true).replaceAll("(Bpm)", "")} ${item.averageNum}${currentType.getSymbol()}";
        }
        if (currentType == KHealthDataType.BODY_TEMPERATURE) {
          //平均数
          text =
              "${item.x} ${currentType.getDisplayName(isReportSmallTotal: true).replaceAll("(Bpm)", "")} ${item.averageNum}${currentType.getSymbol()}";
        } else if (currentType == KHealthDataType.STEPS ||
            currentType == KHealthDataType.LiCheng ||
            currentType == KHealthDataType.CALORIES_BURNED) {
          //总和
          text = "${item.x} ${item.yor_low}${currentType.getSymbol()}";
        }
      }
    }

    return text;
  }

  static double calculate_kcal_steps(int steps, int weight, int hight) {
    return (Decimal.fromInt(weight) *
            Decimal.parse("1.036") *
            (Decimal.fromInt(hight) *
                Decimal.parse("0.41") *
                Decimal.fromInt(steps) *
                Decimal.parse("0.00001")))
        .toDouble();
    // return (uint32_t)(weight * 1.036f * (hight * 0.41f * steps * 0.00001f));
  }

  // kcal和m
  static double calculate_distance_steps(int steps, int hight) {
    return (Decimal.fromInt(hight) *
            Decimal.fromInt(41) *
            Decimal.fromInt(steps) *
            Decimal.parse("0.0000001"))
        .toDouble();
    // return (hight * 41.0f * steps * 0.0001f);
  }

  static double calculate_Temp() {
    Random random = Random();
    double fraction = random.nextDouble() * 0.9 + 36.1;
    return Decimal.parse(fraction.toStringAsFixed(1)).toDouble();
  }

  static String _getFormatX(String? create) {
    try {
      DateTime? date = DateTime.tryParse(create ?? "");
      return DateUtil.formatDate(date, format: DateFormats.mo_d);
    } catch (e) {
      return create ?? "";
    }
  }
}
