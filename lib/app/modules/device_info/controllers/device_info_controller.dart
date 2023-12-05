import 'dart:async';
import 'dart:io';

import 'package:beering/app/data/ring_device.dart';
import 'package:beering/app/modules/home_devices/controllers/home_devices_controller.dart';
import 'package:beering/ble/ble_manager.dart';
import 'package:beering/ble/bledata_serialization.dart';
import 'package:beering/extensions/StringEx.dart';
import 'package:beering/net/app_api.dart';
import 'package:beering/utils/timer_util.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../net/api_stream/api.dart';
import '../../../../public.dart';
import '../../../data/firmware_version_model.dart';

class DeviceInfoController extends GetxController {
  //TODO: Implement DeviceInfoController

  Rx<KStateType> buttonState = KStateType.idle.obs;
  RxDouble progress = 0.0.obs;

  Rx<RingDeviceModel?> ringDevice = Rx(null);

  Rx<FirmwareVersionModel?> versionModel = Rx(null);

  StreamSubscription? receiveDataStream,
      onDfuStart,
      onDfuError,
      onDfuProgress,
      onDfuComplete;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();

    receiveDataStream = KBLEManager.receiveDataStream.listen((event) {
      if (event.command == KBLECommandType.system && event.type == 0x01) {
        if (event.status == true) {
          //同意升级
          downloadBin();
        } else {
          HWToast.showErrText(text: event.tip);
        }
      }
    });

    onDfuStart = KBLEManager.onDfuStart.listen((event) {
      HWToast.showSucText(text: "onDfuStart");
      vmPrint("onDfuStart deinfo", KBLEManager.logevel);
    });
    onDfuError = KBLEManager.onDfuError.listen((event) {
      HWToast.showSucText(text: "onDfuError $event");
      buttonState.value = KStateType.fail;
      vmPrint("onDfuError deinfo $event", KBLEManager.logevel);
    });
    onDfuProgress = KBLEManager.onDfuProgress.listen((event) {
      // HWToast.showSucText(text: "onDfuProgress $event");
      progress.value = double.parse(event) / 100;
      vmPrint("onDfuProgress deinfo $event", KBLEManager.logevel);
    });
    onDfuComplete = KBLEManager.onDfuComplete.listen((event) {
      HWToast.showSucText(text: "升级成功");
      vmPrint("onDfuComplete deinfo", KBLEManager.logevel);
      buttonState.value = KStateType.idle;
      _initData();
    });

    _initData();
  }

  @override
  void onClose() {
    receiveDataStream?.cancel();
    onDfuStart?.cancel();
    onDfuError?.cancel();
    onDfuProgress?.cancel();
    onDfuComplete?.cancel();
    super.onClose();
  }

  _initData() async {
    final a = await RingDeviceModel.queryUserAllWithSelect(
        SPManager.getGlobalUser()!.id.toString(), true);
    ringDevice.value = a;

    HWToast.showLoading();
    AppApi.getLatestFirmwareStream().onSuccess((value) {
      HWToast.hiddenAllToast();
      versionModel.value = value;
      _checkVersion();
    }).onError((r) {
      HWToast.showErrText(text: r.error ?? "");
    });
  }

  void startDFU() {
    if (buttonState.value == KStateType.update) {
      if (KBLEManager.scDevice == null) {
        HWToast.showErrText(text: "设备已断开");
        return;
      }
      //电量检测
      int bat = Get.find<HomeDevicesController>().batNum.value;
      if (bat <= 40) {
        HWToast.showErrText(text: "电量不得低于40%");
        return;
      }

      //发送升级指令
      KBLEManager.sendData(
          sendData:
              KBLESerialization.requestOTA(versionModel.value?.version ?? ""));
      return;
    }
    _initData();
  }

  _checkVersion() {
    String netV = versionModel.value?.version ?? "0";
    String dbV = ringDevice.value?.version ?? "0";
    if (netV.compare(netV, dbV) <= 0) {
      HWToast.showErrText(text: "no_v".tr);
      buttonState.value = KStateType.fail;
      return;
    }
    buttonState.value = KStateType.update;
  }

  downloadBin() async {
    try {
      Directory file = await getTemporaryDirectory();
      String fileNmae = "${file.path}/${DateTime.now()}.bin";
      File cre = File(fileNmae);
      buttonState.value = KStateType.downloading;
      final path = await VMApi().dioDownload(
        versionModel.value?.downloadUrl ?? "",
        cre.absolute.path,
        progressCallback: (a, b) {
          progress.value = a / b;
        },
      );

      if (KBLEManager.scDevice == null) {
        HWToast.showErrText(text: "设备已断开");
        return;
      }

      try {
        vmPrint(
            "startCopyDfu fileNmae $fileNmae copyAdd $bleCopyAddress fastMode true",
            KBLEManager.logevel);
        await KBLEManager.scDevice!.device.startCopyDfu(
            filePath: fileNmae, copyAdd: bleCopyAddress, fastMode: true);
        buttonState.value = KStateType.sending;
      } catch (e) {
        vmPrint(e);
        HWToast.showErrText(text: e.toString());
      }

      vmPrint("dioDownload $path", KBLEManager.logevel);
    } catch (e) {
      vmPrint("dioDownload $e", KBLEManager.logevel);
    }
  }
}
