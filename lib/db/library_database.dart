import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LibraryDatabase {
  Future<Database> getDatabase() async {
    String dbPath = await getDatabasesPath();
    //await deleteDatabase(join(dbPath, 'library.db'));
    Database db = await openDatabase(
      join(dbPath, 'library.db'),
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE users ('
          'id TEXT PRIMARY KEY, '
          'email TEXT UNIQUE, '
          'phoneNumber TEXT, '
          'name TEXT, '
          'location TEXT, '
          'password TEXT'
          ')',
        );

        await db.execute(
          'CREATE TABLE visits ('
          'id TEXT PRIMARY KEY, '
          'placeName TEXT, '
          'date INT, '
          'time INT, '
          'activitytype TEXT, '
          //'ageGroup TEXT,'
          'userId TEXT,'
          'age INT, '
          'visitors INT, '
          'gender TEXT, '
          'phone TEXT, '
          'packageId INT, '
          //'status TEXT, '
          'FOREIGN KEY (userId) REFERENCES users(id)'
          ')',
        );
      },

      version: 2,
    );

    return db;
  }

  Future<bool> verifyLogin(String email, String password) async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    return maps.isNotEmpty;
  }

  Future<void> registerUser(Map<String, dynamic> user) async {
    final db = await getDatabase();
    await db.insert(
      'users',
      user,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
