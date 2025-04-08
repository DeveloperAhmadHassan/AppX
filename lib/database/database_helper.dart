import 'dart:async';

import 'package:loopyfeed/models/saved_collection.dart';
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
    /// Tables
    await db.execute('''
      CREATE TABLE collections (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        thumbnail_url TEXT,
        is_public INTEGER,
        total_reels INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE reels (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        db_id INTEGER UNIQUE,
        title TEXT,
        reel_url TEXT,
        views TEXT,
        likes TEXT,
        thumbnail_url TEXT,
        is_liked INTEGER DEFAULT 0,
        is_saved INTEGER DEFAULT 0,
        date_watched TEXT,
        collections_count INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE reels_collections (
        reel_id INTEGER,
        collection_id INTEGER,
        PRIMARY KEY (reel_id, collection_id),
        FOREIGN KEY (reel_id) REFERENCES reels(id) ON DELETE CASCADE,
        FOREIGN KEY (collection_id) REFERENCES collections(id) ON DELETE CASCADE
      )
    ''');

    /// Table Triggers
    await db.execute('''
      CREATE TRIGGER delete_unused_reel
        AFTER UPDATE ON reels
        FOR EACH ROW
        WHEN NEW.is_liked = 0 AND NEW.is_saved = 0 AND NEW.date_watched IS NULL AND NEW.collections_count <= 0
        BEGIN
          DELETE FROM reels WHERE id = NEW.id;
        END;
    ''');

    await db.execute('''
      CREATE TRIGGER increase_collection_count
        AFTER INSERT ON reels_collections
        FOR EACH ROW
        BEGIN
          UPDATE reels
          SET collections_count = collections_count + 1
          WHERE id = NEW.reel_id;
        END;
    ''');

    await db.execute('''
      CREATE TRIGGER decrease_collection_count
        AFTER DELETE ON reels_collections
        FOR EACH ROW
        BEGIN
          UPDATE reels
          SET collections_count = collections_count - 1
          WHERE id = OLD.reel_id;
        END;
    ''');

    await db.execute('''
      CREATE TRIGGER update_total_reels_after_insert
        AFTER INSERT ON reels_collections
        BEGIN
          UPDATE collections
          SET total_reels = total_reels + 1
          WHERE id = NEW.collection_id;
        END;
    ''');

    await db.execute('''
      CREATE TRIGGER update_total_reels_after_delete
        AFTER DELETE ON reels_collections
        BEGIN
          UPDATE collections
          SET total_reels = total_reels - 1
          WHERE id = OLD.collection_id;
        END;
    ''');
  }

  /// Liked Videos CRUD Operations
  Future<int> insertLikedVideo(Reel reel) async {
    Database db = await instance.database;
    var result = await db.query(
      'reels',
      where: 'db_id = ?',
      whereArgs: [reel.id],
    );
    if (result.isNotEmpty) {
      return await db.update(
        'reels',
        {
          'is_liked': 1
        },
        where: 'db_id = ?',
        whereArgs: [reel.id],
      );
    } else {
      return await db.insert('reels', reel.toMap(forLikedVideos: true));
    }
  }
  Future<int> deleteLikedVideo(int id) async {
    Database db = await instance.database;
    return await db.update(
      'reels',
      {
        'is_liked': 0
      },
      where: 'db_id = ?',
      whereArgs: [id],
    );
  }
  Future<List<Reel>> getLikedVideos() async {
    Database db = await instance.database;
    var result = await db.query('reels', where: 'is_liked = ?', whereArgs: [1]);
    return result.map((map) => Reel.fromMap(map)).toList();
  }
  Future<bool> isReelLiked(int dbId) async {
    Database db = await instance.database;
    var result = await db.query(
      'reels',
      where: 'db_id = ? AND is_liked = ?',
      whereArgs: [dbId, 1],
    );

    return result.isNotEmpty;
  }

  /// Saved Videos CRUD Operations
  Future<int> insertSavedVideo(Reel reel) async {
    Database db = await instance.database;
    var result = await db.query(
      'reels',
      where: 'db_id = ?',
      whereArgs: [reel.id],
    );
    if (result.isNotEmpty) {
      return await db.update(
        'reels',
        {
          'is_saved': 1
        },
        where: 'db_id = ?',
        whereArgs: [reel.id],
      );
    } else {
      return await db.insert('reels', reel.toMap(forSavedVideos: true));
    }
  }
  Future<int> insertCollection(String title, {int isPublic = 0, int? reelId, String? thumbnailUrl}) async {
    Database db = await instance.database;
    int res = await db.insert(
        'collections',
        {
          "title": title,
          "is_public": isPublic,
          "thumbnail_url": thumbnailUrl
        }
    );

    return await db.insert("reels_collections", {
      "collection_id": res,
      "reel_id": reelId
    });
  }
  Future<int> insertToCollection(int reelId, int collectionId) async {
    Database db = await instance.database;
    return await db.insert("reels_collections", {
      "collection_id": collectionId,
      "reel_id": reelId
    });
  }
  Future<int> deleteSavedVideo(int id) async {
    Database db = await instance.database;
    return await db.update(
      'reels',
      {
        'is_saved': 0
      },
      where: 'db_id = ?',
      whereArgs: [id],
    );
  }
  Future<List<Reel>> getSavedVideos() async {
    Database db = await instance.database;
    var result = await db.query('reels', where: 'is_saved = ?', whereArgs: [1]);
    print("getting saved videos");
    print(result);
    return result.map((map) => Reel.fromMap(map)).toList();
  }

  Future<List<Reel>> getSavedVideosByCollection(int collectionId) async {
    Database db = await instance.database;
    var result =  await db.rawQuery('''
        SELECT r.*
        FROM reels r
        JOIN reels_collections rc ON r.db_id = rc.reel_id
        WHERE rc.collection_id = ?
      ''', [collectionId]
    );
    return result.map((map) => Reel.fromMap(map)).toList();
  }
  Future<List<SavedCollection>> getCollections() async {
    Database db = await instance.database;
    var result = await db.query('collections');
    print("getting saved collections");
    print(result);
    return result.map((map) => SavedCollection.fromMap(map)).toList();

  }
  Future<bool> isReelSaved(int dbId) async {
    Database db = await instance.database;
    var result = await db.query(
      'reels',
      where: 'db_id = ? AND is_saved = ?',
      whereArgs: [dbId, 1],
    );

    return result.isNotEmpty;
  }

  /// Watch History CRUD Operations
  Future<int> insertWatchHistory(Reel reel) async {
    print("inserting watch history");
    Database db = await instance.database;

    var result = await db.query(
      'reels',
      where: 'db_id = ?',
      whereArgs: [reel.id],
    );

    DateTime newDate = reel.dateWatched ?? DateTime.now();

    if (result.isNotEmpty) {
      var existingRecord = result.first;
      String? existingDateWatched = existingRecord['date_watched'] as String?;

      if (existingDateWatched != null && existingDateWatched.isNotEmpty) {
        try {
          DateTime existingDate = DateTime.parse(existingDateWatched);
          if (newDate.isAfter(existingDate)) {
            await db.update(
              'reels',
              {'date_watched': newDate.toIso8601String()},
              where: 'db_id = ?',
              whereArgs: [reel.id],
            );
            return 1;
          } else {
            return 0;
          }
        } catch (e) {
          print('Failed to parse existing date: $existingDateWatched');
          // If parsing fails, assume no valid date exists → just update
          await db.update(
            'reels',
            {'date_watched': newDate.toIso8601String()},
            where: 'db_id = ?',
            whereArgs: [reel.id],
          );
          return 1;
        }
      } else {
        await db.update(
          'reels',
          {'date_watched': newDate.toIso8601String()},
          where: 'db_id = ?',
          whereArgs: [reel.id],
        );
        return 1;
      }
    } else {
      return await db.insert('reels', reel.toMap(forWatchHistory: true));
    }
  }
  Future<int> deleteWatchHistory(int id) async {
    Database db = await instance.database;
    return await db.update(
      'reels',
      {
        'date_watched': null
      },
      where: 'db_id = ?',
      whereArgs: [id],
    );
  }
  Future<List<Reel>> getWatchHistory() async {
    Database db = await instance.database;

    String currentDate = DateTime.now().toIso8601String().substring(0, 10);

    var result = await db.rawQuery('''
    SELECT * FROM reels
    WHERE date_watched IS NOT NULL
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

  Future<int> deleteSavedCollection(String title) async {
    Database db = await instance.database;
    return await db.delete('reels', where: 'collection_name = ?', whereArgs: [title]);
  }
}
