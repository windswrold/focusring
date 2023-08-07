import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class RingDevice {
  final String? remoteId;
  final String? localName;
  final String? macAddress;
  final bool? isConnect;
  final int? bat;
  final bool? isCharging;

  RingDevice(
      {this.remoteId,
      this.localName,
      this.macAddress,
      this.isConnect,
      this.isCharging,
      this.bat});

  factory RingDevice.fromResult(ScanResult result) {
    return RingDevice(
      remoteId: result.device.remoteId.str,
      localName: result.device.localName,
      macAddress: result.device.remoteId.str,
    );
  }

  String getBatIcon() {
    String name = "bat/";
    if (bat == null || bat! < 10) {
      "${name}bat_less10";
    } else if ((10 <= bat! && bat! < 20)) {
      "${name}bat_10";
    } else if ((20 <= bat! && bat! < 30)) {
      "${name}bat_20";
    } else if ((30 <= bat! && bat! < 40)) {
      "${name}bat_30";
    } else if ((40 <= bat! && bat! < 50)) {
      "${name}bat_40";
    } else if ((50 <= bat! && bat! < 60)) {
      "${name}bat_50";
    } else if ((60 <= bat! && bat! < 70)) {
      "${name}bat_60";
    } else if ((70 <= bat! && bat! < 80)) {
      "${name}bat_70";
    } else if ((80 <= bat! && bat! < 90)) {
      "${name}bat_80";
    } else if ((90 <= bat! && bat! < 100)) {
      "${name}bat_90";
    } else if ((bat! == 100)) {
      "${name}bat_100";
    }
    if (isCharging == true) {
      "bat_charging";
    }

    return name;
  }
}
