import 'dart:developer';
import 'dart:io' as io;

import 'package:drift/drift.dart';
import 'package:drift/native.dart' as ffi;
import 'package:medium/src/database/queries.dart';
import 'package:meta/meta.dart';
import 'package:multiline/multiline.dart';

export 'package:drift/drift.dart';

part 'database.g.dart';

/// --dart-define=DROP=true
final _kDropTables = io.Platform.environment['DROP']?.toLowerCase() == 'true' ||
    const bool.fromEnvironment('DROP');

@DriftDatabase(
  include: <String>{
    'database/kv.drift',
    'database/article.drift',
  },
  tables: <Type>[],
  daos: <Type>[],
  queries: $queries,
)
class Database extends _$Database
    implements GeneratedDatabase, DatabaseConnectionUser, QueryExecutorUser {
  /// Creates a database that will store its result in the [path], creating it
  /// if it doesn't exist.
  ///
  /// If [logStatements] is true (defaults to `false`), generated sql statements
  /// will be printed before executing. This can be useful for debugging.
  /// The optional [setup] function can be used to perform a setup just after
  /// the database is opened, before moor is fully ready. This can be used to
  /// add custom user-defined sql functions or to provide encryption keys in
  /// SQLCipher implementations.
  Database({
    required io.File path,
    ffi.DatabaseSetup? setup,
    bool logStatements = false,
  }) : super(
          LazyDatabase(() async {
            try {
              if (_kDropTables && path.existsSync()) {
                path.deleteSync();
              }
            } on Object {
              log("Can't delete database file: $path");
              rethrow;
            }
            return Future<QueryExecutor>.value(
              ffi.NativeDatabase(
                path,
                logStatements: logStatements,
                setup: setup,
              ),
            );
          }),
        );

  /// Creates an in-memory database won't persist its changes on disk.
  ///
  /// If [logStatements] is true (defaults to `false`), generated sql statements
  /// will be printed before executing. This can be useful for debugging.
  /// The optional [setup] function can be used to perform a setup just after
  /// the database is opened, before moor is fully ready. This can be used to
  /// add custom user-defined sql functions or to provide encryption keys in
  /// SQLCipher implementations.
  Database.memory({
    ffi.DatabaseSetup? setup,
    bool logStatements = false,
  }) : super(
          ffi.NativeDatabase.memory(
            logStatements: logStatements,
            setup: setup,
          ),
        );

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => DatabaseMigrationStrategy(
        database: this,
      );
}

/// Handles database migrations by delegating work to [OnCreate] and [OnUpgrade]
/// methods.
@immutable
class DatabaseMigrationStrategy implements MigrationStrategy {
  /// Construct a migration strategy from the provided [onCreate] and
  /// [onUpgrade] methods.
  const DatabaseMigrationStrategy({
    required final Database database,
  }) : _db = database;

  /// Database to use for migrations.
  final Database _db;

  /// Executes when the database is opened for the first time.
  @override
  OnCreate get onCreate => (m) async {
        await m.createAll();
      };

  /// Executes when the database has been opened previously, but the last access
  /// happened at a different [GeneratedDatabase.schemaVersion].
  /// Schema version upgrades and downgrades will both be run here.
  @override
  OnUpgrade get onUpgrade => (m, from, to) async {
        await m.createAll();
        return _update(_db, m, from, to);
      };

  /// Executes after the database is ready to be used (ie. it has been opened
  /// and all migrations ran), but before any other queries will be sent. This
  /// makes it a suitable place to populate data after the database has been
  /// created or set sqlite `PRAGMAS` that you need.
  @override
  OnBeforeOpen get beforeOpen => (details) => Future<void>.value();

  /// https://moor.simonbinder.eu/docs/advanced-features/migrations/
  static Future<void> _update(Database db, Migrator m, int from, int to) async {
    if (from >= to) return;
    switch (from) {
      case 1:
        // Migrate from 1 to 2

        break;
      case 2:
        // Migrate from 2 to 3
        break;

      /// Unknown migration
      default:
        assert(
          false,
          '''
          |You've bumped the schema version for your database
          |but didn't provide a strategy for schema updates.
          |Please do that by adapting the migrations getter
          |in your database class.
          '''
              .multiline(),
        );
    }
    final version = from + 1;
    return _update(db, m, version, to);
  }
}
