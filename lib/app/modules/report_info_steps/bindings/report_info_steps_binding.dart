import 'package:get/get.dart';

import '../controllers/report_info_steps_controller.dart';

class ReportInfoStepsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReportInfoStepsController>(
      () => ReportInfoStepsController(),
    );
  }
}
