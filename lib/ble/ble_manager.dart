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

    // _onValueReceived(HEXUtil.decode("eeee0003010000"));
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
