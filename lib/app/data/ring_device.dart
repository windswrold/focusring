import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class RingDevice {
  final String? remoteId;
  final String? localName;
  final String? macAddress;

  RingDevice({this.remoteId, this.localName, this.macAddress});

  factory RingDevice.fromResult(ScanResult result) {
    return RingDevice(
      remoteId: result.device.remoteId.str,
      localName: result.device.localName,
      macAddress: result.device.remoteId.str,
    );
  }
}
