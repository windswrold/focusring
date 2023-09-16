import 'package:beering/app/data/health_data.dart';
import 'package:beering/ble/ble_config.dart';
import 'package:beering/ble/ble_manager.dart';
import 'package:beering/ble/bledata_serialization.dart';
import 'package:beering/net/app_api.dart';
import 'package:beering/utils/hex_util.dart';

import '../public.dart';

class ReceiveDataModel {
  final bool status;
  final KBLECommandType command;
  final String tip;
  final dynamic value;

  ReceiveDataModel(
      {required this.status,
      required this.command,
      required this.tip,
      this.value});

  @override
  String toString() {
    // TODO: implement toString
    return "收到的数据 status $status command $command tip $tip value $value";
  }
}

class ReceiveDataHandler {
  static List<int> _cachePPGData = [];
  static int _maxDay = 0;
  static int _currentDay = 0;

  static ReceiveDataModel parseDataHandler(List<int> _allDatas) {
    //解析收到的数据

    vmPrint("一个完整的数据 ${HEXUtil.encode(_allDatas)}", KBLEManager.logevel);
    //取出头
    int cmd = _allDatas[4];
    int type = _allDatas[5];
    vmPrint("cmd $cmd type $type", KBLEManager.logevel);
    List<int> valueData = _allDatas.sublist(6);
    vmPrint("valueData ${HEXUtil.encode(valueData)}", KBLEManager.logevel);
    ReceiveDataModel? model;
    if (cmd == 0x01) {
      model = _parseCMD_01(valueData, type: type);
    } else if (cmd == 0x02) {
      model = _parseCMD_02(valueData, type: type);
    } else if (cmd == 0x03) {
      model = _parseCMD_03(valueData, type: type);
    } else if (cmd == 0x04) {
      model = _parseCMD_04(valueData, type: type);
    } else if (cmd == 0x05) {
      model = _parseCMD_05(valueData, type: type);
    } else if (cmd == 0x06) {
      model = _parseCMD_06(valueData, type: type);
    } else if (cmd == 0x07) {
      model = _parseCMD_07(valueData, type: type);
    }
    vmPrint("经过解析后的数据 ${model.toString()}}", KBLEManager.logevel);
    if (model == null) {
      throw "command not null";
    }
    return model;
  }

  //绑定认证
  static ReceiveDataModel _parseCMD_01(List<int> valueData,
      {required int? type}) {
    vmPrint("绑定认证", KBLEManager.logevel);
    String tip = "";
    bool status = false;
    KBLECommandType com = KBLECommandType.bindingsverify;
    if (valueData[0] == 0x01) {
      status = false;
      tip = "拒绝绑定";
    } else {
      status = true;
      tip = "成功绑定";

      KBLEManager.sendData(sendData: KBLESerialization.timeSetting());
      bindDeviceStream();
    }
    vmPrint(tip, KBLEManager.logevel);
    return ReceiveDataModel(status: status, tip: tip, command: com);
  }

  ///系统
  static ReceiveDataModel _parseCMD_02(List<int> valueData,
      {required int? type}) {
    KBLECommandType com = KBLECommandType.system;
    bool status = false;
    String tip = "";
    if (type == 0x00) {
      status = true;
      tip = "时间设置成功";
      KBLEManager.sendData(sendData: KBLESerialization.getBattery());
    }
    vmPrint("时间设置成功", KBLEManager.logevel);
    return ReceiveDataModel(status: status, tip: tip, command: com);
  }

