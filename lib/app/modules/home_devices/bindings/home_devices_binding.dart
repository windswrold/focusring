import 'package:get/get.dart';

import '../controllers/home_devices_controller.dart';

class HomeDevicesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeDevicesController>(
      () => HomeDevicesController(),
    );
  }
}
