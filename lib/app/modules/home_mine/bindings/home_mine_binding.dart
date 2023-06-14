import 'package:get/get.dart';

import '../controllers/home_mine_controller.dart';

class HomeMineBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeMineController>(
      () => HomeMineController(),
    );
  }
}
