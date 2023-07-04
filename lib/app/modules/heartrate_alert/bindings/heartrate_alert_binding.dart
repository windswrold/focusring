import 'package:get/get.dart';

import '../controllers/heartrate_alert_controller.dart';

class HeartrateAlertBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HeartrateAlertController>(
      () => HeartrateAlertController(),
    );
  }
}
