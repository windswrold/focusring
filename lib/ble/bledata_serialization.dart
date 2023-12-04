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

  static BLESendData unBindDevice() {
    return BLESendData(
        cmd: KBLECommandType.system, typeStr: "02", valueStr: "00");
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
    required DateTime startTime,
    required DateTime endTime,
    required int? offset,
    required KHealthDataType isHeart,
  }) {
    List<int> data = [];
    data.add(isOn ? 0x01 : 0x00);
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

  ///发送获取历史数据的天数 心率血氧 步数 睡眠
  static BLESendData getDayNumWithType({required KHealthDataType type}) {
    if (type == KHealthDataType.HEART_RATE ||
        type == KHealthDataType.BLOOD_OXYGEN) {
      return BLESendData(
          cmd: KBLECommandType.ppg,
          typeStr: type == KHealthDataType.HEART_RATE ? "03" : "08",
          valueStr: "aa00");
    }

    if (type == KHealthDataType.STEPS) {
      return BLESendData(
          cmd: KBLECommandType.gsensor, typeStr: "03", valueStr: "aa00");
    }

    if (type == KHealthDataType.SLEEP) {
      return BLESendData(
          cmd: KBLECommandType.sleep, typeStr: "01", valueStr: "aa00");
    }

    throw "add type";
  }

  ///根据天数获取历史数据 心率血氧 步数 睡眠
  static BLESendData getHistoryDataWithType(
      {required KHealthDataType type, required int index}) {
    String dayIndex = HEXUtil.encode([index]);

    if (type == KHealthDataType.HEART_RATE ||
        type == KHealthDataType.BLOOD_OXYGEN) {
      return BLESendData(
          cmd: KBLECommandType.ppg,
          typeStr: type == KHealthDataType.HEART_RATE ? "03" : "08",
          valueStr: "bb$dayIndex");
    }

    if (type == KHealthDataType.STEPS) {
      return BLESendData(
          cmd: KBLECommandType.gsensor, typeStr: "03", valueStr: "bb$dayIndex");
    }

    if (type == KHealthDataType.SLEEP) {
      return BLESendData(
          cmd: KBLECommandType.sleep, typeStr: "01", valueStr: "bb$dayIndex");
    }
    throw "add type";
  }

  ///获取当天数据
  static BLESendData getTodayData({
    required KHealthDataType type,
  }) {
    if (type == KHealthDataType.HEART_RATE) {
      return BLESendData(
          cmd: KBLECommandType.ppg, typeStr: "04", valueStr: "bb01");
    } else if (type == KHealthDataType.BLOOD_OXYGEN) {
      return BLESendData(
          cmd: KBLECommandType.ppg, typeStr: "09", valueStr: "bb01");
    } else if (type == KHealthDataType.STEPS) {
      return BLESendData(
          cmd: KBLECommandType.gsensor, typeStr: "02", valueStr: "bb01");
    } else if (type == KHealthDataType.SLEEP) {
      return BLESendData(
          cmd: KBLECommandType.sleep, typeStr: "01", valueStr: "bb00");
    }

    throw "add type";
  }

  ///回复收到相应包，并带上包序号
  static BLESendData sendDataIndex(int index,
      {required KHealthDataType type, required bool isToday}) {
    List<int> e = [0xcc, index];

    if (type == KHealthDataType.HEART_RATE) {
      return BLESendData(
          cmd: KBLECommandType.ppg,
          typeStr: isToday ? "04" : "03",
          valueStr: HEXUtil.encode(e));
    } else if (type == KHealthDataType.BLOOD_OXYGEN) {
      return BLESendData(
          cmd: KBLECommandType.ppg,
          typeStr: isToday ? "09" : "08",
          valueStr: HEXUtil.encode(e));
    } else if (type == KHealthDataType.STEPS) {
      return BLESendData(
          cmd: KBLECommandType.gsensor,
          typeStr: isToday ? "02" : "03",
          valueStr: HEXUtil.encode(e));
    } else if (type == KHealthDataType.SLEEP) {
      return BLESendData(
          cmd: KBLECommandType.sleep,
          typeStr: "01",
          valueStr: HEXUtil.encode(e));
    }

    throw "add type";
  }

  ///电量在发送变化的时候设备回主动上报
  static BLESendData getBattery() {
    return BLESendData(
        cmd: KBLECommandType.battery, typeStr: "00", valueStr: "00");
  }

  ///充电状态
  static BLESendData getCharger() {
    return BLESendData(
        cmd: KBLECommandType.charger, typeStr: "00", valueStr: "00");
  }

  static BLESendData getVersion() {
    return BLESendData(
        cmd: KBLECommandType.system, typeStr: "05", valueStr: "00");
  }

  static BLESendData requestOTA(String version) {
    List<String> data = version.split(".");
    if (data.length == 3) {
      data.removeAt(0);
    }
    final result = HEXUtil.encode(data.map((e) => int.parse(e)).toList());
    return BLESendData(
        cmd: KBLECommandType.system, typeStr: "01", valueStr: "01$result");
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
