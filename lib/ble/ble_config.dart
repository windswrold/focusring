import 'package:focusring/public.dart';

class BLEConfig {
  static const String SERVICEUUID = "FB349B5F-8000-0080-0010-000022220000";

  static const String WRITEUUID =   "FB349B5F-8000-0080-0010-000001220000";

  static const String NOTIFYUUID =  "FB349B5F-8000-0080-0010-000002220000";

  // static const String SERVICEUUID = "00002222-0000-1000-8000-00805f9b34fb";

  // static const String NOTIFYUUID = "00002201-0000-1000-8000-00805f9b34fb";

  // static const String WRITEUUID = "00002202-0000-1000-8000-00805f9b34fb";

  //                               00001801-0000-1000-8000-00805f9b34fb

  static const int appMaster = 0xdddd;
  static const int ringSlave = 0xeeee;
}
