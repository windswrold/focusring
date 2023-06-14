import 'package:get/get.dart';

import '../controllers/home_state_controller.dart';

class HomeStateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeStateController>(
      () => HomeStateController(),
    );
  }
}
