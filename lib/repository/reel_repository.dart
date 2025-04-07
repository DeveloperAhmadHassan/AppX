import 'package:loopyfeed/models/saved_collection.dart';

import '../database/database_helper.dart';
import '../models/reel.dart';

class ReelRepository {
  final dbHelper = DatabaseHelper.instance;

  Future<int> addLikedVideo(Reel reel) async {
    return await dbHelper.insertLikedVideo(reel);
  }

  Future<int> addSavedVideo(SavedCollection collection) async {
    return await dbHelper.insertSavedVideo(collection.reel);
  }

  Future<int> addWatchHistory(Reel reel) async {
    return await dbHelper.insertWatchHistory(reel);
  }

  Future<List<Reel>> getLikedVideos() async {
    return await dbHelper.getLikedVideos();
  }

  Future<List<Reel>> getWatchHistory() async {
    return await dbHelper.getWatchHistory();
  }

  Future<int> removeLikedVideo(int id) async {
    return await dbHelper.deleteLikedVideo(id);
  }

  Future<int> removeWatchHistory(int id) async {
    return await dbHelper.deleteWatchHistory(id);
  }

  Future<int> removeSavedVideo(int id) async {
    return await dbHelper.deleteSavedVideo(id);
  }

  Future<int> removeSavedCollection(String collectionName) async {
    return await dbHelper.deleteSavedCollection(collectionName);
  }

  Future<bool> isReelLiked(int dbId) async {
    return await dbHelper.isReelLiked(dbId);
  }

  Future<bool> isReelSaved(int dbId) async {
    return await dbHelper.isReelSaved(dbId);
  }
}
