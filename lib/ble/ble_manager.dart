import 'dart:async';
import 'dart:io';
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
  static StreamSubscription? _notifySubscription,
      _mtuSubscripation,
      _connectSubscription;
  static List<int> _allValues = []; //接收缓存数据
  static List<List<int>> _cacheSendData = []; //缓存发送的数据集合
  static ScanResult? scDevice;

  static final _receiveController =
      StreamController<ReceiveDataModel>.broadcast();
  static final _deviceStateSC =
      StreamController<BluetoothConnectionState>.broadcast();

  static final logController = StreamController<String>.broadcast();
  static KBLECommandListenerType listenerType = KBLECommandListenerType.connect;

  static clean() {
    _allValues.clear();
    _notifySubscription?.cancel();
    _notifySubscription = null;
    _mtuSubscripation?.cancel();
    _mtuSubscripation = null;
    _notifyCharacteristic = null;
    _writeCharacteristic = null;
    scDevice = null;
    _connectSubscription?.cancel();
    _connectSubscription = null;
    _cacheSendData.clear();
    listenerType = KBLECommandListenerType.connect;
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
    if ((await isAvailableBLE()) == false) {
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
      {required ScanResult scanResult,
      Duration timeout = const Duration(seconds: 8)}) async {
    if ((await isAvailableBLE()) == false) {
      return null;
    }

    clean();
    scanResult.device.connect(timeout: timeout);
    await Future.delayed(Duration(seconds: 1));
    _connectSubscription?.cancel();
    _connectSubscription == null;
    _connectSubscription =
        scanResult.device.connectionState.listen((event) async {
      vmPrint("connectionState $event", KBLEManager.logevel);
      _deviceStateSC.sink.add(event);
      if (event == BluetoothConnectionState.connected) {
        scDevice = scanResult;
        findCharacteristics(scanResult.device);
        await Future.delayed(Duration(seconds: 1));
        stopScan();
      } else if (event == BluetoothConnectionState.disconnected) {
        clean();
      }
// KBLEManager.stopScan();
    });
  }

  static Future disconnectedAllBle() async {
    List<BluetoothDevice> devices =
        await FlutterBluePlus.connectedSystemDevices;
    devices.forEach((element) async {
      await element.disconnect();
    });
    //断开设备补发断开指令
    _deviceStateSC.sink.add(BluetoothConnectionState.disconnected);
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
              onValueReceived(event);
            });
          } else if (compareUUID(
                  characteristic.uuid.toString(), BLEConfig.WRITEUUID) ==
              true) {
            _writeCharacteristic = characteristic;
            String currentDeviceMac =
                SPManager.getGlobalUser()?.currentDeviceMac ?? "";
            if (currentDeviceMac.isNotEmpty) {
              KBLEManager.sendData(sendData: KBLESerialization.timeSetting());
            } else {
              KBLEManager.sendData(
                  sendData: KBLESerialization.bindingsverify());
            }
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
// if (_writeCharacteristic == null) {
//   return;
// }
    vmPrint("发送数据 ${HEX.encode(datas)}", logevel);
    try {
      await _writeCharacteristic?.write(datas, withoutResponse: true);
    } catch (e) {
      vmPrint("发送数据e $e", logevel);
      if (e.toString().contains("device is disconnected")) {
        _deviceStateSC.sink.add(BluetoothConnectionState.disconnected);
      }
    }
  }

  static void onValueReceived(List<int> values) {
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

  static Future<bool> isAvailableBLE() async {
    FlutterBluePlus.setLogLevel(LogLevel.debug);

    await Future.delayed(Duration(seconds: 1));

    while ((await FlutterBluePlus.isAvailable) == false) {
      vmPrint("a");
      await Future.delayed(const Duration(seconds: 2));
    }

// if ((await FlutterBluePlus.adapterState.last) ==
//     BluetoothAdapterState.turningOff) {
//   HWToast.showErrText(text: "turnon_ble".tr);
//   return false;
// }

    bool a = await PermissionUtils.checkBle();
    if (a == true) {
      return true;
    }

    bool isok = await PermissionUtils.requestBle();
    await Future.delayed(Duration(milliseconds: 500));
    return await PermissionUtils.checkBle();
  }
}
