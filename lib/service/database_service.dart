import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:testt/service/class_service.dart';

class DatabaseService {
  static DatabaseService instance = DatabaseService._constructor();
  Database? _db;
  DatabaseService._constructor();
  final String tableName = 'test_table';
  final String contentColumn = 'content';
  final String idColumn = 'id';
  final String statusColumn = 'status';

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await getDatabase();
    return _db!;
  }

  Future<Database> getDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, 'mester.db');
    final database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
        CREATE TABLE $tableName(
         $idColumn INTEGER PRIMARY KEY,
         $contentColumn TEXT NOT NULL,
         $statusColumn INTEGER NOT NULL
        )
       ''');
      },
    );
    return database;
  }

  void createData(String contents) async {
    final db = await database;
    await db.insert(tableName, {
      contentColumn: contents,
      statusColumn: 0,
    });
  }

  Future<List<ClassService>> getData() async {
    final db = await database;
    final List<Map<String, dynamic>> data = await db.query(tableName);
    List<ClassService> myData =
        data.map((item) => ClassService.fromJson(mapData: item)).toList();

    return myData;
  }

  updateNote(int val, int id) async {
    final db = await database;
    db.update(
      tableName,
      {statusColumn: val},
      where: 'id = ?',
      whereArgs: [
        id,
      ],
    );
  }

  deleteNote(int id) async {
    final db = await database;
    db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [
        id,
      ],
    );
  }
}
