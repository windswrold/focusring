import 'package:beering/app/data/app_update_model.dart';
import 'package:beering/const/constant.dart';
import 'package:beering/net/app_api.dart';
import 'package:beering/public.dart';
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

    _initData();
  }

  void _initData() async {
    AppApi.checkAppUpdate(
            systemType: getSystemType(),
            currentVersion: GlobalValues.deviceInfo.appInfo?.version ?? "1.0.0")
        .onSuccess((result) {
      if (result.mapResult == null) {
        return;
      }

      final value = AppUpdateModel.fromJson(result.mapResult!);
      DialogUtils.defaultDialog(
        title: value.version ?? "",
        content: value.remark,
        hiddenCancel: value.forceUpdate ?? false,
        onConfirm: () {
          launchUrlString(value.downloadUrl ?? "");
        },
      );
    }).onError((r) {
      HWToast.showSucText(text: r.error ?? "");
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
