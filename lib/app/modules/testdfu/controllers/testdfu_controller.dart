import 'dart:async';
import 'dart:io';
import 'package:beering/utils/hex_util.dart';
import 'package:file_picker/file_picker.dart';
import 'package:beering/app/data/ring_device.dart';
import 'package:beering/ble/ble_config.dart';
import 'package:beering/ble/ble_manager.dart';
import 'package:get/get.dart';
import 'package:hex/hex.dart';

import '../../../../public.dart';

class TestdfuController extends GetxController {
  //TODO: Implement TestdfuController

  RxString currentFile = "".obs;

  TextEditingController copy1 = TextEditingController();
  TextEditingController copy2 = TextEditingController();
  TextEditingController copy3 = TextEditingController();
  TextEditingController copy4 = TextEditingController();
  TextEditingController copy5 = TextEditingController();

  RxBool isExtFlash = false.obs;
  RxBool isfastMode = true.obs;

  StreamSubscription? onDfuStart,
      onDfuError,
      onDfuProgress,
      onDfuComplete,
      sen,
      receiveDataStream;

  RxList<String> receDatas = RxList();

  @override
  void onInit() {
    super.onInit();

    onDfuStart = KBLEManager.onDfuStart.listen((event) {
      HWToast.showSucText(text: "onDfuStart");
    });
    onDfuError = KBLEManager.onDfuError.listen((event) {
      HWToast.showSucText(text: "onDfuError $event");
    });
    onDfuProgress = KBLEManager.onDfuProgress.listen((event) {
      HWToast.showSucText(text: "onDfuProgress $event");
    });
    onDfuComplete = KBLEManager.onDfuComplete.listen((event) {
      HWToast.showSucText(text: "onDfuComplete");
    });

    receiveDataStream = KBLEManager.receiveDataStream.listen((event) {
      // HWToast.showSucText(text: "收到的数据 $event");
      receDatas.add(event.toString());
    });

    sen = KBLEManager.logController.stream.listen((event) {
      receDatas.add(event);
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    onDfuStart?.cancel();
    onDfuError?.cancel();
    onDfuProgress?.cancel();
    onDfuComplete?.cancel();
    receiveDataStream?.cancel();
    receiveDataStream = null;
    sen?.cancel();
    KBLEManager.clean();
    super.onClose();
  }

  void onChange(bool state) {
    isfastMode.value = state;
  }

  void openFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      withData: true,
    );
    if (result == null) {
      return;
    }

    vmPrint("openFile " + result.toString());
    try {
      File cahe = await getAppFile();
      var fileNmae = result.names.first;
      cahe = File('${cahe.absolute.path}/$fileNmae');
      final file = result.files.first;
      var a = await cahe.writeAsBytes(file.bytes!.toList());
      currentFile.value = a.absolute.path;
      vmPrint("saveToPath a $a");
    } catch (e) {
      HWToast.showSucText(text: e.toString());
    }
  }

  void normalDFU() async {
    if (currentFile.isEmpty) {
      HWToast.showSucText(text: "先选择一个文件");
      return;
    }
    RingDeviceModel de = Get.arguments;
    try {
      await KBLEManager.getDevice(device: de)
          .startDfu(filePath: currentFile.value, fastMode: isfastMode.value);
    } catch (e) {
      vmPrint(e);
      HWToast.showErrText(text: e.toString());
    }
  }

  void copyDFU() async {
    if (currentFile.isEmpty) {
      HWToast.showSucText(text: "先选择一个文件");
      return;
    }
    var text = copy1.text;
    if (text.isEmpty) {
      HWToast.showSucText(text: "输入拷贝地址");
      return;
    }

    RingDeviceModel de = Get.arguments;

    try {
      await KBLEManager.getDevice(device: de).startCopyDfu(
          filePath: currentFile.value,
          copyAdd: int.parse(text, radix: 16),
          fastMode: isfastMode.value);
    } catch (e) {
      HWToast.showErrText(text: e.toString());
    }
  }

  void sendota(BLESendData send) {
    try {
      KBLEManager.sendData(sendData: send);
    } catch (e) {
      HWToast.showSucText(text: e.toString());
    }
  }

  void sendcustom() {
    var text = copy2.text;
    if (text.isEmpty) {
      HWToast.showSucText(text: "输入要发送的数据");
      return;
    }
    final a = HEX.decode(text);
    try {
      KBLEManager.zhiie(datas: a);
    } catch (e) {
      HWToast.showSucText(text: e.toString());
    }
  }

  void fastDFU() {
    if (currentFile.isEmpty) {
      HWToast.showSucText(text: "先选择一个文件");
      return;
    }
    RingDeviceModel de = Get.arguments;

    try {
      KBLEManager.getDevice(device: de).fastDfu(filePath: currentFile.value);
    } catch (e) {
      HWToast.showSucText(text: e.toString());
    }
  }

  void fastCopyDFU() {
    if (currentFile.isEmpty) {
      HWToast.showSucText(text: "先选择一个文件");
      return;
    }
    var text = copy2.text;
    if (text.isEmpty) {
      HWToast.showSucText(text: "输入拷贝地址");
      return;
    }

    RingDeviceModel de = Get.arguments;
    try {
      KBLEManager.getDevice(device: de).fastCopyDfu(
          filePath: currentFile.value, copyAdd: int.parse(text, radix: 16));
    } catch (e) {
      HWToast.showSucText(text: e.toString());
    }
  }

  void fastDFUResource() {
    if (currentFile.isEmpty) {
      HWToast.showSucText(text: "先选择一个文件");
      return;
    }
    var text = copy3.text;
    if (text.isEmpty) {
      HWToast.showSucText(text: "输入资源地址");
      return;
    }

    RingDeviceModel de = Get.arguments;

    try {
      KBLEManager.getDevice(device: de).fastDFUResource(
        filePath: currentFile.value,
        toAddr: int.parse(text, radix: 16),
        toExtFlash: isExtFlash.value,
      );
    } catch (e) {
      HWToast.showSucText(text: e.toString());
    }
  }
}
