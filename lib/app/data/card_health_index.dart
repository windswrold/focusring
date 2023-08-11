import 'package:floor/floor.dart';
import 'package:focusring/db/database.dart';
import 'package:focusring/db/database_config.dart';
import 'package:focusring/public.dart';

const String tableName = 'health_index_table';

@Entity(tableName: tableName, primaryKeys: ["appUserId", "type"])
class KHealthIndexModel {
  final String appUserId;

  int index;

  final KHealthDataType type;

  bool state;

  KHealthIndexModel(this.appUserId, this.index, this.type, this.state);

  static List<KHealthIndexModel> defaultList(String appUserId) {
    int index = 0;
    return KHealthDataType.values
        .map((e) => KHealthIndexModel(appUserId, index++, e, true))
        .toList();
  }

  static Future<List<KHealthIndexModel>> queryAllWithState(
      String appUserId, bool state) async {
    final db = await DataBaseConfig.openDataBase();
    final datas = await db?.indexDap.queryAllWithState(appUserId, state);
    return datas ?? [];
  }

  static Future<List<KHealthIndexModel>> queryAll(String appUserId) async {
    final db = await DataBaseConfig.openDataBase();
    final datas = await db?.indexDap.queryAll(appUserId);
    return datas ?? [];
  }

  static Future<void> insertTokens(List<KHealthIndexModel> models) async {
    final db = await DataBaseConfig.openDataBase();
    return db?.indexDap.insertTokens(models);
  }

  // static Future<void> deleteTokens(KHealthIndexModel model) {}

  static Future<void> updateTokens(List<KHealthIndexModel> model) async {
    final db = await DataBaseConfig.openDataBase();
    return db?.indexDap.updateTokens(model);
  }
}

@dao
abstract class KHealthIndexModelDao {
  @Query(
      'SELECT * FROM $tableName WHERE appUserId = :appUserId ORDER BY "index" asc')
  Future<List<KHealthIndexModel>> queryAll(String appUserId);

  @Query(
      'SELECT * FROM $tableName WHERE appUserId = :appUserId and state = :state  ORDER BY "index" asc')
  Future<List<KHealthIndexModel>> queryAllWithState(
      String appUserId, bool state);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertTokens(List<KHealthIndexModel> models);

  @delete
  Future<void> deleteTokens(KHealthIndexModel model);

  @update
  Future<void> updateTokens(List<KHealthIndexModel> model);
}
