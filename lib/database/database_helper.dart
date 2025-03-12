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
        db_id INTEGER UNIQUE,
        title TEXT,
        reel_url TEXT,
        views TEXT,
        likes TEXT,
        thumbnail_url TEXT,
        date_watched TEXT
      )
    ''');
  }

  Future<int> insertLikedVideo(Reel reel) async {
    Database db = await instance.database;
    return await db.insert('liked_videos', reel.toMap(forLikedVideos: true));
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

    var result = await db.query(
      'watch_history',
      where: 'db_id = ?',
      whereArgs: [reel.id],
    );

    if (result.isNotEmpty) {
      var existingRecord = result.first;
      String existingDateWatched = existingRecord['date_watched'].toString();

      DateTime existingDate = DateTime.parse(existingDateWatched);
      DateTime newDate = reel.dateWatched ?? DateTime.now();

      if (newDate.isAfter(existingDate)) {
        await db.update(
          'watch_history',
          reel.toMap(forLikedVideos: false),
          where: 'db_id = ?',
          whereArgs: [reel.id],
        );
        return 1;
      } else {
        return 0;
      }
    } else {
      return await db.insert('watch_history', reel.toMap(forLikedVideos: false));
    }
  }


  Future<List<Reel>> getWatchHistory() async {
    Database db = await instance.database;

    String currentDate = DateTime.now().toIso8601String().substring(0, 10);

    var result = await db.rawQuery('''
    SELECT * FROM watch_history
    ORDER BY 
      CASE 
        WHEN date_watched LIKE '$currentDate%' THEN 1  -- Today
        WHEN date_watched LIKE '${_yesterday()}%' THEN 2  -- Yesterday
        ELSE 3  -- Older dates (X days ago)
      END, date_watched DESC
  ''');

    return result.map((map) => Reel.fromMap(map)).toList();
  }

  String _yesterday() {
    DateTime yesterday = DateTime.now().subtract(Duration(days: 1));
    return yesterday.toIso8601String().substring(0, 10);
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
