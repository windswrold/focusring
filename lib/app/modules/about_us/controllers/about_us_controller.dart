import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AboutUsController extends GetxController {
  //TODO: Implement AboutUsController

  RxList my_defaultList = [].obs;
  @override
  void onInit() {
    super.onInit();

    my_defaultList = [
      {
        "b": "privacy_policy",
      },
      {
        "b": "user_agreement",
      },
    ].obs;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void onTapList(int index) {
    launchUrlString("https://baidu.com");
  }
}
