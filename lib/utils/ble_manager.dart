import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:focusring/app/data/ring_device.dart';
import 'package:focusring/public.dart';
import 'package:focusring/utils/permission.dart';

class KBLEManager {
  static late FlutterBluePlus flutterBlue = FlutterBluePlus.instance;

  static Stream<List<ScanResult>> get scanResults {
    return flutterBlue.scanResults;
  }

  static Stream<bool> get isScanning {
    return flutterBlue.isScanning;
  }

  static Stream<void> get onDfuStart {
    return flutterBlue.onDfuStart;
  }

  static Stream<String> get onDfuProgress {
    return flutterBlue.onDfuProgress;
  }

  static Stream<String> get onDfuError {
    return flutterBlue.onDfuError;
  }

  static Stream<void> get onDfuComplete {
    return flutterBlue.onDfuComplete;
  }

  static void startScan(
      {Duration timeout = const Duration(seconds: 10)}) async {
    if ((await checkBle()) == false) {
      return;
    }

    if (flutterBlue.isScanningNow) {
      return;
    }

    await flutterBlue.startScan(timeout: timeout);
  }

  static Future<Stream<BluetoothConnectionState>?> connect(
      {required RingDevice device,
      Duration timeout = const Duration(seconds: 20)}) async {
    if ((await checkBle()) == false) {
      return null;
    }

    var bleDevice = getDevice(device: device);
    bleDevice.connect(timeout: timeout);
    return bleDevice.connectionState;
  }

  static BluetoothDevice getDevice({
    required RingDevice device,
  }) {
    var bleDevice = BluetoothDevice.fromId(device.remoteId!);
    return bleDevice;
  }

  static void stopScan() {
    flutterBlue.stopScan();
  }

  static Future<bool> checkBle() async {
    bool a = await PermissionUtils.checkBle();
    if (a == false) {
      HWToast.showSucText(text: "permission_err".tr);
      return false;
    }

    while ((await flutterBlue.isAvailable) == false) {
      vmPrint("a");
      await Future.delayed(const Duration(seconds: 2));
    }

    if ((await flutterBlue.isOn) == false) {
      HWToast.showSucText(text: "turnon_ble".tr);
      return false;
    }

    return true;
  }
}
