import 'dart:async';
import 'dart:math';

import 'package:beering/public.dart';
import 'package:beering/views/charts/home_card/model/home_card_x.dart';
import 'package:beering/views/tra_led_button.dart';
import 'package:get/get.dart';

class ReportInfoEmotionController extends GetxController {
  //TODO: Implement ReportInfoEmotionController

  static const String id_data_souce_update = "id_data_souce_update_emotion";

  late RxString allResult = "-".obs;

  late RxString chartTipValue = "".obs;

  late RxList<List<KChartCellData>> dataSource = [<KChartCellData>[]].obs;

  @override
  void onInit() {
    super.onInit();
    _queryDataSource();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void _queryDataSource() {
    int sumVal = 250;

    dataSource.value = [
      List.generate(
        30,
        (index) => KChartCellData(
          x: index.toString(),
          y: Random.secure().nextInt(50),
          color: KEMOTIONStatusType.positive.getStatusColor(),
        ),
      ),
      List.generate(
        30,
        (index) => KChartCellData(
          x: index.toString(),
          y: Random.secure().nextInt(50),
          color: KEMOTIONStatusType.neutral.getStatusColor(),
        ),
      ),
      List.generate(
        30,
        (index) => KChartCellData(
          x: index.toString(),
          y: Random.secure().nextInt(50),
          color: KEMOTIONStatusType.negative.getStatusColor(),
        ),
      )
    ];

    update([id_data_souce_update]);
  }

  void onTrackballPositionChanging(int? index) {
    if (index == null) {
      return;
    }
    //11:30-11:59:765 steps

    String text = "";

    // chartTipValue.value = "${item.x}:${item.y} steps";
    text = "aaa";

    chartTipValue.value = text;
    Future.delayed(const Duration(seconds: 3)).then((value) => {
          chartTipValue.value = "",
        });
  }

  void stratTest() {
    // if (connectDevice.value == null) {
    //   DialogUtils.defaultDialog(
    //     title: "empty_unbind".tr,
    //     content: "empty_unbindtip".tr,
    //     alignment: Alignment.center,
    //   );
    //   return;
    // }

    Get.toNamed(Routes.USER_MANUALTEST, arguments: KHealthDataType.EMOTION);
  }
}
