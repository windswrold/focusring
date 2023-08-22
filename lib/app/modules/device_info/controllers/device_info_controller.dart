import 'dart:async';

import 'package:beering/app/data/ring_device.dart';
import 'package:beering/utils/timer_util.dart';
import 'package:get/get.dart';

import '../../../../public.dart';

class DeviceInfoController extends GetxController {
  //TODO: Implement DeviceInfoController

  Rx<KState> buttonState = KState.idle.obs;
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

  void changeButtonState(KState state) async {
    buttonState.value = state;

    await Future.delayed(Duration(seconds: 3));

    buttonState.value = KState.idle;

    await Future.delayed(Duration(seconds: 3));

    buttonState.value = KState.fail;

    await Future.delayed(Duration(seconds: 3));

    buttonState.value = KState.success;
    await Future.delayed(Duration(seconds: 3));

    buttonState.value = KState.loading;

    var a = TimerUtil(mTotalTime: Duration(seconds: 5).inMilliseconds);
    a.startCountDown();
    a.setOnTimerTickCallback((millisUntilFinished) {
      progress.value += 0.2;
    });
  }
}
