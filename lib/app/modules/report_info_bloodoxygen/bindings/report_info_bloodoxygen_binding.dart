import 'package:get/get.dart';

import '../controllers/report_info_bloodoxygen_controller.dart';

class ReportInfoBloodoxygenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReportInfoBloodoxygenController>(
      () => ReportInfoBloodoxygenController(),
    );
  }
}
