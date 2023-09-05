import 'dart:async';
import 'package:beering/app/data/app_update_model.dart';
import 'package:beering/const/constant.dart';
import 'package:beering/net/app_api.dart';
import 'package:beering/public.dart';
import 'package:beering/utils/date_util.dart';
import 'package:beering/utils/json_util.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../ble/ble_manager.dart';

class HomeTabbarController extends GetxController {
  //TODO: Implement HomeTabbarController

  final currentIndex = 0.obs;
  StreamSubscription? sen;

  RxList<String> receDatas = RxList();

  @override
  void onInit() {
    super.onInit();

    sen = KBLEManager.logController.stream.listen((event) {
      receDatas.add("${DateUtil.getNowDateStr()} :  $event");
    });
  }

  @override
  void onReady() {
    super.onReady();

    _initData();
  }

  void exportLog() async {
    // final a = await saveFileData(
    //     content: JsonUtil.encodeObj(receDatas) ?? "", pathType: "");

    Share.share(JsonUtil.encodeObj(receDatas)??"");
  }

  void _initData() async {
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
    sen?.cancel();
    super.onClose();
  }

  void onTap(index) {
    currentIndex.value = index;
  }
}
