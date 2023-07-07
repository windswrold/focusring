import 'package:get/get.dart';

import '../controllers/report_info_sleep_controller.dart';

class ReportInfoSleepBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReportInfoSleepController>(
      () => ReportInfoSleepController(),
    );
  }
}
