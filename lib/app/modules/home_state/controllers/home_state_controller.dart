import 'dart:math';

import 'package:beering/app/data/card_health_index.dart';
import 'package:beering/app/data/health_data.dart';
import 'package:beering/app/modules/app_view/controllers/app_view_controller.dart';
import 'package:beering/net/app_api.dart';
import 'package:beering/public.dart';
import 'package:beering/utils/console_logger.dart';
import 'package:beering/views/charts/home_card/model/home_card_type.dart';
import 'package:beering/views/charts/home_card/model/home_card_x.dart';
import 'package:beering/views/charts/radio_gauge_chart/model/radio_gauge_chart_model.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class HomeStateController extends GetxController {
  //TODO: Implement HomeStateController

  static String tag = "HomeStateControllerTag";

  Rx<RadioGaugeChartData> licheng = RadioGaugeChartData().obs;
  Rx<RadioGaugeChartData> steps = RadioGaugeChartData().obs;
  Rx<RadioGaugeChartData> calorie = RadioGaugeChartData().obs;

  RxList<KHomeCardModel> dataTypes = <KHomeCardModel>[].obs;

  late RefreshController refreshController = RefreshController();

  @override
  void onInit() {
    super.onInit();

    initData();
  }

  void onRefresh() {}

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

      KHomeCardModel card = KHomeCardModel(
        type: element.type,
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
  }

  void onTapEditCard() async {
    final now = DateTime.now();
    final time = getZeroDateTime(now: now);

    final nextTime = getZeroDateTime(now: now.add(Duration(days: 1)));
    int userid = SPManager.getGlobalUser()!.id!;

    final item = HeartRateData(
      appUserId: userid,
      createTime: time,
    );
    HeartRateData.insertTokens([item]);

    // await Future.delayed(Duration(seconds: 4));

    try {
      final a = await HeartRateData.queryUserAll(userid, time, nextTime);

      vmPrint("aaaaa " + a.jsonString);

      final b = await HealthData.queryHealthData(
          reportType: KReportType.day, types: KHealthDataType.HEART_RATE);

      vmPrint("bbbb " +b.jsonString);
    } catch (e) {
      vmPrint("eeee " +e.toString());
      HWToast.showErrText(text: "e $e");
    }

    // Get.toNamed(Routes.HOME_EDIT_CARD);
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
