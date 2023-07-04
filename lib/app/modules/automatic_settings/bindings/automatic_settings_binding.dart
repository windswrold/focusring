import 'package:get/get.dart';

import '../controllers/automatic_settings_controller.dart';

class AutomaticSettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AutomaticSettingsController>(
      () => AutomaticSettingsController(),
    );
  }
}
