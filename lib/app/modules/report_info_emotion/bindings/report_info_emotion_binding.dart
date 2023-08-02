import 'package:get/get.dart';

import '../controllers/report_info_emotion_controller.dart';

class ReportInfoEmotionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReportInfoEmotionController>(
      () => ReportInfoEmotionController(),
    );
  }
}
