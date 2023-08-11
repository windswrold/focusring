import 'package:floor/floor.dart';

import '../public.dart';
import 'database.dart';

class DataBaseConfig {
  static FlutterDatabase? fbase;
  static const fileName = 'database.db';
  static Future<FlutterDatabase?> openDataBase() async {
    if (fbase != null) {
      return fbase;
    } else {
      final callback = Callback(
        onOpen: (openDB) async {
          vmPrint("database open succeeded " + openDB.path);
        },
        onUpgrade: (database, startVersion, endVersion) {
          vmPrint("database upgrade succeeded $startVersion -> $endVersion");
        },
        onCreate: (database, version) {
          vmPrint("database create succeeded version $version" + database.path);
        },
      );

      fbase = await $FloorFlutterDatabase
          .databaseBuilder(fileName)
          .addCallback(callback)
          .build();

      return fbase;
    }
  }
}
