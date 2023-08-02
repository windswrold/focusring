import 'package:get/get.dart';

import '../controllers/report_info_femmalehealth_controller.dart';

class ReportInfoFemmalehealthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReportInfoFemmalehealthController>(
      () => ReportInfoFemmalehealthController(),
    );
  }
}
