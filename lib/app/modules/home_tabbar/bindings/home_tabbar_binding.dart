import 'package:get/get.dart';

import '../controllers/home_tabbar_controller.dart';

class HomeTabbarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeTabbarController>(
      () => HomeTabbarController(),
    );
  }
}
