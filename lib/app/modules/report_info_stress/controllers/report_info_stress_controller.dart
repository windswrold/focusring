import 'dart:async';
import 'dart:math';

import 'package:focusring/public.dart';
import 'package:focusring/views/charts/home_card/model/home_card_x.dart';
import 'package:focusring/views/tra_led_button.dart';
import 'package:get/get.dart';

class ReportInfoStressController extends GetxController {
  //TODO: Implement ReportInfoStressController

  late StreamSubscription dateSc;
  late RxString chartTipValue = "".obs;
  static const String id_data_souce_update = "id_data_souce_update_stress";
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
          y: 0,
          color:
              KStressStatus.values[Random.secure().nextInt(4)].getStatusColor(),
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

    String text = "-";

    // chartTipValue.value = "${item.x}:${item.y} steps";

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