  ///ppg 心率 血氧
  static ReceiveDataModel _parseCMD_03(List<int> valueData,
      {required int? type}) {
    KBLECommandType com = KBLECommandType.ppg;
    bool status = false;
    String tip = "";
    dynamic value;
    vmPrint("ppg", KBLEManager.logevel);
    if (type == 0x00 || type == 0x05) {
      if (valueData[0] == 0x01) {
        tip = "设备接受单次测量，正在测量中";
      } else if (valueData[0] == 0x02) {
        tip = "设备已经在单次测量中";
      } else if (valueData[0] == 0x03) {
        tip = "设备在定时测量中，还没有出值";
      } else if (valueData[0] == 0x04) {
        tip = "设备在定时测量中已经出值测量还未结束";
      } else if (valueData[0] == 0x05) {
        if (type == 0x00) {
          if (valueData[1] == 0x01) {
            tip = "其它错误";
          } else if (valueData[1] == 0x02) {
            tip = "心率通信失败";
          } else if (valueData[1] == 0x03) {
            tip = "心率中断不来";
          } else if (valueData[1] == 0x04) {
            tip = "设备没有佩戴";
          }
        } else {
          if (valueData[1] == 0x01) {
            tip = "其它错误";
          } else if (valueData[1] == 0x02) {
            tip = "血氧通信失败";
          } else if (valueData[1] == 0x03) {
            tip = "血氧中断不来";
          } else if (valueData[1] == 0x04) {
            tip = "设备没有佩戴";
          }
        }
      } else if (valueData[0] == 0x06) {
        status = true;
        tip = "获取成功";
        value = valueData[1];
      }
    } else if (type == 0x01 || type == 0x06) {
      vmPrint("心率定时测量设置");
      status = true;
      tip = "设备回复设置成功";
    } else if (type == 0x02 || type == 0x07) {
      if (valueData[0] == 0x00) {
        vmPrint("不打开");
        status = false;
      } else {
        status = true;
      }
      tip = "心率定时测量设置成功";
    } else if (type == 0x03 || type == 0x08) {
      KHealthDataType datatype = type == 0x03
          ? KHealthDataType.HEART_RATE
          : KHealthDataType.BLOOD_OXYGEN;

      if (valueData[0] == 0xaa) {
        value = valueData[1];
        vmPrint("回答天数 $value", KBLEManager.logevel);
        _maxDay = value;
        _currentDay = 0;
        KBLEManager.sendData(
            sendData: KBLESerialization.getHistoryDataWithType(
                type: datatype, index: _currentDay));
      } else if (valueData[0] == 0xbb) {
        _parseDataHistoryData(datatype, valueData);
      }
    } else if (type == 0x04 || type == 0x09) {
      KHealthDataType datatype = type == 0x04
          ? KHealthDataType.HEART_RATE
          : KHealthDataType.BLOOD_OXYGEN;
      //当天数据
      if (valueData[0] == 0xbb) {
        _parseDataCurrentDayData(datatype, valueData);
      }
    }
    return ReceiveDataModel(
        status: status, tip: tip, command: com, value: value);
  }

  ///步数
  static ReceiveDataModel _parseCMD_04(List<int> valueData,
      {required int? type}) {
    KBLECommandType com = KBLECommandType.gsensor;
    bool status = true;
    String tip = "";
    dynamic value;
    if (type == 0x03) {
      if (valueData[0] == 0xaa) {
        value = valueData[1];
        vmPrint("回答天数 $value", KBLEManager.logevel);
        _maxDay = value;
        _currentDay = 0;
        KBLEManager.sendData(
            sendData: KBLESerialization.getHistoryDataWithType(
                type: KHealthDataType.STEPS, index: _currentDay));
      } else if (valueData[0] == 0xbb) {
        _parseDataHistoryData(KHealthDataType.STEPS, valueData);
      }
    }
    return ReceiveDataModel(status: status, tip: tip, command: com);
  }

  ///睡眠
  static ReceiveDataModel _parseCMD_05(List<int> valueData,
      {required int? type}) {
    KBLECommandType com = KBLECommandType.system;
    bool status = false;
    String tip = "";
    dynamic value;
    if (type == 0x01) {
      if (valueData[0] == 0xaa) {
        value = valueData[1];
        vmPrint("回答天数 $value", KBLEManager.logevel);
        _maxDay = value;
        _currentDay = 0;
        KBLEManager.sendData(
            sendData: KBLESerialization.getHistoryDataWithType(
                type: KHealthDataType.SLEEP, index: _currentDay));
      } else if (valueData[0] == 0xbb) {
        _parseDataHistoryData(KHealthDataType.SLEEP, valueData);
      }
    }
    return ReceiveDataModel(status: status, tip: tip, command: com);
  }

  ///电量
  static ReceiveDataModel _parseCMD_06(List<int> valueData,
      {required int? type}) {
    KBLECommandType com = KBLECommandType.battery;
    bool status = true;
    dynamic value = valueData[0];
    String tip = "";
    KBLEManager.sendData(sendData: KBLESerialization.getCharger());
    return ReceiveDataModel(
        status: status, tip: tip, command: com, value: value);
  }

