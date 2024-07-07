// database.dart

// required package imports
import 'dart:async';
import 'dart:typed_data';
import 'package:floor/floor.dart';
import 'package:gemini/features/sqlite_database/dao/text_dao.dart';
import 'package:gemini/features/sqlite_database/entities/text.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'text_database.g.dart'; // the generated code will be there

@Database(version: 1, entities: [TextEntity])
abstract class AppDatabase extends FloorDatabase {
  TextDao get textDao;
}
