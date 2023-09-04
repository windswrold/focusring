import 'package:beering/db/database_config.dart';
import 'package:beering/public.dart';
import 'package:beering/utils/date_util.dart';
import 'package:beering/utils/json_util.dart';
import 'package:beering/views/charts/home_card/model/home_card_x.dart';
import 'package:floor/floor.dart';

const String tableName = 'bloodOxygenData';

@Entity(tableName: tableName, primaryKeys: ["appUserId", "createTime"])
class BloodOxygenData {
  int? appUserId;
  String? mac;
  String? createTime;
  int? averageHeartRate; //这一天的平均值
  int? max;
  int? min;
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

  @override
  String getTabName() {
    // TODO: implement getTabName
    return "BloodOxygenData";
  }
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

const String tableName2 = 'heartRateData';

@Entity(tableName: tableName2, primaryKeys: ["appUserId", "createTime"])
class HeartRateData {
  int? appUserId;
  String? mac;
  String? createTime;
  int? averageHeartRate; //这一天的平均值
  int? max;
  int? min;
  String? heartArray;

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
        averageHeartRate: json["averageHeartRate"],
        heartArray: json["heartArray"],
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

class SleepData {
  int? appUserId;
  String? mac;
  String? createTime;
  int? deepTime;
  int? lightTime;
  String? dataForHour;

