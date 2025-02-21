import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/reel.dart';

class DatabaseHelper {
  static const _databaseName = "ReelsDatabase.db";
  static const _databaseVersion = 1;

  // Singleton pattern
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Reference to our database
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  // Open the database and create tables if necessary
  Future<Database> _initDatabase() async {
    var path = await getDatabasesPath();
    var dbPath = join(path, _databaseName);
    return await openDatabase(dbPath, version: _databaseVersion, onCreate: _onCreate);
  }

  // Create tables when the database is created
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE liked_videos(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        url TEXT,
        isLiked INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE watch_history(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        url TEXT,
        dateWatched TEXT
      )
    ''');
  }

  // Insert a Reel into liked_videos table
  Future<int> insertLikedVideo(Reel reel) async {
    Database db = await instance.database;
    return await db.insert('liked_videos', reel.toMap());
  }

  // Insert a Reel into watch_history table
  Future<int> insertWatchHistory(Reel reel) async {
    Database db = await instance.database;
    return await db.insert('watch_history', reel.toMap());
  }

  // Get all liked videos
  Future<List<Reel>> getLikedVideos() async {
    Database db = await instance.database;
    var result = await db.query('liked_videos');
    return result.map((map) => Reel.fromMap(map)).toList();
  }

  // Get all watched history
  Future<List<Reel>> getWatchHistory() async {
    Database db = await instance.database;
    var result = await db.query('watch_history');
    return result.map((map) => Reel.fromMap(map)).toList();
  }

  // Delete a liked video by ID
  Future<int> deleteLikedVideo(int id) async {
    Database db = await instance.database;
    return await db.delete('liked_videos', where: 'id = ?', whereArgs: [id]);
  }

  // Delete a watched video by ID
  Future<int> deleteWatchHistory(int id) async {
    Database db = await instance.database;
    return await db.delete('watch_history', where: 'id = ?', whereArgs: [id]);
  }
}
