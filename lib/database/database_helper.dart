import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/reel.dart';

class DatabaseHelper {
  static const _databaseName = "ReelsDatabase.db";
  static const _databaseVersion = 1;

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    var path = await getDatabasesPath();
    var dbPath = join(path, _databaseName);
    return await openDatabase(dbPath, version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE liked_videos(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        db_id INTEGER UNIQUE,
        title TEXT,
        reel_url TEXT,
        views TEXT,
        likes TEXT,
        thumbnail_url TEXT,
        is_liked INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE watch_history(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        db_id INTEGER,
        title TEXT,
        reel_url TEXT,
        thumbnail_url TEXT,
        dateWatched TEXT
      )
    ''');
  }

  Future<int> insertLikedVideo(Reel reel) async {
    Database db = await instance.database;
    return await db.insert('liked_videos', reel.toMap());
  }

  Future<bool> isReelLiked(int dbId) async {
    Database db = await instance.database;
    var result = await db.query(
      'liked_videos',
      where: 'db_id = ? AND is_liked = ?',
      whereArgs: [dbId, 1],
    );

    return result.isNotEmpty;
  }

  Future<List<Reel>> getLikedVideos() async {
    Database db = await instance.database;
    var result = await db.query('liked_videos');
    return result.map((map) => Reel.fromMap(map)).toList();
  }

  Future<int> insertWatchHistory(Reel reel) async {
    Database db = await instance.database;
    return await db.insert('watch_history', reel.toMap());
  }

  Future<List<Reel>> getWatchHistory() async {
    Database db = await instance.database;
    var result = await db.query('watch_history');
    return result.map((map) => Reel.fromMap(map)).toList();
  }

  Future<int> deleteLikedVideo(int id) async {
    Database db = await instance.database;
    return await db.delete('liked_videos', where: 'db_id = ?', whereArgs: [id]);
  }

  Future<int> deleteWatchHistory(int id) async {
    Database db = await instance.database;
    return await db.delete('watch_history', where: 'id = ?', whereArgs: [id]);
  }
}
