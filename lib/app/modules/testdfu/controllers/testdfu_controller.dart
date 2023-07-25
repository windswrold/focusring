import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:focusring/app/data/ring_device.dart';
import 'package:focusring/utils/ble_manager.dart';
import 'package:get/get.dart';

import '../../../../public.dart';

class TestdfuController extends GetxController {
  //TODO: Implement TestdfuController

  RxString currentFile = "".obs;

  TextEditingController copy1 = TextEditingController();
  TextEditingController copy2 = TextEditingController();
  TextEditingController copy3 = TextEditingController();

  RxBool isExtFlash = false.obs;

  @override
  void onInit() {
    super.onInit();

    KBLEManager.onDfuStart.listen((event) {
      HWToast.showText(text: "onDfuStart");
    });
    KBLEManager.onDfuError.listen((event) {
      HWToast.showText(text: "onDfuError $event");
    });
    KBLEManager.onDfuProgress.listen((event) {
      HWToast.showText(text: "onDfuProgress $event");
    });
    KBLEManager.onDfuComplete.listen((event) {
      HWToast.showText(text: "onDfuComplete");
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void onChange(bool state) {
    isExtFlash.value = state;
  }

  void openFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result == null) {
      return;
    }

    vmPrint("openFile " + result.toString());

    // File cahe = await getAppFile();
    // var fileNmae = result.names.toList();
    // cahe = File('${cahe.absolute.path}/$fileNmae');
    // final file = result.files.first;
    // final fileReadStream = file.readStream;
    // if (fileReadStream == null) {
    //   throw Exception('Cannot read file from null stream');
    // }

    // var bytes = await fileReadStream.first;
    // var a = await cahe.writeAsBytes(bytes);
    currentFile.value = result.paths.first ?? "";
    vmPrint("saveToPath a $currentFile");
  }

  void normalDFU() {
    if (currentFile.isEmpty) {
      HWToast.showText(text: "先选择一个文件");
      return;
    }
    RingDevice de = Get.arguments;
    KBLEManager.getDevice(device: de).startDfu(filePath: currentFile.value);
  }

  void copyDFU() {
    if (currentFile.isEmpty) {
      HWToast.showText(text: "先选择一个文件");
      return;
    }
    var text = copy1.text;
    if (text.isEmpty) {
      HWToast.showText(text: "输入拷贝地址");
      return;
    }

    RingDevice de = Get.arguments;
    KBLEManager.getDevice(device: de).startCopyDfu(
        filePath: currentFile.value, copyAdd: int.parse(text, radix: 16));
  }

  void fastDFU() {
    if (currentFile.isEmpty) {
      HWToast.showText(text: "先选择一个文件");
      return;
    }
    RingDevice de = Get.arguments;

    try {
      KBLEManager.getDevice(device: de).fastDfu(filePath: currentFile.value);
    } catch (e) {
      HWToast.showText(text: e.toString());
    }
  }

  void fastCopyDFU() {
    if (currentFile.isEmpty) {
      HWToast.showText(text: "先选择一个文件");
      return;
    }
    var text = copy2.text;
    if (text.isEmpty) {
      HWToast.showText(text: "输入拷贝地址");
      return;
    }

    RingDevice de = Get.arguments;
    try {
      KBLEManager.getDevice(device: de).fastCopyDfu(
          filePath: currentFile.value, copyAdd: int.parse(text, radix: 16));
    } catch (e) {
      HWToast.showText(text: e.toString());
    }
  }

  void fastDFUResource() {
    if (currentFile.isEmpty) {
      HWToast.showText(text: "先选择一个文件");
      return;
    }
    var text = copy3.text;
    if (text.isEmpty) {
      HWToast.showText(text: "输入资源地址");
      return;
    }

    RingDevice de = Get.arguments;

    try {
      KBLEManager.getDevice(device: de).fastDFUResource(
        filePath: currentFile.value,
        toAddr: int.parse(text, radix: 16),
        toExtFlash: isExtFlash.value,
      );
    } catch (e) {
      HWToast.showText(text: e.toString());
    }
  }
}