  SleepData({
    this.appUserId,
    this.mac,
    this.createTime,
    this.deepTime,
    this.lightTime,
    this.dataForHour,
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

class TempData {
  int? appUserId;
  String? mac;
  String? createTime;
  int? temperature;

  TempData({
    this.appUserId,
    this.mac,
    this.createTime,
    this.temperature,
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
}

const String tableName3 = 'stepData';

@Entity(tableName: tableName3, primaryKeys: ["appUserId", "createTime"])
class StepData {
  int? appUserId;
  String? mac;
  String? createTime;
  int? steps;
  int? distance;
  int? calorie;
  String? dataForHour;

  String? dataArrs;

  StepData(
      {this.appUserId,
      this.mac,
      this.createTime,
      this.steps,
      this.distance,
      this.calorie,
      this.dataForHour,
      this.dataArrs});

  factory StepData.fromJson(Map<String, dynamic> json) => StepData(
      appUserId: json["appUserId"],
      mac: json["mac"],
      createTime: json["createTime"],
      steps: json["steps"],
      distance: json["distance"],
      calorie: json["calorie"],
      dataForHour: json["dataForHour"],
      dataArrs: json["dataArrs"]);

  Map<String, dynamic> toJson() => {
        "appUserId": appUserId,
        "mac": mac,
        "createTime": createTime,
        "steps": steps,
        "distance": distance,
        "calorie": calorie,
        "dataForHour": dataForHour,
        "dataArrs": dataArrs,
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

  static Future<List<KChartCellData>> queryHealthData(
      {required KReportType reportType, required KHealthDataType types}) async {
    List<KChartCellData> cellDatas = [];

    try {
      int userid = SPManager.getGlobalUser()!.id!;

      final currentTime = DateTime.now();
      String create = getZeroDateTime(now: currentTime);
      String nextTime = "";
      if (reportType == KReportType.day) {
        nextTime =
            getZeroDateTime(now: currentTime.add(const Duration(days: 1)));
      } else if (reportType == KReportType.week) {
        create =
            getZeroDateTime(now: currentTime.subtract(const Duration(days: 7)));

        nextTime = getZeroDateTime(now: currentTime);
      } else if (reportType == KReportType.moneth) {
        create = getZeroDateTime(
            now: currentTime.subtract(const Duration(days: 30)));
        nextTime = getZeroDateTime(now: currentTime);
      }

      if (types == KHealthDataType.HEART_RATE) {
        List<HeartRateData> datas =
            await HeartRateData.queryUserAll(userid, create, nextTime);
        if (reportType == KReportType.day) {
          final results = generateCellData(
            createTime: datas.first.createTime ?? "",
            data: datas.first.heartArray ?? "",
            type: types,
          );
          cellDatas.addAll(results);
        } else {
          for (var i = 0; i < datas.length; i++) {
            final e = datas[i];
            cellDatas.add(
              KChartCellData(
                x: e.createTime,
                y: (e.min ?? 0),
                z: e.max ?? 0,
                a: e.averageHeartRate ?? 0,
                color: types.getTypeMainColor(),
              ),
            );
          }
        }
      } else if (types == KHealthDataType.BLOOD_OXYGEN) {
        List<BloodOxygenData> datas =
            await BloodOxygenData.queryUserAll(userid, create, nextTime);
        if (reportType == KReportType.day) {
          final results = generateCellData(
              createTime: datas.first.createTime ?? "",
              type: types,
              data: datas.first.bloodArray ?? "");
          cellDatas.addAll(results);
        } else {
          for (var i = 0; i < datas.length; i++) {
            final e = datas[i];
            cellDatas.add(
              KChartCellData(
                x: e.createTime,
                y: (e.min ?? 0),
                z: e.max ?? 0,
                a: e.averageHeartRate ?? 0,
                color: types.getTypeMainColor(),
              ),
            );
          }
        }
      } else if (types == KHealthDataType.STEPS) {
        List<StepData> datas =
            await StepData.queryUserAll(userid, create, nextTime);
        if (reportType == KReportType.day) {
          final results = generateCellData(
              createTime: datas.first.createTime ?? "",
              type: types,
              data: datas.first.dataArrs ?? "");
          cellDatas.addAll(results);
        } else {
          for (var i = 0; i < datas.length; i++) {
            final e = datas[i];
            // cellDatas.add(
            //   KChartCellData(
            //     x: e.createTime,
            //     y: (e.min ?? 0),
            //     z: e.max ?? 0,
            //     a: e.averageHeartRate ?? 0,
            //     color: types.getTypeMainColor(),
            //   ),
            // );
          }
        }
      }
    } catch (e) {
      HWToast.showErrText(text: "读取失败 ${e}");
    }

    return cellDatas;
  }

  static void insertHealthBleData(
      {required List<int> datas,
      required bool isHaveTime,
      required KHealthDataType type}) {
    try {
      int userid = SPManager.getGlobalUser()!.id!;
      final mac = "";
      if (type == KHealthDataType.BLOOD_OXYGEN) {
        final model = BloodOxygenData(
          appUserId: userid,
          mac: mac,
        );

        List<int> results = [];
        if (isHaveTime == true) {
          int year = (datas[1] << 8) + datas[0];
          int month = datas[2];
          int day = datas[3];
          model.createTime = DateUtil.formatDate(
              DateTime(year, month, day, 0, 0),
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
        BloodOxygenData.insertTokens([model]);
      } else if (type == KHealthDataType.HEART_RATE) {
        List<int> results = [];
        final model = HeartRateData(
          appUserId: userid,
          mac: mac,
        );
        if (isHaveTime == true) {
          int year = (datas[1] << 8) + datas[0];
          int month = datas[2];
          int day = datas[3];
          model.createTime = DateUtil.formatDate(
              DateTime(year, month, day, 0, 0),
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
        HeartRateData.insertTokens([model]);
      } else if (type == KHealthDataType.STEPS) {
        List<int> results = [];
        final model = StepData(
          appUserId: userid,
          mac: mac,
        );
        if (isHaveTime == true) {
          int year = (datas[1] << 8) + datas[0];
          int month = datas[2];
          int day = datas[3];
          model.createTime = DateUtil.formatDate(
              DateTime(year, month, day, 0, 0),
              format: DateFormats.full);
          results = datas.sublist(4);
        } else {
          model.createTime = getZeroDateTime();
          results = datas;
        }
        model.dataArrs = JsonUtil.encodeObj(results);

        StepData.insertTokens([model]);
      }

      HWToast.showSucText(text: "构造成功，已存数据库");
    } catch (e) {
      HWToast.showErrText(text: "构造失败，${e.toString()}");
    }
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
          dur = time?.add(Duration(minutes: i * 5));
        }
        final e = dataArr[i];
        cellDatas.add(
          KChartCellData(
            x: DateUtil.formatDate(dur, format: DateFormats.h_m),
            y: e,
          ),
        );
      }
    } else {
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
}
