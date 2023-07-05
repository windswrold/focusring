import 'package:get/get.dart';

import '../controllers/app_view_controller.dart';

class AppViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AppViewController>(
      () => AppViewController(),
    );
  }
}
