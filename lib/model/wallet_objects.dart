import 'package:floor/floor.dart';
import 'package:vmeta3v2/db/database_config.dart';

const String tableName = "wallet_table";

@Entity(tableName: tableName)
class KWalletObjects {
  @primaryKey
  final String a;

  final String b;

  final bool select;

  KWalletObjects(this.a, this.b, this.select);

  static Future<KWalletObjects?> findSelect() async {
    var db = await DataBaseConfig.openDataBase();
    return db?.kwalletDao.findSelect();
  }
}

@dao
abstract class KWalletObjectsDao {
  @Query('SELECT * FROM $tableName ')
  Future<List<KWalletObjects>?> findAllDatas();

  @Query("SELECT * FROM $tableName where select = true")
  Future<KWalletObjects?> findSelect();
}
