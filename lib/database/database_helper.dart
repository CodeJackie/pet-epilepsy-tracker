import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/seizure_entry.dart';
import '../models/pet_details.dart';
import '../models/trigger.dart';

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
    return await openDatabase(path, version: 6, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT';
    const intType = 'INTEGER';

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
        notes $textType
      )
    ''');
    
    await db.execute('''
    CREATE TABLE pet_details (
      id $idType,
      name $textType,
      breed $textType,
      birthdate $textType,
      neuter $textType,
      weight $intType,
      lastSeizure $textType,
      meds $textType,
      medsFrequency $intType,
      about $textType,
      imagePath $textType
    )
    ''');

    await db.execute('''
      CREATE TABLE Trigger (
        triggerId $idType,
        triggerName TEXT NOT NULL,
        triggerNotes $textType
      )
    ''');

    await db.execute('''
      CREATE TABLE seizure_trigger(
        id $idType,
        seizureId $intType,
        triggerId $intType,
        FOREIGN KEY (seizureId) REFERENCES seizure_entries(id),
        FOREIGN KEY (triggerId) REFERENCES trigger(triggerId)
      )
    ''');
  }

  //Create Data
  Future<int> insertEntry(SeizureEntry entry) async {
    final db = await database;
    try {
      int id = await db.insert(
        'seizure_entries',
        entry.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return id; 
    } catch (e) {
      print('Error inserting entry: $e');
      throw Exception('Failed to insert entry');
    }
  }

  //Read Data
  Future<List<SeizureEntry>> getEntries() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('seizure_entries',
    orderBy: 'seizureDate DESC');

    
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

  //---------TRIGGER---------

  //Read Data
  Future<List<Trigger>> getTriggers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('trigger');
    return List.generate(maps.length, (i) {
      return Trigger.fromMap(maps[i]);
    });
  }

  //Read Triggers
  Future<List<Trigger>> getTriggersForSeizure(int seizureId) async {
    final db = await database;
    var results = await db.rawQuery('''
      SELECT t.* FROM trigger t
      INNER JOIN seizure_trigger st ON t.triggerId = st.triggerId
      WHERE st.seizureId = ?
    ''', [seizureId]);

    return results.map((map) => Trigger.fromMap(map)).toList();
  }

  // Update Trigger
  Future<void> updateTrigger(int triggerId, Trigger newTrigger) async {
    final db = await database;
    await db.update(
      'trigger',
      newTrigger.toMap(),
      where: 'triggerId = ?',
      whereArgs: [triggerId]
    );
  }

  // Delete Trigger
  Future<void> deleteTrigger(int triggerId) async {
    final db = await database;
    await db.delete(
      'trigger',
      where: 'triggerId = ?',
      whereArgs: [triggerId]
    );
  }

  // Merge Triggers
  Future<void> mergeTriggers(int oldTriggerId, int newTriggerId) async {
    final db = await database;
    // Update all links to the old trigger to point to the new trigger
    await db.rawUpdate(
      'UPDATE seizure_trigger SET triggerId = ? WHERE triggerId = ?',
      [newTriggerId, oldTriggerId]
    );
    // Optionally delete the old trigger if it is no longer needed
    await deleteTrigger(oldTriggerId);
  }

  // Add trigger only if it doesn't exist
  Future<Trigger> checkTrigger(String triggerName) async {
    final db = await database;
    var existing = await db.query(
      'trigger',
      where: 'triggerName = ?',
      whereArgs: [triggerName],
    );

    if (existing.isNotEmpty) {
      return Trigger.fromMap(existing.first);
    } else {
      var id = await db.insert('trigger', {'triggerName': triggerName});
      return Trigger(triggerId: id, triggerName: triggerName);
    }
  }

  // Link seizure and triggers
  Future<void> addTrigger(int seizureId, List<Trigger> triggers) async {
    final db = await database;
    for (var trigger in triggers) {
      var triggerInDb = await checkTrigger(trigger.triggerName);
      await db.insert('seizure_trigger', {
        'seizureId': seizureId,
        'triggerId': triggerInDb.triggerId,
      });
    }
  }


  // Remove a link between a seizure and a trigger
  Future<void> removeTrigger(int seizureId, int triggerId) async {
    final db = await database;
    await db.delete(
      'seizure_trigger',
      where: 'seizureId = ? AND triggerId = ?',
      whereArgs: [seizureId, triggerId]
    );
  }

  //---------SEIZURE TRIGGER JUNCTION---------

  // Link a seizure with multiple triggers
  Future<void> addSeizureTriggers(int seizureId, List<Trigger> triggers) async {
    final db = await database;
    for (var trigger in triggers) {
      var triggerInDb = await checkTrigger(trigger.triggerName);
      await db.insert('seizure_trigger', {
        'seizureId': seizureId,
        'triggerId': triggerInDb.triggerId,
      });
    }
  }


  //---------PET DETAILS---------

  //Create Data
  Future<void> insertDetails(PetDetails entry) async {
    final db = await database;
    print('New data entered into Pet Details Table');
    try {
      await db.insert(
        'pet_details',
        entry.toMap(),
        conflictAlgorithm:  ConflictAlgorithm.replace,
      );
      print('Data Entry Created: ${entry.toMap()}');
    } catch (e) {
      print('Error inserting entry: $e');
    }
  }

  //Read Data
  Future<List<PetDetails>> getDetails() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('pet_details');
    
    print('Fetched entries from DB: $maps');
    
    return List.generate(maps.length, (i) {
      return PetDetails.fromMap(maps[i]);
    });
  }

 //Update Data
  Future<void> updateDetails(PetDetails entry) async {
    final db = await database;
    await db.update(
      'pet_details',
      entry.toMap(), //insert data
      where: 'id = ?', //find the entry by id
      whereArgs: [entry.id], //use entry.id as argument
    );
  }

  //Delete Data 
  Future<void> deleteDetails(int id) async {
    final db = await database;
    await db.delete(
      'pet_details',
      where: 'id = ?', //find the entry by id
      whereArgs: [id]
    );
  }

  //Update Pet Name
  Future<void> updatePetName(String newName) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.query('pet_details');
    if (results.isEmpty) {
      await db.insert('pet_details', {'name': newName});
      print('Inserted new row and pet name into Pet Details Table');
    } else {
    await db.update(
      'pet_details',
      {'name': newName},
      where: 'id = ?', 
      whereArgs: [results.first['id']],
    );
    print('Updated pet name in Pet Details Table');
  }

  }

  //Update Pet Breed
  Future<void> updatePetBreed(String newBreed) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.query('pet_details');
    if (results.isEmpty) {
      await db.insert('pet_details', {'name': newBreed});
      print('Inserted new row and breed into Pet Details Table');
    } else {
    await db.update(
      'pet_details',
      {'breed': newBreed},
      where: 'id = ?', 
      whereArgs: [results.first['id']],
    );
   }

  }

  //Update Pet Birthdate
  Future<void> updatePetBirthdate(String newBirthdate) async {
    final db = await database;
    await db.update(
      'pet_details', 
      {'birthdate': newBirthdate},
      where: 'id = ?',
      whereArgs: [1],
      );
  }

  //Update Pet About
  Future<void> updatePetAbout(String newAbout) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.query('pet_details');
    if (results.isEmpty) {
      await db.insert('pet_details', {'about': newAbout});
    } else {
    await db.update(
      'pet_details',
      {'about': newAbout},
      where: 'id = ?', 
      whereArgs: [results.first['id']],
    );
  }

  }
  //Update Image Path
  Future<bool> updatePetImagePath(String imagePath, int petId) async {
    final db = await database;
    int updateCount = await db.update(
      'pet_details',
      {'imagePath': imagePath},
      where: 'id = ?',
      whereArgs: [petId],
    );
    return updateCount > 0;
  }

}