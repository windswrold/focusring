import 'package:floor/floor.dart';
import 'package:vmeta3v2/db/database.dart';

class DataBaseConfig {
  static FlutterDatabase? fbase;
  static bool migrationsTokens = false;
  static const fileName = 'zk_database.db';
  //open the database
  // ignore: missing_return
  static Future<FlutterDatabase?> openDataBase() async {
    if (fbase != null) {
      return fbase;
    } else {
      final callback = Callback(
        onOpen: (openDB) async {},
        onUpgrade: (database, startVersion, endVersion) {},
        onCreate: (database, version) {},
      );
      fbase = await $FloorFlutterDatabase
          .databaseBuilder(fileName)
          .addMigrations([])
          .addCallback(callback)
          .build();

      // await TaskInit.createTables();
      return fbase;
    }
  }
}
