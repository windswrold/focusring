import 'package:focusring/app/modules/app_view/controllers/app_view_controller.dart';
import 'package:get/get.dart';

import '../../../../public.dart';

class FindDevicesController extends GetxController {
  //TODO: Implement FindDevicesController

  late AnimationController controller;

  late RxList datas = [].obs;
  @override
  void onInit() {
    super.onInit();
  }

  void onCreate(AnimationController c) {
    controller = c;
  }

  @override
  void onReady() {
    super.onReady();

    AppViewController c = Get.find(tag: AppViewControllerTag);

    c.startScan();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void pauseAnimation() {
    if (controller.isAnimating) {
      controller.stop();
    }
  }

  void resumeAnimation() {
    if (!controller.isAnimating) {
      controller.repeat();
    }
  }
}
