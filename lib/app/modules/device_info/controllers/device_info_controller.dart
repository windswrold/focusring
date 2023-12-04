import 'dart:async';

import 'package:beering/app/data/ring_device.dart';
import 'package:beering/ble/ble_manager.dart';
import 'package:beering/extensions/StringEx.dart';
import 'package:beering/net/app_api.dart';
import 'package:beering/utils/timer_util.dart';
import 'package:get/get.dart';

import '../../../../net/api_stream/api.dart';
import '../../../../public.dart';
import '../../../data/firmware_version_model.dart';

class DeviceInfoController extends GetxController {
  //TODO: Implement DeviceInfoController

  Rx<KStateType> buttonState = KStateType.idle.obs;
  RxDouble progress = 0.0.obs;

  late RingDeviceModel ringDevice;

  Rx<FirmwareVersionModel?> versionModel = Rx(null);

  StreamSubscription? receiveDataStream;

  @override
  void onInit() {
    super.onInit();
    ringDevice = Get.arguments;
  }

  @override
  void onReady() {
    super.onReady();

    receiveDataStream = KBLEManager.receiveDataStream.listen((event) {
      if (event.command == KBLECommandType.system) {


      }
    });

    _initData();
  }

  @override
  void onClose() {
    receiveDataStream?.cancel();
    super.onClose();
  }

  _initData() {
    HWToast.showLoading();
    AppApi.getLatestFirmwareStream().onSuccess((value) {
      HWToast.hiddenAllToast();
      versionModel.value = value;
    }).onError((r) {
      HWToast.showErrText(text: r.error ?? "");
    });
  }

  void startDFU() {
    HWToast.showLoading();
    AppApi.getLatestFirmwareStream().onSuccess((value) {
      HWToast.hiddenAllToast();
      versionModel.value = value;
      String netV = value?.version??"";
      String dbV = ringDevice.version??"";
      if(netV.compare(netV, dbV) >0){
        
      }

    }).onError((r) {
      HWToast.showErrText(text: r.error ?? "");
    });
  }

  downlOADING() {
    // VMApi().dioUpload(url, filePath)
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
