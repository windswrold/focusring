import 'package:beering/app/modules/home_devices/controllers/home_devices_controller.dart';
import 'package:beering/app/modules/home_mine/controllers/home_mine_controller.dart';
import 'package:beering/app/modules/home_state/controllers/home_state_controller.dart';
import 'package:beering/app/modules/home_state/views/home_state_view.dart';
import 'package:get/get.dart';

import '../controllers/home_tabbar_controller.dart';

class HomeTabbarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeTabbarController>(
      () => HomeTabbarController(),
    );
    Get.lazyPut<HomeDevicesController>(
      () => HomeDevicesController(),
    );
    Get.lazyPut<HomeStateController>(
      () => HomeStateController(),
    );
    Get.lazyPut<HomeMineController>(
      () => HomeMineController(),
    );
  }
}
