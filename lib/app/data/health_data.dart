import 'dart:math';
import 'dart:typed_data';

import 'package:beering/app/data/user_info.dart';
import 'package:beering/app/modules/app_view/controllers/app_view_controller.dart';
import 'package:beering/ble/ble_manager.dart';
import 'package:beering/db/database_config.dart';
import 'package:beering/public.dart';
import 'package:beering/utils/date_util.dart';
import 'package:beering/utils/json_util.dart';
import 'package:beering/views/charts/home_card/model/home_card_x.dart';
import 'package:decimal/decimal.dart';
import 'package:floor/floor.dart';

const String tableName = 'bloodOxygenData';

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

  static void insertTokens(List<BloodOxygenData> models) async {
    final db = await DataBaseConfig.openDataBase();
    final datas = await db?.bloodDao.insertTokens(models);
    return;
  }
}

const String tableName2 = 'heartRateData';

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

    HWToast.showSucText(
        text: "queryUserAll ${datas.length} datas ${datas.first.heartArray}");
    return datas;
  }

  static void insertTokens(List<HeartRateData> models) async {
    final db = await DataBaseConfig.openDataBase();
    final datas = await db?.heartDao.insertTokens(models);
    return;
  }
}

const String tableName3 = 'stepData';

@Entity(tableName: tableName3, primaryKeys: ["appUserId", "createTime"])
class StepData {
  int? appUserId;
  String? mac;
  String? createTime;
  int? steps;

  ///总步数
  int? distance;

  ///总里程
  int? calorie;

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

  static void insertTokens(List<StepData> models) async {
    final db = await DataBaseConfig.openDataBase();
    final datas = await db?.stepDao.insertTokens(models);
    return;
  }
}

const String tableName4 = 'TempData';

@Entity(tableName: tableName4, primaryKeys: ["appUserId", "createTime"])
class TempData {
  int? appUserId;
  String? mac;
  String? createTime;
  int? temperature;
  double? average; //自己计算这一天的平均值
  double? max; //自己计算当天最高
  double? min; //自己计算当天最低
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

  static void insertTokens(List<TempData> models) async {
    final db = await DataBaseConfig.openDataBase();
    final datas = await db?.tempDap.insertTokens(models);
    return;
  }
}

class SleepData {
  int? appUserId;
  String? mac;
  String? createTime;
  int? deepTime;
  int? lightTime;
  String? dataForHour;

  String? start_Sleep; //开始
  String? end_Sleep; //结束
  int? sleepDuration; //睡眠时长
  int? sleep_score; //睡眠评分
  int? awake_time; //清醒时间
  int? awake_time_percentage; //清醒时间百分比
  int? light_sleep_time; //浅睡时间
  int? light_sleep_time_percentage; //浅睡时间百分比
  int? deep_sleep_time; //深睡时间
  int? deep_sleep_time_percentage; //深睡时间百分比
  int? rapid_eye_movement_time; //快速眼动时间
  int? rapid_eye_movement_time_percentage; //快速眼动时间百分比
  int? sleep_distribution_data_list_count; //睡眠段数
  String? sleep_distribution_data_list; //睡眠分布

  SleepData({
    this.appUserId,
    this.mac,
    this.createTime,
    this.deepTime,
    this.lightTime,
    this.dataForHour,
    this.start_Sleep,
    this.end_Sleep,
    this.sleepDuration,
    this.sleep_score,
    this.awake_time,
    this.awake_time_percentage,
    this.light_sleep_time,
    this.light_sleep_time_percentage,
    this.deep_sleep_time,
    this.deep_sleep_time_percentage,
    this.rapid_eye_movement_time,
    this.rapid_eye_movement_time_percentage,
    this.sleep_distribution_data_list_count,
    this.sleep_distribution_data_list,
  });

  factory SleepData.fromJson(Map<String, dynamic> json) => SleepData(
        appUserId: json["appUserId"],
        mac: json["mac"],
        createTime: json["createTime"],
        deepTime: json["deepTime"],
        lightTime: json["lightTime"],
        dataForHour: json["dataForHour"],
      );

