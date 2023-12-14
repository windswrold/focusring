import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:beering/app/data/card_health_index.dart';
import 'package:beering/app/data/health_data_model.dart';
import 'package:beering/app/modules/app_view/controllers/app_view_controller.dart';
import 'package:beering/ble/ble_manager.dart';

import 'package:beering/ble/bledata_serialization.dart';
import 'package:beering/net/app_api.dart';
import 'package:beering/public.dart';
import 'package:beering/utils/console_logger.dart';
import 'package:beering/utils/date_util.dart';
import 'package:beering/utils/json_util.dart';
import 'package:beering/views/charts/home_card/model/home_card_type.dart';
import 'package:beering/views/charts/home_card/model/home_card_x.dart';
import 'package:beering/views/charts/radio_gauge_chart/model/radio_gauge_chart_model.dart';
import 'package:beering/views/tra_led_button.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../../../const/event_bus_class.dart';
import '../../../data/health_data_utils.dart';
import '../../../data/ring_device.dart';

class HomeStateController extends GetxController {
  //TODO: Implement HomeStateController

  static String tag = "HomeStateControllerTag";

  Rx<RadioGaugeChartData> licheng = RadioGaugeChartData().obs;
  Rx<RadioGaugeChartData> steps = RadioGaugeChartData().obs;
  Rx<RadioGaugeChartData> calorie = RadioGaugeChartData().obs;

  RxList<KHomeCardModel> dataTypes = <KHomeCardModel>[].obs;

  late RefreshController refreshController = RefreshController();

  StreamSubscription? receiveDataStream;

  @override
  void onInit() {
    super.onInit();

    receiveDataStream = GlobalValues.globalEventBus
        .on<KReportQueryDataUpdate>()
        .listen((event) {
      initData(refreshType: event.refreType);
    });
  }

  void onRefresh() {
    initData();
    Future.delayed(Duration(seconds: 3)).then((value) => {
          refreshController.refreshCompleted(),
        });
  }

  void initData({KHealthDataType? refreshType}) async {
    final us =
        (Get.find<AppViewController>(tag: AppViewController.tag)).user.value;
    bool showHeartrate = false;
    final device = await RingDeviceModel.queryUserAllWithSelect(
        (us?.id ?? 0).toString(), true);
    if (device != null) {
      showHeartrate = true;
    }

    List<KHomeCardModel> dataArr = [];

    final appUserId = await SPManager.getPhoneID();
    List<KBaseHealthType> datas =
        await KBaseHealthType.queryAllWithState(appUserId, true);
    // if (refreshType != null) {
    //   datas = datas.where((element) => element.type == refreshType).toList();
    // }

    String date =
        DateUtil.formatDate(DateTime.now(), format: DateFormats.y_mo_d);
    for (var element in datas) {
      if (showHeartrate == false) {
        if (element.type == KHealthDataType.BLOOD_OXYGEN ||
            element.type == KHealthDataType.HEART_RATE ||
            element.type == KHealthDataType.EMOTION ||
            element.type == KHealthDataType.STRESS ||
            element.type == KHealthDataType.BODY_TEMPERATURE) {
          continue;
        }
      }

      HealthDataUtils.queryHealthData(
          types: element.type,
          reportType: KReportType.day,
          currentTime: null,
          callBackData: (a, b) {
            vmPrint("dataTypesdataTypesdataTypes${dataTypes.length}");
            KHomeCardModel card = KHomeCardModel();
            card.type = element.type;
            card.date = b == null ? "empty_data".tr : date;
            card.datas = b;
            card.startDesc = "00:00";
            card.endDesc = "23:59";
            card.resultDesc = "";
            if (element.type == KHealthDataType.STEPS ||
                element.type == KHealthDataType.CALORIES_BURNED ||
                element.type == KHealthDataType.LiCheng) {
              List<StepData> datas = a as List<StepData>;
              StepData? step = datas.tryFirst;
              if (element.type == KHealthDataType.STEPS) {
                card.result = step?.steps;
                _calSteps(
                    currentDistance: step?.distance,
                    currentSteps: step?.steps,
                    currentCalorie: step?.calorie);
              } else if (element.type == KHealthDataType.CALORIES_BURNED) {
                card.result = step?.calorie;
              } else {
                card.result = step?.distance;
              }
            } else if (element.type == KHealthDataType.HEART_RATE) {
              //心率
              List<HeartRateData> datas = a as List<HeartRateData>;
              HeartRateData? data = datas.tryFirst;
              card.result = data?.averageHeartRate.toString();
            } else if (element.type == KHealthDataType.BLOOD_OXYGEN) {
              //血氧
              List<BloodOxygenData> datas = a as List<BloodOxygenData>;
              BloodOxygenData? data = datas.tryFirst;
              card.result = data?.averageHeartRate.toString();
            } else if (element.type == KHealthDataType.BODY_TEMPERATURE) {
              //体温
              List<TempData> datas = a as List<TempData>;
              TempData? data = datas.tryFirst;
              card.result = data?.average.toString();
            } else if (element.type == KHealthDataType.SLEEP) {
              //睡眠
              List<SleepData> datas = a as List<SleepData>;
              SleepData? data = datas.tryFirst;
              card.startDesc = data?.start_Sleep == null
                  ? "00:00"
                  : data?.formatDateMs(data.start_Sleep ?? 0);
              card.endDesc = data?.end_Sleep == null
                  ? "00:00"
                  : data?.formatDateMs(data.end_Sleep ?? 0);
              card.result = data?.getSleepTime();
            }
            dataArr.add(card);
            dataTypes.value = dataArr;
            update(["dataTypes"]);
          });
    }

    // AppApi.queryAppData(startTime: startTime, endTime: endTime);
  }

