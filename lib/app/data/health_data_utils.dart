import 'dart:math';
import 'dart:typed_data';

import 'package:beering/app/data/user_info.dart';
import 'package:beering/extensions/EnumEx.dart';
import 'package:beering/extensions/ListEx.dart';
import 'package:beering/public.dart';
import 'package:decimal/decimal.dart';

import '../../ble/ble_manager.dart';
import '../../const/constant.dart';
import '../../utils/console_logger.dart';
import '../../utils/date_util.dart';
import '../../utils/hex_util.dart';
import '../../utils/json_util.dart';
import '../../utils/sp_manager.dart';
import '../../views/charts/home_card/model/home_card_x.dart';
import 'health_data_model.dart';

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
      } else if (types == KHealthDataType.SLEEP) {
        List<SleepData> datas =
            await SleepData.queryUserAll(userid, create, nextTime);

        List<List<KChartCellData>> cellDatas = [];
        if (reportType == KReportType.day) {
          final results = generateDay(
            createTime: datas.tryFirst?.createTime ?? "",
            data: datas.tryFirst?.dataArray ?? "",
            type: types,
            reportType: reportType,
          );
          cellDatas = [results];
        } else {
          List<KChartCellData> awake = [];
          List<KChartCellData> deep = [];
          List<KChartCellData> light = [];
          for (var i = 0; i < datas.length; i++) {
            SleepData e = datas[i];
            final awakeCell = KChartCellData(
                x: _getFormatX(e.createTime),
                yor_low: e.awake_time ?? 0,
                averageNum: Decimal.parse(e.getSleepTime()).toDouble(),
                color: KSleepStatusType.awake.getStatusColor());
            final deepCell = KChartCellData(
                x: _getFormatX(e.createTime),
                yor_low: e.deep_sleep_time ?? 0,
                averageNum: Decimal.parse(e.getSleepTime()).toDouble(),
                color: KSleepStatusType.deepSleep.getStatusColor());
            final light_cell = KChartCellData(
                x: _getFormatX(e.createTime),
                yor_low: e.light_sleep_time ?? 0,
                averageNum: Decimal.parse(e.getSleepTime()).toDouble(),
                color: KSleepStatusType.lightSleep.getStatusColor());

            awake.add(awakeCell);
            deep.add(deepCell);
            light.add(light_cell);
          }
          cellDatas = [deep, light, awake];
        }
        callBackData(datas, datas.isEmpty ? null : cellDatas);
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
      vmPrint("读取失败 $e", KBLEManager.logevel);
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
    final model = SleepData(
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
    int hour = byteData.getUint8(offset++);
    int minute = byteData.getUint8(offset++);
    int second = byteData.getUint8(offset++);

    // final time = DateTime(year, month, day, hour, minute, second);
    // vmPrint("时间 $time ${model.toJson()}", KBLEManager.logevel);
    //
    // int startSleepTimestamp = byteData.getUint32(offset, Endian.little);
    // offset += 4;
    //
    // int endSleepTimestamp = byteData.getUint32(offset, Endian.little);
    // offset += 4;
    //
    // int sleepDuration = byteData.getUint16(offset, Endian.little);
    // offset += 2;
    //
    // vmPrint(
    //     "startSleepTimestamp $startSleepTimestamp  ${DateUtil.formatDateMs(startSleepTimestamp * 1000)}" +
    //         "endSleepTimestamp $endSleepTimestamp ${DateUtil.formatDateMs(endSleepTimestamp * 1000)} sleepDuration $sleepDuration $sleepDuration}",
    //     KBLEManager.logevel);
    //
    // int sleepScore = byteData.getUint8(offset++);
    // int awakeTime = byteData.getUint16(offset, Endian.little);
    // offset += 2;
    //
    // int awakeTimePercentage = byteData.getUint8(offset++);
    // int lightSleepTime = byteData.getUint16(offset, Endian.little);
    // offset += 2;
    //
    // int lightSleepTimePercentage = byteData.getUint16(offset, Endian.little);
    // offset += 2;
    //
    // int deepSleepTime = byteData.getUint16(offset, Endian.little);
    // offset += 2;
    //
    // int deepSleepTimePercentage = byteData.getUint16(offset, Endian.little);
    // offset += 2;
    //
    // int rapidEyeMovementTime = byteData.getUint16(offset, Endian.little);
    // offset += 2;
    //
    // int rapidEyeMovementTimePercentage =
    //     byteData.getUint16(offset, Endian.little);
    // offset += 2;
    //
    // vmPrint(
    //     "sleepScore $sleepScore , awakeTime $awakeTime awakeTimePercentage awakeTimePercentage $awakeTimePercentage lightSleepTime $lightSleepTime",
    //     KBLEManager.logevel);
    //
    // vmPrint(
    //     "lightSleepTimePercentage $lightSleepTimePercentage  deepSleepTime $deepSleepTime",
    //     KBLEManager.logevel);
    //
    // vmPrint(
    //     "offset $offset deepSleepTimePercentage $deepSleepTimePercentage  rapidEyeMovementTime $rapidEyeMovementTime rapidEyeMovementTimePercentage $rapidEyeMovementTimePercentage",
    //     KBLEManager.logevel);

    offset = 40 - 4;

    List<Map> sleepCounts = [];
    int sleepDistributionDataListCount = byteData.getUint8(offset);
    vmPrint(
        "sleepDistributionDataListCount $offset $sleepDistributionDataListCount",
        KBLEManager.logevel);
    offset += 4;
    Map<int, int> timeParams = {};
    for (int i = 0; i < sleepDistributionDataListCount; i++) {
      //秒时间 处理的
      int startTimestamp = byteData.getUint32(offset, Endian.little);
      offset += 4;

      int sleepDuration = byteData.getUint16(offset, Endian.little);
      offset += 2;

      int type = byteData.getUint8(offset);

      offset += 2;

      Map params = {
        "startTimestamp": startTimestamp,
        "sleepDuration": sleepDuration,
        "type": type,
        "percent": 0,
      };
      sleepCounts.add(params);
      int length = timeParams[type] ?? 0;
      length += sleepDuration;
      timeParams[type] = length;
    }
    Decimal alltime = ListEx.sumVal(timeParams.values.toList());
    for (var e in sleepCounts) {
      int current = e["sleepDuration"];
      e["percent"] =
          getPercent(current: current.toDouble(), all: alltime.toDouble());
    }
    vmPrint("sleepCounts $sleepCounts  timeParams $timeParams",
        KBLEManager.logevel);

    model.dataArray = JsonUtil.encodeObj(sleepCounts);
    model.start_Sleep = sleepCounts.tryFirst?.intFor("startTimestamp") ?? 0;
    model.end_Sleep = sleepCounts.tryLast?.intFor("startTimestamp") ?? 0;
    model.awake_time = timeParams[KSleepStatusType.awake.index];
    model.light_sleep_time = timeParams[KSleepStatusType.lightSleep.index];
    model.deep_sleep_time = timeParams[KSleepStatusType.deepSleep.index];

    vmPrint(
        "插入的睡眠数据${JsonUtil.encodeObj(model.toJson())}", KBLEManager.logevel);

    return SleepData.insertTokens([model]);
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
    } else if (type == KHealthDataType.SLEEP) {
      //日 计算宽度
      for (var i = 0; i < dataArr.length; i++) {
        Map e = dataArr[i];
        SleepDataGenterData genterData = SleepDataGenterData.fromJson(e);
        final x = DateUtil.formatDateMs(genterData.startTimestamp * 1000,
            format: DateFormats.h_m);
        cellDatas.add(
          KChartCellData(
            x: x,
            yor_low: genterData.percent,
            state: genterData.type,
            color: genterData.type.getStatusColor(),
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
      } else if (currentType == KHealthDataType.SLEEP) {
        text = "${item.x} ${item.averageNum}${currentType.getSymbol()}";
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
