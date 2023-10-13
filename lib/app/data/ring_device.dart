import 'package:floor/floor.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:beering/db/database_config.dart';

const String tableName = 'ring_device_table';

@Entity(tableName: tableName, primaryKeys: ["appUserId", "remoteId"])
class RingDeviceModel {
  String? appUserId;
  final String? remoteId;
  final String? localName;
  final String? macAddress;
  bool? isSelect;

  RingDeviceModel({
    this.appUserId,
    this.remoteId,
    this.localName,
    this.macAddress,
    this.isSelect,
  });

  factory RingDeviceModel.fromResult(ScanResult result) {
    return RingDeviceModel(
      remoteId: result.device.remoteId.str,
      localName: result.device.localName,
      macAddress: result.device.remoteId.str,
    );
  }

  static String getBatIcon({int? bat, bool isCharging = false}) {
    String name = "bat/";
    if (bat == null || bat < 10) {
      name = "${name}bat_less10";
    } else if ((10 <= bat && bat < 20)) {
      name = "${name}bat_10";
    } else if ((20 <= bat && bat < 30)) {
      name = "${name}bat_20";
    } else if ((30 <= bat && bat < 40)) {
      name = "${name}bat_30";
    } else if ((40 <= bat && bat < 50)) {
      name = "${name}bat_40";
    } else if ((50 <= bat && bat < 60)) {
      name = "${name}bat_50";
    } else if ((60 <= bat && bat < 70)) {
      name = "${name}bat_60";
    } else if ((70 <= bat && bat < 80)) {
      name = "${name}bat_70";
    } else if ((80 <= bat && bat < 90)) {
      name = "${name}bat_80";
    } else if ((90 <= bat && bat < 100)) {
      name = "${name}bat_90";
    } else if ((bat == 100)) {
      name = "${name}bat_100";
    }
    if (isCharging == true) {
      name = "bat/bat_charging";
    }

    return name;
  }

  static Future<List<RingDeviceModel>> queryUserAll(
      String appUserId, bool state) async {
    final db = await DataBaseConfig.openDataBase();
    final datas = await db?.ringDao.queryUserAll(appUserId);
    return datas ?? [];
  }

  static Future<RingDeviceModel?> queryUserAllWithSelect(
      String appUserId, bool select) async {
    try {
      final db = await DataBaseConfig.openDataBase();
      final datas = await db?.ringDao.queryUserAllWithSelect(appUserId, select);
      return datas;
    } catch (e) {
      return null;
    }
  }

  static Future<void> insertTokens(List<RingDeviceModel> models) async {
    final db = await DataBaseConfig.openDataBase();
    db?.database.execute("update $tableName set isSelect = 0");

    return db?.ringDao.insertTokens(models);
  }

  static Future<void> updateTokens(List<RingDeviceModel> model) async {
    final db = await DataBaseConfig.openDataBase();
    return db?.ringDao.updateTokens(model);
  }

  static Future<void> delTokens(RingDeviceModel model) async {
    final db = await DataBaseConfig.openDataBase();
    return db?.database?.execute(
        "Delete FROM $tableName where appUserId = '${model.appUserId}' and remoteId = '${model.remoteId}'");
  }
}

@dao
abstract class RingDeviceDao {
  @Query('SELECT * FROM $tableName WHERE appUserId = :appUserId ')
  Future<List<RingDeviceModel>> queryUserAll(String appUserId);

  @Query(
      'SELECT * FROM $tableName WHERE appUserId = :appUserId and isSelect = :select ')
  Future<RingDeviceModel?> queryUserAllWithSelect(
      String appUserId, bool select);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertTokens(List<RingDeviceModel> models);

  @delete
  Future<void> deleteTokens(RingDeviceModel model);

  @update
  Future<void> updateTokens(List<RingDeviceModel> model);
}
