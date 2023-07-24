import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:focusring/app/data/ring_device.dart';
import 'package:focusring/utils/ble_manager.dart';
import 'package:get/get.dart';

import '../../../../public.dart';

class TestdfuController extends GetxController {
  //TODO: Implement TestdfuController

  RxString currentFile = "".obs;

  TextEditingController textEditingController = TextEditingController();
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void openFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result == null) {
      return;
    }
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
    currentFile.value = result.paths.first??"";
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
    var text = textEditingController.text;
    if (text.isEmpty) {
      return;
    }

    RingDevice de = Get.arguments;
    KBLEManager.getDevice(device: de)
        .startCopyDfu(filePath: currentFile.value, copyAdd: int.parse(text));
  }
}
