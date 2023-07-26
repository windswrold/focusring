import 'package:focusring/const/constant.dart';
import 'package:focusring/net/app_api.dart';
import 'package:focusring/public.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

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

    AppApi.checkAppUpdate(
            systemType: isIOS ? 1 : 2,
            currentVersion: GlobalValues.deviceInfo.appInfo?.version ?? "1.0.0")
        .onSuccess((value) {
      DialogUtils.defaultDialog(
        title: value.version ?? "",
        content: value.remark,
        hiddenCancel: value.forceUpdate??false,
        onConfirm: () {
          launchUrlString(value.downloadUrl ?? "");
        },
      );
    }).onError((r) {
      HWToast.showText(text: r.error ?? "");
    });
  }

  @override
  void onClose() {
    super.onClose();
  }

  void onTap(index) {
    currentIndex.value = index;
  }
}
