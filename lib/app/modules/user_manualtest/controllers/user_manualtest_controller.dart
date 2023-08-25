import 'dart:async';

import 'package:beering/ble/ble_manager.dart';
import 'package:beering/ble/bledata_serialization.dart';
import 'package:beering/utils/timer_util.dart';
import 'package:get/get.dart';
import 'package:gif/gif.dart';

import '../../../../public.dart';

const countDownTime = Duration(seconds: 5);

class UserManualtestController extends GetxController
    with GetTickerProviderStateMixin {
  late GifController gifController;

  late Rx<KStateType> kState = KStateType.idle.obs;
  late RxInt countDownNum = countDownTime.inSeconds.obs;

  late final TimerUtil _timerUtil =
      TimerUtil(mTotalTime: countDownTime.inMilliseconds);

  late Rx<KHealthDataType> type = KHealthDataType.HEART_RATE.obs;

  late RxString testResult = RxString("");

  StreamSubscription? receive;

  @override
  void onInit() {
    gifController = GifController(vsync: this);
    type.value = Get.arguments;
    vmPrint(type);
    super.onInit();
  }

  @override
  void onReady() {
    kState.value = KStateType.loading;
    _timerUtil.startCountDown();
    _timerUtil.setOnTimerTickCallback((millisUntilFinished) {
      vmPrint(millisUntilFinished);
      countDownNum.value = (millisUntilFinished ?? 0) ~/ 1000;
      if (countDownNum.value <= 0) {
        pauseAnimation();
      }
    });

    receive = KBLEManager.receiveDataStream.listen((event) {
      if (event.command == KBLECommandType.ppg) {
        if (event.status == false) {
          HWToast.showErrText(text: event.tip);
        } else {
          pauseAnimation();
          HWToast.showSucText(text: event.tip);
          dynamic result = event.value;
          testResult.value = result.toString();
        }
      }
    });

    KBLEManager.sendData(
        sendData: KBLESerialization.ppg_heartOnceTest(
      isHeart: type.value,
    ));
    super.onReady();
  }

  @override
  void onClose() {
    _timerUtil.cancel();
    gifController.dispose();
    receive?.cancel();
    super.onClose();
  }

  void pauseAnimation() {
    if (gifController.isAnimating) {
      gifController.stop();
      kState.value = KStateType.success;
      _timerUtil.cancel();
    }
  }

  void resumeAnimation() {
    if (!gifController.isAnimating) {
      gifController.repeat();
      kState.value = KStateType.loading;
      _timerUtil.updateTotalTime(countDownTime.inMilliseconds);
      KBLEManager.sendData(
          sendData: KBLESerialization.ppg_heartOnceTest(
        isHeart: type.value,
      ));
    }
  }
}
