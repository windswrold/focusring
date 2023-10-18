import 'package:get/get.dart';

import '../controllers/permiss_setting_controller.dart';

class PermissSettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PermissSettingController>(
      () => PermissSettingController(),
    );
  }
}