  ///充电
  static ReceiveDataModel _parseCMD_07(List<int> valueData,
      {required int? type}) {
    KBLECommandType com = KBLECommandType.charger;
    bool status = true;
    dynamic value = valueData[0];
    String tip = "";
    if (value == 0x00) {
      status = false;
      tip = "未充电";
    } else if (value == 0x01) {
      status = true;
      tip = "充电中";
    } else {
      status = true;
      tip = "充满";
    }

    KBLEManager.sendData(
        sendData: KBLESerialization.getDayNumWithType(
            type: KHealthDataType.HEART_RATE));

    return ReceiveDataModel(
        status: status, tip: tip, command: com, value: value);
  }

  static void bindDeviceStream() {
    String a = KBLEManager.currentDevices?.macAddress ?? "";
    if (a.isEmpty) {
      return;
    }
    AppApi.bindDeviceStream(mac: a).onSuccess((value) {
      SPManager.setBindDevice();
    });
  }

  static void _parseDataHistoryData(
    KHealthDataType datatype,
    List<int> valueData,
  ) {
    int all = valueData[1];
    int current = valueData[2];
    _cachePPGData.addAll(valueData.sublist(3)); //包含时间

    if (datatype == KHealthDataType.STEPS) {
      KBLEManager.sendData(
        sendData:
            KBLESerialization.getStepsHistoryDataByCurrentByIndex(current),
      );
    } else if (datatype == KHealthDataType.BLOOD_OXYGEN ||
        datatype == KHealthDataType.HEART_RATE) {
      //心率或者血氧
      KBLEManager.sendData(
          sendData: KBLESerialization.getHeartHistoryDataByCurrentByIndex(
              current,
              isHeart: datatype));
    } else if (datatype == KHealthDataType.SLEEP) {
      //睡眠
      KBLEManager.sendData(
          sendData:
              KBLESerialization.getSleepHistoryDataByCurrentByIndex(current));
    }

    if (all == current) {
      vmPrint("一个包结束了，接收完毕", KBLEManager.logevel);
      //存
      HealthData.insertHealthBleData(
          datas: List.from(_cachePPGData), isContainTime: true, type: datatype);
      _cachePPGData.clear();
      _maxDay = _maxDay - 1;
      _currentDay = _currentDay + 1;

      if (_maxDay <= 0) {
        //发下一个
        if (datatype == KHealthDataType.HEART_RATE) {
          vmPrint("发送血氧", KBLEManager.logevel);
          KBLEManager.sendData(
              sendData: KBLESerialization.getDayNumWithType(
                  type: KHealthDataType.BLOOD_OXYGEN));
        } else if (datatype == KHealthDataType.BLOOD_OXYGEN) {
          vmPrint("发送步数", KBLEManager.logevel);
          KBLEManager.sendData(
              sendData: KBLESerialization.getDayNumWithType(
                  type: KHealthDataType.STEPS));
        } else if (datatype == KHealthDataType.STEPS) {
          vmPrint("发送睡眠", KBLEManager.logevel);
          KBLEManager.sendData(
              sendData: KBLESerialization.getDayNumWithType(
                  type: KHealthDataType.SLEEP));
        }
      } else if (_maxDay >= 1) {
        //请求昨天的数据

        KBLEManager.sendData(
            sendData: KBLESerialization.getHistoryDataWithType(
                type: datatype, index: _currentDay));
      }
    }
  }

  static void _parseDataCurrentDayData(
    KHealthDataType datatype,
    List<int> valueData,
  ) {
    //   int all = valueData[1];
    //   int current = valueData[2];
    //   status = true;
    //   if (all == current) {
    //   } else {}
    //   KBLEManager.sendData(
    //       sendData: KBLESerialization.getHeartHistoryDataByCurrentByIndex(
    //     current,
    //     isHeart: type == 0x04
    //         ? KHealthDataType.HEART_RATE
    //         : KHealthDataType.BLOOD_OXYGEN,
    //   ));
    //   HealthData.insertHealthBleData(
    //       datas: valueData.sublist(3),
    //       isContainTime: false,
    //       type: type == 0x04
    //           ? KHealthDataType.HEART_RATE
    //           : KHealthDataType.BLOOD_OXYGEN);
  }
}
