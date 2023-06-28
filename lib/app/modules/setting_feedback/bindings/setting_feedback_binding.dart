import 'package:get/get.dart';

import '../controllers/setting_feedback_controller.dart';

class SettingFeedbackBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingFeedbackController>(
      () => SettingFeedbackController(),
    );
  }
}
