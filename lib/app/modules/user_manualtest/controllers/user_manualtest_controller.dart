import 'dart:async';

import 'package:beering/ble/ble_manager.dart';
import 'package:beering/ble/bledata_serialization.dart';
import 'package:beering/utils/hex_util.dart';
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
    _setTime();
    _timerUtil.setOnTimerTickCallback((millisUntilFinished) {
      vmPrint(millisUntilFinished, KBLEManager.logevel);
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
          if (countDownNum.value >= 0) {
            if (event.type == 0x00 &&
                type.value == KHealthDataType.HEART_RATE) {
              //心率
              dynamic result = event.value;
              testResult.value = result.toString();
              HWToast.showSucText(text: event.tip);
              pauseAnimation();
            } else if (event.type == 0x05 &&
                type.value == KHealthDataType.BLOOD_OXYGEN) {
              //血氧
              dynamic result = event.value;
              testResult.value = result.toString();
              HWToast.showSucText(text: event.tip);
              pauseAnimation();
            }
          }
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
      _setTime();
      KBLEManager.sendData(
          sendData: KBLESerialization.ppg_heartOnceTest(
        isHeart: type.value,
      ));
    }

    if (!inProduction) {
      //电量获取
      // KBLEManager.onValueReceived(HEXUtil.decode("EEEE0003060012"));
      //充电状态
      // KBLEManager.onValueReceived(HEXUtil.decode("EEEE0003070002"));
      //心率有3天暑假
      // KBLEManager.onValueReceived(HEXUtil.decode("EEEE00040303AA03"));
      //回复心率数据
      // KBLEManager.onValueReceived(HEXUtil.decode("EEEE00050303bb0101"));

      //设备接受测量
      // KBLEManager.onValueReceived(HEXUtil.decode("EEEE000403000100"));
      //设备已经在测量中
      // KBLEManager.onValueReceived(HEXUtil.decode("EEEE000403000200"));
      //设备在定时测量中，还没有出值
      // KBLEManager.onValueReceived(HEXUtil.decode("EEEE000403000300"));
      //设备在定时测量中已经出值测量还未结束
      // KBLEManager.onValueReceived(HEXUtil.decode("EEEE000403000400"));
      // KBLEManager.onValueReceived(HEXUtil.decode("EEEE0004030006aa"));

      // KBLEManager.onValueReceived(HEXUtil.decode("EEEE0004030506aa"));

      return;
    }
  }

  void _setTime() {
    if (type.value == KHealthDataType.HEART_RATE) {
      _timerUtil.updateTotalTime(Duration(seconds: 30).inMilliseconds);
    } else {
      _timerUtil.updateTotalTime(Duration(seconds: 60).inMilliseconds);
    }
    countDownNum.value = (_timerUtil.mTotalTime ?? 0) ~/ 1000;
  }
}
