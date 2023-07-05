import 'package:get/get.dart';

import '../controllers/find_devices_controller.dart';

class FindDevicesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FindDevicesController>(
      () => FindDevicesController(),
    );
  }
}