  Map<String, dynamic> toJson() => {
        "appUserId": appUserId,
        "mac": mac,
        "createTime": createTime,
        "deepTime": deepTime,
        "lightTime": lightTime,
        "dataForHour": dataForHour,
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

class HealthData {
  List<BloodOxygenData>? bloodOxygenData;
  List<FemalePeriodData>? femalePeriodData;
  List<HeartRateData>? heartRateData;
  List<SleepData>? sleepData;
  List<TempData>? tempData;
  List<StepData>? stepData;
  List<EmotionData>? emotionData;
  List<PressureData>? pressureData;

  HealthData({
    this.bloodOxygenData,
    this.femalePeriodData,
    this.heartRateData,
    this.sleepData,
    this.tempData,
    this.stepData,
    this.emotionData,
    this.pressureData,
  });

  factory HealthData.fromJson(Map<String, dynamic> json) => HealthData(
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

  static Future<List<dynamic>> queryHealthData({
    required KHealthDataType types,
    required KReportType reportType,
    required DateTime? currentTime,
  }) async {
    currentTime ??= DateTime.now();
    try {
      int userid = SPManager.getGlobalUser()!.id!;
      String create = "";
      String nextTime = create;
      if (reportType == KReportType.day) {
        create = getZeroDateTime(now: currentTime);
        nextTime =
            getZeroDateTime(now: currentTime.add(const Duration(days: 1)));
      } else if (reportType == KReportType.week) {
        create =
            getZeroDateTime(now: currentTime.subtract(const Duration(days: 6)));
        nextTime =
            getZeroDateTime(now: currentTime.add(const Duration(days: 1)));
      } else if (reportType == KReportType.moneth) {
        create = getZeroDateTime(
            now: DateTime(currentTime.year, currentTime.month, 1));
        nextTime = getZeroDateTime(
            now: DateTime(currentTime.year, currentTime.month + 1, 1)
                .subtract(const Duration(days: 1)));
      }

      vmPrint("create $create  nextTime $nextTime reportType $reportType");

      if (types == KHealthDataType.HEART_RATE) {
        List<HeartRateData> datas =
            await HeartRateData.queryUserAll(userid, create, nextTime);
        return datas;
      } else if (types == KHealthDataType.BLOOD_OXYGEN) {
        List<BloodOxygenData> datas =
            await BloodOxygenData.queryUserAll(userid, create, nextTime);
        return datas;
      } else if (types == KHealthDataType.STEPS ||
          types == KHealthDataType.LiCheng ||
          types == KHealthDataType.CALORIES_BURNED) {
        List<StepData> datas =
            await StepData.queryUserAll(userid, create, nextTime);
        return datas;
      } else if (types == KHealthDataType.BODY_TEMPERATURE) {
        List<TempData> datas =
            await TempData.queryUserAll(userid, create, nextTime);
        return datas;
      } else if (types == KHealthDataType.EMOTION) {
        return [];
      } else if (types == KHealthDataType.STRESS) {
        return [];
      }
    } catch (e) {
      HWToast.showErrText(text: "读取失败 ${e}");
    }
    return [];
  }

  static void insertHealthBleData(
      {required List<int> datas,
      required bool isContainTime,
      required KHealthDataType type}) {
    try {
      int userid = SPManager.getGlobalUser()!.id!;
      String mac = "";
      if (type == KHealthDataType.BLOOD_OXYGEN) {
        _insertBloodOxygen(userid,
            mac: mac, isContainTime: isContainTime, datas: datas);
      } else if (type == KHealthDataType.HEART_RATE) {
        _insertHEARTRATE(userid,
            mac: mac, isContainTime: isContainTime, datas: datas);
      } else if (type == KHealthDataType.STEPS) {
        _insertSteps(userid,
            mac: mac, isContainTime: isContainTime, datas: datas);
      } else if (type == KHealthDataType.SLEEP) {
        _insertSleep(userid,
            mac: mac, isContainTime: isContainTime, datas: datas);
      }

      HWToast.showSucText(text: "构造成功，已存数据库");
    } catch (e) {
      HWToast.showErrText(text: "构造失败，${e.toString()}");
    }
  }

  static void _insertBloodOxygen(
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

    vmPrint(
        "插入的血氧数据${JsonUtil.encodeObj(model.toJson())}", KBLEManager.logevel);

    BloodOxygenData.insertTokens([model]);
  }

  static void _insertHEARTRATE(
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

    HeartRateData.insertTokens([model]);
  }

  static void _insertSleep(
    int userid, {
    required String mac,
    required bool isContainTime,
    required List<int> datas,
  }) {
    var buffer = Uint8List.fromList(datas).buffer;
    var byteData = ByteData.sublistView(buffer.asByteData());
    int offset = 0;
    int year = byteData.getUint16(offset, Endian.little);
    offset += 2;
    int month = byteData.getUint8(offset++);
    int day = byteData.getUint8(offset++);
    int hour = byteData.getUint8(offset++);
    int minute = byteData.getUint8(offset++);
    int second = byteData.getUint8(offset++);

    final time = DateTime(year, month, day, hour, minute, second);

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
        "lightSleepTimePercentage $lightSleepTimePercentage  deepSleepTime $deepSleepTime");

    vmPrint(
        "deepSleepTimePercentage $deepSleepTimePercentage  rapidEyeMovementTime $rapidEyeMovementTime rapidEyeMovementTimePercentage $rapidEyeMovementTimePercentage");

    int sleepDistributionDataListCount = byteData.getUint8(offset++);

    for (int i = 0; i < sleepDistributionDataListCount; i++) {
      int startTimestamp = byteData.getUint32(offset, Endian.little);
      offset += 4;

      int sleepDuration = byteData.getUint16(offset, Endian.little);
      offset += 2;

      int type = byteData.getUint8(offset++);

      vmPrint(
          "startTimestamp $startTimestamp sleepDuration $sleepDuration type $type",
          KBLEManager.logevel);
    }

    int sleepType = byteData.getUint8(offset++);

    vmPrint("sleepType $sleepType", KBLEManager.logevel);
  }

  ///顺便计算里程跟能量消耗
  static void _insertSteps(
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
    model.steps = ListEx.sumVal(results).toInt();
    model.distance = calculate_distance_steps(model.steps!, hight).toInt();
    model.calorie = calculate_kcal_steps(model.steps!, weight, hight).toInt();
    model.dataArrs = JsonUtil.encodeObj(results);
    StepData.insertTokens([model]);
    vmPrint(
        "插入的步数数据${JsonUtil.encodeObj(model.toJson())}", KBLEManager.logevel);
    TempData temp = TempData(
      appUserId: userid,
      mac: mac,
    );
    temp.createTime = model.createTime;

    //24个点
    List<double> tempsVal =
        List.generate(24, (index) => calculate_Temp()).toList();
    temp.dataArray = JsonUtil.encodeObj(tempsVal);
    temp.average = ListEx.averageNum(tempsVal);
    temp.max = ListEx.maxVal(tempsVal).toDouble();
    temp.min = ListEx.minVal(tempsVal).toDouble();
    vmPrint(
        "插入的温度数据${JsonUtil.encodeObj(model.toJson())}", KBLEManager.logevel);
    TempData.insertTokens([temp]);
  }

  static List<KChartCellData> generateCellData(
      {required String createTime,
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
              minutes: i * (type == KHealthDataType.HEART_RATE ? 5 : 30)));
        }
        final e = dataArr[i];
        cellDatas.add(
          KChartCellData(
            x: DateUtil.formatDate(dur, format: DateFormats.h_m),
            y: e,
            color: type.getTypeMainColor(),
          ),
        );
      }
    } else if (type == KHealthDataType.STEPS) {
      for (int i = 0; i < dataArr.length; i += 4) {
        DateTime? dur;
        dur = time?.add(Duration(hours: i ~/ 4));
        int end = (i + 4 > dataArr.length) ? dataArr.length : i + 4;
        final e = dataArr.sublist(i, end);
        int num = (e[3] << 24) | (e[2] << 16) | (e[1] << 8) | e[0];
        cellDatas.add(
          KChartCellData(
            x: DateUtil.formatDate(dur, format: DateFormats.h_m),
            y: num,
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
            y: e,
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
      final item = dataSource.first[index];
      text = "${item.x} ${item.y}${currentType.getSymbol()}";
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
            Decimal.parse("0.0001"))
        .toDouble();
    // return (hight * 41.0f * steps * 0.0001f);
  }

  static double calculate_Temp() {
    Random random = Random();
    double fraction = random.nextDouble() * 0.9 + 36.1;
    return Decimal.parse(fraction.toStringAsFixed(1)).toDouble();
  }
}
