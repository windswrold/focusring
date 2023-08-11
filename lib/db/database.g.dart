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
}

class _$KHealthIndexModelDao extends KHealthIndexModelDao {
  _$KHealthIndexModelDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _kHealthIndexModelInsertionAdapter = InsertionAdapter(
            database,
            'health_index_table',
            (KHealthIndexModel item) => <String, Object?>{
                  'appUserId': item.appUserId,
                  'index': item.index,
                  'type': item.type.index,
                  'state': item.state ? 1 : 0
                }),
        _kHealthIndexModelUpdateAdapter = UpdateAdapter(
            database,
            'health_index_table',
            ['appUserId', 'type'],
            (KHealthIndexModel item) => <String, Object?>{
                  'appUserId': item.appUserId,
                  'index': item.index,
                  'type': item.type.index,
                  'state': item.state ? 1 : 0
                }),
        _kHealthIndexModelDeletionAdapter = DeletionAdapter(
            database,
            'health_index_table',
            ['appUserId', 'type'],
            (KHealthIndexModel item) => <String, Object?>{
                  'appUserId': item.appUserId,
                  'index': item.index,
                  'type': item.type.index,
                  'state': item.state ? 1 : 0
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<KHealthIndexModel> _kHealthIndexModelInsertionAdapter;

  final UpdateAdapter<KHealthIndexModel> _kHealthIndexModelUpdateAdapter;

  final DeletionAdapter<KHealthIndexModel> _kHealthIndexModelDeletionAdapter;

  @override
  Future<List<KHealthIndexModel>> queryAll(String appUserId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM health_index_table WHERE appUserId = ?1 ORDER BY \"index\" asc',
        mapper: (Map<String, Object?> row) => KHealthIndexModel(row['appUserId'] as String, row['index'] as int, KHealthDataType.values[row['type'] as int], (row['state'] as int) != 0),
        arguments: [appUserId]);
  }

  @override
  Future<List<KHealthIndexModel>> queryAllWithState(
    String appUserId,
    bool state,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM health_index_table WHERE appUserId = ?1 and state = ?2  ORDER BY \"index\" asc',
        mapper: (Map<String, Object?> row) => KHealthIndexModel(row['appUserId'] as String, row['index'] as int, KHealthDataType.values[row['type'] as int], (row['state'] as int) != 0),
        arguments: [appUserId, state ? 1 : 0]);
  }

  @override
  Future<void> insertTokens(List<KHealthIndexModel> models) async {
    await _kHealthIndexModelInsertionAdapter.insertList(
        models, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateTokens(List<KHealthIndexModel> model) async {
    await _kHealthIndexModelUpdateAdapter.updateList(
        model, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteTokens(KHealthIndexModel model) async {
    await _kHealthIndexModelDeletionAdapter.delete(model);
  }
}

class _$RingDeviceDao extends RingDeviceDao {
  _$RingDeviceDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _ringDeviceInsertionAdapter = InsertionAdapter(
            database,
            'ring_device_table',
            (RingDevice item) => <String, Object?>{
                  'appUserId': item.appUserId,
                  'remoteId': item.remoteId,
                  'localName': item.localName,
                  'macAddress': item.macAddress,
                  'select': item.select == null ? null : (item.select! ? 1 : 0)
                }),
        _ringDeviceUpdateAdapter = UpdateAdapter(
            database,
            'ring_device_table',
            ['appUserId', 'remoteId'],
            (RingDevice item) => <String, Object?>{
                  'appUserId': item.appUserId,
                  'remoteId': item.remoteId,
                  'localName': item.localName,
                  'macAddress': item.macAddress,
                  'select': item.select == null ? null : (item.select! ? 1 : 0)
                }),
        _ringDeviceDeletionAdapter = DeletionAdapter(
            database,
            'ring_device_table',
            ['appUserId', 'remoteId'],
            (RingDevice item) => <String, Object?>{
                  'appUserId': item.appUserId,
                  'remoteId': item.remoteId,
                  'localName': item.localName,
                  'macAddress': item.macAddress,
                  'select': item.select == null ? null : (item.select! ? 1 : 0)
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<RingDevice> _ringDeviceInsertionAdapter;

  final UpdateAdapter<RingDevice> _ringDeviceUpdateAdapter;

  final DeletionAdapter<RingDevice> _ringDeviceDeletionAdapter;

  @override
  Future<List<RingDevice>> queryUserAll(String appUserId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM ring_device_table WHERE appUserId = ?1',
        mapper: (Map<String, Object?> row) => RingDevice(
            appUserId: row['appUserId'] as String?,
            remoteId: row['remoteId'] as String?,
            localName: row['localName'] as String?,
            macAddress: row['macAddress'] as String?,
            select: row['select'] == null ? null : (row['select'] as int) != 0),
        arguments: [appUserId]);
  }

  @override
  Future<List<RingDevice>> queryUserAllWithSelect(
    String appUserId,
    bool select,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM ring_device_table WHERE appUserId = ?1 and select = ?2',
        mapper: (Map<String, Object?> row) => RingDevice(
            appUserId: row['appUserId'] as String?,
            remoteId: row['remoteId'] as String?,
            localName: row['localName'] as String?,
            macAddress: row['macAddress'] as String?,
            select: row['select'] == null ? null : (row['select'] as int) != 0),
        arguments: [appUserId, select ? 1 : 0]);
  }

  @override
  Future<void> insertTokens(List<RingDevice> models) async {
    await _ringDeviceInsertionAdapter.insertList(
        models, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateTokens(List<RingDevice> model) async {
    await _ringDeviceUpdateAdapter.updateList(model, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteTokens(RingDevice model) async {
    await _ringDeviceDeletionAdapter.delete(model);
  }
}
