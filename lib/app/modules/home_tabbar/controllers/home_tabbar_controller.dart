import 'package:beering/app/data/app_update_model.dart';
import 'package:beering/ble/ble_manager.dart';
import 'package:beering/const/constant.dart';
import 'package:beering/net/app_api.dart';
import 'package:beering/public.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../home_devices/controllers/home_devices_controller.dart';
import '../../home_mine/controllers/home_mine_controller.dart';
import '../../home_state/controllers/home_state_controller.dart';

class HomeTabbarController extends GetxController {
  //TODO: Implement HomeTabbarController

  final currentIndex = 0.obs;

  final bleIsok = false.obs;

  @override
  void onInit() {
    super.onInit();

    Get.put(HomeDevicesController());
    Get.put(HomeMineController());
    Get.put(HomeStateController());
  }

  @override
  void onReady() {
    super.onReady();

    _initData();
  }

  void _initData() async {
    final state = await KBLEManager.checkBle();
    vmPrint("checkBle $state");
    bleIsok.value = state;

    AppApi.checkAppUpdateStream(
            systemType: getSystemType(),
            currentVersion: GlobalValues.appInfo?.version ?? "1.0.0")
        .onSuccess((result) {
      if (result.mapResult == null) {
        return;
      }

      final value = AppUpdateVersionModel.fromJson(result.mapResult!);
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
