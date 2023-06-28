import 'package:get/get.dart';

import '../controllers/setting_user_info_controller.dart';

class SettingUserInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingUserInfoController>(
      () => SettingUserInfoController(),
    );
  }
}
