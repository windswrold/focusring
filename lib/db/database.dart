import 'dart:async';
import 'package:beering/app/data/health_data_utils.dart';
import 'package:beering/app/data/health_data_dao.dart';
import 'package:floor/floor.dart';
import 'package:beering/app/data/card_health_index.dart';
import 'package:beering/app/data/ring_device.dart';
import 'package:beering/const/constant.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
part 'database.g.dart';

//flutter packages pub run build_runner build --delete-conflicting-outputs
const int dbCurrentVersion = 1;

@Database(version: dbCurrentVersion, entities: [
  KBaseHealthType,
  RingDeviceModel,
  BloodOxygenData,
  HeartRateData,
  StepData,
  TempData,
])
abstract class FlutterDatabase extends FloorDatabase {
  KHealthIndexModelDao get indexDap;
  RingDeviceDao get ringDao;
  BloodOxygenDataDao get bloodDao;
  HeartRateDataDao get heartDao;
  StepDataDao get stepDao;
  TempDataDao get tempDap;
}
