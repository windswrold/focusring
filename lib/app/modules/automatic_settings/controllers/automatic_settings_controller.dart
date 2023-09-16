import 'dart:async';

import 'package:beering/ble/ble_manager.dart';
import 'package:beering/ble/bledata_serialization.dart';
import 'package:beering/net/app_api.dart';
import 'package:get/get.dart';

import '../../../../public.dart';

class AutomaticSettingsController extends GetxController {
  //TODO: Implement AutomaticSettingsController

  final heartRateAutoTestSwitch = false.obs;
  final bloodOxygenAutoTestSwitch = false.obs;

  final heartRateAutoTestInterval = "5".obs;
  final bloodOxygenAutoTestInterval = "4".obs;

  StreamSubscription? receive;

  @override
  void onInit() {
    super.onInit();

    final us = SPManager.getGlobalUser();
    heartRateAutoTestSwitch.value = us?.heartRateAutoTestSwitch ?? false;
    bloodOxygenAutoTestSwitch.value = us?.bloodOxygenAutoTestSwitch ?? false;
    heartRateAutoTestInterval.value =
        (us?.heartRateAutoTestInterval ?? 5).toString();
    bloodOxygenAutoTestInterval.value =
        (us?.bloodOxygenAutoTestInterval ?? 4).toString();

    receive = KBLEManager.receiveDataStream.listen((event) {
      if (event.command == KBLECommandType.ppg) {
        if (event.status == true) {
          HWToast.showSucText(text: event.tip);
        } else {
          HWToast.showErrText(text: event.tip);
        }
      }
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    receive?.cancel();
    super.onClose();
  }

  void onChangeHeart(bool state) async {
    heartRateAutoTestSwitch.value = state;
    final a = await _requestData({"heartRateAutoTestSwitch": state});
    HWToast.showLoading();
    var sameTime = DateTime.now();
    KBLEManager.sendData(
        sendData: KBLESerialization.ppg_heartTimingTest(
      isOn: state,
      startTime: sameTime,
      endTime: sameTime,
      offset: int.tryParse(heartRateAutoTestInterval.value),
      isHeart: KHealthDataType.HEART_RATE,
    ));
  }

  void onChangeBloodoxy(bool state) async {
    bloodOxygenAutoTestSwitch.value = state;
    final a = await _requestData({"bloodOxygenAutoTestSwitch": state});
    HWToast.showLoading();
    var sameTime = DateTime.now();
    KBLEManager.sendData(
        sendData: KBLESerialization.ppg_heartTimingTest(
      isOn: state,
      startTime: sameTime,
      endTime: sameTime,
      offset: int.tryParse(bloodOxygenAutoTestInterval.value),
      isHeart: KHealthDataType.BLOOD_OXYGEN,
    ));
  }

  void showHeartrate_Offset() async {
    final arrs = ListEx.generateHeartRateAutoTestInterval();
    final selectIndex = await DialogUtils.dialogDataPicker(
      title: "heartrate_interval".tr,
      datas: arrs,
      symbolText: "  min",
      symbolRight: 100.w,
      initialItem: arrs.indexOf(heartRateAutoTestInterval.value),
    );
    if (selectIndex == null) {
      return;
    }
    heartRateAutoTestInterval.value = arrs[selectIndex];
    final a =
        await _requestData({"heartRateAutoTestInterval": arrs[selectIndex]});

    HWToast.showLoading();
    var sameTime = DateTime.now();
    KBLEManager.sendData(
        sendData: KBLESerialization.ppg_heartTimingTest(
      isOn: heartRateAutoTestSwitch.value,
      startTime: sameTime,
      endTime: sameTime,
      offset: int.tryParse(heartRateAutoTestInterval.value),
      isHeart: KHealthDataType.HEART_RATE,
    ));
  }

  void showBloodOxygen_Offset() async {
    final arrs = ListEx.generateBloodOxygenAutoTestInterval();
    final selectIndex = await DialogUtils.dialogDataPicker(
      title: "bloodoxygen_interval".tr,
      datas: arrs,
      symbolText: KHealthDataType.BLOOD_OXYGEN.getSymbol(),
      symbolRight: 100.w,
      initialItem: arrs.indexOf(bloodOxygenAutoTestInterval.value),
    );
    if (selectIndex == null) {
      return;
    }
    bloodOxygenAutoTestInterval.value = arrs[selectIndex];
    final a =
        await _requestData({"bloodOxygenAutoTestInterval": arrs[selectIndex]});

    HWToast.showLoading();
    var sameTime = DateTime.now();
    KBLEManager.sendData(
        sendData: KBLESerialization.ppg_heartTimingTest(
      isOn: bloodOxygenAutoTestSwitch.value,
      startTime: sameTime,
      endTime: sameTime,
      offset: int.tryParse(bloodOxygenAutoTestInterval.value),
      isHeart: KHealthDataType.BLOOD_OXYGEN,
    ));
  }

  Future _requestData(Map<String, dynamic> params) {
    Completer completer = Completer();
    Future future = completer.future;
    HWToast.showLoading();
    AppApi.editUserInfoStream(model: params).onSuccess((value) {
      // HWToast.showSucText(text: "modify_success".tr);
      // Get.backDelay();
      completer.complete();
    }).onError((r) {
      HWToast.showErrText(text: r.error ?? "");
      completer.complete();
    });
    return future;
  }
}
