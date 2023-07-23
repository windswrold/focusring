import 'dart:math';

import 'package:focusring/app/routes/app_pages.dart';
import 'package:focusring/public.dart';
import 'package:focusring/views/charts/home_card/model/home_card_type.dart';
import 'package:focusring/views/charts/home_card/model/home_card_x.dart';
import 'package:focusring/views/charts/radio_gauge_chart/model/radio_gauge_chart_model.dart';

class HomeStateController extends GetxController {
  //TODO: Implement HomeStateController

  RxList<RadioGaugeChartData> gaugeDatas = <RadioGaugeChartData>[].obs;

  RxList<KHomeCardModel> dataTypes = <KHomeCardModel>[].obs;

  String mileageDefault = "5.00";
  String pedometerDefault = "8000";
  String exerciseDefault = "400";
  @override
  void onInit() {
    super.onInit();

    _initData();
  }

  void _initData() {
    RadioGaugeChartData a = RadioGaugeChartData(
        percent: Random.secure().nextInt(100), color: const Color(0xFF00CEFF));
    RadioGaugeChartData b = RadioGaugeChartData(
        percent: Random.secure().nextInt(100), color: const Color(0xFF34E050));
    RadioGaugeChartData c = RadioGaugeChartData(
        percent: Random.secure().nextInt(100), color: const Color(0xFFFF723E));

    gaugeDatas.value = [a, b, c];
    List<KHomeCardModel> dataArr = [];
    KHealthDataType.values.forEach((element) {
      var data = List.generate(
          30, (index) => KChartCellData(x: index.toString(), y: 1000));
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
  }

  @override
  void onReady() {
    super.onReady();

    Future.delayed(Duration(seconds: 5)).then((value) => {
          vmPrint("delayeddelayeddelayed"),
          _initData(),
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
    Get.toNamed(Routes.REPORT_INFO_STEPS, arguments: type.type);

    return;

    // if (type == KHealthDataType.STEPS ||
    //     type == KHealthDataType.LiCheng ||
    //     type == KHealthDataType.CALORIES_BURNED ||
    //     type == KHealthDataType.STRESS) {
    //   Get.toNamed(Routes.REPORT_INFO_STEPS);
    // } else if (type == KHealthDataType.SLEEP) {
    //   Get.toNamed(Routes.REPORT_INFO_SLEEP);
    // } else if (type == KHealthDataType.HEART_RATE) {
    //   Get.toNamed(Routes.REPORT_INFO_HEARTRATE);
    // } else if (type == KHealthDataType.BLOOD_OXYGEN ||
    //     type == KHealthDataType.BODY_TEMPERATURE) {
    //   Get.toNamed(Routes.REPORT_INFO_BLOODOXYGEN);
    // } else if (type == KHealthDataType.EMOTION) {
    // } else if (type == KHealthDataType.FEMALE_HEALTH) {
    //   Get.toNamed(Routes.REPORT_INFO_FEMMALEHEALTH);
    // }
  }
}
