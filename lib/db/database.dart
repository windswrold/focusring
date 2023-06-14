import 'dart:async';

import 'package:floor/floor.dart';
import 'package:vmeta3v2/model/wallet_objects.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
part 'database.g.dart';

const int dbCurrentVersion = 1;

@Database(version: dbCurrentVersion, entities: [
  KWalletObjects,
])
abstract class FlutterDatabase extends FloorDatabase {
  KWalletObjectsDao get kwalletDao;
}
