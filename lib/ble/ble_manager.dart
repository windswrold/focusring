import 'dart:async';
import 'dart:ffi';

import 'package:beering/ble/bledata_serialization.dart';
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
  static int logevel = 999;
  static BluetoothCharacteristic? _writeCharacteristic; //写入特征
  static BluetoothCharacteristic? _notifyCharacteristic; //通知特征
  static BluetoothDevice? _mBluetoothDevice; //记录当前链接的蓝牙
  static StreamSubscription? _notifySubscription,
      _mtuSubscripation,
      _connectSubscription;
  static List<int> _allValues = []; //接收缓存数据
  static List<List<int>> _cacheSendData = []; //缓存发送的数据集合
  static BluetoothDevice? _currentDevice;

  static final _receiveController =
      StreamController<ReceiveDataModel>.broadcast();
  static final _deviceStateSC =
      StreamController<BluetoothConnectionState>.broadcast();

  static final logController = StreamController<String>.broadcast();

  static clean() {
    _allValues.clear();
    _notifySubscription?.cancel();
    _mtuSubscripation?.cancel();
    _notifyCharacteristic = null;
    _writeCharacteristic = null;
    _mBluetoothDevice = null;
    _connectSubscription?.cancel();
    _cacheSendData.clear();
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

  static Stream<ReceiveDataModel> get receiveDataStream {
    return _receiveController.stream;
  }

  static Stream<BluetoothConnectionState> get deviceStateStream {
    return _deviceStateSC.stream;
  }

  static void startScan(
      {Duration timeout = const Duration(seconds: 10)}) async {
    if (inProduction) {
      _onValueReceived(HEXUtil.decode(
          "eeee00690403bb0101e70709060000000064000000c80000002c01000090010000f401000058020000bc0200002003000084030000e80300004c040000b00400001405000078050000dc05000040060000a4060000080700006c070000d00700003408000098080000fc080000"));

      return;
    }

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

  static void connect(
      {required RingDeviceModel device,
      Duration timeout = const Duration(seconds: 20)}) async {
    if ((await checkBle()) == false) {
      return null;
    }

    // _onValueReceived(HEXUtil.decode("eeee00f00308bb0201e7070906000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f202122232425262728292a2b2c2d2e2f303132333435363738393a3b3c3d3e3f404142434445464748494a4b4c4d4e4f505152535455565758595a5b5c5d5e5f606162636465666768696a6b6c6d6e6f707172737475767778797a7b7c7d7e7f808182838485868788898a8b8c8d8e8f909192939495969798999a9b9c9d9e9fa0a1a2a3a4a5a6a7a8a9aaabacadaeafb0b1b2b3b4b5b6b7b8b9babbbcbdbebfc0c1c2c3c4c5c6c7c8c9cacbcccdcecfd0d1d2d3d4d5d6d7d8d9dadbdcdddedfe0e1e2e3e4e5e6eeee003e0308bb0202e7e8e9eaebecedeeeff0f1f2f3f4f5f6f7f8f9fafbfcfdfeff000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f"));
    // return;
    // _onValueReceived(HEXUtil.decode("eeee0003020000"));
    // _onValueReceived(HEXUtil.decode(
    //     "eeee00690403bb0101e707090500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"));

    // return;
    // if ((await deviceStateStream.first) ==
    //     BluetoothConnectionState.connecting) {
    //   HWToast.showErrText(text: "connecting");
    //   return;
    // }

    // final dats = await FlutterBluePlus.connectedSystemDevices;
    // dats.forEach((element) {
    //   element.disconnect();
    // });

    var bleDevice = getDevice(device: device);
    bleDevice.connect(timeout: timeout);
    await Future.delayed(Duration(seconds: 1));
    _connectSubscription = bleDevice.connectionState.listen((event) {
      vmPrint("connectionState $event");
      _deviceStateSC.sink.add(event);
      if (event == BluetoothConnectionState.connected) {
        findCharacteristics(bleDevice);
      } else if (event == BluetoothConnectionState.disconnected) {
        clean();
      }
      // KBLEManager.stopScan();
    });
  }

  Future disconnectedAllBle() async {
    List<BluetoothDevice> devices =
        await FlutterBluePlus.connectedSystemDevices;
    devices.forEach((element) {
      element.disconnect();
    });
  }

  ///发现外设
  static void findCharacteristics(BluetoothDevice bluetoothDevice) async {
    vmPrint("开始找特征", logevel);
    List<BluetoothService> services = await bluetoothDevice.discoverServices();
    for (var service in services) {
      //读取服务ID
      vmPrint("服务ID ${service.uuid}", logevel);
      if (compareUUID(service.uuid.toString(), BLEConfig.SERVICEUUID) == true) {
        List<BluetoothCharacteristic> characteristics = service.characteristics;
        for (BluetoothCharacteristic characteristic in characteristics) {
          vmPrint("当前id ${characteristic.uuid}", logevel);
          //读取外设ID
          if (compareUUID(
                  characteristic.uuid.toString(), BLEConfig.NOTIFYUUID) ==
              true) {
            _notifyCharacteristic = characteristic;
            await characteristic.setNotifyValue(true);
            _notifySubscription =
                characteristic.onValueReceived.listen((event) {
              _onValueReceived(event);
            });
          } else if (compareUUID(
                  characteristic.uuid.toString(), BLEConfig.WRITEUUID) ==
              true) {
            _writeCharacteristic = characteristic;
            KBLEManager.sendData(sendData: KBLESerialization.bindingsverify());
          }
        }
      }
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
    vmPrint("发送数据 ${HEX.encode(datas)}", logevel);
    await _writeCharacteristic?.write(datas, withoutResponse: true);
  }

  static void _onValueReceived(List<int> values) {
    final a = HEXUtil.encode(values);
    _allValues.addAll(values);
    vmPrint("接收到结果是 ${HEXUtil.encode(values)} len ${values.length} ", logevel);
    vmPrint("合并的总数据 ${HEXUtil.encode(_allValues)} len ${_allValues.length}",
        logevel);
    final first = HEXUtil.encode(_allValues);
    if (first.startsWith(BLEConfig.ringSlave)) {
      bool isLoop = true;
      while (isLoop && _allValues.length > 4) {
        int len = (_allValues[2] << 8) | _allValues[3];
        int currentLen = len + 4;
        vmPrint("数据域长度 len $currentLen", logevel);
        if (_allValues.length >= currentLen) {
          //取出后移除
          List<int> _allDatas = _allValues.sublist(0, currentLen);
          _allValues.removeRange(0, currentLen);
          ReceiveDataModel model =
              ReceiveDataHandler.parseDataHandler(_allDatas);
          _receiveController.add(model);
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
    bool a = await PermissionUtils.checkBle();
    if (a == false) {
      HWToast.showErrText(text: "permission_err".tr);
      return false;
    }

    while ((await FlutterBluePlus.isAvailable) == false) {
      vmPrint("a");
      await Future.delayed(const Duration(seconds: 2));
    }

    if ((await FlutterBluePlus.adapterState.first) ==
        BluetoothAdapterState.turningOff) {
      HWToast.showErrText(text: "turnon_ble".tr);
      return false;
    }

    return true;
  }
}
