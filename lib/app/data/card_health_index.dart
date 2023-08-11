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

//   static Future<bool> moveItem(
//       KHealthIndexModel oldItem, KHealthIndexModel newItem) async {
//     try {
//       FlutterDatabase? database = await DataBaseConfig.openDataBase();
//       var tokenOwner = oldItem.owner;
//       var tchainid = oldItem.chainId;
//       if (oldItem.index == null || newItem.index == null) {
//         List<MCollectionTokens> datas =
//             (await database?.tokensDao.findTokens(tokenOwner!, tchainid!)) ??
//                 [];
//         int _index = 999;
//         datas.forEach((element) {
//           _index -= 1;
//           var eleIndex =
//               (element.index ?? _index); //allocate an index if no index
//           element.index = eleIndex;
//           if (oldItem.contract == element.contract) {
//             oldItem = element;
//           }
//           if (newItem.contract == element.contract) {
//             newItem = element;
//           }
//           database?.tokensDao.updateTokens(element);
//         });
//       }
//       var oldIndex = oldItem.index ?? 0;
//       var newIndex = newItem.index ?? 0;
//       int maxnum = double.maxFinite.toInt();
//       oldItem.index = maxnum;
//       database!.tokensDao.updateTokens(oldItem);

//       List<MCollectionTokens> datas =
//           (await database.tokensDao.findTokens(tokenOwner!, tchainid!));
//       datas.forEach((element) {
//         var eleIndex = element.index ?? 0;
//         if (oldIndex < newIndex) {
//           if (eleIndex > oldIndex && eleIndex <= newIndex) {
//             element.index = eleIndex - 1;
//           }
//         } else {
//           if (eleIndex >= newIndex && eleIndex < oldIndex) {
//             element.index = eleIndex + 1;
//           }
//         }
//         vmPrint('element ${element.token} ${element.index}');
//         database.tokensDao.updateTokens(element);
//       });
//       oldItem.index = newIndex;
//       database.tokensDao.updateTokens(oldItem);
//       return true;
//     } catch (e) {
//       vmPrint('failed:' + e.toString());
//       return false;
//     }
//   }
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
