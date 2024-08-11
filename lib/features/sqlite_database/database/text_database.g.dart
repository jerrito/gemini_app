// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'text_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  TextDao? _textDaoInstance;

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
            'CREATE TABLE IF NOT EXISTS `TextEntity` (`textId` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, `title` TEXT, `data` TEXT, `hasImage` INTEGER, `dataImage` BLOB)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  TextDao get textDao {
    return _textDaoInstance ??= _$TextDao(database, changeListener);
  }
}

class _$TextDao extends TextDao {
  _$TextDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _textEntityInsertionAdapter = InsertionAdapter(
            database,
            'TextEntity',
            (TextEntity item) => <String, Object?>{
                  'textId': item.textId,
                  'title': item.title,
                  'data': item.data,
                  'hasImage':
                      item.hasImage == null ? null : (item.hasImage! ? 1 : 0),
                  'dataImage': item.dataImage
                }),
        _textEntityUpdateAdapter = UpdateAdapter(
            database,
            'TextEntity',
            ['textId'],
            (TextEntity item) => <String, Object?>{
                  'textId': item.textId,
                  'title': item.title,
                  'data': item.data,
                  'hasImage':
                      item.hasImage == null ? null : (item.hasImage! ? 1 : 0),
                  'dataImage': item.dataImage
                }),
        _textEntityDeletionAdapter = DeletionAdapter(
            database,
            'TextEntity',
            ['textId'],
            (TextEntity item) => <String, Object?>{
                  'textId': item.textId,
                  'title': item.title,
                  'data': item.data,
                  'hasImage':
                      item.hasImage == null ? null : (item.hasImage! ? 1 : 0),
                  'dataImage': item.dataImage
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<TextEntity> _textEntityInsertionAdapter;

  final UpdateAdapter<TextEntity> _textEntityUpdateAdapter;

  final DeletionAdapter<TextEntity> _textEntityDeletionAdapter;

  @override
  Future<List<TextEntity>> getAllTextData() async {
    return _queryAdapter.queryList('SELECT * FROM TextEntity',
        mapper: (Map<String, Object?> row) => TextEntity(
            hasImage:
                row['hasImage'] == null ? null : (row['hasImage'] as int) != 0,
            textId: row['textId'] as int,
            title: row['title'] as String?,
            data: row['data'] as String?,
            dataImage: row['dataImage'] as Uint8List?));
  }

  @override
  Future<void> insertData(TextEntity textEntity) async {
    await _textEntityInsertionAdapter.insert(
        textEntity, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateData(TextEntity textEntity) async {
    await _textEntityUpdateAdapter.update(
        textEntity, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteData(TextEntity textEntity) async {
    await _textEntityDeletionAdapter.delete(textEntity);
  }

  @override
  Future<void> deleteAll(List<TextEntity> listTextEntities) async {
    await _textEntityDeletionAdapter.deleteList(listTextEntities);
  }
}
