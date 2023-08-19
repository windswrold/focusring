import 'package:focusring/public.dart';
import 'package:hex/hex.dart';

class BLEConfig {
  static const String SERVICEUUID = "FB349B5F-8000-0080-0010-000022220000";

  static const String WRITEUUID = "FB349B5F-8000-0080-0010-000001220000";

  static const String NOTIFYUUID = "FB349B5F-8000-0080-0010-000002220000";

  // static const String SERVICEUUID = "00002222-0000-1000-8000-00805f9b34fb";

  // static const String NOTIFYUUID = "00002201-0000-1000-8000-00805f9b34fb";

  // static const String WRITEUUID = "00002202-0000-1000-8000-00805f9b34fb";

  //                               00001801-0000-1000-8000-00805f9b34fb

  static const String appMaster = "dddd";
  static const String ringSlave = "eeee";
}

class BLESendData {
  final String head;

  final KBLECommand? cmd;

  final String? cmdStr;

  final String typeStr;

  final String valueStr;

  BLESendData(
      {this.head = BLEConfig.appMaster,
      required this.cmd,
      required this.cmdStr,
      required this.typeStr,
      required this.valueStr});

  List<int> getData() {
    // len = LEN1(CMD)+LEN2(TYPE)+LEN3(VALUE);
    List<int> datas = [];
    final master = HEX.decode(head);
    final command = HEX.decode(cmd != null ? cmd!.getBLECommand() : cmdStr!);
    final type = HEX.decode(typeStr);
    final values = HEX.decode(valueStr);
    int length = command.length + type.length + values.length;
    int highByte = (length & 0xFF00) >> 8;
    int lowByte = length & 0x00FF;
    datas.addAll(master);
    datas.addAll([highByte, lowByte]);
    datas.addAll(command);
    datas.addAll(type);
    datas.addAll(values);
    vmPrint("getData  ${HEX.encode(datas)}");
    return datas;
  }
}
