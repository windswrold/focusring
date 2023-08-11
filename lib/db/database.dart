import 'dart:async';
import 'package:floor/floor.dart';
import 'package:focusring/app/data/card_health_index.dart';
import 'package:focusring/const/constant.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
part 'database.g.dart';

//flutter packages pub run build_runner build --delete-conflicting-outputs
const int dbCurrentVersion = 1;

@Database(version: dbCurrentVersion, entities: [
  KHealthIndexModel,
])
abstract class FlutterDatabase extends FloorDatabase {
  KHealthIndexModelDao get indexDap;
}
