import 'dart:math';

import 'package:focusring/app/modules/app_view/controllers/app_view_controller.dart';
import 'package:focusring/net/app_api.dart';
import 'package:focusring/public.dart';
import 'package:focusring/utils/console_logger.dart';
import 'package:focusring/views/charts/home_card/model/home_card_type.dart';
import 'package:focusring/views/charts/home_card/model/home_card_x.dart';
import 'package:focusring/views/charts/radio_gauge_chart/model/radio_gauge_chart_model.dart';
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

  void initData() {
    vmPrint("initData");
    final us =
        (Get.find<AppViewController>(tag: AppViewController.tag)).user.value;

    final currentDistance = Random.secure().nextInt(100);
    final currentSteps = Random.secure().nextInt(100);
    final currentCalorie = Random.secure().nextInt(100);

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
    KHealthDataType.values.forEach((element) {
      var data = List.generate(
        30,
        (index) => KChartCellData(
          x: index.toString(),
          y: Random.secure().nextDouble() * 500,
          state: KSleepStatus.values[Random.secure().nextInt(3)],
        ),
      );
      KHomeCardModel card = KHomeCardModel(
        type: element,
        datas: element == KHealthDataType.EMOTION
            ? [
                List.generate(
                    30, (index) => KChartCellData(x: index.toString(), y: 300)),
                List.generate(
                    30, (index) => KChartCellData(x: index.toString(), y: 100)),
                List.generate(
                    30, (index) => KChartCellData(x: index.toString(), y: 1000))
              ]
            : [data],
        date: "2022",
        result: "result",
        resultDesc: "resultDesc",
        startDesc: "startDesc",
        endDesc: "startDesc",
      );
      dataArr.add(card);
    });

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
    } else {
      Get.toNamed(Routes.REPORT_INFO_STEPS, arguments: type.type);
    }
  }
}
