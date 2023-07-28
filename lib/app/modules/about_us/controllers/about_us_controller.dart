import 'package:focusring/app/routes/app_pages.dart';
import 'package:focusring/net/app_api.dart';
import 'package:focusring/utils/custom_toast.dart';
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
    HWToast.showLoading();

    AppApi.queryAgreement().onSuccess((value) {
      HWToast.hiddenAllToast();
      Get.toNamed(Routes.COMMON_HTML_VIEW, arguments: value.responseBody);
    }).onError((r) {
      HWToast.showSucText(text: r.error ?? "");
    });

    // launchUrlString("https://baidu.com");
  }
}
