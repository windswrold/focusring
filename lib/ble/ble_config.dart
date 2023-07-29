class BLEConfig {
  // static String SERVICEUUID = "49535343-fe7d-4ae5-8fa9-9fafd205e455";
  // static String NOTIFYUUID = "49535343-1e4d-4bd9-ba61-23c647249616";
  // static String WRITEUUID = "49535343-8841-43f4-a8d4-ecbe34729bb3";

  static const String SERVICEUUID = "0000ffe1-0000-1000-8000-00805f9b34fb";

  static const String NOTIFYUUID = "0000ffe2-0000-1000-8000-00805f9b34fb";

  static const String WRITEUUID = "0000ffe3-0000-1000-8000-00805f9b34fb";

  static const int mtuSize = 512;

  static const int crcLen = 2;
  static const int headLen = 2;
  static const int connectTimeout = 30;
  static const int scanTimeout = 30;
}
