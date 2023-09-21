import 'dart:math';

import 'package:beering/app/data/card_health_index.dart';
import 'package:beering/app/modules/app_view/controllers/app_view_controller.dart';
import 'package:beering/ble/ble_manager.dart';
import 'package:beering/net/app_api.dart';
import 'package:beering/public.dart';
import 'package:beering/utils/console_logger.dart';
import 'package:beering/views/charts/home_card/model/home_card_type.dart';
import 'package:beering/views/charts/home_card/model/home_card_x.dart';
import 'package:beering/views/charts/radio_gauge_chart/model/radio_gauge_chart_model.dart';
import 'package:get/get.dart';

class HomeStateController extends GetxController {
  //TODO: Implement HomeStateController

  static String tag = "HomeStateControllerTag";

  Rx<RadioGaugeChartData> licheng = RadioGaugeChartData().obs;
  Rx<RadioGaugeChartData> steps = RadioGaugeChartData().obs;
  Rx<RadioGaugeChartData> calorie = RadioGaugeChartData().obs;

  RxList<KHomeCardModel> dataTypes = <KHomeCardModel>[].obs;

  @override
  void onInit() {
    super.onInit();

    initData();
  }

  void initData() async {
    final us =
        (Get.find<AppViewController>(tag: AppViewController.tag)).user.value;

    var currentDistance = Random.secure().nextInt(100);
    var currentSteps = Random.secure().nextInt(100);
    var currentCalorie = Random.secure().nextInt(100);

    currentDistance = 0;
    currentSteps = 0;
    currentCalorie = 0;

    licheng.value = RadioGaugeChartData(
      title: "mileage",
      color: KHealthDataType.LiCheng.getTypeMainColor(),
      all: us?.distancePlan,
      current: currentDistance,
      icon: "icons/status_target_distance",
      symbol: KHealthDataType.LiCheng.getSymbol(),
    );

    steps.value = RadioGaugeChartData(
      title: "pedometer",
      color: KHealthDataType.STEPS.getTypeMainColor(),
      all: us?.stepsPlan,
      current: currentSteps,
      icon: "icons/status_target_steps",
      symbol: KHealthDataType.STEPS.getSymbol(),
    );

    calorie.value = RadioGaugeChartData(
      title: "exercise",
      color: KHealthDataType.CALORIES_BURNED.getTypeMainColor(),
      all: us?.caloriePlan,
      current: currentCalorie,
      icon: "icons/status_target_steps",
      symbol: KHealthDataType.CALORIES_BURNED.getSymbol(),
    );

    List<KHomeCardModel> dataArr = [];

    final appUserId = await SPManager.getPhoneID();
    List<KBaseHealthType> datas =
        await KBaseHealthType.queryAllWithState(appUserId, true);
    for (var element in datas) {
      var data = List.generate(
        30,
        (index) => KChartCellData(
          x: index.toString(),
          y: Random.secure().nextDouble() * 500,
          state: KSleepStatusType.values[Random.secure().nextInt(3)],
          color: element.type.getTypeMainColor(),
        ),
      );
      if (element.type == KHealthDataType.BLOOD_OXYGEN ||
          element.type == KHealthDataType.HEART_RATE ||
          element.type == KHealthDataType.EMOTION ||
          element.type == KHealthDataType.STRESS ||
          element.type == KHealthDataType.BODY_TEMPERATURE) {
        continue;
      }
      KHomeCardModel card = KHomeCardModel(
        type: element.type,
        // datas: element.type == KHealthDataType.EMOTION
        //     ? [
        //         List.generate(
        //             30, (index) => KChartCellData(x: index.toString(), y: 300)),
        //         List.generate(
        //             30, (index) => KChartCellData(x: index.toString(), y: 100)),
        //         List.generate(
        //             30, (index) => KChartCellData(x: index.toString(), y: 1000))
        //       ]
        //     : [data],
        date: "empty_data".tr,
        result: "",
        resultDesc: "",
        startDesc: "",
        endDesc: "",
      );
      dataArr.add(card);
    }

    dataTypes.value = dataArr;

    // AppApi.queryAppData(startTime: startTime, endTime: endTime);
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

  void onTapEditCard() {
    Get.toNamed(Routes.HOME_EDIT_CARD);
  }

  @override
  void onClose() {
    super.onClose();
  }

  void onTapCardType(KHomeCardModel type) {
    // Get.toNamed(Routes.REPORT_INFO_STEPS, arguments: type.type);

    // return;

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
