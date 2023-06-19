import 'package:get/get.dart';

class HomeTabbarController extends GetxController {
  //TODO: Implement HomeTabbarController

  final currentIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void onTap(index) {
    currentIndex.value = index;
  }
}
