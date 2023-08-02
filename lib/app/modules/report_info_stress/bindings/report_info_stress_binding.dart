import 'package:get/get.dart';

import '../controllers/report_info_stress_controller.dart';

class ReportInfoStressBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReportInfoStressController>(
      () => ReportInfoStressController(),
    );
  }
}
