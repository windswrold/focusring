import 'dart:async';

import 'package:beering/ble/receivedata_handler.dart';
import 'package:beering/extensions/StringEx.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:beering/app/data/ring_device.dart';
import 'package:beering/ble/ble_config.dart';
import 'package:beering/public.dart';
import 'package:beering/utils/hex_util.dart';
import 'package:beering/utils/permission.dart';
import 'package:hex/hex.dart';

class KBLEManager {
  static BluetoothCharacteristic? _writeCharacteristic; //写入特征
  static BluetoothCharacteristic? _notifyCharacteristic; //通知特征
  static BluetoothDevice? _mBluetoothDevice; //记录当前链接的蓝牙
  static StreamSubscription? _notifySubscription, _mtuSubscripation;
  static List<int> _allValues = []; //接收缓存数据

  static BluetoothDevice? _currentDevice;

  static Stream<String> get receiveDataStream => _receiveController.stream;
  static final _receiveController = StreamController<String>.broadcast();

  static clean() {
    _allValues.clear();
    _notifySubscription?.cancel();
    _mtuSubscripation?.cancel();
    _notifyCharacteristic = null;
    _writeCharacteristic = null;
    _mBluetoothDevice = null;
  }

  static Stream<List<ScanResult>> get scanResults {
    return FlutterBluePlus.scanResults;
  }

  static Stream<bool> get isScanning {
    return FlutterBluePlus.isScanning;
  }

  static Stream<void> get onDfuStart {
    return FlutterBluePlus.onDfuStart;
  }

  static Stream<String> get onDfuProgress {
    return FlutterBluePlus.onDfuProgress;
  }

  static Stream<String> get onDfuError {
    return FlutterBluePlus.onDfuError;
  }

  static Stream<void> get onDfuComplete {
    return FlutterBluePlus.onDfuComplete;
  }

  static void startScan(
      {Duration timeout = const Duration(seconds: 10)}) async {
    if ((await checkBle()) == false) {
      return;
    }

    if (FlutterBluePlus.isScanningNow) {
      return;
    }

    await FlutterBluePlus.startScan(timeout: timeout);
  }

  static void stopScan() {
    FlutterBluePlus.stopScan();
  }

  static Future<Stream<BluetoothConnectionState>?> connect(
      {required RingDeviceModel device,
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
            await characteristic.setNotifyValue(true);
            _notifySubscription =
                characteristic.onValueReceived.listen((event) {
              _onValueReceived(event);
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
    required BLESendData sendData,
  }) async {
    final datas = sendData.getData();
    zhiie(datas: datas);
  }

  static void zhiie({
    required List<int> datas,
  }) async {
    if (_writeCharacteristic == null) {
      return;
    }

    _receiveController.add("准备发送数据 ${HEX.encode(datas)}");
    await _writeCharacteristic?.write(datas, withoutResponse: true);
  }

  static void _onValueReceived(List<int> values) {
    final a = HEXUtil.encode(values);
    _receiveController.add("接收的数据: $a");
    _allValues.addAll(values);

    vmPrint("接收到结果 是${HEXUtil.encode(values)}");
    vmPrint("接收到结果 长度是${values.length}");
    final first = HEXUtil.encode(_allValues);
    if (first.startsWith(BLEConfig.ringSlave)) {
      bool isLoop = true;
      while (isLoop && _allValues.length > 4) {
        int len = (_allValues[2] << 8) | _allValues[3];
        int currentLen = len + 2;
        vmPrint("数据域长度 len $currentLen");
        vmPrint("当前总长度_allValues ${_allValues.length}");
        if (_allValues.length >= currentLen) {
          //取出后移除
          List<int> _allDatas = _allValues.sublist(0, currentLen);
          _allValues.removeRange(0, currentLen);
          ReceiveDataHandler.parseDataHandler(_allDatas);
        } else {
          isLoop = false;
        }
      }
    } else {}
  }

  static BluetoothDevice getDevice({
    required RingDeviceModel device,
  }) {
    var bleDevice = BluetoothDevice.fromId(device.remoteId!);
    return bleDevice;
  }

  static Future<bool> checkBle() async {
    while ((await FlutterBluePlus.isAvailable) == false) {
      vmPrint("a");
      await Future.delayed(const Duration(seconds: 2));
    }

    if ((await FlutterBluePlus.adapterState.first) ==
        BluetoothAdapterState.turningOff) {
      HWToast.showErrText(text: "turnon_ble".tr);
      return false;
    }

    bool a = await PermissionUtils.checkBle();
    if (a == true) {
      return true;
    }
    final b = await PermissionUtils.showBleDialog();
    if (b == false) {
      HWToast.showErrText(text: "permission_err".tr);
      return false;
    }
    return PermissionUtils.requestBle();
  }
}
