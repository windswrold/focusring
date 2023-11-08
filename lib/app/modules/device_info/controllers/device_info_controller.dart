import 'dart:async';

import 'package:beering/app/data/ring_device.dart';
import 'package:beering/net/app_api.dart';
import 'package:beering/utils/timer_util.dart';
import 'package:get/get.dart';

import '../../../../public.dart';

class DeviceInfoController extends GetxController {
  //TODO: Implement DeviceInfoController

  Rx<KStateType> buttonState = KStateType.idle.obs;
  RxDouble progress = 0.0.obs;

  late RingDeviceModel ringDevice;
  @override
  void onInit() {
    super.onInit();
    ringDevice = Get.arguments;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void startDFU() {
    // HWToast.showSucText(text: "no_v".tr);

    HWToast.showLoading();
    AppApi.getLatestFirmwareStream().onSuccess((value) {
      HWToast.hiddenAllToast();
    }).onError((r) {
      HWToast.showErrText(text: r.error ?? "");
    });
  }

  void changeButtonState(KStateType state) async {
    buttonState.value = state;

    await Future.delayed(Duration(seconds: 3));

    buttonState.value = KStateType.idle;

    await Future.delayed(Duration(seconds: 3));

    buttonState.value = KStateType.fail;

    await Future.delayed(Duration(seconds: 3));

    buttonState.value = KStateType.success;
    await Future.delayed(Duration(seconds: 3));

    buttonState.value = KStateType.loading;

    var a = TimerUtil(mTotalTime: Duration(seconds: 5).inMilliseconds);
    a.startCountDown();
    a.setOnTimerTickCallback((millisUntilFinished) {
      progress.value += 0.2;
    });
  }
}
