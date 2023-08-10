import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:focusring/app/data/ring_device.dart';
import 'package:focusring/ble/ble_config.dart';
import 'package:focusring/public.dart';
import 'package:focusring/utils/permission.dart';
import 'package:hex/hex.dart';

class KBLEManager {
  static late FlutterBluePlus flutterBlue = FlutterBluePlus.instance;

  static BluetoothCharacteristic? _writeCharacteristic; //写入特征
  static BluetoothCharacteristic? _notifyCharacteristic; //通知特征
  static BluetoothDevice? _mBluetoothDevice; //记录当前链接的蓝牙
  static StreamSubscription? _notifySubscription, _mtuSubscripation;
  static List<int> _allValues = []; //接收缓存数据

  // static Stream<List<int>> get receiveDataStream =>
  //     _nameController.stream.asBroadcastStream();
  // static final _nameController = StreamController<List<int>>();

  static clean() {
    _allValues.clear();
    _notifySubscription?.cancel();
    _mtuSubscripation?.cancel();
    _notifyCharacteristic = null;
    _writeCharacteristic = null;
    _mBluetoothDevice = null;
  }

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

  static void stopScan() {
    flutterBlue.stopScan();
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

  ///发现外设
  static void findCharacteristics(BluetoothDevice bluetoothDevice) async {
    vmPrint("开始找特征 _findCharacteristics");
    List<BluetoothService> services = await bluetoothDevice.discoverServices();
    for (var service in services) {
      //读取服务ID
      vmPrint("服务ID ${service.uuid}");
      HWToast.showSucText(text: "服务ID ${service.uuid}");
      await Future.delayed(Duration(milliseconds: 500));

      if (compareUUID(service.uuid.toString(), BLEConfig.SERVICEUUID) == true) {
        List<BluetoothCharacteristic> characteristics = service.characteristics;
        for (BluetoothCharacteristic characteristic in characteristics) {
          vmPrint("当前id ${characteristic.uuid}");
          HWToast.showSucText(text: "特征id ${characteristic.uuid}");
          await Future.delayed(Duration(milliseconds: 500));
          //读取外设ID
          if (compareUUID(
                  characteristic.uuid.toString(), BLEConfig.NOTIFYUUID) ==
              true) {
            vmPrint("记录通知");
            vmPrint("找到NOTIFYUUID");
            HWToast.showSucText(text: "找到NOTIFYUUID");
            await Future.delayed(Duration(milliseconds: 500));
            _notifyCharacteristic = characteristic;
            characteristic.setNotifyValue(true);
            _notifySubscription =
                characteristic.onValueReceived.listen((event) {
              onValueReceived(event);
            });
          } else if (compareUUID(
                  characteristic.uuid.toString(), BLEConfig.WRITEUUID) ==
              true) {
            vmPrint("记录写");
            HWToast.showSucText(text: "找到WRITEUUID");
            _writeCharacteristic = characteristic;
            await Future.delayed(Duration(milliseconds: 500));
          }
        }
      }
      await Future.delayed(Duration(milliseconds: 500));
    }
  }

  static void sendData({
    required List<int> values,
  }) async {
    vmPrint("len ${values.length} sendData ${HEX.encode(values)}");

    if (_writeCharacteristic == null) {
      return;
    }
    HWToast.showSucText(text: "准备发送数据 ${HEX.encode(values)}");
    await _writeCharacteristic?.write(values, withoutResponse: true);
  }

  static void onValueReceived(List<int> values) {
    final a = HEX.encode(values);
    HWToast.showSucText(text: "收到的数据 $a");
  }

  static BluetoothDevice getDevice({
    required RingDevice device,
  }) {
    var bleDevice = BluetoothDevice.fromId(device.remoteId!);
    return bleDevice;
  }

  static Future<bool> checkBle() async {
    bool a = await PermissionUtils.checkBle();
    if (a == false) {
      HWToast.showErrText(text: "permission_err".tr);
      return false;
    }

    while ((await flutterBlue.isAvailable) == false) {
      vmPrint("a");
      await Future.delayed(const Duration(seconds: 2));
    }

    if ((await flutterBlue.isOn) == false) {
      HWToast.showErrText(text: "turnon_ble".tr);
      return false;
    }

    return true;
  }
}
