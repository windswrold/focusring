import 'package:get/get.dart';

import '../../../../public.dart';

class FindDevicesController extends GetxController {
  //TODO: Implement FindDevicesController

  late AnimationController controller;
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
