// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorFlutterDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$FlutterDatabaseBuilder databaseBuilder(String name) =>
      _$FlutterDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$FlutterDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$FlutterDatabaseBuilder(null);
}

class _$FlutterDatabaseBuilder {
  _$FlutterDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$FlutterDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$FlutterDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<FlutterDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$FlutterDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$FlutterDatabase extends FlutterDatabase {
  _$FlutterDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  KHealthIndexModelDao? _indexDapInstance;

  RingDeviceDao? _ringDaoInstance;

  BloodOxygenDataDao? _bloodDaoInstance;

  HeartRateDataDao? _heartDaoInstance;

  StepDataDao? _stepDaoInstance;

  TempDataDao? _tempDapInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `health_index_table` (`appUserId` TEXT NOT NULL, `index` INTEGER NOT NULL, `type` INTEGER NOT NULL, `state` INTEGER NOT NULL, PRIMARY KEY (`appUserId`, `type`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `ring_device_table` (`appUserId` TEXT, `remoteId` TEXT, `localName` TEXT, `macAddress` TEXT, `select` INTEGER, PRIMARY KEY (`appUserId`, `remoteId`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `bloodOxygenData` (`appUserId` INTEGER, `mac` TEXT, `createTime` TEXT, `averageHeartRate` INTEGER, `max` INTEGER, `min` INTEGER, `bloodArray` TEXT, PRIMARY KEY (`appUserId`, `createTime`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `heartRateData` (`appUserId` INTEGER, `mac` TEXT, `createTime` TEXT, `averageHeartRate` INTEGER, `max` INTEGER, `min` INTEGER, `heartArray` TEXT, PRIMARY KEY (`appUserId`, `createTime`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `stepData` (`appUserId` INTEGER, `mac` TEXT, `createTime` TEXT, `steps` INTEGER, `distance` INTEGER, `calorie` INTEGER, `dataArrs` TEXT, PRIMARY KEY (`appUserId`, `createTime`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `TempData` (`appUserId` INTEGER, `mac` TEXT, `createTime` TEXT, `temperature` INTEGER, `average` REAL, `max` REAL, `min` REAL, `dataArray` TEXT, PRIMARY KEY (`appUserId`, `createTime`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  KHealthIndexModelDao get indexDap {
    return _indexDapInstance ??=
        _$KHealthIndexModelDao(database, changeListener);
  }

  @override
  RingDeviceDao get ringDao {
    return _ringDaoInstance ??= _$RingDeviceDao(database, changeListener);
  }

  @override
  BloodOxygenDataDao get bloodDao {
    return _bloodDaoInstance ??= _$BloodOxygenDataDao(database, changeListener);
  }

  @override
  HeartRateDataDao get heartDao {
    return _heartDaoInstance ??= _$HeartRateDataDao(database, changeListener);
  }

  @override
  StepDataDao get stepDao {
    return _stepDaoInstance ??= _$StepDataDao(database, changeListener);
  }

  @override
  TempDataDao get tempDap {
    return _tempDapInstance ??= _$TempDataDao(database, changeListener);
  }
}

class _$KHealthIndexModelDao extends KHealthIndexModelDao {
  _$KHealthIndexModelDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _kBaseHealthTypeInsertionAdapter = InsertionAdapter(
            database,
            'health_index_table',
            (KBaseHealthType item) => <String, Object?>{
                  'appUserId': item.appUserId,
                  'index': item.index,
                  'type': item.type.index,
                  'state': item.state ? 1 : 0
                }),
        _kBaseHealthTypeUpdateAdapter = UpdateAdapter(
            database,
            'health_index_table',
            ['appUserId', 'type'],
            (KBaseHealthType item) => <String, Object?>{
                  'appUserId': item.appUserId,
                  'index': item.index,
                  'type': item.type.index,
                  'state': item.state ? 1 : 0
                }),
        _kBaseHealthTypeDeletionAdapter = DeletionAdapter(
            database,
            'health_index_table',
            ['appUserId', 'type'],
            (KBaseHealthType item) => <String, Object?>{
                  'appUserId': item.appUserId,
                  'index': item.index,
                  'type': item.type.index,
                  'state': item.state ? 1 : 0
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<KBaseHealthType> _kBaseHealthTypeInsertionAdapter;

  final UpdateAdapter<KBaseHealthType> _kBaseHealthTypeUpdateAdapter;

  final DeletionAdapter<KBaseHealthType> _kBaseHealthTypeDeletionAdapter;

  @override
  Future<List<KBaseHealthType>> queryAll(String appUserId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM health_index_table WHERE appUserId = ?1 ORDER BY \"index\" asc',
        mapper: (Map<String, Object?> row) => KBaseHealthType(row['appUserId'] as String, row['index'] as int, KHealthDataType.values[row['type'] as int], (row['state'] as int) != 0),
        arguments: [appUserId]);
  }

  @override
  Future<List<KBaseHealthType>> queryAllWithState(
    String appUserId,
    bool state,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM health_index_table WHERE appUserId = ?1 and state = ?2  ORDER BY \"index\" asc',
        mapper: (Map<String, Object?> row) => KBaseHealthType(row['appUserId'] as String, row['index'] as int, KHealthDataType.values[row['type'] as int], (row['state'] as int) != 0),
        arguments: [appUserId, state ? 1 : 0]);
  }

  @override
  Future<void> insertTokens(List<KBaseHealthType> models) async {
    await _kBaseHealthTypeInsertionAdapter.insertList(
        models, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateTokens(List<KBaseHealthType> model) async {
    await _kBaseHealthTypeUpdateAdapter.updateList(
        model, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteTokens(KBaseHealthType model) async {
    await _kBaseHealthTypeDeletionAdapter.delete(model);
  }
}

class _$RingDeviceDao extends RingDeviceDao {
  _$RingDeviceDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _ringDeviceModelInsertionAdapter = InsertionAdapter(
            database,
            'ring_device_table',
            (RingDeviceModel item) => <String, Object?>{
                  'appUserId': item.appUserId,
                  'remoteId': item.remoteId,
                  'localName': item.localName,
                  'macAddress': item.macAddress,
                  'select': item.select == null ? null : (item.select! ? 1 : 0)
                }),
        _ringDeviceModelUpdateAdapter = UpdateAdapter(
            database,
            'ring_device_table',
            ['appUserId', 'remoteId'],
            (RingDeviceModel item) => <String, Object?>{
                  'appUserId': item.appUserId,
                  'remoteId': item.remoteId,
                  'localName': item.localName,
                  'macAddress': item.macAddress,
                  'select': item.select == null ? null : (item.select! ? 1 : 0)
                }),
        _ringDeviceModelDeletionAdapter = DeletionAdapter(
            database,
            'ring_device_table',
            ['appUserId', 'remoteId'],
            (RingDeviceModel item) => <String, Object?>{
                  'appUserId': item.appUserId,
                  'remoteId': item.remoteId,
                  'localName': item.localName,
                  'macAddress': item.macAddress,
                  'select': item.select == null ? null : (item.select! ? 1 : 0)
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<RingDeviceModel> _ringDeviceModelInsertionAdapter;

  final UpdateAdapter<RingDeviceModel> _ringDeviceModelUpdateAdapter;

  final DeletionAdapter<RingDeviceModel> _ringDeviceModelDeletionAdapter;

  @override
  Future<List<RingDeviceModel>> queryUserAll(String appUserId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM ring_device_table WHERE appUserId = ?1',
        mapper: (Map<String, Object?> row) => RingDeviceModel(
            appUserId: row['appUserId'] as String?,
            remoteId: row['remoteId'] as String?,
            localName: row['localName'] as String?,
            macAddress: row['macAddress'] as String?,
            select: row['select'] == null ? null : (row['select'] as int) != 0),
        arguments: [appUserId]);
  }

  @override
  Future<List<RingDeviceModel>> queryUserAllWithSelect(
    String appUserId,
    bool select,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM ring_device_table WHERE appUserId = ?1 and select = ?2',
        mapper: (Map<String, Object?> row) => RingDeviceModel(
            appUserId: row['appUserId'] as String?,
            remoteId: row['remoteId'] as String?,
            localName: row['localName'] as String?,
            macAddress: row['macAddress'] as String?,
            select: row['select'] == null ? null : (row['select'] as int) != 0),
        arguments: [appUserId, select ? 1 : 0]);
  }

  @override
  Future<void> insertTokens(List<RingDeviceModel> models) async {
    await _ringDeviceModelInsertionAdapter.insertList(
        models, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateTokens(List<RingDeviceModel> model) async {
    await _ringDeviceModelUpdateAdapter.updateList(
        model, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteTokens(RingDeviceModel model) async {
    await _ringDeviceModelDeletionAdapter.delete(model);
  }
}

class _$BloodOxygenDataDao extends BloodOxygenDataDao {
  _$BloodOxygenDataDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _bloodOxygenDataInsertionAdapter = InsertionAdapter(
            database,
            'bloodOxygenData',
            (BloodOxygenData item) => <String, Object?>{
                  'appUserId': item.appUserId,
                  'mac': item.mac,
                  'createTime': item.createTime,
                  'averageHeartRate': item.averageHeartRate,
                  'max': item.max,
                  'min': item.min,
                  'bloodArray': item.bloodArray
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<BloodOxygenData> _bloodOxygenDataInsertionAdapter;

  @override
  Future<List<BloodOxygenData>> queryUserAll(
    int appUserId,
    String createTime,
    String nextTime,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM bloodOxygenData WHERE appUserId = ?1 and createTime >= ?2 AND createTime < ?3',
        mapper: (Map<String, Object?> row) => BloodOxygenData(appUserId: row['appUserId'] as int?, mac: row['mac'] as String?, createTime: row['createTime'] as String?, bloodArray: row['bloodArray'] as String?, averageHeartRate: row['averageHeartRate'] as int?, max: row['max'] as int?, min: row['min'] as int?),
        arguments: [appUserId, createTime, nextTime]);
  }

  @override
  Future<void> insertTokens(List<BloodOxygenData> models) async {
    await _bloodOxygenDataInsertionAdapter.insertList(
        models, OnConflictStrategy.replace);
  }
}

class _$HeartRateDataDao extends HeartRateDataDao {
  _$HeartRateDataDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _heartRateDataInsertionAdapter = InsertionAdapter(
            database,
            'heartRateData',
            (HeartRateData item) => <String, Object?>{
                  'appUserId': item.appUserId,
                  'mac': item.mac,
                  'createTime': item.createTime,
                  'averageHeartRate': item.averageHeartRate,
                  'max': item.max,
                  'min': item.min,
                  'heartArray': item.heartArray
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<HeartRateData> _heartRateDataInsertionAdapter;

  @override
  Future<List<HeartRateData>> queryUserAll(
    int appUserId,
    String createTime,
    String nextTime,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM heartRateData WHERE appUserId = ?1 and createTime >= ?2 AND createTime < ?3',
        mapper: (Map<String, Object?> row) => HeartRateData(appUserId: row['appUserId'] as int?, mac: row['mac'] as String?, createTime: row['createTime'] as String?, averageHeartRate: row['averageHeartRate'] as int?, heartArray: row['heartArray'] as String?, max: row['max'] as int?, min: row['min'] as int?),
        arguments: [appUserId, createTime, nextTime]);
  }

  @override
  Future<void> insertTokens(List<HeartRateData> models) async {
    await _heartRateDataInsertionAdapter.insertList(
        models, OnConflictStrategy.replace);
  }
}

class _$StepDataDao extends StepDataDao {
  _$StepDataDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _stepDataInsertionAdapter = InsertionAdapter(
            database,
            'stepData',
            (StepData item) => <String, Object?>{
                  'appUserId': item.appUserId,
                  'mac': item.mac,
                  'createTime': item.createTime,
                  'steps': item.steps,
                  'distance': item.distance,
                  'calorie': item.calorie,
                  'dataArrs': item.dataArrs
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<StepData> _stepDataInsertionAdapter;

  @override
  Future<List<StepData>> queryUserAll(
    int appUserId,
    String createTime,
    String nextTime,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM stepData WHERE appUserId = ?1 and createTime >= ?2 AND createTime < ?3',
        mapper: (Map<String, Object?> row) => StepData(appUserId: row['appUserId'] as int?, mac: row['mac'] as String?, createTime: row['createTime'] as String?, steps: row['steps'] as int?, distance: row['distance'] as int?, calorie: row['calorie'] as int?, dataArrs: row['dataArrs'] as String?),
        arguments: [appUserId, createTime, nextTime]);
  }

  @override
  Future<void> insertTokens(List<StepData> models) async {
    await _stepDataInsertionAdapter.insertList(
        models, OnConflictStrategy.replace);
  }
}

class _$TempDataDao extends TempDataDao {
  _$TempDataDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _tempDataInsertionAdapter = InsertionAdapter(
            database,
            'TempData',
            (TempData item) => <String, Object?>{
                  'appUserId': item.appUserId,
                  'mac': item.mac,
                  'createTime': item.createTime,
                  'temperature': item.temperature,
                  'average': item.average,
                  'max': item.max,
                  'min': item.min,
                  'dataArray': item.dataArray
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<TempData> _tempDataInsertionAdapter;

  @override
  Future<List<TempData>> queryUserAll(
    int appUserId,
    String createTime,
    String nextTime,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM TempData WHERE appUserId = ?1 and createTime >= ?2 AND createTime < ?3',
        mapper: (Map<String, Object?> row) => TempData(appUserId: row['appUserId'] as int?, mac: row['mac'] as String?, createTime: row['createTime'] as String?, temperature: row['temperature'] as int?, average: row['average'] as double?, dataArray: row['dataArray'] as String?, max: row['max'] as double?, min: row['min'] as double?),
        arguments: [appUserId, createTime, nextTime]);
  }

  @override
  Future<void> insertTokens(List<TempData> models) async {
    await _tempDataInsertionAdapter.insertList(
        models, OnConflictStrategy.replace);
  }
}
