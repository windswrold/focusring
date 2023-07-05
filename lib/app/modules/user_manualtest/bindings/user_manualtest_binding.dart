import 'package:get/get.dart';

import '../controllers/user_manualtest_controller.dart';

class UserManualtestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserManualtestController>(
      () => UserManualtestController(),
    );
  }
}
