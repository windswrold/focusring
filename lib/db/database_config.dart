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
      final migration1to2 = Migration(1, 2, (migdatabase) async {
        await migdatabase.execute(
            'CREATE TABLE IF NOT EXISTS `bloodOxygenData_v2` (`appUserId` INTEGER, `mac` TEXT, `createTime` TEXT, `averageHeartRate` INTEGER, `max` INTEGER, `min` INTEGER, `bloodArray` TEXT, PRIMARY KEY (`appUserId`, `createTime`))');
        await migdatabase.execute(
            'CREATE TABLE IF NOT EXISTS `heartRateData_v2` (`appUserId` INTEGER, `mac` TEXT, `createTime` TEXT, `averageHeartRate` INTEGER, `max` INTEGER, `min` INTEGER, `heartArray` TEXT, PRIMARY KEY (`appUserId`, `createTime`))');
        await migdatabase.execute(
            'CREATE TABLE IF NOT EXISTS `stepData_v2` (`appUserId` INTEGER, `mac` TEXT, `createTime` TEXT, `steps` TEXT, `distance` TEXT, `calorie` TEXT, `dataArrs` TEXT, PRIMARY KEY (`appUserId`, `createTime`))');
        await migdatabase.execute(
            'CREATE TABLE IF NOT EXISTS `TempData_v2` (`appUserId` INTEGER, `mac` TEXT, `createTime` TEXT, `temperature` INTEGER, `average` TEXT, `max` TEXT, `min` TEXT, `dataArray` TEXT, PRIMARY KEY (`appUserId`, `createTime`))');
      });

      final migration2to3 = Migration(2, 3, (migdatabase) async {
        await migdatabase.execute(
            'CREATE TABLE IF NOT EXISTS `SleepData_V2` (`appUserId` INTEGER, `mac` TEXT, `createTime` TEXT, `start_Sleep` INTEGER, `end_Sleep` INTEGER, `awake_time` INTEGER, `light_sleep_time` INTEGER, `deep_sleep_time` INTEGER, `dataArray` TEXT, PRIMARY KEY (`appUserId`, `createTime`))');
        await migdatabase
            .execute('ALTER TABLE ring_device_table  ADD COLUMN version text');
      });
      final migration3to4 = Migration(3, 4, (migdatabase) async {
        await migdatabase.execute(
            'CREATE TABLE IF NOT EXISTS `stepData_v3` (`appUserId` INTEGER, `mac` TEXT, `createTime` TEXT, `steps` TEXT, `dataArrs` TEXT, `max` TEXT, PRIMARY KEY (`appUserId`, `createTime`))');
      });
      fbase = await $FloorFlutterDatabase
          .databaseBuilder(fileName)
          .addMigrations([migration1to2, migration2to3, migration3to4])
          .addCallback(callback)
          .build();

      return fbase;
    }
  }
}
