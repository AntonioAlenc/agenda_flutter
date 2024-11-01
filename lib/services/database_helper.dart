import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/contact.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;
  static final _secureStorage = FlutterSecureStorage();

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'agenda.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await createContactTable(db);
        await createLoginTable(db);
      },
    );
  }

  Future<void> createContactTable(Database db) async {
    await db.execute('''
      CREATE TABLE contacts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        phone TEXT NOT NULL,
        email TEXT NOT NULL
      )
    ''');
  }

  Future<void> createLoginTable(Database db) async {
    await db.execute('''
      CREATE TABLE login (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
    ''');
  }

  Future<int> addContact(Contact contact) async {
    final db = await database;
    return await db.insert('contacts', {
      'name': contact.name,
      'phone': contact.phone,
      'email': contact.email,
    });
  }

  Future<List<Contact>> getContacts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('contacts');

    return List.generate(maps.length, (i) {
      return Contact(
        name: maps[i]['name'],
        phone: maps[i]['phone'],
        email: maps[i]['email'],
      );
    });
  }

  Future<int> updateContact(Contact contact) async {
    final db = await database;
    return await db.update(
      'contacts',
      {
        'name': contact.name,
        'phone': contact.phone,
        'email': contact.email,
      },
      where: 'id = ?',
      whereArgs: [contact.name],
    );
  }

  Future<int> deleteContact(int id) async {
    final db = await database;
    return await db.delete(
      'contacts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> addUser(String username, String password) async {
    final db = await database;
    await db.insert('login', {
      'username': username,
      'password': password,
    });
  }

  Future<Map<String, dynamic>?> getUser(String username, String password) async {
    final db = await database;
    final result = await db.query(
      'login',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    return result.isNotEmpty ? result.first : null;
  }

  // Funções para gerenciar a sessão segura
  Future<void> saveSession(String username) async {
    await _secureStorage.write(key: 'session', value: username);
  }

  Future<String?> getSession() async {
    return await _secureStorage.read(key: 'session');
  }

  Future<void> clearSession() async {
    await _secureStorage.delete(key: 'session');
  }

  Future<void> close() async {
    final db = await _database;
    if (db != null && db.isOpen) {
      await db.close();
    }
  }

  fetchContacts() {}
}
