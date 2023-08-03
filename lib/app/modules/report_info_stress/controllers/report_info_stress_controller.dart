import 'dart:async';

import 'package:focusring/public.dart';
import 'package:focusring/views/tra_led_button.dart';
import 'package:get/get.dart';

class ReportInfoStressController extends GetxController {
  //TODO: Implement ReportInfoStressController

  late StreamSubscription dateSc;

  @override
  void onInit() {
    super.onInit();
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
}
