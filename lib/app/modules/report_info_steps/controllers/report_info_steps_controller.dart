import 'dart:async';
import 'dart:math';

import 'package:focusring/public.dart';
import 'package:focusring/views/tra_led_button.dart';
import 'package:get/get.dart';

class ReportInfoStepsController extends GetxController
    with GetSingleTickerProviderStateMixin {
  //TODO: Implement ReportInfoStepsController

  late List<Tab> myTabbas = [];
  late TabController tabController;
  late Rx<KReportType> reportType = KReportType.day.obs;
  late KHealthDataType currentType;

  late RxString allResult = "-".obs;

  late StreamSubscription dateSc;

  @override
  void onInit() {
    super.onInit();

    currentType = Get.arguments;
    myTabbas = [
      Tab(
        text: ("Day".tr),
      ),
      Tab(
        text: ("Week".tr),
      ),
      Tab(
        text: ("Month".tr),
      ),
    ];
    tabController = TabController(vsync: this, length: myTabbas.length);
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

  void onTapType(int type) {
    reportType.value = KReportType.values[type];

    allResult.value = Random.secure().nextInt(10000).toString();
  }
}
