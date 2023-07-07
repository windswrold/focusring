import 'package:get/get.dart';

import '../controllers/report_info_heartrate_controller.dart';

class ReportInfoHeartrateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReportInfoHeartrateController>(
      () => ReportInfoHeartrateController(),
    );
  }
}
