import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'library_database.dart';
import '../models/user.dart';

String _hashPassword(String password) {
  final bytes = utf8.encode(password);
  final digest = sha256.convert(bytes);
  return digest.toString();
}

void insertUser(User user) async {
  LibraryDatabase database = LibraryDatabase();
  final db = await database.getDatabase();
  final hashedUser = User(
    id: user.id,
    email: user.email,
    phoneNumber: user.phoneNumber,
    name: user.name,
    location: user.location,
    password: _hashPassword(user.password),
  );
  try {
    await db.insert('users', hashedUser.userMap);
  } catch (e) {
    throw Exception('Email already exists');
  }
}

Future<List<User>> loadUsers() async {
  LibraryDatabase database = LibraryDatabase();
  final db = await database.getDatabase();
  final result = await db.query('users');
  List<User> resultList = result.map((row) {
    return User(
      id: row['id'] as String,
      email: row['email'] as String,
      phoneNumber: row['phoneNumber'] as String,
      name: row['name'] as String,
      location: row['location'] as String,
      password: row['password'] as String,
    );
  }).toList();
  return resultList;
}

Future<User?> verifyLogin(String email, String password) async {
  LibraryDatabase database = LibraryDatabase();
  final db = await database.getDatabase();
  final hashedPassword = _hashPassword(password);
  final result = await db.query(
    'users',
    where: 'email = ? AND password = ?',
    whereArgs: [email, hashedPassword],
  );
  if (result.isNotEmpty) {
    return User(
      id: result.first['id'] as String,
      email: result.first['email'] as String,
      phoneNumber: result.first['phoneNumber'] as String,
      name: result.first['name'] as String,
      location: result.first['location'] as String,
      password: result.first['password'] as String,
    );
  }
  return null;
}

Future<bool> checkEmailExists(String email) async {
  LibraryDatabase database = LibraryDatabase();
  final db = await database.getDatabase();
  final result = await db.query(
    'users',
    where: 'email = ?',
    whereArgs: [email],
  );
  return result.isNotEmpty;
}

void deleteUser(User user) async {
  LibraryDatabase database = LibraryDatabase();
  final db = await database.getDatabase();
  db.delete('users', where: 'id = ?', whereArgs: [user.id]);
}
