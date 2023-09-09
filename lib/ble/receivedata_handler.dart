import 'package:beering/app/data/health_data.dart';
import 'package:beering/ble/ble_config.dart';
import 'package:beering/ble/ble_manager.dart';
import 'package:beering/ble/bledata_serialization.dart';
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
  static List<int> _cacheData = [];

  static ReceiveDataModel parseDataHandler(List<int> _allDatas) {
    //解析收到的数据
    String tip = "";
    bool status = false;
    dynamic value;

    KBLECommandType? com;
    vmPrint("一个完整的数据 ${HEXUtil.encode(_allDatas)}", KBLEManager.logevel);
    //取出头
    int cmd = _allDatas[4];
    int type = _allDatas[5];
    vmPrint("cmd $cmd type $type", KBLEManager.logevel);
    List<int> valueData = _allDatas.sublist(6);
    vmPrint("valueData ${HEXUtil.encode(valueData)}", KBLEManager.logevel);
    if (cmd == 0x01) {
      return _parseCMD_01(valueData, type: type);
    } else if (cmd == 0x02) {
      return _parseCMD_02(valueData, type: type);
    } else if (cmd == 0x03) {
      return _parseCMD_03(valueData, type: type);
    } else if (cmd == 0x04) {
      return _parseCMD_04(valueData, type: type);
    } else if (cmd == 0x05) {
      return _parseCMD_05(valueData, type: type);
    } else if (cmd == 0x06) {
      return _parseCMD_06(valueData, type: type);
    }

    if (com == null) {
      throw "command not null";
    }

    vmPrint("经过解析后的数据 status $status tip $tip com $com }", KBLEManager.logevel);

    return ReceiveDataModel(
        status: status, tip: tip, command: com, value: value);
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
    } else if (type == 0x02) {
      //解除绑定
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
      if (valueData[0] == 0xaa) {
        value = valueData[1];
        vmPrint("回答天数", KBLEManager.logevel);
      } else if (valueData[0] == 0xbb) {
        vmPrint("回答数据", KBLEManager.logevel);
        int all = valueData[1];
        int current = valueData[2];
        KBLEManager.sendData(
            sendData: KBLESerialization.getHeartHistoryDataByCurrentByIndex(
          current,
          isHeart: type == 0x03
              ? KHealthDataType.HEART_RATE
              : KHealthDataType.BLOOD_OXYGEN,
        ));
        if (all == current) {
          vmPrint("心率或者血氧接收完毕", KBLEManager.logevel);
          status = true;
          if (type == 0x03) {
            KBLEManager.sendData(
                sendData: KBLESerialization.getStepsHistoryDataByCurrent());
          } else if (type == 0x08) {
            vmPrint("发送睡眠", KBLEManager.logevel);
            KBLEManager.sendData(
                sendData: KBLESerialization.getSleepHistoryDataByCurrent());
          }
        } else {}

        HealthData.insertHealthBleData(
            datas: valueData.sublist(3),
            isContainTime: true,
            type: type == 0x03
                ? KHealthDataType.HEART_RATE
                : KHealthDataType.BLOOD_OXYGEN);
      }
    } else if (type == 0x04 || type == 0x09) {
      //当天数据
      if (valueData[0] == 0xbb) {
        int all = valueData[1];
        int current = valueData[2];
        status = true;
        if (all == current) {
        } else {}
        KBLEManager.sendData(
            sendData: KBLESerialization.getHeartHistoryDataByCurrentByIndex(
          current,
          isHeart: type == 0x04
              ? KHealthDataType.HEART_RATE
              : KHealthDataType.BLOOD_OXYGEN,
        ));
        HealthData.insertHealthBleData(
            datas: valueData.sublist(3),
            isContainTime: false,
            type: type == 0x04
                ? KHealthDataType.HEART_RATE
                : KHealthDataType.BLOOD_OXYGEN);
      }
    }
    return ReceiveDataModel(status: status, tip: tip, command: com);
  }

  ///步数
  static ReceiveDataModel _parseCMD_04(List<int> valueData,
      {required int? type}) {
    KBLECommandType com = KBLECommandType.system;
    bool status = false;
    String tip = "";
    com = KBLECommandType.gsensor;
    status = true;
    dynamic value;
    if (type == 0x03) {
      if (valueData[0] == 0xaa) {
        value = valueData[1];
        vmPrint("回答天数");
      } else if (valueData[0] == 0xbb) {
        vmPrint("回答数据");
        int all = valueData[1];
        int current = valueData[2];

        KBLEManager.sendData(
          sendData:
              KBLESerialization.getStepsHistoryDataByCurrentByIndex(current),
        );
        HealthData.insertHealthBleData(
          datas: valueData.sublist(3),
          isContainTime: true,
          type: KHealthDataType.STEPS,
        );
        if (all == current) {
          vmPrint("步数接收完毕", KBLEManager.logevel);

          KBLEManager.sendData(
              sendData: KBLESerialization.getHeartHistoryDataByCurrent(
                  isHeart: KHealthDataType.BLOOD_OXYGEN));
        } else {}
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
    if (type == 0x01) {
      if (valueData[0] == 0xbb) {
        vmPrint("睡眠数据", KBLEManager.logevel);
        int all = valueData[1];
        int current = valueData[2];
        KBLEManager.sendData(
            sendData:
                KBLESerialization.getSleepHistoryDataByCurrentByIndex(current));
        if (all == current) {
          vmPrint("睡眠接收完毕", KBLEManager.logevel);
        }
        HealthData.insertHealthBleData(
            datas: valueData.sublist(3),
            isContainTime: true,
            type: KHealthDataType.SLEEP);
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
    return ReceiveDataModel(
        status: status, tip: tip, command: com, value: value);
  }
}
