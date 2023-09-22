import 'dart:async';

import 'package:beering/ble/ble_manager.dart';
import 'package:beering/ble/bledata_serialization.dart';
import 'package:beering/net/app_api.dart';
import 'package:beering/utils/date_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../public.dart';

late DateTime defaultTime = DateTime.now();

class AutomaticSettingsController extends GetxController {
  //TODO: Implement AutomaticSettingsController

  final heartRateAutoTestSwitch = false.obs;
  final bloodOxygenAutoTestSwitch = false.obs;

  final heartRateAutoTestInterval = "5".obs;
  final bloodOxygenAutoTestInterval = "5".obs;

  RxString startTimeHeart =
      DateUtil.formatDate(defaultTime, format: DateFormats.h_m).obs;
  RxString endTimeHeart =
      DateUtil.formatDate(defaultTime, format: DateFormats.h_m).obs;

  RxString startTimeOxygen =
      DateUtil.formatDate(defaultTime, format: DateFormats.h_m).obs;
  RxString endTimeOxygen =
      DateUtil.formatDate(defaultTime, format: DateFormats.h_m).obs;

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
        (us?.bloodOxygenAutoTestInterval ?? 5).toString();

    receive = KBLEManager.receiveDataStream.listen((event) {
      if (event.command == KBLECommandType.ppg) {
        if (event.type == 0x02) {
          List result = event.value;
          heartRateAutoTestSwitch.value = result[0] == 0 ? false : true;
          int hour = result[1];
          int min = result[2];
          startTimeHeart.value = "$hour:$min";
          int hour1 = result[3];
          int min1 = result[4];
          endTimeHeart.value = "$hour1:$min1";
          heartRateAutoTestInterval.value = result[5];
          //心率回复设置
          KBLEManager.sendData(
              sendData: KBLESerialization.ppg_getHeartTimingSetting(
                  isHeart: KHealthDataType.BLOOD_OXYGEN));
        } else if (event.type == 0x07) {
          //血氧回复设置
          List result = event.value;
          bloodOxygenAutoTestSwitch.value = result[0] == 0 ? false : true;
          int hour = result[1];
          int min = result[2];
          startTimeOxygen.value = "$hour:$min";
          int hour1 = result[3];
          int min1 = result[4];
          endTimeOxygen.value = "$hour1:$min1";
          bloodOxygenAutoTestInterval.value = result[5];
        } else if (event.type == 0x01) {
          //心率设置成功
          //发送血氧变更
          KBLEManager.sendData(
              sendData: KBLESerialization.ppg_heartTimingTest(
            isOn: bloodOxygenAutoTestSwitch.value,
            startTime:
                DateUtil.getDateTime(startTimeOxygen.value) ?? defaultTime,
            endTime: DateUtil.getDateTime(endTimeOxygen.value) ?? defaultTime,
            offset: int.tryParse(bloodOxygenAutoTestInterval.value),
            isHeart: KHealthDataType.BLOOD_OXYGEN,
          ));
        } else if (event.type == 0x06) {
          HWToast.showSucText(text: event.tip);
          //血氧更新成功
          Future.delayed(Duration(seconds: 1)).then((value) => {
                //发送读取心率
                KBLEManager.sendData(
                    sendData: KBLESerialization.ppg_getHeartTimingSetting(
                        isHeart: KHealthDataType.HEART_RATE))
              });
        }
      }
    });

    //发送读取心率
    KBLEManager.sendData(
        sendData: KBLESerialization.ppg_getHeartTimingSetting(
            isHeart: KHealthDataType.HEART_RATE));
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

  void save() async {
    if (endTimeHeart.value.compareTo(startTimeHeart.value) < 0) {
      HWToast.showErrText(text: "心率结束时间需要大于等于心率开始时间");
      return;
    }
    if (endTimeOxygen.value.compareTo(startTimeOxygen.value) < 0) {
      HWToast.showErrText(text: "血氧结束时间需要大于等于血氧开始时间");
      return;
    }
    final a = await _requestData({
      "heartRateAutoTestSwitch": heartRateAutoTestSwitch.value,
      "bloodOxygenAutoTestSwitch": bloodOxygenAutoTestSwitch.value,
      "heartRateAutoTestInterval": heartRateAutoTestInterval.value,
      "bloodOxygenAutoTestInterval": bloodOxygenAutoTestInterval.value,
    });

    //发送心率变更
    KBLEManager.sendData(
        sendData: KBLESerialization.ppg_heartTimingTest(
      isOn: heartRateAutoTestSwitch.value,
      startTime: DateUtil.getDateTime(startTimeHeart.value) ?? defaultTime,
      endTime: DateUtil.getDateTime(endTimeHeart.value) ?? defaultTime,
      offset: int.tryParse(heartRateAutoTestInterval.value),
      isHeart: KHealthDataType.HEART_RATE,
    ));
  }

  void onChangeTime(int type) async {
    final arrs = ListEx.getFiveMinuteIntervals();
    int initialItem = 0;
    if (type == 0) {
      initialItem = arrs.indexOf(startTimeHeart.value);
    } else if (type == 1) {
      initialItem = arrs.indexOf(endTimeHeart.value);
    } else if (type == 2) {
      initialItem = arrs.indexOf(startTimeOxygen.value);
    } else if (type == 3) {
      initialItem = arrs.indexOf(endTimeOxygen.value);
    }
    final selectIndex = await DialogUtils.dialogDataPicker(
      title: (type == 0 || type == 2) ? "starttime".tr : "endtime".tr,
      datas: arrs,
      symbolText: "",
      symbolRight: 100.w,
      initialItem: initialItem,
    );
    if (selectIndex == null) {
      return;
    }
    String selectTime = arrs[selectIndex];
    if (type == 0) {
      startTimeHeart.value = selectTime;
    } else if (type == 1) {
      endTimeHeart.value = selectTime;
    } else if (type == 2) {
      startTimeOxygen.value = selectTime;
    } else if (type == 3) {
      endTimeOxygen.value = selectTime;
    }
  }

  void onChangeHeart(bool state) async {
    heartRateAutoTestSwitch.value = state;
  }

  void onChangeBloodoxy(bool state) async {
    bloodOxygenAutoTestSwitch.value = state;
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
  }

  void showBloodOxygen_Offset() async {
    final arrs = ListEx.generateBloodOxygenAutoTestInterval();
    final selectIndex = await DialogUtils.dialogDataPicker(
      title: "bloodoxygen_interval".tr,
      datas: arrs,
      symbolText: "  min",
      symbolRight: 100.w,
      initialItem: arrs.indexOf(bloodOxygenAutoTestInterval.value),
    );
    if (selectIndex == null) {
      return;
    }
    bloodOxygenAutoTestInterval.value = arrs[selectIndex];
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