  void _calSteps(
      {required String? currentDistance,
      required String? currentSteps,
      required String? currentCalorie}) {
    double disNum = 0;
    double stepsNum = 0;
    double caloriNum = 0;
    try {
      disNum =
          (Decimal.tryParse(currentDistance ?? "0") ?? Decimal.zero).toDouble();
      stepsNum =
          (Decimal.tryParse(currentSteps ?? "0") ?? Decimal.zero).toDouble();

      caloriNum =
          (Decimal.tryParse(currentCalorie ?? "0") ?? Decimal.zero).toDouble();
    } catch (e) {}

    final us =
        (Get.find<AppViewController>(tag: AppViewController.tag)).user.value;
    licheng.value = RadioGaugeChartData(
      title: "mileage",
      color: KHealthDataType.LiCheng.getTypeMainColor(),
      allStr: us?.distancePlan?.toStringAsFixed(0),
      currentStr: disNum.toStringAsFixed(1),
      icon: "icons/status_target_distance",
      symbol: KHealthDataType.LiCheng.getSymbol(),
    );

    steps.value = RadioGaugeChartData(
      title: "pedometer",
      color: KHealthDataType.STEPS.getTypeMainColor(),
      allStr: us?.stepsPlan?.toStringAsFixed(0),
      currentStr: stepsNum.toStringAsFixed(0),
      icon: "icons/status_target_steps",
      symbol: KHealthDataType.STEPS.getSymbol(),
    );

    calorie.value = RadioGaugeChartData(
      title: "exercise",
      color: KHealthDataType.CALORIES_BURNED.getTypeMainColor(),
      allStr: us?.caloriePlan?.toStringAsFixed(0),
      currentStr: caloriNum.toStringAsFixed(1),
      icon: "icons/status_target_steps",
      symbol: KHealthDataType.CALORIES_BURNED.getSymbol(),
    );
  }

  @override
  void onReady() {
    super.onReady();

    Future.delayed(Duration(seconds: 5)).then((value) => {
          vmPrint("delayeddelayeddelayed"),
          initData(),
        });

    // KBLEManager.checkBle();
  }

  void onTapEditCard() async {
    Get.toNamed(Routes.HOME_EDIT_CARD);
  }

  @override
  void onClose() {
    receiveDataStream?.cancel();
    super.onClose();
  }

  void onTapCardType(KHomeCardModel type) {
    try {
      KBLEManager.sendData(
          sendData: KBLESerialization.getTodayData(
              type: type.type ?? KHealthDataType.STEPS));
    } catch (e) {}

    if (type.type == KHealthDataType.FEMALE_HEALTH) {
      Get.toNamed(Routes.REPORT_INFO_FEMMALEHEALTH);
    } else if (type.type == KHealthDataType.EMOTION) {
      Get.toNamed(Routes.REPORT_INFO_EMOTION);
    } else if (type.type == KHealthDataType.STRESS) {
      Get.toNamed(Routes.REPORT_INFO_STRESS);
    } else {
      Get.toNamed(Routes.REPORT_INFO_STEPS, arguments: type.type);
    }
  }
}
