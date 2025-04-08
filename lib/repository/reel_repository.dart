import 'package:loopyfeed/models/saved_collection.dart';

import '../database/database_helper.dart';
import '../models/reel.dart';

class ReelRepository {
  final dbHelper = DatabaseHelper.instance;

  Future<int> addLikedVideo(Reel reel) async {
    return await dbHelper.insertLikedVideo(reel);
  }

  Future<int> addSavedVideo(Reel reel) async {
    return await dbHelper.insertSavedVideo(reel);
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

  Future<List<Reel>> getSavedVideos() async {
    return await dbHelper.getSavedVideos();
  }

  Future<List<SavedCollection>> getCollections() async {
    return await dbHelper.getCollections();
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

  Future<int> addCollection(String title, {bool isPublic = false, int? reelId, String? thumbnailUrl}) async {
    return await dbHelper.insertCollection(title, isPublic: isPublic ? 1 : 0, reelId: reelId, thumbnailUrl: thumbnailUrl);
  }
}
