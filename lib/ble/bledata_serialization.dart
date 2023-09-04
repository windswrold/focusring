//构建冷钱包指令

import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:beering/ble/ble_config.dart';
import 'package:beering/public.dart';
import 'package:beering/utils/hex_util.dart';
import 'package:beering/utils/json_util.dart';
import 'package:flutter/services.dart';
import 'package:hex/hex.dart';

class KBLESerialization {
  ///更新
  // static Future<List<List<int>>> update() async {
  //   File file = await Constant.getBinFile();
  //   if (file.existsSync() == false) {
  //     LogUtil.v("文件为空");
  //     return null;
  //   }
  //   List<int> list = file.readAsBytesSync().toList();
  //   if (list.length > 0) {
  //     List<List<int>> updates =
  //         await _parseData(list, command.command_update.index, true);

  //     return updates;
  //   }
  //   ByteData data = await rootBundle.load('assets/data/HolderWallet.bin');
  //   list = List.from(data.buffer.asUint8List());
  //   return Future.value(_parseData(list, command.command_update.index, false));
  // }

  ///开始配对
  static BLESendData bindingsverify() {
    return BLESendData(
        cmd: KBLECommandType.bindingsverify, typeStr: "00", valueStr: "00");
  }

  static BLESendData timeSetting() {
    final a = DateTime.now();

    return BLESendData(
        cmd: KBLECommandType.system,
        typeStr: "00",
        valueStr: a.toCustomFormat());
  }

  ///心率实时单次测量设置 血氧
  static BLESendData ppg_heartOnceTest({required KHealthDataType isHeart}) {
    return BLESendData(
        cmd: KBLECommandType.ppg,
        typeStr: isHeart == KHealthDataType.HEART_RATE ? "00" : "05",
        valueStr: "00");
  }

  ///心率定时测量设置 血氧
  static BLESendData ppg_heartTimingTest({
    required bool isOn,
    required DateTime? startTime,
    required DateTime? endTime,
    required int? offset,
    required KHealthDataType isHeart,
  }) {
    List<int> data = [];
    data.add(isOn ? 0x01 : 0x00);
    if (isOn == true) {
      if (startTime == null || endTime == null || offset == null) {
        throw "无效数据";
      }
      if (startTime.compareTo(endTime) > 0) {
        throw "无效数据";
      }
      data.add(startTime.hour);
      data.add(startTime.minute);
      data.add(endTime.hour);
      data.add(endTime.minute);
      data.add(offset);
    }
    return BLESendData(
        cmd: KBLECommandType.ppg,
        typeStr: isHeart == KHealthDataType.HEART_RATE ? "01" : "06",
        valueStr: HEXUtil.encode(data));
  }

  ///心率定时测量设置获取 血氧
  static BLESendData ppg_getHeartTimingSetting(
      {required KHealthDataType isHeart}) {
    return BLESendData(
        cmd: KBLECommandType.ppg,
        typeStr: isHeart == KHealthDataType.HEART_RATE ? "02" : "07",
        valueStr: "00");
  }

  ///发送获取历史心率数据天数获取 血氧
  static BLESendData getHeartHistoryDataDayNum(
      {required KHealthDataType isHeart}) {
    return BLESendData(
        cmd: KBLECommandType.ppg,
        typeStr: isHeart == KHealthDataType.HEART_RATE ? "03" : "08",
        valueStr: "aa00");
  }

  ///获取历史心率数据请求当天数据 血氧
  static BLESendData getHeartHistoryDataByCurrent(
      {required KHealthDataType isHeart}) {
    return BLESendData(
        cmd: KBLECommandType.ppg,
        typeStr: isHeart == KHealthDataType.HEART_RATE ? "03" : "08",
        valueStr: "bb00");
  }

  ///回复收到相应包，并带上包序号 血氧
  static BLESendData getHeartHistoryDataByCurrentByIndex(int index,
      {required KHealthDataType isHeart}) {
    List<int> e = [0xcc, index];
    return BLESendData(
        cmd: KBLECommandType.ppg,
        typeStr: isHeart == KHealthDataType.HEART_RATE ? "03" : "08",
        valueStr: HEXUtil.encode(e));
  }

  ///心率当天数据获取心率按照5min一个值： 血氧
  ///1天：12X24=288个字节；固定大小；
  static BLESendData getHeartHistoryDataByCurrentLong(
      {required KHealthDataType isHeart}) {
    return BLESendData(
        cmd: KBLECommandType.ppg,
        typeStr: isHeart == KHealthDataType.HEART_RATE ? "04" : "09",
        valueStr: "bb01");
  }

  ///获取当天历史步数
  static BLESendData getStepsHistoryDataByCurrent() {
    return BLESendData(
        cmd: KBLECommandType.gsensor, typeStr: "03", valueStr: "bb00");
  }

  ///回复收到相应包，并带上包序号
  static BLESendData getStepsHistoryDataByCurrentByIndex(
    int index,
  ) {
    List<int> e = [0xcc, index];
    return BLESendData(
        cmd: KBLECommandType.gsensor,
        typeStr: "03",
        valueStr: HEXUtil.encode(e));
  }

  ///电量在发送变化的时候设备回主动上报
  static BLESendData getBattery() {
    return BLESendData(
        cmd: KBLECommandType.battery, typeStr: "00", valueStr: "00");
  }
}

extension DateTimeEX on DateTime {
  String toCustomFormat() {
    // Extract date and time components
    int year = this.year; // 2023
    int month = this.month; // 6
    int day = this.day; // 18
    int hour = this.hour; // 11
    int minute = this.minute; // 34
    int second = this.second; // 30

    // Convert to custom format
    ByteData byteData = ByteData(8); // 7 bytes in total
    byteData.setUint16(0, year, Endian.little);
    byteData.setUint8(2, month);
    byteData.setUint8(3, day);
    byteData.setUint8(4, hour);
    byteData.setUint8(5, minute);
    byteData.setUint8(6, second);

    final offset = timeZoneOffset.inHours;
    byteData.setUint8(7, offset);

    return HEXUtil.encode(byteData.buffer.asUint8List().toList());
  }
}
