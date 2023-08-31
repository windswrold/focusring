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
}

class ReceiveDataHandler {
  static ReceiveDataModel parseDataHandler(List<int> _allDatas) {
    //解析收到的数据
    String tip = "";
    bool status = false;
    dynamic value;

    KBLECommandType? com;
    vmPrint("一个完整的数据 ${HEXUtil.encode(_allDatas)}");
    //取出头
    int cmd = _allDatas[4];
    int type = _allDatas[5];
    List<int> valueData = _allDatas.sublist(6);
    if (cmd == 0x01) {
      vmPrint("绑定认证");
      com = KBLECommandType.bindingsverify;
      if (valueData[0] == 0x01) {
        status = false;
        tip = "拒绝绑定";
      } else {
        status = true;
        tip = "成功绑定";
      }
    } else if (cmd == 0x02) {
      com = KBLECommandType.system;
      if (type == 0x00) {
        status = true;
        tip = "时间设置成功";
      } else if (type == 0x02) {
        //解除绑定
      }
      vmPrint("时间设置成功");
    } else if (cmd == 0x03) {
      vmPrint("ppg");
      com = KBLECommandType.ppg;
      status = false;
      if (type == 0x00 && type == 0x05) {
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
      } else if (type == 0x01 && type == 0x06) {
        vmPrint("心率定时测量设置");
        status = true;
        tip = "设备回复设置成功";
      } else if (type == 0x02 && type == 0x07) {
        if (valueData[0] == 0x00) {
          vmPrint("不打开");
          status = false;
        } else {
          status = true;
        }
        tip = "心率定时测量设置成功";
      } else if (type == 0x03 && type == 0x08) {
        if (valueData[0] == 0xaa) {
          value = valueData[1];
          vmPrint("回答天数");
          status = true;
        } else if (valueData[0] == 0xbb) {
          vmPrint("回答数据");
          int all = valueData[1];
          int current = valueData[2];
          if (all == current) {
            vmPrint("接收完毕");
            status = true;
          } else {
            KBLEManager.sendData(
                sendData: KBLESerialization.getHeartHistoryDataByCurrentByIndex(
              current,
              isHeart: type == 0x03
                  ? KHealthDataType.HEART_RATE
                  : KHealthDataType.BLOOD_OXYGEN,
            ));
          }

          HealthData.insertHeartBloodBleData(
              datas: valueData.sublist(3),
              isHaveTime: true,
              isHeart: type == 0x03 ? true : false);
        }
      } else if (type == 0x04 && type == 0x09) {
        //当天数据
        if (valueData[0] == 0xbb) {
          int all = valueData[1];
          int current = valueData[2];
          if (all == current) {
            vmPrint("接收完毕");
            status = true;
          } else {
            KBLEManager.sendData(
                sendData: KBLESerialization.getHeartHistoryDataByCurrentByIndex(
              current,
              isHeart: type == 0x04
                  ? KHealthDataType.HEART_RATE
                  : KHealthDataType.BLOOD_OXYGEN,
            ));
          }
          HealthData.insertHeartBloodBleData(
              datas: valueData.sublist(3),
              isHaveTime: false,
              isHeart: type == 0x04 ? true : false);
        }
      }
    } else if (cmd == 0x06) {
      status = true;
      value = valueData[0];
    }

    if (com == null) {
      throw "command not null";
    }

    return ReceiveDataModel(
        status: status, tip: tip, command: com, value: value);
  }

  static void receiveDataHandler(Map event) async {}
}
