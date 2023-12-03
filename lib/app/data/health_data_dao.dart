import 'package:beering/app/data/health_data_model.dart';
import 'package:floor/floor.dart';

@dao
abstract class BloodOxygenDataDao {
  @Query(
      'SELECT * FROM $tableName WHERE appUserId = :appUserId and createTime >= :createTime AND createTime <= :nextTime')
  Future<List<BloodOxygenData>> queryUserAll(
      int appUserId, String createTime, String nextTime);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertTokens(List<BloodOxygenData> models);
}

@dao
abstract class HeartRateDataDao {
  @Query(
      'SELECT * FROM $tableName2 WHERE appUserId = :appUserId and createTime >= :createTime AND createTime <= :nextTime')
  Future<List<HeartRateData>> queryUserAll(
      int appUserId, String createTime, String nextTime);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertTokens(List<HeartRateData> models);
}

@dao
abstract class StepDataDao {
  @Query(
      'SELECT * FROM $tableName3 WHERE appUserId = :appUserId and createTime >= :createTime AND createTime <= :nextTime')
  Future<List<StepData>> queryUserAll(
      int appUserId, String createTime, String nextTime);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertTokens(List<StepData> models);
}

@dao
abstract class TempDataDao {
  @Query(
      'SELECT * FROM $tableName4 WHERE appUserId = :appUserId and createTime >= :createTime AND createTime <= :nextTime')
  Future<List<TempData>> queryUserAll(
      int appUserId, String createTime, String nextTime);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertTokens(List<TempData> models);
}

@dao
abstract class SleepDataDao {
  @Query(
      'SELECT * FROM $tableName5 WHERE appUserId = :appUserId and createTime >= :createTime AND createTime <= :nextTime')
  Future<List<SleepData>> queryUserAll(
      int appUserId, String createTime, String nextTime);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertTokens(List<SleepData> models);
}
