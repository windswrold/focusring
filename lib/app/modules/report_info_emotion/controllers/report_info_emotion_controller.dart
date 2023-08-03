import 'dart:async';
import 'dart:math';

import 'package:focusring/public.dart';
import 'package:focusring/views/charts/home_card/model/home_card_x.dart';
import 'package:focusring/views/tra_led_button.dart';
import 'package:get/get.dart';

class ReportInfoEmotionController extends GetxController {
  //TODO: Implement ReportInfoEmotionController

  static const String id_data_souce_update = "id_data_souce_update_emotion";

  late StreamSubscription dateSc;
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

    final a = Get.find<TraLedButtonController>();
    dateSc = a.displayTimeStream.listen((event) {
      vmPrint("displayTimeStream $event");
      allResult.value = Random.secure().nextInt(1000).toString();
    });
  }

  @override
  void onClose() {
    dateSc.cancel();
    super.onClose();
  }

  void _queryDataSource() {
    dataSource.value = [
      List.generate(
        30,
        (index) => KChartCellData(
          x: index.toString(),
          y: Random.secure().nextDouble() * 500,
          color: KEMOTIONStatus.positive.getStatusColor(),
        ),
      ),
      List.generate(
        30,
        (index) => KChartCellData(
          x: index.toString(),
          y: Random.secure().nextDouble() * 500,
          color: KEMOTIONStatus.neutral.getStatusColor(),
        ),
      ),
      List.generate(
        30,
        (index) => KChartCellData(
          x: index.toString(),
          y: Random.secure().nextDouble() * 500,
          color: KEMOTIONStatus.negative.getStatusColor(),
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
}
