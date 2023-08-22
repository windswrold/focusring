import 'package:floor/floor.dart';
import 'package:beering/db/database.dart';
import 'package:beering/db/database_config.dart';
import 'package:beering/public.dart';

const String tableName = 'health_index_table';

@Entity(tableName: tableName, primaryKeys: ["appUserId", "type"])
class KBaseHealthType {
  final String appUserId;

  int index;

  final KHealthDataType type;

  bool state;

  KBaseHealthType(this.appUserId, this.index, this.type, this.state);

  static List<KBaseHealthType> defaultList(String appUserId) {
    int index = 0;
    return KHealthDataType.values
        .map((e) => KBaseHealthType(appUserId, index++, e, true))
        .toList();
  }

  static Future<List<KBaseHealthType>> queryAllWithState(
      String appUserId, bool state) async {
    final db = await DataBaseConfig.openDataBase();
    final datas = await db?.indexDap.queryAllWithState(appUserId, state);
    return datas ?? [];
  }

  static Future<List<KBaseHealthType>> queryAll(String appUserId) async {
    final db = await DataBaseConfig.openDataBase();
    final datas = await db?.indexDap.queryAll(appUserId);
    return datas ?? [];
  }

  static Future<void> insertTokens(List<KBaseHealthType> models) async {
    final db = await DataBaseConfig.openDataBase();
    return db?.indexDap.insertTokens(models);
  }

  // static Future<void> deleteTokens(KHealthIndexModel model) {}

  static Future<void> updateTokens(List<KBaseHealthType> model) async {
    final db = await DataBaseConfig.openDataBase();
    return db?.indexDap.updateTokens(model);
  }
}

@dao
abstract class KHealthIndexModelDao {
  @Query(
      'SELECT * FROM $tableName WHERE appUserId = :appUserId ORDER BY "index" asc')
  Future<List<KBaseHealthType>> queryAll(String appUserId);

  @Query(
      'SELECT * FROM $tableName WHERE appUserId = :appUserId and state = :state  ORDER BY "index" asc')
  Future<List<KBaseHealthType>> queryAllWithState(
      String appUserId, bool state);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertTokens(List<KBaseHealthType> models);

  @delete
  Future<void> deleteTokens(KBaseHealthType model);

  @update
  Future<void> updateTokens(List<KBaseHealthType> model);
}
