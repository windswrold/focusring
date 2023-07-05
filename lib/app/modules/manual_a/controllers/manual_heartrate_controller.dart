import 'package:focusring/utils/console_logger.dart';
import 'package:focusring/utils/timer_util.dart';
import 'package:get/get.dart';
import 'package:gif/gif.dart';

import '../../../../public.dart';

const countDownTime = Duration(seconds: 5);

class ManualHeartrateController extends GetxController
    with GetTickerProviderStateMixin {
  late GifController gifController;

  late Rx<KState> kState = KState.idle.obs;
  late RxInt countDownNum = countDownTime.inSeconds.obs;

  late final TimerUtil _timerUtil =
      TimerUtil(mTotalTime: countDownTime.inMilliseconds);

  @override
  void onInit() {
    gifController = GifController(vsync: this);
    super.onInit();
  }

  @override
  void onReady() {
    kState.value = KState.loading;
    _timerUtil.startCountDown();
    _timerUtil.setOnTimerTickCallback((millisUntilFinished) {
      vmPrint(millisUntilFinished);
      countDownNum.value = (millisUntilFinished ?? 0) ~/ 1000;
      if (countDownNum.value <= 0) {
        pauseAnimation();
      }
    });
    super.onReady();
  }

  @override
  void onClose() {
    _timerUtil.cancel();
    gifController.dispose();
    super.onClose();
  }

  void pauseAnimation() {
    if (gifController.isAnimating) {
      gifController.stop();
      kState.value = KState.success;
      _timerUtil.cancel();
    }
  }

  void resumeAnimation() {
    if (!gifController.isAnimating) {
      gifController.repeat();
      kState.value = KState.loading;
      _timerUtil.updateTotalTime(countDownTime.inMilliseconds);
    }
  }
}
