import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/seizure_entry.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database !=null) return _database!;

    _database = await _initDB('seizure_tracker.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTERGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
      CREATE TABLE seizure_entries (
        id $idType, 
        seizureDate $textType, 
        seizureTime $textType,
        seizureCount $textType, 
        seizureDuration $textType, 
        seizureTypes $textType, 
        rescueMed $textType,
        regularMed $textType,
        preSymptoms $textType,
        postSymptoms $textType,
        postIctalDuration $textType,
        triggers $textType,
        notes $textType
      )
    ''');
  }

  //Create Data
  Future<void> insertEntry(SeizureEntry entry) async {
    final db = await database;
    await db.insert(
      'seizure_entries',//Table name
       entry.toMap(), //insert data
       conflictAlgorithm: ConflictAlgorithm.replace,
       );
  }

  //Read Data
  Future<List<SeizureEntry>> getEntries() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('seizure_entries');
    return List.generate(maps.length, (i) {
      return SeizureEntry.fromMap(maps[i]);
    });
  }

  //Update Data
  Future<void> updateEntry(SeizureEntry entry) async {
    final db = await database;
    await db.update(
      'seizure_entries',
      entry.toMap(), //insert data
      where: 'id = ?', //find the entry by id
      whereArgs: [entry.id], //use entry.id as argument
    );
  }

  //Delete Data 
  Future<void> deleteEntry(int id) async {
    final db = await database;
    await db.delete(
      'seizure_entries',
      where: 'id = ?', //find the entry by id
      whereArgs: [id]
    );
  }
}